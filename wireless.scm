;; wireless.scm - 無線ネットワーク
(use-modules (gnu services networking)
             (gnu packages admin)) ;; wpa-supplicant
(load "config.scm") ;; %common-os を継承

(define %wireless-os
  (operating-system
    (inherit %common-os)
    (packages (append
               (list wpa-supplicant)
               (operating-system-packages %common-os)))
    (services (append
               (list (service wpa-supplicant-service-type)
                     (service network-manager-service-type))
               %base-services))))
