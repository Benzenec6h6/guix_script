#!/usr/bin/env bash
set -euxo pipefail

MOUNTPOINT="/mnt"
CONFIG="./config.scm"

# ディスク選択
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

# パーティション作成
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+512MiB -t 1:ef00 "$DISK"
sgdisk -n 2:0:0 -t 2:8300 "$DISK"

# フォーマット
mkfs.fat -F32 ${DISK}1
mkfs.ext4 -F ${DISK}2

# マウント
mount ${DISK}2 "$MOUNTPOINT"
mkdir -p "$MOUNTPOINT/boot/efi"
mount ${DISK}1 "$MOUNTPOINT/boot/efi"

# --- config.scm のプレースホルダー置換 ---
DEVICE_EFI="${DISK}1"
DEVICE_ROOT="${DISK}2"
sed -i "s|DEVICE_ROOT|$DEVICE_ROOT|g" "$CONFIG"
sed -i "s|DEVICE_EFI|$DEVICE_EFI|g" "$CONFIG"

# --- インストール実行 ---
guix system init "$CONFIG" "$MOUNTPOINT"

# アンマウント（任意）
umount "$MOUNTPOINT/boot/efi"
umount "$MOUNTPOINT"
