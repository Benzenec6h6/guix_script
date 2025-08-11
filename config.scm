(use-modules (gnu) (gnu system) (gnu services desktop)
             (gnu packages guile) (gnu packages emacs))

(operating-system
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; ブートローダー（UEFI対応）
  (bootloader
   (grub-bootloader
    (efi-boot-directory "/boot/efi")
    (device #f)))

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
                (shell "/bin/bash")
                (password-hash "$6$efOm4a7EFll0NclZ$F4lztTkqwcUrfCgvaraqN9O8nv5OQIErNgXpXzwWFQsZow3IlRWaXYS4NazObcO8qnw/rKCGeo1WU/oHGMqnB."))))

  ;; パッケージ
  (packages (append (list guix guile emacs emacs-exwm git)
                    %base-packages))

  ;; GUI,ネットワーク (Xorg + EXWM)
  (services (append
             (list (service xorg-service-type)
                   (service exwm-service-type)
                   (service network-management-service-type))
             %base-services)))
