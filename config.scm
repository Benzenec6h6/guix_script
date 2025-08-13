(use-modules (gnu)
             (gnu system)
             (gnu services xorg)
             (gnu services networking)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages package-management)
             (gnu packages version-control))

(operating-system
  ;; ホスト名・タイムゾーン・ロケール
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; キーボード
  (keyboard-layout (keyboard-layout "jp" "jp106"))

  ;; ブートローダー（UEFI対応）
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))))

  ;; ファイルシステム（install.sh で置換）
  (file-systems
   (list (file-system
          (device "DEVICE_EFI")
          (mount-point "/boot/efi")
          (type "vfat"))
         (file-system
          (device "DEVICE_ROOT")
          (mount-point "/")
          (type "ext4"))))

  ;; グループ設定（文字列リスト）
  (groups '("root" "wheel" "audio" "video" "network" "users"))

  ;; ユーザー
  (users (list (user-account
                (name "yourusername")
                (group "users")
                (supplementary-groups '("wheel" "audio" "video" "network"))
                (home-directory "/home/yourusername")
                (shell (file-append bash "/bin/bash")))))

  ;; パッケージ
  (packages (append (list guile-3.0 emacs emacs-exwm git)
                    %base-packages))

  ;; サービス
  (services (append
             (list
              (service xorg-server-service-type)
              (service network-manager-service-type))
             %base-services)))
