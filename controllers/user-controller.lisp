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
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :users
           :register
           :destroy))
(in-package :com.momoiroshikibu.controllers.user)


(defparameter *<users-partial-template>* (read-file-into-string "views/user/users-partial.html"))
(defparameter *<users-page-template>* (read-file-into-string "views/user/users.html"))


(defun users (env)
  (let* ((users (get-users 1000))
        ({users} (encode-json-to-string users)))
    `(200
      (:content-type "application/json")
      (,{users}))))


(defun users-by-id (user-id)
  (let ((user (get-user-by-id user-id)))
    (if user
        `(200
          (:content-type "application/json")
          (encode-json-to-string user))
        '(404
          (:content-type "application/json")
          ("{\"message\": \"user not found\"}")))))


(defun register (env)
  (let* ((request (lack.request:make-request env))
         (body-parameters (lack.request:request-body-parameters request))
         (first-name (cdr (assoc "first-name" body-parameters :test #'string=)))
         (last-name (cdr (assoc "last-name" body-parameters :test #'string=)))
         (mail-address (cdr (assoc "mail-address" body-parameters :test #'string=)))
         (password (cdr (assoc "password" body-parameters :test #'string=)))
         (hashed-password (hash-password password)))
    (create-user first-name last-name mail-address hashed-password)
    `(201
      (:content-type "application/json")
      ;; TODO: should return created user resource
      ("{\"result\": \"user created\"}"))))


(defun destroy (env)
  (let* ((request (lack.request:make-request env))
         (body-parameters (lack.request:request-body-parameters request))
         (user-id (cdr (assoc "id" body-parameters :test #'string=))))
    (destroy-user-by-id user-id)
    `(200
      (:content-type "application/json")
      ("{\"result\": \"user deleted\"}"))))
