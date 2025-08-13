(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
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

 ;; キーボード設定
 (keyboard-layout (keyboard-layout "jp" "jp106"))

 ;; ブートローダー（UEFI対応）
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets '("/boot/efi"))))

 ;; ファイルシステム（install.sh で置換）
 (file-systems
  (list (file-system
         (device "DEVICE_EFI")   ;; install.sh が置換
         (mount-point "/boot/efi")
         (type "vfat"))
        (file-system
         (device "DEVICE_ROOT")  ;; install.sh が置換
         (mount-point "/")
         (type "ext4"))))

 ;; グループ設定（base のものを残す + 自分の追加）
 (groups (append
          (list (user-group (name "teto"))) ;; 自作ユーザー用グループ
          (list (user-group (name "network")))
          %base-groups))

 ;; ユーザー設定（base の root や nobody を残す）
 (users (append
         (list (user-account
                 (name "teto")
                 (group "teto")
                 (supplementary-groups '("wheel" "audio" "video" "network"))
                 (home-directory "/home/teto")
                 (shell (file-append bash "/bin/bash"))))
         %base-user-accounts))

 ;; パッケージ
 (packages (append (list guile-3.0 emacs emacs-exwm git wpa-supplicant)
                   %base-packages))

 ;; サービス
 (services (append
            (list
             ;; Xorg
             (service xorg-server-service-type)
             ;; Network
             ;(service wpa-supplicant-service-type)
             ;(service network-manager-service-type)
             ;; 有線のみ
             (service dhcp-client-service-type))
            %base-services)))
