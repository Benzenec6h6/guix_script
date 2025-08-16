;; EXWM を使った OS 定義
(use-modules (srfi srfi-1)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages fcitx5)
             (gnu packages xorg)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services shepherd)
             (shepherd service))

;; 共通 OS 設定を読み込み
(load "./config.scm")

;; ネットワーク設定 (wired.scm または wireless.scm をロード)
(define network
  (or (getenv "NETWORK") "wired"))
(load (string-append "./" network ".scm"))

;; Emacs/EXWM 初期化設定（Emacs Lisp）
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

;; EXWM 用の OS 定義
(define %exwm-os
  (operating-system
    (inherit %common-os)

    ;; パッケージ追加
    (packages
     (append
      (list emacs emacs-exwm emacs-magit
            fcitx5 fcitx5-anthy fcitx5-gtk fcitx5-qt fcitx5-configtool
            xorg-server xterm)
      (operating-system-packages %common-os)))

    ;; サービス追加
    (services
     (append
      (list
       ;; SLiM ログインマネージャ
       (service slim-service-type
                (slim-configuration
                 (xorg-configuration
                  (keyboard-layout (keyboard-layout "jp" "jp106")))))

       ;; EXWM / Emacs を Shepherd サービスとして起動
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
