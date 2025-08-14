;; exwm.scm - EXWM デスクトップ環境
(use-modules (gnu)
             (gnu system)
             (gnu services shepherd)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (srfi srfi-1)) ; append 用

;; ネットワークタイプに応じて %wired-os または %wireless-os を load する
(load "./wired.scm")   ;; wired を例とする
;; (load "./wireless.scm") ;; 無線ならこちらに切り替え

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
    (inherit %wired-os) ;; 有線なら %wired-os、無線なら %wireless-os
    (packages (append
               (list emacs emacs-exwm)
               (operating-system-packages %wired-os))) ; パッケージ継承
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
               (operating-system-services %wired-os)))))
