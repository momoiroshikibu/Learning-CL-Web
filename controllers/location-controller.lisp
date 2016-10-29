(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.location
  (:use :cl)
  (:export :index))
(in-package :com.momoiroshikibu.controllers.location)


(defun index ()
  '(200
   (:content-type "text/html")
   ("<h1>locations</h1>")))
