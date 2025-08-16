;; 共通設定（OS、ユーザー、共通パッケージ、X11）
(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
             (gnu services xorg)
             (gnu services desktop)
             (gnu packages xorg)
             (gnu packages bash)
             (gnu packages fonts)
             (gnu packages guile)
             (gnu packages version-control))

(define %common-os
  (operating-system
    ;; ホスト名・タイムゾーン・ロケール
    (host-name "guix-box")
    (timezone "Asia/Tokyo")
    (locale "ja_JP.UTF-8")

    ;; キーボード設定
    (keyboard-layout (keyboard-layout "jp" "jp106"))

    ;; ブートローダー
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
             (list (user-group (name "teto"))
                   (user-group (name "network")))
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

    ;; 共通パッケージ（X11）
    (packages (append
               (list xorg-server xterm
                     font-google-noto-serif-cjk font-google-noto-sans-cjk)
               %base-packages))

    ;; 共通サービス（X11）
    (services (append
               (list (service xorg-server-service-type))
               %base-services))))
