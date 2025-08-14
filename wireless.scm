(use-modules (gnu services networking)
             (gnu packages networking) ;; wpa-supplicant のため
             (gnu packages admin))     ;; wpa-supplicant パッケージ参照用
(load "config.scm")

(operating-system
  (inherit %common-os)
  ;; 無線は wpa-supplicant + network-manager を追加
  (packages (append
             (list wpa-supplicant)
             (operating-system-packages %common-os)))
  (services (append
             (list
              (service wpa-supplicant-service-type)
              (service network-manager-service-type))
             %base-services)))
