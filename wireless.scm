(use-modules (gnu services networking)
             (gnu packages networking))

;; 共通設定を読み込む
(load "./config.scm")

(define %wireless-os
  (operating-system
    (inherit %exwm-os)
    (services (append
               (list (service network-manager-service-type)
                     (service wpa-supplicant-service-type))
               (operating-system-services %exwm-os)))))
