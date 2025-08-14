;; 共通設定（有線・無線共通部分）
(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
             (gnu services xorg)
             (gnu packages bash)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
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
            (device "DEVICE_EFI")   ;; install.sh で置換
            (mount-point "/boot/efi")
            (type "vfat"))
           (file-system
            (device "DEVICE_ROOT")  ;; install.sh で置換
            (mount-point "/")
            (type "ext4"))))

    ;; グループ設定（自作ユーザー＋base）
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

    ;; パッケージ（共通）
    (packages (append
               (list guile-3.0 emacs emacs-exwm git)
               %base-packages))))
