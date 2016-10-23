(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:export :users
           :register
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers)

(defun users-new ()
  `(200
    (:content-type "text/html")
    (,(com.momoiroshikibu.utils:read-file-into-string "views/users-new.html"))))

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
  (let* ((user (com.momoiroshikibu.database:select-one user-id))
         (user-html (format-user (getf user :|id|)
                                 (getf user :|first_name|)
                                 (getf user :|last_name|)
                                 (getf user :|created_at|))))
    `(200
      (:content-type "text/html")
      (,user-html))))

(defun register (first-name last-name)
  (com.momoiroshikibu.database:insert first-name last-name)
  `(303
    (:location "/users")))


(defun format-user (user-id first-name last-name created-at)
  (format nil (com.momoiroshikibu.utils:read-file-into-string "views/user.html")
          user-id
          first-name
          last-name
          created-at))
