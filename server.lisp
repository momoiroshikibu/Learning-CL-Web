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
  (:import-from :com.momoiroshikibu.middlewares.auth-handler-middleware
                :auth-handler-middleware)
  (:import-from :com.momoiroshikibu.app
                :app)
  (:export :*app*))
(in-package :com.momoiroshikibu.server)

(defvar *app* (lack:builder :accesslog
                            :session
                            #'auth-handler-middleware
                            #'app))
