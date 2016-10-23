(in-package :cl-user)
(defpackage com.momoiroshikibu.utils.string-util
  (:use :cl)
  (:export :hash-password))
(in-package :com.momoiroshikibu.utils.string-util)

(defun hash-password (password)
  (ironclad:byte-array-to-hex-string 
   (ironclad:digest-sequence 
    :sha256
    (ironclad:ascii-string-to-byte-array password))))
