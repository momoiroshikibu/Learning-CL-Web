(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.location
  (:use :cl)
  (:import-from :com.momoiroshikibu.repositories.location
                :get-locations)
  (:import-from :jonathan
                :to-json)
  (:export :index))
(in-package :com.momoiroshikibu.controllers.location)


(defun index ()
  (let* ((locations (get-locations 100))
         ({locations} (to-json locations)))
    `(200
      (:content-type "application/json")
      (,{locations}))))
