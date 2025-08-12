(use-modules (gnu)
             (gnu system)
             (gnu accounts)
             (gnu services xorg)
             (gnu services networking)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages package-management)
             (gnu packages version-control))

(operating-system
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; キーボード設定
  (keyboard-layout (keyboard-layout "jp" "jp106"))

  ;; ブートローダー（UEFI対応）
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))))

  ;; ファイルシステム設定
  (file-systems
    (list (file-system
            (device "/dev/vda1")
            (mount-point "/boot/efi")
            (type "vfat"))
          (file-system
            (device "/dev/vda2")
            (mount-point "/")
            (type "ext4"))))

  ;; groups
  (groups (list (group-account (name "network"))
              (group-account (name "wheel"))
              (group-account (name "audio"))
              (group-account (name "video"))
              (group-account (name "users"))))          

  ;; ユーザーアカウント
  (users
    (list (user-account
            (name "yourusername")
            (group "users")
            (supplementary-groups '("wheel" "audio" "video" "network"))
            (home-directory "/home/yourusername")
            (shell (file-append bash "/bin/bash")))))

  ;; パッケージ
  (packages
    (append (list guile-3.0 emacs emacs-exwm git)
            %base-packages))

  ;; サービス
  (services
    (append
      (list
        (service xorg-server-service-type
                 (xorg-configuration))
        (service network-manager-service-type))
      %base-services)))
