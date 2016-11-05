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
    (let ((path-info (getf env :path-info))
          (login-user (get-login-user env)))
      (let* ((headers (getf env :headers))
             (access-token (gethash "access-token" headers)))
        (if access-token
            (print "access token pattern")
            (if (or (not (null (get-login-user env)))
                    (equal "/login" path-info)
                    (equal "/authenticate" path-info))
                (funcall app env)
                `(303
                  (:location ,(format nil "/login?redirect=~A" path-info))))))
      )))


