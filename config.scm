(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
             (gnu services networking)
             (gnu services xorg)
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
  (keyboard-layout (keyboard-layout "jp" "jp106"))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))))

  (file-systems
    (list (file-system
            (device "DEVICE_EFI")
            (mount-point "/boot/efi")
            (type "vfat"))
          (file-system
            (device "DEVICE_ROOT")
            (mount-point "/")
            (type "ext4"))))

  ;; %base-groups に追加する形でグループ定義
  (groups (append
            (list (user-group (name "root") (id 0))
                  (user-group (name "wheel"))
                  (user-group (name "audio"))
                  (user-group (name "video"))
                  (user-group (name "network"))
                  (user-group (name "users")))
            %base-groups)) ; ここで nogroup や netdev など標準グループを保持

  ;; %base-user-accounts に追加する形でユーザー定義
  (users (append
           (list (user-account
                   (name "teto")
                   (group "users")
                   (supplementary-groups '("wheel" "audio" "video" "network"))
                   (home-directory "/home/teto")
                   (shell (file-append bash "/bin/bash"))))
           %base-user-accounts))

  (packages (append (list guile-3.0 emacs emacs-exwm git)
                    %base-packages))

  (services (append
              (list
                (service xorg-server-service-type)
                (service network-manager-service-type))
              %base-services)))
