(progn ;;init forms
  (ql:quickload :dbi))

(defpackage :ros.script.database.connection
  (:use :cl))
(in-package :ros.script.database.connection)

(defvar db (dbi:connect :mysql
                        :database-name "testdb"
                        :username "testuser"
                        :password "password"))
