(use-modules (srfi srfi-1)) ; append用
(load "./config.scm")

;; ネットワークタイプは環境変数 NETWORK に  "wired" か "wireless" を指定
(define network
  (or (getenv "NETWORK") "wired"))

;; wired または wireless を読み込む
(load (string-append "./" network ".scm"))

;; EXWM 専用パッケージとサービス
(define emacs-exwm-init
  "
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
;; 日本語入力
(setq default-input-method \"japanese-anthy\")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
")

(define %exwm-os
  (operating-system
    (inherit %common-os)
    ;; パッケージ追加
    (packages (append
               (list emacs emacs-exwm)
               (operating-system-packages %common-os)))
    ;; サービス追加
    (services (append
               (list
                (simple-service 'start-exwm shepherd-root-service-type
                  (list
                   (shepherd-service
                    (provision '(exwm))
                    (requirement '(xorg-server fcitx5))
                    (start #~(make-forkexec-constructor
                              (list #$(file-append emacs "/bin/emacs") "--eval"
                                    #$(string-append "(progn " emacs-exwm-init ")"))))
                    (stop #~(make-kill-destructor))))))
               (operating-system-services %common-os)))))

%exwm-os
