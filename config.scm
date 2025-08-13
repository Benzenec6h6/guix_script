(use-modules (gnu)
             (gnu system)
             (gnu services networking)
             (gnu services xorg)
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

 ;; ファイルシステム設定（install.sh が置換）
 (file-systems
  (list (file-system
         (device "DEVICE_EFI")   ;; install.sh が置換
         (mount-point "/boot/efi")
         (type "vfat"))
        (file-system
         (device "DEVICE_ROOT")  ;; install.sh が置換
         (mount-point "/")
         (type "ext4"))))

 ;; グループ定義（root はここで宣言するだけ）
 (groups '("root" "wheel" "audio" "video" "network" "users"))

 ;; ユーザー定義（root は書かない）
 (users (list (user-account
               (name "teto")
               (group "users")
               (supplementary-groups '("wheel" "audio" "video" "network"))
               (home-directory "/home/teto")
               (shell (file-append bash "/bin/bash")))))

 ;; パッケージ
 (packages (append (list guile-3.0 emacs emacs-exwm git)
                   %base-packages))

 ;; サービス
 (services (append
            (list
             ;; Xorg
             (service xorg-server-service-type)
             ;; Network
             (service network-manager-service-type))
            %base-services)))
