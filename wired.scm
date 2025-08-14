(use-modules (gnu services networking))
(load "./config.scm")

(define %wired-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list (service dhcp-client-service-type))
               %base-services))))

%wired-os
