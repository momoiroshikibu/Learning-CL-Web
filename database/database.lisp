(in-package :cl-user)
(defpackage com.momoiroshikibu.database
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.datetime
                :get-current-date-in-yyyy-mm-dd-format)
  (:export :select-user-from-mail-address
           :select-multi
           :select-one
           :insert
           :destroy))
(in-package :com.momoiroshikibu.database)

(defvar *database* (dbi:connect :mysql
                                :database-name "testdb"
                                :username "testuser"
                                :password "password"))

(defun select-user-from-mail-address (mail-address hashed-password)
  (let* ((query (dbi:prepare *database*
                             "select * from users where mail_address = ?"))
         (result (dbi:execute query mail-address)))
    (dbi:fetch result)))

(defun select-multi (n)
  (let* ((query (dbi:prepare *database*
                             "select * from users limit ?"))
         (result (dbi:execute query n)))
    (loop for row = (dbi:fetch result)
       while row
       collect row)))


(defun select-one (id)
  (let* ((query (dbi:prepare *database*
                             "select * from users where id = ?"))
         (result (dbi:execute query id))
         (row (dbi:fetch result)))
    (if (null row)
        nil
        row)))


(defun insert (first-name last-name mail-address password-hash)
  (let* ((query (dbi:prepare *database*
                             "insert into users values (null, ?, ?, ?, ?, ?)"))
         (current-date (get-current-date-in-yyyy-mm-dd-format))
         (result (dbi:execute query first-name last-name mail-address password-hash current-date)))
    (dbi:fetch result)))

(defun destroy-by-id (id)
  (let ((query (dbi:prepare *database*
                            "delete from users where id = ?")))
    (dbi:execute query id)))
