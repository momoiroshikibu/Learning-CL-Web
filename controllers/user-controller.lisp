(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:export :users
           :register
           :users-new
           :users-by-id))
(in-package :com.momoiroshikibu.controllers)


(defun string-join (string-list)
    (format nil "~{~A~^ ~}" string-list))

(defun users-new ()
  `(200
    (:content-type "text/html")
    (,(com.momoiroshikibu.utils:read-file-into-string "views/users-new.html"))))

(defvar <users-partial-template> (com.momoiroshikibu.utils:read-file-into-string "views/users-partial.html"))
(defvar <users-page-template> (com.momoiroshikibu.utils:read-file-into-string "views/users.html"))

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
         (user-html (format-user (getf user :|id|)
                                 (getf user :|first_name|)
                                 (getf user :|last_name|)
                                 (getf user :|created_at|))))
    `(200
      (:content-type "text/html")
      (,user-html))))

(defun register (first-name last-name)
  (com.momoiroshikibu.database:insert first-name last-name)
  `(303
    (:location "/users")))


(defun format-user (user-id first-name last-name created-at)
  (format nil (com.momoiroshikibu.utils:read-file-into-string "views/user.html")
          user-id
          first-name
          last-name
          created-at))
