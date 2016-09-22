(defpackage com.momoiroshikibu.database
  (:use :cl))
(in-package :com.momoiroshikibu.database)

(ql:quickload :dbi)

(defvar database (dbi:connect :mysql
                              :database-name "testdb"
                              :username "testuser"
                              :password "password"))

(defun select (n)
  (let* ((query (dbi:prepare database
                             "select * from users where id > ?"))
         (result (dbi:execute query n)))
    (loop for row = (dbi:fetch result)
       while row
       do (print row)
         )))

(defun insert (first-name last-name current-date)
  (let* ((query (dbi:prepare database
                             "insert into users values (null, ?, ?, ?)"))
         (result (dbi:execute query first-name last-name current-date)))
    (print result)))


(export '(database
          select
          insert))
