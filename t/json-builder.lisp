(in-package :cl-user)
(defpackage json-builder-test
  (:use :cl
        :json-builder
        :prove))
(in-package :json-builder-test)

;; NOTE: To run this test file, execute `(asdf:test-system :json-builder)' in your Lisp.

(plan nil)

(is (encode
     (build (lambda (json))))
    "{}")

(is (encode
     (build (lambda (json)
              (key json :|id| 10))))
    "{\"id\":10}")

(is (encode
     (build (lambda (json)
              (key json :|id| 10)
              (key json :|foo| "bar"))))
    "{\"foo\":\"bar\",\"id\":10}")

(is (encode
     (build (lambda (json)
              (array! json '(1 2 3)))))
    "[1,2,3]")

(is (encode
     (build (lambda (json)
              (array! json '(1 2 3) (lambda (json item)
                                      (key json :|id| item))))))
    "[{\"id\":1},{\"id\":2},{\"id\":3}]")

(is (encode
     (build (lambda (json)
              (key json :id 10)
              (array! json '(1 2 3) (lambda (json item)
                                      (key json :|id| item))))))
    "[{\"id\":1},{\"id\":2},{\"id\":3}]")

(defstruct foo
  id name)

(is (encode
     (build (lambda (json)
              (extract! json (make-foo :id 1 :name "Foo")))))
    "{\"NAME\":\"Foo\",\"ID\":1}")

(finalize)
