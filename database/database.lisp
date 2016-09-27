(in-package :cl-user)

(defun get-current-date-in-format-yyyy-mm-dd ()
  (multiple-value-bind (second minute hour day month year) (get-decoded-time)
    (concatenate 'string (princ-to-string year) "-" (princ-to-string month) "-" (princ-to-string day))))


(defpackage com.momoiroshikibu.database
  (:use :cl
        :dbi)
  (:export :select-multi
           :select-one
           :insert))

(in-package :com.momoiroshikibu.database)


(defvar *database* (dbi:connect :mysql
                                :database-name "testdb"
                                :username "testuser"
                                :password "password"))

(defun select-multi (n)
  (let* ((query (dbi:prepare *database*
                             "select * from users limit ?"))
         (result (dbi:execute query n)))
    (loop for row = (dbi:fetch result)
       while row
       collect row
         )))


(defun select-one (id)
  (let* ((query (dbi:prepare *database*
                             "select * from users where id = ?"))
         (result (dbi:execute query id))
         (row (dbi:fetch result)))
    (if (null row)
        nil
        row)))


(defun insert (first-name last-name)
  (let* ((query (dbi:prepare *database*
                             "insert into users values (null, ?, ?, ?)"))
         (current-date (get-current-date-in-format-yyyy-mm-dd))
         (result (dbi:execute query first-name last-name current-date)))
    (dbi:fetch result)))


