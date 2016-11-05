(in-package :cl-user)
(defpackage com.momoiroshikibu.models.access-token
  (:use :cl)
  (:export :access-token
           :get-id))
(in-package :com.momoiroshikibu.models.access-token)

(defclass access-token ()
  ((id
    :reader get-id
    :initarg :id)
   (user-id
    :reader get-user-id
    :initarg :user-id)
   (access-token
    :reader get-access-token
    :initarg :access-token)
   (created-at
    :reader get-created-at
    :initarg :created-at)))
