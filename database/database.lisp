(in-package :cl-user)




(defpackage com.momoiroshikibu.database
  (:use :cl
        :dbi
        ))
(in-package :com.momoiroshikibu.database)



(defvar database (dbi:connect :mysql
                              :database-name "testdb"
                              :username "testuser"
                              :password "password"))

(defun get-current-date-in-format-yyyy-mm-dd ()
  (multiple-value-bind (second minute hour day month year) (get-decoded-time)
    (concatenate 'string (princ-to-string year) "-" (princ-to-string month) "-" (princ-to-string day))))


(defun select-multi (n)
  (let* ((query (dbi:prepare database
                             "select * from users limit ?"))
         (result (dbi:execute query n)))
    (loop for row = (dbi:fetch result)
       while row
       collect row
         )))


(defun select-one (id)
  (let* ((query (dbi:prepare database
                             "select * from users where id = ?"))
         (result (dbi:execute query id))
         (row (dbi:fetch result)))
    (if (null row)
        nil
        row)))


(defun insert (first-name last-name)
  (print 'insert)
  (let* ((query (dbi:prepare database
                             "insert into users values (null, ?, ?, ?)"))
         (current-date (get-current-date-in-format-yyyy-mm-dd))
         (print current-date)
         (result (dbi:execute query first-name last-name current-date)))
    (print result)))


(export '(database
          get-current-date-in-format-yyyy-mm-dd
          select-multi
          select-one
          insert))
