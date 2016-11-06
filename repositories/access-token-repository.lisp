(in-package :cl-user)
(defpackage com.momoiroshikibu.repositories.access-token
  (:use :cl
        :dbi)
  (:import-from :com.momoiroshikibu.database.connection
                :*connection*)
  (:import-from :com.momoiroshikibu.models.access-token
                :access-token)
  (:export :get-access-token-by-access-token))
(in-package :com.momoiroshikibu.repositories.access-token)

(defvar *get-access-tokens-prepared-statement* (dbi:prepare *connection*
                                                        "select * from access_tokens limit ?"))

(defvar *get-access-token-by-access-token-prepared-statement* (dbi:prepare *connection*
                                                                 "select * from access_tokens where access_token = ?"))


(defun get-access-tokens (limit)
  (let* ((result (dbi:execute *get-access-tokens-prepared-statement* limit)))
    (loop for row = (dbi:fetch result)
       while row
       collect (make-instance 'access-token
                              :access-token (getf row :|access_token|)
                              :user-id (getf row :|user_id|)
                              :created-at (getf row :|created_at|)))))


(defun get-access-token-by-access-token (access-token)
  (let* ((result (dbi:execute *get-access-token-by-access-token-prepared-statement* access-token))
         (row (dbi:fetch result)))
    (if row
        (make-instance 'access-token
                       :access-token (getf row :|access_token|)
                       :user-id (getf row :|user_id|)
                       :created-at (getf row :|created_at|))
        nil)))
