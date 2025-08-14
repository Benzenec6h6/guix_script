;; wired.scm - 有線ネットワーク
(use-modules (gnu services networking))
(load "config.scm") ;; %common-os を継承

(define %wired-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list (service dhcp-client-service-type))
               %base-services))))
