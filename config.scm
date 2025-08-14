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
             (gnu packages version-control)
             (gnu packages networking))  ; wpa-supplicant用

;; ===== 有線/無線切り替えフラグ =====
(define use-wireless? #t) ; #t = 無線, #f = 有線

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

  ;; ファイルシステム
  (file-systems
   (list (file-system
           (device "DEVICE_EFI")
           (mount-point "/boot/efi")
           (type "vfat"))
         (file-system
           (device "DEVICE_ROOT")
           (mount-point "/")
           (type "ext4"))))

  ;; グループ設定
  (groups (append
           (list (user-group (name "teto")))
           (list (user-group (name "network")))
           %base-groups))

  ;; ユーザー設定
  (users (append
          (list (user-account
                  (name "teto")
                  (group "teto")
                  (supplementary-groups '("wheel" "audio" "video" "network"))
                  (home-directory "/home/teto")
                  (shell (file-append bash "/bin/bash"))))
          %base-user-accounts))

  ;; パッケージ
  (packages (append
             (list guile-3.0 emacs emacs-exwm git
                   ;; 無線使用時だけ wpa-supplicant を追加
                   (if use-wireless? wpa-supplicant '()))
             %base-packages))

  ;; サービス
  (services
   (append
    (list
     ;; Xorg
     (service xorg-server-service-type)
     ;; ネットワーク
     (if use-wireless?
         ;; 無線モード
         (list
          (service wpa-supplicant-service-type)
          (service network-manager-service-type))
         ;; 有線モード
         (list
          (service dhcp-client-service-type))))
    %base-services))))
