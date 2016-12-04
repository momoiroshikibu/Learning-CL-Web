(in-package :cl-user)
(defpackage com.momoiroshikibu.controllers.access-token
  (:use :cl)
  (:import-from :com.momoiroshikibu.utils
                :read-file-into-string)
  (:import-from :com.momoiroshikibu.utils.string-util
                :hash-password)
  (:import-from :com.momoiroshikibu.repositories.user
                :get-user-from-mail-address)
  (:import-from :com.momoiroshikibu.repositories.access-token
                :get-access-tokens
                :get-access-token-by-access-token
                :_create-access-token
                :_destroy-access-token)
  (:import-from :com.momoiroshikibu.models.user
                :get-id)
  (:import-from :cl-json
                :encode-json-to-string)
  (:import-from :lack.request
                :request-parameters)
  (:export :access-token-index
           :access-token-by-access-token
           :create-access-token
           :destroy-access-token))
(in-package :com.momoiroshikibu.controllers.access-token)

(defun access-token-index (env)
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
  (let* ((request (lack.request:make-request env))
         (request-parameters (request-parameters request))
         (body-parameters (lack.request:request-body-parameters request))
         (mail-address (cdr (assoc "mail-address" body-parameters :test 'string=)))
         (password (cdr (assoc "password" body-parameters :test 'string=)))
         (expected-password-hash (hash-password password))
         (user (get-user-from-mail-address mail-address expected-password-hash)))
    (princ user)
    (let* ((access-token (_create-access-token (get-id user)))
           ({access-token} (encode-json-to-string access-token)))
      (print {access-token})
      (if access-token
          `(200
            (:content-type "application/json")
            (,{access-token}))
          '(404
            (:content-type "application/json")
            ("null"))))))


(defun destroy-access-token (access-token)
  (_destroy-access-token access-token)
  `(200
    (:content-type "application/json")
    ()))
