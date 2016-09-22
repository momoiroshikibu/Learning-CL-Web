(defpackage com.momoiroshikibu.database
  (:use :cl))
(in-package :com.momoiroshikibu.database)

(ql:quickload :dbi)

;; (progn ;;init forms
;;   (ql:quickload :dbi))

;; (defpackage :ros.script.database.connection
;;   (:use :cl))
;; (in-package :ros.script.database.connection)

(defvar database (dbi:connect :mysql
                        :database-name "testdb"
                        :username "testuser"
                        :password "password"))
(export 'database)
