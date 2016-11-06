(in-package :cl-user)
(defpackage com.momoiroshikibu.models.access-token
  (:use :cl)
  (:export :access-token
           :get-access-token))
(in-package :com.momoiroshikibu.models.access-token)

(defclass access-token ()
  ((access-token
    :reader get-access-token
    :initarg :access-token)
   (user-id
    :reader get-user-id
    :initarg :user-id)
   (created-at
    :reader get-created-at
    :initarg :created-at)))
