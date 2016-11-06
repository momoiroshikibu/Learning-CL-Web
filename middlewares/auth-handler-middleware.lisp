(in-package :cl-user)
(defpackage com.momoiroshikibu.middlewares.auth-handler-middleware
  (:use :cl)
  (:import-from :com.momoiroshikibu.controllers.login
                :login-page
                :authenticate)
  (:import-from :com.momoiroshikibu.models.access-token
                :get-user-id)
  (:import-from :com.momoiroshikibu.repositories.access-token
                :get-access-token-by-id)
  (:import-from :com.momoiroshikibu.repositories.user
                :get-user-by-id)
  (:export :auth-handler-middleware))
(in-package :com.momoiroshikibu.middlewares.auth-handler-middleware)


(defun get-login-user (env)
  (gethash :login-user (getf env :lack.session)))

(defun auth-handler-middleware (app)
  (lambda (env)
    (let ((path-info (getf env :path-info))
          (login-user (get-login-user env)))
      (let* ((headers (getf env :headers))
             (requested-access-token (gethash "access-token" headers)))
        (if requested-access-token
            (progn
              (let ((access-token (get-access-token-by-id (parse-integer requested-access-token))))
                (if access-token
                    (let ((user (get-user-by-id (get-user-id access-token)))
                          )
                      (if user
                          (progn
                            (setf (gethash :login-user (getf env :lack.session)) user)
                            (funcall app env))
                          `(403 nil nil))))
                ))
            (if (or (not (null (get-login-user env)))
                    (equal "/login" path-info)
                    (equal "/authenticate" path-info))
                (funcall app env)
                `(303
                  (:location ,(format nil "/login?redirect=~A" path-info)))))))))
