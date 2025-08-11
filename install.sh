#!/usr/bin/env bash
set -euxo pipefail

# --- 設定（環境に合わせて書き換え） ---
MOUNTPOINT="/mnt"
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')

if ((${#disks[@]}==0)); then
  echo "No block device found"; exit 1
fi

echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1))  \
    "$(awk '{print $1}' <<<"${disks[$i]}")" \
    "$(awk '{print $2}' <<<"${disks[$i]}")"
done

read -rp 'Index: ' idx
((idx>=1 && idx<=${#disks[@]})) || { echo "Invalid index"; exit 1; }
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"
echo "→ selected $DISK"

# --- パーティション作成 ---
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+512MiB -t 1:ef00 "$DISK"
sgdisk -n 2:0:0 -t 2:8300 "$DISK"

# --- フォーマット ---
mkfs.fat -F32 "$EFI_PART"
mkfs.ext4 "$ROOT_PART"

# --- マウント ---
mount "$ROOT_PART" "$MOUNTPOINT"
mkdir -p "$MOUNTPOINT/boot/efi"
mount "$EFI_PART" "$MOUNTPOINT/boot/efi"

# --- config.scmを/mnt/etc/config.scmにコピー（別途準備済みとする） ---
mkdir -p "$MOUNTPOINT/etc"
cp ./config.scm "$MOUNTPOINT/etc/config.scm"

# --- インストール実行 ---
guix system install /mnt/etc/config.scm --target="$DISK"

# --- アンマウント（任意） ---
umount "$MOUNTPOINT/boot/efi"
umount "$MOUNTPOINT"
