(use-modules (gnu services networking)
             (gnu packages networking))

(define %wireless-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list
                ;; 無線LAN管理のための NetworkManager サービス
                (service network-manager-service-type)
                ;; WPA Supplicant サービス（必要に応じて）
                (service wpa-supplicant-service-type))
               (operating-system-services %common-os)))))
