(in-package :cl-user)
(defpackage com.momoiroshikibu.models.user
  (:use :cl)
  (:export :user
           :get-id
           :get-first-name
           :get-last-name
           :get-mail-address
           :get-created-at
           :get-created-by
           :get-updated-at
           :get-updated-by))
(in-package :com.momoiroshikibu.models.user)

(defclass user ()
  ((id
    :reader get-id
    :initarg :id)
   (first-name
    :reader get-first-name
    :initarg :first-name)
   (last-name
    :reader get-last-name
    :initarg :last-name)
   (mail-address
    :reader get-mail-address
    :initarg :mail-address)
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
