(in-package :cl-user)
(defpackage com.momoiroshikibu.middlewares.access-token-handler-middleware
  (:use :cl)
  (:import-from :com.momoiroshikibu.models.access-token
                :get-user-id)
  (:import-from :com.momoiroshikibu.repositories.access-token
                :get-access-token-by-access-token)
  (:import-from :com.momoiroshikibu.repositories.user
                :get-user-by-id)
  (:export :access-token-middleware))
(in-package :com.momoiroshikibu.middlewares.access-token-handler-middleware)


(defun access-token-handler-middleware (app)
  (lambda (env)
    (let* ((headers (getf env :headers))
           (requested-access-token (gethash "access-token" headers)))
      (if requested-access-token
          (let ((access-token (get-access-token-by-access-token requested-access-token)))
            (if access-token
                (let ((user (get-user-by-id (get-user-id access-token))))
                  (if user
                      (progn
                        (setf (get :authenticated-user env) user)
                        (funcall app env))
                      (403-FORBIDDEN)))
                (403-FORBIDDEN)))
          (403-FORBIDDEN)))))

(defun 403-FORBIDDEN ()
  '(403
    (:content-type "application/json")
    ("{\"message\": \"unauthorized\"}")))
