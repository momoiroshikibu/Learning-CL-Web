(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.location
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:import-from :com.momoiroshikibu.datetime
                :get-current-date-in-yyyy-mm-dd-format)
  (:export :get-locations
           :get-location-by-id
           :create-location
           :destroy-location-by-id))
(in-package :com.momoiroshikibu.repositories.location)


(defun get-locations (limit)
  (let* ((query (dbi:prepare *connection*
                             "select * from locations limit ?"))
         (result (dbi:execute query limit)))
    (dbi:fetch result)))

(defun get-location-by-id (id)
  (let* ((query (dbi:prepare *connection*
                             "select * from locations where id = ?"))
         (result (dbi:execute query id)))
    (dbi:fetch result)))


(defun create-location (user-id lat lng)
  (let* ((query (dbi:prepare *connection*
                             "insert into locations values (null, ?, ?, ?, ?, null, null)"))
         (current-date (com.momoiroshikibu.datetime:get-current-date-in-yyyy-mm-dd-format))
         (result (dbi:execute query lat lng current-date user-id)))
    (dbi:fetch result)))

(defun destroy-location-by-id (id)
  (let ((query (dbi:prepare *connection*
                            "delete from locations where id = ?")))
    (dbi:execute query id)))