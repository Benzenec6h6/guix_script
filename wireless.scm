(use-modules (gnu services networking)
             (gnu packages admin))  ;; wpa-supplicant パッケージ用
(load "./config.scm")

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

%wireless-os
