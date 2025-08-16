;; wireless.scm
(use-modules (gnu services networking)
             (gnu packages networking))

;; 共通 OS 設定をロード
(load "./config.scm")

(define %wireless-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list
                (service network-manager-service-type)
                (service wpa-supplicant-service-type))
               (operating-system-services %common-os)))))
