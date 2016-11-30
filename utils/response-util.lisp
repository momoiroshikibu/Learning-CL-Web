(in-package :cl-user)
(defpackage com.momoiroshikibu.utils.response-util
  (:use :cl)
  (:export :200-OK
           :201-CREATED
           :400-BAD-REQUEST
           :404-NOT-FOUND))
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

(defun 404-NOT-FOUND (body)
  `(404
    (:content-type "application/json")
    (,body)))
