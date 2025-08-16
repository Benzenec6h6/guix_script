;; 共通設定（OS、ユーザー、共通パッケージ）
(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
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

    ;; 共通パッケージ
    (packages (append
               (list
                 font-google-noto-serif-cjk
                 font-google-noto-sans-cjk)
               %base-packages))

    ;; 共通サービス
    (services %base-services)))
