(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages fcitx5)
             (gnu services shepherd)
             (shepherd service))

(load "./config.scm")

;; ネットワーク設定 (wired / wireless)
(define network
  (or (getenv "NETWORK") "wired"))
(load (string-append "./" network ".scm"))

;; Emacs/EXWM 初期化
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

    ;; EXWM/Emacs + fcitx5 パッケージ
    (packages
     (append
      (list emacs emacs-exwm emacs-magit
            fcitx5 fcitx5-anthy fcitx5-gtk fcitx5-qt fcitx5-configtool)
      (operating-system-packages %common-os)))

    ;; EXWM 専用サービス
    (services
     (append
      (list
       (service shepherd-root-service-type
                (list
                 (shepherd-service
                  (provision '(exwm))
                  (requirement '(xorg-server))
                  (start #~(make-forkexec-constructor
                            (list #$(file-append emacs "/bin/emacs")
                                  "--eval" #$emacs-exwm-init)))
                  (stop #~(make-kill-destructor))))))
      ;; 共通サービスを継承
      (operating-system-services %common-os)))))

%exwm-os
