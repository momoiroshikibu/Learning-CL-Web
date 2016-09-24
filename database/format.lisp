(in-package :cl-user)
(defpackage com.momoiroshikibu.format
  (:use :cl))
(in-package :com.momoiroshikibu.format)

(defun format-yyyy-mm-dd (decoded-time)
  (multiple-value-bind (second minute hour day month year) (decoded-time)
    (concatenate 'string (princ-to-string year) "-" (princ-to-string month) "-" (princ-to-string day))))

(export '(format-yyyy-mm-dd))
