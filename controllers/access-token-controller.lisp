(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.access-token
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.repositories.access-token
                :get-access-tokens
                :get-access-token-by-access-token
                :_create-access-token)
  (:import-from :com.momoiroshikibu.models.user
                :get-id)
  (:import-from :cl-json
                :encode-json-to-string)
  (:export :access-token-index
           :access-token-by-access-token
           :create-access-token))
(in-package :com.momoiroshikibu.controllers.access-token)

(defun access-token-index ()
  (let* ((access-tokens (get-access-tokens 100))
         ({access-tokens} (encode-json-to-string access-tokens)))
    `(200
      (:content-type "application/json")
      (,{access-tokens}))))


(defun access-token-by-access-token (access-token)
  (let* ((access-token (get-access-token-by-access-token access-token))
         ({access-token} (encode-json-to-string access-token)))
    (if access-token
        `(200
          (:content-type "application/json")
          (,{access-token}))
        '(404
          (:content-type "application/json")
          ("null")))))

(defun create-access-token (env)
  (let* ((login-user (gethash :login-user (getf env :lack.session)))
         (login-user-id (get-id login-user)))
    (let* ((access-token (_create-access-token login-user-id))
           ({access-token} (encode-json-to-string access-token)))
      (print {access-token})
      (if access-token
          `(200
            (:content-type "application/json")
            (,{access-token}))
          '(404
            (:content-type "application/json")
            ("null"))))))
