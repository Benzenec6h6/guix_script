(define %exwm-os
  (operating-system
    ;; ホスト名・タイムゾーン・ロケール
    (host-name "guix-box")
    (timezone "Asia/Tokyo")
    (locale "ja_JP.UTF-8")

    ;; ファイルシステム
    (file-systems %common-file-systems)

    ;; ブートローダー
    (bootloader %common-bootloader)

    ;; グループ・ユーザー
    (groups %common-groups)
    (users %common-users)

    ;; パッケージ
    (packages
     (append
      (list emacs emacs-exwm emacs-magit
            fcitx5 fcitx5-anthy fcitx5-gtk fcitx5-qt fcitx5-configtool
            xorg-server xterm)
      %common-packages))

    ;; サービス
    (services
     (append
      (list
       ;; SLiM
       (service slim-service-type
                (slim-configuration
                 (xorg-configuration
                  (keyboard-layout (keyboard-layout "jp" "jp106")))))

       ;; EXWM / Emacs をユーザー空間で起動
       (simple-service 'exwm
         (start #~(make-forkexec-constructor
                   (list #$(file-append emacs "/bin/emacs")
                         "--eval" #$emacs-exwm-init)))
         (stop #~(make-kill-destructor)))

       ;; 必要なら fcitx5 を EXWM 起動時に起動
       (simple-service 'fcitx5
         (start #~(make-forkexec-constructor
                   (list "fcitx5")))
         (stop #~(make-kill-destructor))))

      ;; 共通サービス
      %common-services))))
