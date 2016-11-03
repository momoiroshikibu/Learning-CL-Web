(in-package :cl-user)
(defpackage com.momoiroshikibu.models.location
  (:use :cl)
  (:export :location))
(in-package :com.momoiroshikibu.models.location)

(defclass location ()
  ((id
    :reader get-id
    :initarg :id)
   (lat
    :reader get-lat
    :initarg :lat)
   (lng
    :reader get-lng
    :initarg :lng)
   (created-at
    :reader get-created-at
    :initarg :created-at)
   (created-by
    :reader get-created-by
    :initarg :created-by)
   (updated-at
    :reader get-updated-at
    :initarg :updated-at)
   (updated-by
    :reader get-updated-by
    :initarg :updated-by)))
