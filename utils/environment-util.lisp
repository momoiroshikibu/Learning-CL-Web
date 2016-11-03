(in-package :cl-user)
(defpackage com.momoiroshikibu.utils.environment-util
  (:use :cl)
  (:export :getenv))
(in-package :com.momoiroshikibu.utils.environment-util)

(defun getenv (variable-name)
  (sb-ext:posix-getenv variable-name))
