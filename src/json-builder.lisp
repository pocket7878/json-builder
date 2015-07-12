(in-package :cl-user)
(defpackage json-builder
  (:use :cl)
  (:import-from :jonathan
                :to-json)
  (:import-from :alexandria
                :make-keyword
                :symbolicate))
(in-package :json-builder)

(annot:enable-annot-syntax)

(defclass <json-builder> ()
  ((dirty :reader dirty
          :initform nil)
   (data :initarg :data
         :reader data
         :initform (make-hash-table))))

(defmethod add-value ((jbuilder <json-builder>) key value)
  (setf (slot-value jbuilder 'dirty) t
        (gethash key (data jbuilder) nil) value))

@export
(defgeneric encode (jbuilder))

@export
(defmethod encode ((jbuilder <json-builder>))
  (to-json (data jbuilder)))

@export
(defmethod key ((jbuilder <json-builder>) key value-form)
  (if (functionp value-form)
      (let ((json (make-instance '<json-builder>)))
        (funcall value-form json)
        (when (dirty json)
          (add-value jbuilder key (data json))))
    (add-value jbuilder key value-form)))

@export
(defmethod array! ((jbuilder <json-builder>) seq &optional fn)
  (setf (slot-value jbuilder 'dirty) t
        (slot-value jbuilder 'data)
        (let ((acc nil))
          (loop for item in (reverse seq)
             do
               (if fn
                   (let ((json (make-instance '<json-builder>)))
                     (funcall fn json item)
                     (if (dirty json)
                         (pushnew (data json) acc)))
                   (pushnew item acc)))
          acc)))

@export
(defmethod extract! ((jbuilder <json-builder>) obj &rest keys)
  (if keys
      (loop for key in keys
         do
           (let* ((key (make-keyword key))
                  (slot-name (symbolicate (symbol-name key))))
             (key jbuilder key (slot-value obj slot-name))))
      (loop for slot in (c2mop:class-direct-slots (class-of obj))
         do
           (let ((slot-name (c2mop:slot-definition-name slot)))
             (key jbuilder (make-keyword slot-name) (slot-value obj slot-name))))))

@export
(defun build (builder-fn)
  (let ((json (make-instance '<json-builder>)))
    (funcall builder-fn json)
    json))
