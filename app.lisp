(in-package :cl-user)
(defpackage com.momoiroshikibu.app
  (:use :cl)
  (:import-from :com.momoiroshikibu.controllers.portal
                :portal-index)
  (:import-from :com.momoiroshikibu.controllers.user
                :users-new
                :users
                :users-by-id
                :register
                :destroy)
  (:import-from :com.momoiroshikibu.controllers.location
                :location-index
                :location-new
                :location-by-id
                :register-location)
  (:import-from :com.momoiroshikibu.controllers.access-token
                :access-token-index
                :access-token-by-access-token
                :create-access-token)
  (:import-from :com.momoiroshikibu.controllers.login
                :login-page
                :authenticate
                :logout)
  (:import-from :lack.request
                :make-request
                :request-parameters)
  (:export :app))

(in-package :com.momoiroshikibu.app)


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
    (cond ((path "/" request-path)
           (portal-index env))

          ((path "/users" request-path)
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
           (if (string= (getf env :request-method) "GET")
               (location-index)
               (let* ((request (lack.request:make-request env))
                      (request-parameters (request-parameters request))
                      (body-parameters (lack.request:request-body-parameters request))
                      (lat (cdr (assoc "lat" body-parameters :test 'equal)))
                      (lng (cdr (assoc "lng" body-parameters :test 'equal))))
                 (register-location env lat lng))))

          ((path "/locations/new" request-path)
           (location-new))

          ((path-by-id "/locations/([0-9]+)" #'location-by-id))


          ((path "/access-tokens" request-path)
           (if (string= (getf env :request-method) "GET")
               (access-token-index)
               (create-access-token env)))

          ((path-by-id "/access-tokens/([0-9]+)" #'access-token-by-access-token))

          (t
           '(404
             (:content-type "text/html")
             ("<h1>404 Not Found</h1>"))))))
