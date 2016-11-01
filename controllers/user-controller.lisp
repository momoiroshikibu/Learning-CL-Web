(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.user
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password
                :join-into-string)
  (:import-from :com.momoiroshikibu.repositories.user
                :get-users
                :get-user-by-id
                :create-user
                :destroy-user-by-id)
  (:export :users
           :register
           :destroy
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers.user)


(defparameter *<users-partial-template>* (read-file-into-string "views/user/users-partial.html"))
(defparameter *<users-page-template>* (read-file-into-string "views/user/users.html"))
(defparameter *<users-new>* (read-file-into-string "views/user/users-new.html"))
(defparameter *<user>* (read-file-into-string "views/user/user.html"))


(defun users-new ()
  `(200
    (:content-type "text/html")
    (,*<users-new>*)))


(defun users (count)
  (let* ((users (get-users count))
         (<users-partial> (loop for row in users
                             collect (format nil *<users-partial-template>*
                                             (getf row :|id|)
                                             (getf row :|id|)
                                             (getf row :|last_name|)
                                             (getf row :|first_name|))))
         (<users-page> (format nil *<users-page-template>* (join-into-string <users-partial>))))
    `(200
      (:content-type "text/html")
      (,<users-page>))))


(defun users-by-id (user-id)
  (let* ((user (get-user-by-id user-id))
         (user-html (format nil *<user>*
                            (getf user :|id|)
                            (getf user :|first_name|)
                            (getf user :|last_name|)
                            (getf user :|mail_address|)
                            (getf user :|created_at|)
                            (getf user :|id|))))
    `(200
      (:content-type "text/html")
      (,user-html))))


(defun register (first-name last-name mail-address password)
  (let ((password-hash (hash-password password)))
    (create-user first-name last-name mail-address password-hash)
    `(303
      (:location "/users"))))


(defun destroy (id)
  (destroy-user-by-id id)
  `(303
    (:location "/users")))
