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
  (:import-from :lack.request
                :make-request
                :request-parameters)
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


(defun users (env)
  (let* ((users (get-users 1000))
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


(defun register (env)
  (let* ((request (lack.request:make-request env))
         (body-parameters (lack.request:request-body-parameters request))
         (first-name (assoc "first-name" plist :test #'equal))
         (last-name (assoc "last-name" plist :test #'equal))
         (mail-address (assoc "mail-address" plist :test #'equal))
         (password (assoc "password" plist :test #'equal))
         (hashed-password (hash-password password)))
    (create-user first-name last-name mail-address hashed-password)
    `(303
      (:location "/users"))))


(defun destroy (env)
  (let* ((request (lack.request:make-request env))
         (body-parameters (lack.request:request-body-parameters request))
         (user-id (last-name (assoc "id" plist :test #'equal))))
    (destroy-user-by-id user-id)
    `(303
      (:location "/users"))))
