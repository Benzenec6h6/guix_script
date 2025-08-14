;; exwm.scm - EXWM デスクトップ環境構成
(use-modules (gnu)
             (gnu system)
             (gnu services shepherd)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (srfi srfi-1)) ; append 用

;; 共通設定を読み込む
(load "./config.scm")  ; %common-os を定義済み

;; Emacs EXWM 初期設定
(define emacs-exwm-init
  "
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
;; メニューバー・ツールバー・スクロールバー非表示
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
")

(define %exwm-os
  (operating-system
    (inherit %common-os)

    ;; パッケージ追加（EXWM、Emacs）
    (packages (append
               (list emacs emacs-exwm)
               (operating-system-packages %common-os)))

    ;; Shepherd サービス: EXWM 自動起動
    (services (append
               (list
                (simple-service 'start-exwm shepherd-root-service-type
                  (list
                   (shepherd-service
                    (provision '(exwm))
                    (requirement '(xorg-server fcitx5))
                    (start #~(make-forkexec-constructor
                              (list #$(file-append emacs "/bin/emacs") "--eval"
                                    #$(string-append
                                       "(progn "
                                       emacs-exwm-init
                                       ")"))))
                    (stop #~(make-kill-destructor))))))
               (operating-system-services %common-os)))))
