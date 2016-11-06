(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.location
  (:use :cl
        :dbi)
  (:import-from :dbi
                :with-transaction
                :do-sql)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:import-from :com.momoiroshikibu.datetime
                :get-current-date-in-yyyy-mm-dd-format)
  (:import-from :com.momoiroshikibu.models.location
                :location)
  (:export :get-locations
           :get-location-by-id
           :create-location
           :destroy-location-by-id))
(in-package :com.momoiroshikibu.repositories.location)


(defvar *get-locations-prepared-statement* (dbi:prepare *connection*
                                                        "select * from locations limit ?"))
(defvar *get-location-by-id-prepared-statement* (dbi:prepare *connection*
                                                             "select * from locations where id = ?"))

(defvar *create-location-prepared-statement* (dbi:prepare *connection*
                                                          "insert into locations values (null, ?, ?, ?, ?, null, null)"))

(defvar *destroy-location-by-id* (dbi:prepare *connection*
                                              "delete from locations where id = ?"))


(defun get-locations (limit)
  (let* ((result (dbi:execute *get-locations-prepared-statement* limit)))
    (loop for row = (dbi:fetch result)
       while row
       collect (make-instance 'location
                              :id (getf row :|id|)
                              :lat (getf row :|lat|)
                              :lng (getf row :|lng|)
                              :created-at (getf row :|created_at|)
                              :created-by (getf row :|created_by|)
                              :updated-at (getf row :|updated_at|)
                              :updated-by (getf row :|updated_by|)))))

(defun get-location-by-id (id)
  (let* ((result (dbi:execute *get-location-by-id-prepared-statement* id))
         (row (dbi:fetch result)))
    (if (null row)
        nil
        (make-instance 'location
                       :id (getf row :|id|)
                       :lat (getf row :|lat|)
                       :lng (getf row :|lng|)
                       :created-at (getf row :|created_at|)
                       :created-by (getf row :|created_by|)
                       :updated-at (getf row :|updated_at|)
                       :updated-by (getf row :|updated_by|)))))

(defun create-location (user-id lat lng)
  (with-transaction *connection*
    (let* ((current-date (get-current-date-in-yyyy-mm-dd-format))
           (result (dbi:execute *create-location-prepared-statement* lat lng current-date user-id)))
      (dbi:fetch result))))


(defun update-location (location)
  ; TODO
  )

(defun destroy-location-by-id (id)
  (dbi:execute *destroy-location-by-id* id))
