#|
  This file is a part of json-builder project.
  Copyright (c) 2015 Masato Sogame (poketo7878@gmail.com)
|#

#|
  Author: Masato Sogame (poketo7878@gmail.com)
|#

(in-package :cl-user)
(defpackage json-builder-asd
  (:use :cl :asdf))
(in-package :json-builder-asd)

(defsystem json-builder
  :version "0.1"
  :author "Masato Sogame"
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "json-builder"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op json-builder-test))))
