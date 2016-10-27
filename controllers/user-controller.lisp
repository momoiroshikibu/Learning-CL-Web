(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.user
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:import-from :com.momoiroshikibu.database
                :select-multi
                :select-one
                :insert
                :destroy-by-id)
  (:export :users
           :register
           :destroy
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers.user)


(defun string-join (string-list)
    (format nil "~{~A~^ ~}" string-list))

(defparameter *<users-partial-template>* (read-file-into-string "views/users-partial.html"))
(defparameter *<users-page-template>* (read-file-into-string "views/users.html"))
(defparameter *<users-new>* (read-file-into-string "views/users-new.html"))
(defparameter *<user>* (read-file-into-string "views/user.html"))


(defun users-new ()
  `(200
    (:content-type "text/html")
    (,*<users-new>*)))


(defun users (count)
  (let* ((users (select-multi count))
         (<users-partial> (loop for row in users
                             collect (format nil *<users-partial-template>*
                                             (getf row :|id|)
                                             (getf row :|id|)
                                             (getf row :|last_name|)
                                             (getf row :|first_name|))))
         (<users-page> (format nil *<users-page-template>* (string-join <users-partial>))))
    `(200
      (:content-type "text/html")
      (,<users-page>))))


(defun users-by-id (user-id)
  (let* ((user (select-one user-id))
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
    (insert first-name last-name mail-address password-hash)
    `(303
      (:location "/users"))))


(defun destroy (id)
  (destroy-by-id id)
  `(303
    (:location "/users")))
