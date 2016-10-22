(in-package :cl-user)
(defpackage com.momoiroshikibu.controller
  (:use :cl
        :dbi)
  (:export :users-new))
(in-package :com.momoiroshikibu.controller)


(defun users-new (env)
  `(200
    (:content-type "text/html")
    ("<h1>create new user</h1>
<form method='POST' action='/users'>
<input name=first-name placeholder='First Name' />
<input name=last-name placeholder='Last Name' />
<button>register</button>
</form>"))
  )
