(use-modules (gnu services networking))

;; 共通設定を読み込む
(load "./config.scm")

(define %wired-os
  (operating-system
    (inherit %exwm-os) ;; exwm.os を継承している場合
    (services (append
               (list (service network-manager-service-type))
               (operating-system-services %exwm-os)))))
