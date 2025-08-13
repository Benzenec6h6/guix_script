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
  ;; ホスト名とタイムゾーン
  (host-name "guix-box")
  (timezone "Asia/Tokyo")
  (locale "ja_JP.UTF-8")

  ;; キーボード設定
  (keyboard-layout (keyboard-layout "jp" "jp106"))

  ;; ブートローダー (UEFI)
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))))

  ;; ファイルシステム設定（install.sh で置換される）
  (file-systems
   (list (file-system
          (device "DEVICE_EFI")   ;; install.sh が置換
          (mount-point "/boot/efi")
          (type "vfat"))
         (file-system
          (device "DEVICE_ROOT")  ;; install.sh が置換
          (mount-point "/")
          (type "ext4"))))

  ;; グループ設定（文字列リスト）
  (groups '("root" "wheel" "audio" "video" "network" "users"))

  ;; ユーザーアカウント
  (users (list (user-account
                (name "yourusername")
                (group "users")
                (supplementary-groups '("wheel" "audio" "video" "network"))
                (home-directory "/home/yourusername")
                (shell (file-append bash "/bin/bash")))))

  ;; インストールするパッケージ
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
