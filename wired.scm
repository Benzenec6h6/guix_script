(use-modules (gnu services networking))

;; 共通 OS 設定をロード
(load "./config.scm")

(define %wired-os
  (operating-system
    (inherit %common-os)
    (services (append
               (list
                (service network-manager-service-type))
               (operating-system-services %common-os)))))
