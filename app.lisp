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
                :create-access-token
                :destroy-access-token)
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


(defmacro route (method pattern)
  `(and (string= ,method (getf env :request-method))
        (string= ,pattern request-path)))

(defmacro @GET (pattern)
  `(route "GET" ,pattern))

(defmacro @POST (pattern)
  `(route "POST" ,pattern))

(defmacro @PUT (pattern)
  `(route "PUT" ,pattern))

(defmacro @DELETE (pattern)
  `(route "DELETE" ,pattern))

(defmacro path-by-id (method regex controller)
  (let ((id (gensym)))
    `(let ((,id (routing-by-id ,regex request-path))
           (method ,method))
       (if (and ,id (string= (getf env :request-method) method))
           (apply ,controller ,id)
           nil))))

(defvar @GET "GET")
(defvar @POST "POST")
(defvar @PUT "PUT")
(defvar @DELETE "DELETE")

(defun app (env)
  (let ((request-path (getf env :path-info)))
    (cond ((@GET "/")
           (portal-index env))

          ((@GET "/users")
           (users 1000))

          ((@POST "/users")
           (let* ((request (lack.request:make-request env))
                  (body-parameters (lack.request:request-body-parameters request)))
             (register
              (get-request-value body-parameters "first-name")
              (get-request-value body-parameters "last-name")
              (get-request-value body-parameters "mail-address")
              (get-request-value body-parameters "password"))))

          ((@GET "/users/new")
           (users-new))

          ((@POST "/users/destroy")
           (let* ((request (lack.request:make-request env))
                  (body-parameters (lack.request:request-body-parameters request)))
             (destroy
              (get-request-value body-parameters "id"))))


          ((path-by-id @GET "/users/([0-9]+)" #'users-by-id))

          ((@GET "/login")
           (let ((request (lack.request:make-request env)))
             (login-page (getf env :query-string))))

          ((@POST "/authenticate")
           (let* ((request (lack.request:make-request env))
                  (request-parameters (request-parameters request))
                  (body-parameters (lack.request:request-body-parameters request))
                  (mail-address (get-request-value body-parameters "mail-address"))
                  (password (get-request-value body-parameters "password"))
                  (redirect-to (cdr (assoc "redirect" request-parameters :test 'equal))))
             (authenticate env redirect-to mail-address password)))

          ((@GET "/logout")
           (logout env))

          ((@GET "/locations")
           (location-index))
          ((@POST "/locations")
           (let* ((request (lack.request:make-request env))
                  (request-parameters (request-parameters request))
                  (body-parameters (lack.request:request-body-parameters request))
                  (lat (cdr (assoc "lat" body-parameters :test 'equal)))
                  (lng (cdr (assoc "lng" body-parameters :test 'equal))))
             (register-location env lat lng)))

          ((@GET "/locations/new")
           (location-new))

          ((path-by-id @GET "/locations/([0-9]+)" #'location-by-id))


          ((@GET "/access-tokens")
           (access-token-index))

          ((@POST "/access-tokens")
           (create-access-token env))

          ((path-by-id @GET "/access-tokens/([0-9]+)" #'access-token-by-access-token))
          ((path-by-id @DELETE "/access-tokens/([0-9]+)" #'destroy-access-token))

          (t
           '(404
             (:content-type "text/html")
             ("<h1>404 Not Found</h1>"))))))
