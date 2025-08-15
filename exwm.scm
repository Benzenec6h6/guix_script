(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu services xorg)
             (gnu services desktop))

(load "./config.scm")

;; ネットワークタイプは環境変数 NETWORK に "wired" または "wireless"
(define network
  (or (getenv "NETWORK") "wired"))
(load (string-append "./" network ".scm"))

;; EXWM/Emacs 初期化スクリプト
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

    ;; パッケージ追加
    (packages (append
               (list emacs emacs-exwm emacs-magit)
               (operating-system-packages %common-os)))

    ;; サービス追加
    (services (append
               (list
                 ;; SLiMサービス（ログインマネージャ）
                 (service slim-service-type
                          (slim-configuration
                           (xorg-configuration
                            (keyboard-layout (keyboard-layout "jp" "jp106")))))

                 ;; EXWM/Emacs サービス
                 (simple-service 'exwm
                                 xorg-server-service-type
                                 #:start #~(make-forkexec-constructor
                                           (list #$(file-append emacs "/bin/emacs")
                                                 "--eval"
                                                 #$emacs-exwm-init)))

                 ;; 日本語入力 fcitx5
                 (service fcitx5-service-type))
               (operating-system-services %common-os)))))

%exwm-os
