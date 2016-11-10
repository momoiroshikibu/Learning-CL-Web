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


(defmacro route (method pattern controller)
  `(and (string= ,method (getf env :request-method))
        (string= ,pattern request-path)))


;; (defmacro @POST (pattern controller)
;;   `(route "POST" ,pattern ,controller))

(defmacro @PUT (pattern controller)
  `(route "PUT" ,pattern ,controller))

(defmacro @DELETE (pattern controller)
  `(route "DELETE" ,pattern ,controller))

(defmacro path-by-id (method regex controller)
  (let ((id (gensym)))
    `(let ((,id (routing-by-id ,regex request-path))
           (method ,method))
       (if (and ,id (string= (getf env :request-method) method))
           (apply ,controller ,id)
           nil))))

(defmacro @GET/{id} (regex controller)
  (let ((id (gensym)))
    `(let ((,id (routing-by-id ,regex request-path)))
       (if (and ,id (string= (getf env :request-method) "GET"))
           (apply ,controller ,id)
           nil))))


;; (defmacro routing (routes)
;;   `(mapcar #'(lambda (route)
;;               `(hello ,,q(cadr route)))
;;           ,@routes))

;; (defmacro routing (routes)
;;   `(progn
;;      ,(mapcar #'(lambda (route)
;;                  `(print ,(cadr route)))
;;                ,@routes)))

;; (macroexpand '(routing (("GET" "/" #'portal-index)
;;                         ("GET" "/users" #'users)
;;                         ("GET" "/login" #'login-page))))

 ;; (routing '((@GET "/" #'portal-index)
;;            (@GET "/users" #'users)
;;            (@GET "/login" #'login-page)))


(defmacro @GET (pattern controller)
  `(if (and (string= "GET" (getf env :request-method))
             (string= ,pattern request-path))
        (funcall ,controller env)
        nil))

(defmacro @POST (pattern controller)
  `(if (and (string= "POST" (getf env :request-method))
             (string= ,pattern request-path))
        (funcall ,controller env)
        nil))

(defun app (env)
  (let ((request-path (getf env :path-info)))
    (print (getf env :request-method))
    (print env)

    (or (@GET "/" #'portal-index)
        (@GET "/login" #'login-page)
        (@POST "/authenticate" #'authenticate)
        (@GET "/logout" #'logout)

        (@GET "/users" #'users)
        (@GET/{id} "/users/([0-9]+)" #'users-by-id)
        (@GET "/users/new" #'users-new)
        (@POST "/users/destroy" #'destroy)
        (@POST "/users" #'register)


        (@GET "/locations" #'location-index)
        (@POST "/locations" #'register-location)
        (@GET/{id} "/locations/([0-9]+)" #'location-by-id)
        (@GET "/locations/new" #'location-new)

        (@GET "/access-tokens" #'access-token-index)
        (@POST "/access-tokens" #'create-access-token)
        (@GET/{id} "/access-tokens/([0-9]+)" #'access-token-by-access-token)

        '(404
          (:content-type "text/html")
          ("<h1>404 Not Found</h1>")))))

;; ;;           ((path-by-id "DELETE" "/access-tokens/([0-9]+)" #'destroy-access-token))

;;           (t
;;            '(404
;;              (:content-type "text/html")
;;              ("<h1>404 Not Found</h1>"))))

