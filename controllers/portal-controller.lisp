(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.portal
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.environment-util
                :getenv)
  (:import-from :com.momoiroshikibu.models.user
                :get-first-name)
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :portal-index))
(in-package :com.momoiroshikibu.controllers.portal)


(defparameter *<portal-new-html>* (read-file-into-string "views/portal/portal-index.html"))

(defun portal-index (env)
  (let* ((login-user (gethash :login-user (getf env :lack.session)))
         (login-user-name (get-first-name login-user))
         (script (read-file-into-string "views/portal/portal.js"))
         (google-map-api-key (getenv "GOOGLE_MAP_API_KEY")))
    `(200
      (:content-type "text/html")
      (,(format nil (read-file-into-string "views/portal/portal-index.html") login-user-name script google-map-api-key)))))
