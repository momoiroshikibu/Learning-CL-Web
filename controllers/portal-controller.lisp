(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.portal
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :portal-index))
(in-package :com.momoiroshikibu.controllers.portal)


(defparameter *<portal-new-html>* (read-file-into-string "views/portal/portal-index.html"))

(defun portal-index ()
  `(200
    (:content-type "text/html")
    (,(read-file-into-string "views/portal/portal-index.html"))))
