(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.location
  (:use :cl)
  (:import-from :com.momoiroshikibu.repositories.location
                :get-locations
                :get-location-by-id)
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :index))
(in-package :com.momoiroshikibu.controllers.location)


(defun index ()
  (let* ((locations (get-locations 100))
         ({locations} (encode-json-to-string locations)))
    `(200
      (:content-type "application/json")
      (,{locations}))))

(defun location-by-id (id)
  (let* ((location (get-location-by-id id))
         ({location} (encode-json-to-string location)))
    (print location)
    (if location
        `(200
          (:content-type "application/json")
          (,{location}))
        '(404
          (:content-type "application/json")
          ("null")))))
