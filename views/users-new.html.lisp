(in-package :cl-user)
(defpackage com.momoiroshikibu.views
  (:use :cl
        :dbi)
  (:export :*view*))
(in-package :com.momoiroshikibu.database)

(defvar *view* "
<h1>create new user</h1>
<form method='POST' action='/users'>
  <input name=first-name placeholder='First Name' />
  <input name=last-name placeholder='Last Name' />
  <button>register</button>
</form>
")
