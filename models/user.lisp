(defclass user ()
  ((id
    :reader get-id
    :initarg :id)
   (first-name
    :reader get-first-name
    :initarg :first-name)
   (last-name
    :reader get-last-name
    :initarg :last-name)
   (mail-address
    :reader get-mail-address
    :initarg :mail-address)
   (created-at
    :reader get-created-at
    :initarg :created-at)
   (created-by
    :reader get-created-by
    :initarg :created-by)
   (updated-at
    :reader get-updated-at
    :initarg :updated-at)
   (updated-by
    :reader get-updated-by
    :initarg :updated-by)))
