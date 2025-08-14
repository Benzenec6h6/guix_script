(define %wired-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list
                (service network-manager-service-type))
               (operating-system-services %common-os)))))
