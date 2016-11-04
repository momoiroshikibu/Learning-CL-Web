(in-package :cl-user)
(defpackage com.momoiroshikibu.config
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:export :*google-map-api-key*))
(in-package :com.momoiroshikibu.config)

(defvar *google-map-api-key* (read-file-into-string ".google-map-api-key"))

