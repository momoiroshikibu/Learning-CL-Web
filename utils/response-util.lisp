(in-package :cl-user)
(defpackage com.momoiroshikibu.utils.response-util
  (:use :cl)
  (:export :200-OK
           :201-CREATED
           :400-BAD_REQUEST))
(in-package :com.momoiroshikibu.utils.response-util)

(defun 200-OK (body)
  `(200
    (:content-type "application/json")
    (,body)))

(defun 201-CREATED (body)
  `(201
    (:content-type "application/json")
    (,body)))

(defun 400-BAD-REQUEST (body)
  `(400
    (:content-type "application/json")
    (,body)))
