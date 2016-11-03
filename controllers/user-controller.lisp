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
  (:import-from :com.momoiroshikibu.models.user
                :get-id
                :get-last-name
                :get-first-name
                :get-mail-address
                :get-created-at)
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
         (<users-partial> (loop for user in users
                             collect (format nil *<users-partial-template>*
                                             (get-id user)
                                             (get-id user)
                                             (get-last-name user)
                                             (get-first-name user))))
         (<users-page> (format nil *<users-page-template>* (join-into-string <users-partial>))))
    `(200
      (:content-type "text/html")
      (,<users-page>))))


(defun users-by-id (user-id)
  (let* ((user (get-user-by-id user-id))
         (user-html (format nil *<user>*
                            (get-id user)
                            (get-first-name user)
                            (get-last-name user)
                            (get-mail-address user)
                            (get-created-at user)
                            (get-id user))))
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
