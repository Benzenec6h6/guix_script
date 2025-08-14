(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services fcitx5))

(load "./config.scm")

(define network
  (or (getenv "NETWORK") "wired"))
(load (string-append "./" network ".scm"))

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

(define %exwm-os
  (operating-system
    (inherit %common-os)
    ;; パッケージ
    (packages (append
               (list emacs emacs-exwm emacs-magit)
               (operating-system-packages %common-os)))
    ;; サービス
    (services
     (append
      (list
       ;; Xorg サーバーとセッション設定
       (service xorg-server-service-type
                (xorg-configuration
                 (keyboard-layout (keyboard-layout "jp" "jp106"))
                 (server-arguments '("-nolisten" "tcp"))))
       ;; EXWM セッション
       (service slim-service-type
                (slim-configuration
                 (xorg-configuration
                  (keyboard-layout (keyboard-layout "jp" "jp106")))
                 (session-list
                  (list
                   (xorg-session
                    (name "exwm")
                    (start
                     (xorg-start-command
                      (string-append
                       "exec "
                       #$(file-append emacs "/bin/emacs")
                       " --eval '" #$emacs-exwm-init "'"))))))))
       ;; 日本語入力 fcitx5
       (service fcitx5-service-type))
      (operating-system-services %common-os)))))


%exwm-os
