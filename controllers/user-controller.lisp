(in-package :cl-user)
(defpackage com.momoiroshikibu.controller
  (:use :cl
        :dbi)
  (:export :users-new))
(in-package :com.momoiroshikibu.controller)

(defvar *html* (with-open-file (stream
                 "views/users-new.html"
                 :direction :input)
  (let ((buffer (make-string (file-length stream))))
    (read-sequence buffer stream)
    buffer)))

(defun users-new (env)
  `(200
    (:content-type "text/html")
    (,*html*))
  )
