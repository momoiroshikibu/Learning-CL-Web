(in-package :cl-user)
(load (merge-pathnames (make-pathname :directory '(:relative "./dependencies.lisp"))))
(defpackage com.momoiroshikibu.server
  (:use :cl)
  (:import-from :clack
                :clackup)
  (:import-from :lack.builder
                :builder)
  (:import-from :lack.middleware.session
                :*lack-middleware-session*)
  (:import-from :lack.middleware.accesslog
                :*lack-middleware-accesslog*)
  (:import-from :com.momoiroshikibu.middlewares.access-token-handler-middleware
                :access-token-handler-middleware)
  (:import-from :com.momoiroshikibu.middlewares.auth-handler-middleware
                :auth-handler-middleware)
  (:import-from :com.momoiroshikibu.app
                :app))
(in-package :com.momoiroshikibu.server)

(lack:builder :accesslog
;              :session
              #'access-token-handler-middleware
;              #'auth-handler-middleware
              #'app)
