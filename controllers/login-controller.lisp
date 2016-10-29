(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.login
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:import-from :com.momoiroshikibu.database
                :select-user-from-mail-address)
  (:export :login-page
           :authenticate))
(in-package :com.momoiroshikibu.controllers.login)

(defparameter *<login-html>* (read-file-into-string "views/login/login.html"))

(defun login-page ()
  `(200
    (:content-type "text/html")
    (,*<login-html>*)))

(defun authenticate (env mail-address password)
  (print mail-address)
  (let* ((expected-password-hash (hash-password password))
         (user (select-user-from-mail-address mail-address expected-password-hash)))
    (print "authenticate")
    (print user)
    (if user
        (progn
          (setf (gethash :login-user (getf env :lack.session)) user)
          (print "authenticate")
          (print (gethash :login-user (getf env :lack.session)))
          `(303
            (:location "/users")))
        `(303
          (:location "/login")))))
