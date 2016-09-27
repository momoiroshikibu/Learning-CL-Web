(in-package :cl-user)
(defpackage com.momoiroshikibu.database
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.datetime
                :get-current-date-in-yyyy-mm-dd-format)
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
       collect row)))


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
         (current-date (get-current-date-in-yyyy-mm-dd-format))
         (result (dbi:execute query first-name last-name current-date)))
    (dbi:fetch result)))
