(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages fcitx5)
             (gnu packages xorg)
             (gnu services xorg)
             (gnu services desktop)
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

    ;; パッケージ
    (packages
     (append
      (list emacs emacs-exwm emacs-magit
            fcitx5 fcitx5-anthy fcitx5-gtk fcitx5-qt fcitx5-configtool
            xorg-server xterm)
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

       ;; EXWM / Emacs を simple-service でユーザー空間起動
       (simple-service 'exwm
                       (start #~(make-forkexec-constructor
                                 (list #$(file-append emacs "/bin/emacs")
                                       "--eval" #$emacs-exwm-init)))
                       (stop #~(make-kill-destructor)))

       ;; fcitx5 日本語入力 (xorg と同じユーザー空間サービス)
       (service fcitx5-service-type))

      ;; 共通サービスを継承
      (operating-system-services %common-os)))))
      
%exwm-os
