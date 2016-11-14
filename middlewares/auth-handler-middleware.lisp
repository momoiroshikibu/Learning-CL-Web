(in-package :cl-user)
(defpackage com.momoiroshikibu.middlewares.auth-handler-middleware
  (:use :cl)
  (:import-from :com.momoiroshikibu.controllers.login
                :authenticate)
  (:export :auth-handler-middleware))
(in-package :com.momoiroshikibu.middlewares.auth-handler-middleware)


(defun get-login-user (env)
  (gethash :login-user (getf env :lack.session)))

(defun auth-handler-middleware (app)
  (lambda (env)
    (let ((path-info (getf env :path-info))
          (login-user (get-login-user env)))
      (if (or (not (null login-user))
              (equal "/login" path-info)
              (equal "/authenticate" path-info))
          (funcall app env)
          `(403
            (:content-type "application/json")
            ("{\"message\": \"unauthorized\"}"))))))
