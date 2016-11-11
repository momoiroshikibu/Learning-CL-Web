(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.location
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.repositories.location
                :get-locations
                :get-location-by-id
                :create-location)
  (:import-from :com.momoiroshikibu.models.user
                :get-id)
  (:import-from :cl-json
                :encode-json-to-string)
  (:import-from :lack.request
                :make-request
                :request-parameters)
  (:export :location-index
           :location-new
           :location-by-id
           :register-location))
(in-package :com.momoiroshikibu.controllers.location)


(defparameter *<location-new-html>* (read-file-into-string "views/location/location-new.html"))

(defun location-index (env)
  (let* ((locations (get-locations 100))
         ({locations} (encode-json-to-string locations)))
    `(200
      (:content-type "application/json")
      (,{locations}))))

(defun location-new (env)
  `(200
    (:content-type "text/html")
    (,*<location-new-html>*)))

(defun location-by-id (id)
  (let* ((location (get-location-by-id id))
         ({location} (encode-json-to-string location)))
    (if location
        `(200
          (:content-type "application/json")
          (,{location}))
        '(404
          (:content-type "application/json")
          ("null")))))

(defun register-location (env)
  (let* ((request (lack.request:make-request env))
         (request-parameters (request-parameters request))
         (body-parameters (lack.request:request-body-parameters request))
         (lat (cdr (assoc "lat" body-parameters :test #'string=)))
         (lng (cdr (assoc "lng" body-parameters :test #'string=)))
         (login-user (gethash :login-user (getf env :lack.session)))
         (login-user-id (get-id login-user)))
    (create-location login-user-id lat lng)
    '(303
      (:location "/locations"))))
