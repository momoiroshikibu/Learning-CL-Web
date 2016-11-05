(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.access-token
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.repositories.access-token
                :get-access-token-by-id)
  (:import-from :com.momoiroshikibu.models.user
                :get-id)
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :access-token-by-id))
(in-package :com.momoiroshikibu.controllers.access-token)

;; (defun access-token-index ()
;;   (let* ((locations (get-locations 100))
;;          ({locations} (encode-json-to-string locations)))
;;     `(200
;;       (:content-type "application/json")
;;       (,{locations}))))

(defun access-token-by-id (id)
  (let* ((access-token (get-access-token-by-id id))
         ({access-token} (encode-json-to-string access-token)))
    (if access-token
        `(200
          (:content-type "application/json")
          (,{access-token}))
        '(404
          (:content-type "application/json")
          ("null")))))
