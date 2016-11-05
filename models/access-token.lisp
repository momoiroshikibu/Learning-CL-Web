(in-package :cl-user)
(defpackage com.momoiroshikibu.models.access-token
  (:use :cl)
  (:export :access-token
           :make-access-token))
(in-package :com.momoiroshikibu.models.access-token)

(defstruct access-token
  (id nil)
  (user-id nil)
  (access-token nil)
  (created-at nil))
