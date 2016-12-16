(in-package :cl-user)
(defpackage com.momoiroshikibu.app
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils.response-util
                :404-NOT-FOUND)
  (:import-from :com.momoiroshikibu.utils.string-util
                :join-into-string)
  (:import-from :com.momoiroshikibu.controllers.user
                :users
                :users-by-id
                :register
                :destroy)
  (:import-from :com.momoiroshikibu.controllers.location
                :location-index
                :location-by-id
                :register-location)
  (:import-from :com.momoiroshikibu.controllers.access-token
                :access-token-index
                :access-token-by-access-token
                :create-access-token
                :destroy-access-token)
  (:import-from :lack.request
                :make-request
                :request-parameters)
  (:export :app))

(in-package :com.momoiroshikibu.app)

(defun @GET (env path controller)
  (let ((request-path (string-right-trim "/" (getf env :path-info)))
        (request-method (getf env :request-method)))
    (if (and (string= "GET" request-method)
             (string= path request-path))
        (funcall controller env)
        nil)))

(defun @GET-BY-ID (env pattern controller)
  (let ((id (ppcre:register-groups-bind (id)
               (pattern (getf env :path-info) :sharedp t)
             id))
        (request-method (getf env :request-method)))
    (if (and id
             (string= "GET" request-method))
        (funcall controller id)
        nil)))

(defun @POST (env path controller)
  (let ((request-path (string-right-trim "/" (getf env :path-info)))
        (request-method (getf env :request-method)))
    (if (and (string= "POST" request-method)
             (string= path request-path))
        (funcall controller env)
        nil)))

(defun app (env)
  (let ((request-path (getf env :path-info)))
    (or (@GET env "/users" #'users)
        (@GET-BY-ID env "/users/([0-9]+)" #'users-by-id)
;        (@DELETE/{id} "/users/([0-9]+)" #'destroy)
        (@POST env "/users" #'register)

        (@GET env "/locations" #'location-index)
        (@POST env "/locations" #'register-location)
;        (@GET/{id} "/locations/([0-9]+)" #'location-by-id)
        (@GET-BY-ID env "/locations/([0-9]+)" #'location-by-id)

        (@GET env "/access-tokens" #'access-token-index)
        (@POST env "/access-tokens" #'create-access-token)
        (@GET-BY-ID env "/access-tokens/([0-9]+)" #'access-token-by-access-token)

        (404-NOT-FOUND "{\"message\": \"not found\"}"))))
