(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.login
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:import-from :com.momoiroshikibu.repositories.user
                :get-user-from-mail-address)
  (:import-from :lack.request
                :make-request
                :request-parameters)
  (:export :login-page
           :authenticate
           :logout))
(in-package :com.momoiroshikibu.controllers.login)

(defparameter *<login-html>* (read-file-into-string "views/login/login.html"))

(defun login-page (env)
  (let ((request (lack.request:make-request env))
        (query-string (getf env :query-string)))
    `(200
      (:content-type "text/html")
      (,(format nil *<login-html>* query-string)))))

(defun authenticate (env)
  (let* ((request (lack.request:make-request env))
         (request-parameters (request-parameters request))
         (body-parameters (lack.request:request-body-parameters request))
         (mail-address (cdr (assoc "mail-address" body-parameters :test 'string=)))
         (password (cdr (assoc "password" body-parameters :test 'string=)))
         (redirect-to (cdr (assoc "redirect" request-parameters :test 'string=)))
         (expected-password-hash (hash-password password))
         (user (get-user-from-mail-address mail-address expected-password-hash)))
    (if user
        (progn
          (setf (gethash :login-user (getf env :lack.session)) user)
          (print (gethash :login-user (getf env :lack.session)))
          `(303
            (:location ,redirect-to)))
        `(303
          (:location ,(format nil "/login?redirect=~A" redirect-to))))))


(defun logout (env)
  (let ((options (getf env :lack.session.options)))
    (setf (getf options :expire) t))
  `(303
    (:location "/login")))
