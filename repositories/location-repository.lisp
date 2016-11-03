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


(defun get-locations (limit)
  (let* ((query (dbi:prepare *connection*
                             "select * from locations limit ?"))
         (result (dbi:execute query limit)))
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
  (let* ((query (dbi:prepare *connection*
                             "select * from locations where id = ?"))
         (result (dbi:execute query id))
         (row (dbi:fetch result)))
    (make-instance 'location
                   :id (getf row :|id|)
                   :lat (getf row :|lat|)
                   :lng (getf row :|lng|)
                   :created-at (getf row :|created_at|)
                   :created-by (getf row :|created_by|)
                   :updated-at (getf row :|updated_at|)
                   :updated-by (getf row :|updated_by|))))

(defun create-location (user-id lat lng)
  (with-transaction *connection*
    (let* ((query (dbi:prepare *connection*
                               "insert into locations values (null, ?, ?, ?, ?, null, null)"))
           (current-date (get-current-date-in-yyyy-mm-dd-format))
           (result (dbi:execute query lat lng current-date user-id)))
      (dbi:fetch result))))


(defun update-location (location)
  (let* ((query (dbi:prepare *connection*
                             "update locations set column1 = value1 where id = ?")))))

(defun destroy-location-by-id (id)
  (let ((query (dbi:prepare *connection*
                            "delete from locations where id = ?")))
    (dbi:execute query id)))
