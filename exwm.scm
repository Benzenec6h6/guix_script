(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu services xorg)
             (gnu services desktop))

(load "./config.scm")

;; ネットワークタイプは環境変数 NETWORK に "wired" か "wireless" を指定
(define network
  (or (getenv "NETWORK") "wired"))
(load (string-append "./" network ".scm"))

;; EXWM / Emacs 初期化設定
(define emacs-exwm-init
  "
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(setq default-input-method \"japanese-anthy\")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
")

;; EXWM 用 OS 定義
(define %exwm-os
  (operating-system
    (inherit %common-os)

    ;; 追加パッケージ
    (packages (append
               (list emacs emacs-exwm emacs-magit)
               (operating-system-packages %common-os)))

    ;; サービス
    (services
     (append
      (list
       ;; SLiM ログインマネージャ
       (service slim-service-type
                (slim-configuration
                 (xorg-configuration
                  (keyboard-layout (keyboard-layout "jp" "jp106")))))

       ;; EXWM / Emacs サービス
       (simple-service 'exwm
                       xorg-server-service-type
                       (start #~(list #$(file-append emacs "/bin/emacs")
                                      "--eval"
                                      #$emacs-exwm-init)))

       ;; fcitx5 日本語入力
       (service fcitx5-service-type))
      ;; 共通サービスを継承
      (operating-system-services %common-os)))))

%exwm-os
