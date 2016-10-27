(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.login
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:import-from :com.momoiroshikibu.database
                :select-user-from-mail-address)
  (:export :index
           :authenticate))
(in-package :com.momoiroshikibu.controllers.login)

(defparameter *<login-html>* (read-file-into-string "views/login/login.html"))

(defun index ()
  `(200
    (:content-type "text/html")
    (,*<login-html>*)))

(defun authenticate (mail-address password)
  (let* ((expected-password-hash (hash-password password))
         (user (select-user-from-mail-address mail-address expected-password-hash)))
    (if user
        `(303
          (:location "/users"))
        `(303
          (:location "/login")))))
