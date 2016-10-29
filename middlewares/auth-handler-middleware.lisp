(in-package :cl-user)
(defpackage com.momoiroshikibu.middlewares.auth-handler-middleware
  (:use :cl)
  (:import-from :com.momoiroshikibu.controllers.login
                :login-page
                :authenticate)
  (:export :auth-handler-middleware))
(in-package :com.momoiroshikibu.middlewares.auth-handler-middleware)


(defun get-login-user (env)
  (gethash :login-user (getf env :lack.session)))

(defun auth-handler-middleware (app)
  (lambda (env)
    (if (or (equal "/authenticate" (getf env :path-info))
            (get-login-user env))
        (funcall app env)
        (login-page))))


