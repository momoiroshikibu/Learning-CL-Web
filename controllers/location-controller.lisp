(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.location
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.repositories.location
                :get-locations
                :get-location-by-id
                :create-location)
  (:import-from :cl-json
                :encode-json-to-string)
  (:import-from :jonathan
                :to-json)
  (:export :location-index
           :location-new
           :location-by-id
           :register-location))
(in-package :com.momoiroshikibu.controllers.location)


(defparameter *<location-new-html>* (read-file-into-string "views/location/location-new.html"))

(defun location-index ()
  (let* ((locations (get-locations 100))
         ({locations} (to-json locations)))
    `(200
      (:content-type "application/json")
      (,{locations}))))

(defun location-new ()
  `(200
    (:content-type "text/html")
    (,*<location-new-html>*)))


(defun location-by-id (id)
  (let* ((location (get-location-by-id id))
         ({location} (to-json location)))
    (if location
        `(200
          (:content-type "application/json")
          (,{location}))
        '(404
          (:content-type "application/json")
          ("null")))))

(defun register-location (env lat lng)
  (let* ((login-user (gethash :login-user (getf env :lack.session)))
         (login-user-id (getf login-user :|id|)))
    (create-location login-user-id lat lng)
    '(303
      (:location "/locations"))))
