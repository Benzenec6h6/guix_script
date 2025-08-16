;; 共通設定（OS、ユーザー、共通パッケージ）
(use-modules (gnu)
             (gnu system)
             (gnu system shadow)
             (gnu packages bash)
             (gnu packages fonts)
             (gnu packages guile)
             (gnu packages version-control))

;; 共通ファイルシステム設定
(define %common-file-systems
  (list (file-system
          (device "DEVICE_EFI")
          (mount-point "/boot/efi")
          (type "vfat"))
        (file-system
          (device "DEVICE_ROOT")
          (mount-point "/")
          (type "ext4"))))

;; 共通ブートローダー設定
(define %common-bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets '("/boot/efi"))))

;; 共通グループ設定
(define %common-groups
  (append
   (list (user-group (name "teto"))
         (user-group (name "network")))
   %base-groups))

;; 共通ユーザー設定
(define %common-users
  (append
   (list (user-account
           (name "teto")
           (group "teto")
           (supplementary-groups '("wheel" "audio" "video" "network"))
           (home-directory "/home/teto")
           (shell (file-append bash "/bin/bash"))))
   %base-user-accounts))

;; 共通パッケージ（OS基盤）
(define %common-packages
  (append
   (list font-google-noto-serif-cjk
         font-google-noto-sans-cjk)
   %base-packages))

;; 共通サービス（OS基盤）
(define %common-services
  %base-services)
