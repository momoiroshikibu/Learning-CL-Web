(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.login
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:export :index
           :authenticate))
(in-package :com.momoiroshikibu.controllers.login)

(defun index ()
  `(200
    (:content-type "text/html")
    (,(com.momoiroshikibu.utils:read-file-into-string "views/login/login.html"))))

(defun authenticate (mail-address password)
  (let* ((expected-password-hash (com.momoiroshikibu.utils.string-util:hash-password password))
         (user (com.momoiroshikibu.database:select-user-from-mail-address mail-address expected-password-hash)))
    (princ mail-address)
    (princ expected-password-hash)
    (princ user)
    (if user
        `(303
          (:location "/users"))
        `(303
          (:location "/login")))))


;; (defun authenticate (mail-address password)
;;   (let ((user (com.momoiroshikibu.database:select-user-from-mail-address mail-address))
;;         (expected-password-hash (com.momoiroshikibu.utils.string-util:hash-password password)))
;;     (if user
;;         (let (actual-password-hash (getf user :|password_hash|))
;;           (if (eq expected-password-hash actual-password-hash)
;;               `(303
;;                 (:location "/"))
;;               `(303
;;                 (:location "/login")))))))
