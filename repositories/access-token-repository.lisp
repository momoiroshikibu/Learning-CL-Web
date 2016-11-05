(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.access-token
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:import-from :com.momoiroshikibu.models.access-token
                :access-token)
  (:export :get-access-token-by-id))
(in-package :com.momoiroshikibu.repositories.access-token)

(defvar *get-access-token-by-id-prepared-statement* (dbi:prepare *connection*
                                                                 "select * from access_tokens where id = ?"))

(defun get-access-token-by-id (id)
  (let* ((result (dbi:execute *get-access-token-by-id-prepared-statement* id))
         (row (dbi:fetch result)))
    (if row
        (make-instance 'access-token
                       :id (getf row :|id|)
                       :user-id (getf row :|user_id|)
                       :access-token (getf row :|access_token|)
                       :created-at (getf row :|created_at|))
        nil)))
