(in-package :cl-user)
(defpackage com.momoiroshikibu.database.connection
  (:use :cl
        :dbi)
  (:export :*connection*))
(in-package :com.momoiroshikibu.database.connection)

(defvar *connection* (dbi:connect :mysql
                                  :database-name "testdb"
                                  :username "testuser"
                                  :password "password"))
