(in-package :cl-user)
(defpackage com.momoiroshikibu.utils
  (:use :cl)
  (:export :read-file-into-string))
(in-package :com.momoiroshikibu.utils)

(defun read-file-into-string (file-path)
  (with-open-file (stream
                   file-path
                   :direction :input)
    (let ((buffer (make-string (file-length stream))))
      (read-sequence buffer stream)
      buffer)))
