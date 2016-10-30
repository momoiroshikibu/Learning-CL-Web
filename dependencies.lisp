(ql:quickload :dbi)
(ql:quickload :clack)
(ql:quickload :lack)
(ql:quickload :lack-request)
(ql:quickload :lack-middleware-session)
(ql:quickload :lack-middleware-accesslog)
(ql:quickload :hunchentoot)
(ql:quickload :ironclad)
(ql:quickload :jonathan)


(defmacro load-file (file-path)
  `(load (merge-pathnames (make-pathname :directory '(:relative ,file-path)))))

(load-file "./utils/string-util.lisp")
(load-file "./utils/datetime.lisp")
(load-file "./database/connection.lisp")
(load-file "./repositories/user-repository.lisp")
(load-file "./repositories/location-repository.lisp")
(load-file "./utils/file-util.lisp")
(load-file "./controllers/login-controller.lisp")
(load-file "./controllers/user-controller.lisp")
(load-file "./controllers/location-controller.lisp")
(load-file "./middlewares/auth-handler-middleware.lisp")
