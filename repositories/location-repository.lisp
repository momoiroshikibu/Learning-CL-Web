(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.location
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:export :get-locations
           :create-location
           :destroy-location-by-id))
(in-package :com.momoiroshikibu.repositories.location)


(defun get-locations (limit)
  (let* ((query (dbi:prepare *connection*
                             "select * from locations where limit ?"))
         (result (dbi:execute query limit)))
    (dbi:fetch result)))


(defun create-location ())

(defun destroy-location-by-id ())
