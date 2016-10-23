(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:export :users-new))
(in-package :com.momoiroshikibu.controllers)

(defvar *html* (com.momoiroshikibu.utils:read-file-into-string "views/users-new.html"))
(print *html*)

(defun users-new (env)
  `(200
    (:content-type "text/html")
    (,*html*)))
