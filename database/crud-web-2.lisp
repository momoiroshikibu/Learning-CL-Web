(ql:quickload :clack)
(ql:quickload :dbi)
(ql:quickload :hunchentoot)
(load (merge-pathnames (make-pathname :directory '(:relative "./database.lisp"))))


(in-package :cl-user)
(defpackage com.momoiroshikibu.database.crud-web
  (:use :cl
        :clack
        :com.momoiroshikibu.database))
(in-package :com.momoiroshikibu.database.crud-web)


(defun format-user (user-plist)
  (format nil "ID: ~A~&FirstName: ~A~&LastName: ~A~&CreatedAt: ~A~&"
          (getf user-plist :|id|)
          (getf user-plist :|first_name|)
          (getf user-plist :|last_name|)
          (getf user-plist :|created_at|)))

(lambda (env)
      (declare (ignore env))
      `(200
        (:content-type "text/plain")
        ("hello " ,(format-user (com.momoiroshikibu.database:select-one 1)))))

