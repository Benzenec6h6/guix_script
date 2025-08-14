(use-modules (gnu services networking))
(load "config.scm")

(operating-system
  (inherit %common-os)
  (services (append
             (list (service dhcp-client-service-type)) ;; 有線用DHCPクライアント
             %base-services)))
