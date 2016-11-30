(in-package :cl-user)
(defpackage com.momoiroshikibu.utils.response-util
  (:use :cl)
  (:export :200-OK))
(in-package :com.momoiroshikibu.utils.response-util)

(defun 200-OK (body)
  `(200
    (:content-type "application/json")
    (,body)))
