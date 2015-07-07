#|
  This file is a part of json-builder project.
  Copyright (c) 2015 Masato Sogame (poketo7878@gmail.com)
|#

(in-package :cl-user)
(defpackage json-builder-test-asd
  (:use :cl :asdf))
(in-package :json-builder-test-asd)

(defsystem json-builder-test
  :author "Masato Sogame"
  :license ""
  :depends-on (:json-builder
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "json-builder"))))
  :description "Test system for json-builder"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
