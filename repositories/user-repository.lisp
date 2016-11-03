(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.user
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
(in-package :com.momoiroshikibu.repositories.user)


(defun get-user-from-mail-address (mail-address hashed-password)
  (let* ((query (dbi:prepare *connection*
                             "select * from users where mail_address = ? and password_hash = ?"))
         (result (dbi:execute query mail-address hashed-password))
         (row (dbi:fetch result)))
    (make-instance 'user
                   :id (getf row :|id|)
                   :first-name (getf row :|first_name|)
                   :last-name (getf row :|last_name|)
                   :mail-address (getf row :|mail_address|)
                   :created-at (getf row :|created_at|)
                   :created-by (getf row :|created_by|)
                   :updated-at (getf row :|updated_at|)
                   :updated-by (getf row :|updated_by|))))

(defun get-users (n)
  (let* ((query (dbi:prepare *connection*
                             "select * from users limit ?"))
         (result (dbi:execute query n)))
    (loop for row = (dbi:fetch result)
       while row
       collect (make-instance 'user
                              :id (getf row :|id|)
                              :first-name (getf row :|first_name|)
                              :last-name (getf row :|last_name|)
                              :mail-address (getf row :|mail_address|)
                              :created-at (getf row :|created_at|)
                              :created-by (getf row :|created_by|)
                              :updated-at (getf row :|updated_at|)
                              :updated-by (getf row :|updated_by|)))))


(defun get-user-by-id (id)
  (let* ((query (dbi:prepare *connection*
                             "select * from users where id = ?"))
         (result (dbi:execute query id))
         (row (dbi:fetch result)))
    (if (null row)
        nil
        (make-instance 'user
                       :id (getf row :|id|)
                       :first-name (getf row :|first_name|)
                       :last-name (getf row :|last_name|)
                       :mail-address (getf row :|mail_address|)
                       :created-at (getf row :|created_at|)
                       :created-by (getf row :|created_by|)
                       :updated-at (getf row :|updated_at|)
                       :updated-by (getf row :|updated_by|)))))


(defun create-user (first-name last-name mail-address password-hash)
  (let* ((query (dbi:prepare *connection*
                             "insert into users values (null, ?, ?, ?, ?, ?)"))
         (current-date (get-current-date-in-yyyy-mm-dd-format))
         (result (dbi:execute query first-name last-name mail-address password-hash current-date)))
    (dbi:fetch result)))

(defun destroy-user-by-id (id)
  (let ((query (dbi:prepare *connection*
                            "delete from users where id = ?")))
    (dbi:execute query id)))
