(in-package :cl-user)
(load (merge-pathnames (make-pathname :directory '(:relative "./dependencies.lisp"))))
(defpackage com.momoiroshikibu.server
  (:use :cl
        :clack
        :com.momoiroshikibu.database)
  (:import-from :lack.request
                :make-request
                :request-cookies))
(in-package :com.momoiroshikibu.server)


(defun routing=user-id (path)
  (ppcre:register-groups-bind (user-id)
                              ("/users/([0-9]+)" path :sharedp t)
                              (list user-id)))

(defun get-request-value (pairs key)
  (defun iter (pairs key)
    (let ((pair (car pairs)))
      (if (null pair)
          nil
          (if (string= key (car pair))
              (cdr pair)
              (iter (cdr pairs) key)))))
  (iter pairs key))

(defmacro path (pattern request-path)
  `(string= ,pattern ,request-path))

(lambda (env)
  (let ((request-path (getf env :path-info)))
    (cond ((path "/users" request-path)
           (cond ((string= (getf env :request-method) "GET")
                  (com.momoiroshikibu.controllers:users 1000))

                 ((string= (getf env :request-method) "POST")
                  (let* ((request (lack.request:make-request env))
                         (body-parameters (lack.request:request-body-parameters request)))
                    (com.momoiroshikibu.controllers:register
                     (get-request-value body-parameters "first-name")
                     (get-request-value body-parameters "last-name")
                     (get-request-value body-parameters "mail-address")
                     (get-request-value body-parameters "password"))))))

          ((path "/users/new" request-path)
           (com.momoiroshikibu.controllers:users-new))

          ((path "/users/destroy" request-path)
           (let* ((request (lack.request:make-request env))
                  (body-parameters (lack.request:request-body-parameters request)))
             (com.momoiroshikibu.controllers:destroy
              (get-request-value body-parameters "id"))))

          ((routing=user-id request-path)
           (let ((user-id (car (routing=user-id request-path))))
             (com.momoiroshikibu.controllers:users-by-id user-id)))

          (t
           '(404
             (:content-type "text/html")
             ("<h1>404 Not Found</h1>"))))))
