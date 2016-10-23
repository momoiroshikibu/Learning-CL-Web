(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:export :users
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers)

(defvar *html* (com.momoiroshikibu.utils:read-file-into-string "views/users-new.html"))
(print *html*)

(defun users-new ()
  `(200
    (:content-type "text/html")
    (,*html*)))

(defun users (count)
  (defun htmlify-user (user-plist)
    (let ((user-id (getf user-plist :|id|))
          (first-name (getf user-plist :|first_name|)))
      (format nil "<a href=users/~A>~A</a>" user-id first-name)))

  (defun listify-user (user-plist)
    (format nil "<li>~A</li>" (htmlify-user user-plist)))

  (let ((users (com.momoiroshikibu.database:select-multi count)))
    `(200
      (:content-type "text/html")
      ("<a href='/users/new'>/users/new</a>"
       ,@(loop for row in users
            collect (listify-user row))))))

(defun users-by-id (user-id)
  (let ((user (com.momoiroshikibu.database:select-one user-id)))
    `(200
      (:content-type "text/plain")
      (,(format-user user)))))


(defun format-user (user-plist)
  (format nil "ID: ~A~&FirstName: ~A~&LastName: ~A~&CreatedAt: ~A~&"
          (getf user-plist :|id|)
          (getf user-plist :|first_name|)
          (getf user-plist :|last_name|)
          (getf user-plist :|created_at|)))
