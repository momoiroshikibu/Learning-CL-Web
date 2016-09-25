(in-package :cl-user)
(progn ;;init forms
  (ql:quickload :dbi)
  (ql:quickload :clack)
  (ql:quickload :dbi)
  (ql:quickload :hunchentoot)
  (load (merge-pathnames (make-pathname :directory '(:relative "./database.lisp")))))


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
  (cond
    ((string= (getf env :path-info) "/")
     `(200
       (:content-type "text/plain")
       ,(loop for row in (com.momoiroshikibu.database:select-multi 10)
                    collect (format-user row))))
    ((string= (getf env :path-info) "/one")
     `(200
       (:content-type "text/plain")
       (,(format-user (com.momoiroshikibu.database:select-one 1)))))
    ((string= (getf env :path-info) "/two")
     '(200
       (:content-type "text/html")
       ("<h1>two</h1>")))
    (t
     '(404
       (:content-type "text/plain")
       ("Not Found")))))
