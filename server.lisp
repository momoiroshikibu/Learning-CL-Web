(in-package :cl-user)
(load (merge-pathnames (make-pathname :directory '(:relative "./dependencies.lisp"))))
(defpackage com.momoiroshikibu.server
  (:use :cl)

  (:import-from :lack.builder
                :builder)

  (:import-from :lack.middleware.session
                :*lack-middleware-session*)

  (:import-from :lack.middleware.accesslog
                :*lack-middleware-accesslog*)

  (:import-from :com.momoiroshikibu.controllers.user
                :users-new
                :users
                :users-by-id
                :register
                :destroy)
  (:import-from :com.momoiroshikibu.controllers.location
                :index
                :location-by-id)
  (:import-from :com.momoiroshikibu.controllers.login
                :login-page
                :authenticate
                :logout)
  (:import-from :com.momoiroshikibu.middlewares.auth-handler-middleware
                :auth-handler-middleware)
  (:import-from :lack.request
                :make-request
                :request-cookies
                :request-parameters))
(in-package :com.momoiroshikibu.server)


(defun routing-by-id (regex path)
  (ppcre:register-groups-bind (id)
                              (regex path :sharedp t)
                              (list id)))

(defun get-request-value (pairs key)
  (labels ((get-value (pairs key)
             (let ((pair (car pairs)))
               (if (null pair)
                   nil
                   (if (equal key (car pair))
                       (cdr pair)
                       (get-value (cdr pairs) key))))))
    (get-value pairs key)))

(defmacro path (pattern request-path)
  `(string= ,pattern ,request-path))

(defmacro path-by-id (regex controller)
  (let ((id (gensym)))
    `(let ((,id (routing-by-id ,regex request-path)))
     (if ,id
         (apply ,controller ,id)
         nil))))

(defun app (env)
  (let ((request-path (getf env :path-info)))
    (cond ((path "/users" request-path)
           (cond ((string= (getf env :request-method) "GET")
                  (users 1000))
                 ((string= (getf env :request-method) "POST")
                  (let* ((request (lack.request:make-request env))
                         (body-parameters (lack.request:request-body-parameters request)))
                    (register
                     (get-request-value body-parameters "first-name")
                     (get-request-value body-parameters "last-name")
                     (get-request-value body-parameters "mail-address")
                     (get-request-value body-parameters "password"))))))

          ((path "/users/new" request-path)
           (users-new))

          ((path "/users/destroy" request-path)
           (let* ((request (lack.request:make-request env))
                  (body-parameters (lack.request:request-body-parameters request)))
             (destroy
              (get-request-value body-parameters "id"))))


          ((path-by-id "/users/([0-9]+)" #'users-by-id))

          ((path "/login" request-path)
           (let ((request (lack.request:make-request env)))
             (login-page (getf env :query-string))))

          ((path "/authenticate" request-path)
           (let* ((request (lack.request:make-request env))
                  (request-parameters (request-parameters request))
                  (body-parameters (lack.request:request-body-parameters request))
                  (mail-address (get-request-value body-parameters "mail-address"))
                  (password (get-request-value body-parameters "password"))
                  (redirect-to (cdr (assoc "redirect" request-parameters :test 'equal))))
             (authenticate env redirect-to mail-address password)))

          ((path "/logout" request-path)
           (logout env))

          ((path "/locations" request-path)
           (index))

          ((path-by-id "/locations/([0-9]+)" #'location-by-id))

          (t
           '(404
             (:content-type "text/html")
             ("<h1>404 Not Found</h1>"))))))

;; app
(lack:builder :session
              #'auth-handler-middleware
              #'app)
