#!/bin/sh
#|-*- mode:lisp -*-|#
#| <Put a one-line description here>
exec ros -Q -- $0 "$@"
|#
(ql:quickload :clack)
(load (merge-pathnames (make-pathname :directory '(:relative "./database.lisp"))))


;; (progn ;;init forms
;;   (ql:quickload :clack)
;;   (ql:quickload :dbi)
;;   (load (merge-pathnames (make-pathname :directory '(:relative "./database.lisp")))))

;; (defpackage com.momoiroshikibu.database.crud-web
;;   (:use :cl
;;         :clack
;;         :com.momoiroshikibu.database))
;; (in-package :com.momoiroshikibu.database.crud-web)



;; (defun main (&rest argv)
;;   (declare (ignorable argv))
;;   (clack:clackup app
;;                  :port 5000
;;                  :debug t))


;; (defvar *handler*
;;   (clack:clackup app
;;            :port 5000
;;            :debug t))

;; (print *handler*)

(defun format-user (user-plist)
  (format nil "ID: ~A~&FirstName: ~A~&LastName: ~A~&CreatedAt: ~A~&"
          (getf user-plist :|id|)
          (getf user-plist :|first_name|)
          (getf user-plist :|last_name|)
          (getf user-plist :|created_at|)))

;; (clack:clackup
;;  (lambda (env)
;;    '(200
;;     (:content-type "text-plain")
;;     (
;;      "aiueo"
;; ;     (format-user (select 0))
;;      ))))

;; (defun app (env)
;;   (declare (ignore env))
;;   '(200
;;     (:content-type "text-plain")
;;     ("hello"
;;      ;(format-user (select 0))
;;      )))

;; (defvar app
;;   #'(lambda (env)
;;       (declare (ignore env))
;;       '(200
;;         (:content-type "text/plain")
;;         ("hello"))))


(defvar app
  #'(lambda (env)
      (declare (ignore env))
      '(200
        (:content-type "text/plain")
        (format-user (select-one 1)))))





(defun main (&rest argv)
  (declare (ignorable argv))
  (clack:clackup app
                 :port 5000
                 :debug t))

(clack:clackup app
                 :port 5000
                 :debug t)


;; (defun app (env)
;;   (declare (ignore env))
;;   '(200
;;     (:content-type "text-plain")
;;     ("hello"
;;      ;(format-user (select 0))
;;      )))
;; ;; (export '(app))
