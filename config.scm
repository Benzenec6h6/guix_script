(use-modules (gnu) (gnu system) (gnu services desktop)
             (gnu packages guile) (gnu packages emacs))

(operating-system
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; ブートローダー（UEFI対応）
  (bootloader
   (grub-configuration
    (target "/boot/efi")
    (device "/dev/sda")))

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
  (users (list (user-account
                (name "yourusername")
                (group "users")
                (home-directory "/home/yourusername")
                (shell (file-append (user-profile) "/bin/bash"))
                (password-hash "……ここに生成したハッシュ"))))

  ;; パッケージ
  (packages (append (list guix guile emacs emacs-exwm git)
                    %base-packages))

  ;; GUI,ネットワーク (Xorg + EXWM)
  (services (append
             (list (service xorg-service-type)
                   (service exwm-service-type)
                   (service network-management-service-type))
             %base-services)))
