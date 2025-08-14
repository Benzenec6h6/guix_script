#!/usr/bin/env bash
set -euxo pipefail

MOUNTPOINT="/mnt"

# ディスク選択
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1))  \
    "$(awk '{print $1}' <<<"${disks[$i]}")" \
    "$(awk '{print $2}' <<<"${disks[$i]}")"
done
read -rp 'Index: ' idx
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"

# ネットワーク選択
echo "== Select network type =="
echo "1) Wired"
echo "2) Wireless"
read -rp "Choice [1-2]: " net_choice
case "$net_choice" in
    1) export NETWORK="wired";;
    2) export NETWORK="wireless";;
    *) echo "Invalid choice"; exit 1;;
esac

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

# プレースホルダー置換
DEVICE_EFI="${DISK}1"
DEVICE_ROOT="${DISK}2"
sed -i "s|DEVICE_ROOT|$DEVICE_ROOT|g" ./config.scm
sed -i "s|DEVICE_EFI|$DEVICE_EFI|g" ./config.scm

# インストール実行（EXWM を有効化する場合）
guix system init ./exwm.scm "$MOUNTPOINT"

# アンマウント
umount "$MOUNTPOINT/boot/efi"
umount "$MOUNTPOINT"
