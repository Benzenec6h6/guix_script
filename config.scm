(use-modules (gnu)
             (gnu system)
             (gnu services desktop)
             (gnu packages guile)
             (gnu packages emacs))

(operating-system
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; キーボード設定
  (keyboard-layout (keyboard-layout "jp" "jp106"))

  ;; ブートローダー（UEFI対応）
  (bootloader
    (bootloader grub-efi-bootloader)
    (target "/boot/efi"))

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
   (append (list guix guile emacs emacs-exwm git)
           %base-packages))

  ;; GUI, ネットワーク (Xorg + EXWM)
  (services
   (append
    (list
     (service xorg-service-type
              (xorg-configuration
               (keyboard-layout keyboard-layout)))
     (service exwm-service-type)
     (service network-manager-service-type))
    %base-services)))
