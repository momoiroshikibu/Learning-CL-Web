(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:export :users
           :register
           :destroy
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers)


(defun string-join (string-list)
    (format nil "~{~A~^ ~}" string-list))

(defvar <users-partial-template> (com.momoiroshikibu.utils:read-file-into-string "views/users-partial.html"))
(defvar <users-page-template> (com.momoiroshikibu.utils:read-file-into-string "views/users.html"))



(defun users-new ()
  `(200
    (:content-type "text/html")
    (,(com.momoiroshikibu.utils:read-file-into-string "views/users-new.html"))))


(defun users (count)
  (let* ((users (com.momoiroshikibu.database:select-multi count))
         (<users-partial> (loop for row in users
                             collect (format nil <users-partial-template>
                                             (getf row :|id|)
                                             (getf row :|id|)
                                             (getf row :|last_name|)
                                             (getf row :|first_name|))))
         (<users-page> (format nil <users-page-template> (string-join <users-partial>))))
    `(200
      (:content-type "text/html")
      (,<users-page>))))


(defun users-by-id (user-id)
  (let* ((user (com.momoiroshikibu.database:select-one user-id))
         (user-html (format nil (com.momoiroshikibu.utils:read-file-into-string "views/user.html")
          (getf user :|id|)
          (getf user :|first_name|)
          (getf user :|last_name|)
          (getf user :|mail_address|)
          (getf user :|created_at|)
          (getf user :|id|))))
    `(200
      (:content-type "text/html")
      (,user-html))))


(defun register (first-name last-name mail-address password)
  (let ((password-hash (com.momoiroshikibu.utils.string-util:hash-password password)))
    (com.momoiroshikibu.database:insert first-name last-name mail-address password-hash)
    `(303
      (:location "/users"))))


(defun destroy (id)
  (com.momoiroshikibu.database:destroy id)
  `(303
    (:location "/users")))
