(in-package :cl-user)
(defpackage json-builder
  (:use :cl)
  (:import-from :cl-json
                :encode-json
                :encode-json-to-string))
(in-package :json-builder)

(annot:enable-annot-syntax)

(defclass <json-builder> ()
  ((dirty :reader dirty
          :initform nil)
   (data :initarg :data
         :reader data
         :initform nil)))

(defmethod add-value ((jbuilder <json-builder>) value)
  (setf (slot-value jbuilder 'dirty) t)
  (pushnew value (slot-value jbuilder 'data)))

@export
(defgeneric encode (jbuilder &optional stream))

@export
(defmethod encode ((jbuilder <json-builder>) &optional (stream cl-json:*json-output*))
  (encode-json (data jbuilder) stream))

@export
(defgeneric encode-to-string (jbuilder))

@export
(defmethod encode-to-string ((jbuilder <json-builder>))
  (encode-json-to-string (data jbuilder)))

@export
(defmethod key ((jbuilder <json-builder>) key value-form)
  (if (functionp value-form)
      (let ((json (make-instance '<json-builder>)))
        (funcall value-form json)
        (add-value jbuilder (cons key (data json))))
    (add-value  jbuilder (cons key value-form))))

@export
(defmethod array! ((jbuilder <json-builder>) seq &optional fn)
  (loop for item in (reverse seq)
        do
        (if fn
            (let ((json (make-instance '<json-builder>)))
              (funcall fn json item)
              (if (dirty json)
                  (add-value jbuilder (data json))))
          (add-value jbuilder item))))

@export
(defun build (builder-fn)
  (let ((json (make-instance '<json-builder>)))
    (funcall builder-fn json)
    json))
