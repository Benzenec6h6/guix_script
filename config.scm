(use-modules (gnu)
             (gnu system)
             (gnu services desktop)
             (gnu services xorg)
             (gnu services networking)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages emacs)
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
            (device "/dev/sda1")
            (mount-point "/boot/efi")
            (type "vfat"))
          (file-system
            (device "/dev/sda2")
            (mount-point "/")
            (type "ext4"))))

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
        (service xorg-service-type
                 (xorg-configuration
                   (keyboard-layout (keyboard-layout "jp" "jp106"))))
        (service network-manager-service-type))
      %base-services)))
