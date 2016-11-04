(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.repository
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.datetime
                :get-current-date-in-yyyy-mm-dd-format)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:import-from :com.momoiroshikibu.models.user
                :user)
  (:export :get-user-from-mail-address
           :get-users
           :get-user-by-id
           :create-user
           :destroy-user-by-id))
(in-package :com.momoiroshikibu.repositories.repository)

(defclass repository ()
  ((connection
    :reader get-connection
    )
   (statements)))


(defmethod insert ())
(defmethod find ())
(defmethod find-all ())
(defmethod delete ())
(defmethod update ())
