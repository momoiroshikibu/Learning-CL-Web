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

(defun htmlify-user (user-plist)
  (let ((user-id (getf user-plist :|id|))
        (first-name (getf user-plist :|first_name|)))
    (format nil "<a href=users/~A>~A</a>" user-id first-name)))

(defun listify-user (user-plist)
  (format nil "<li>~A</li>" (htmlify-user user-plist)))


(defun routing=user-id (path)
  (ppcre:register-groups-bind (user-id)
      ("/users/([0-9]+)" path :sharedp t)
    (list user-id)))

(lambda (env)
  (cond
    ((string= (getf env :path-info) "/")
     `(200
       (:content-type "text/html")
       ("<html><body><a href='/users'>/users</a></body></html>")))

    ((string= (getf env :path-info) "/users")
     `(200
       (:content-type "text/html")
       ,(loop for row in (com.momoiroshikibu.database:select-multi 10)
                    collect (listify-user row))))

    ((routing=user-id (getf env :path-info))
     `(200
       (:content-type "text/plain")
       (,(format-user (com.momoiroshikibu.database:select-one (car (routing=user-id (getf env :path-info))))))))

    (t
     '(404
       (:content-type "text/plain")
       ("Not Found")))))
