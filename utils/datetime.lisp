(in-package :cl-user)
(defpackage com.momoiroshikibu.datetime
  (:use :cl)
  (:export :get-current-date-in-yyyy-mm-dd-format))
(in-package :com.momoiroshikibu.datetime)

(defun get-current-date-in-yyyy-mm-dd-format ()
  (multiple-value-bind (second minute hour day month year)
      (get-decoded-time)
    (declare (ignore second minute hour))
    (concatenate 'string (princ-to-string year) "-" (princ-to-string month) "-" (princ-to-string day))))
