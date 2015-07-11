# Json-Builder

Builder style json builder for Common Lisp

## Usage

```lisp
(encode
        (build (lambda (json)
                  (key json :hoge 10))))
[{"id": 1}]
; No value

(encode-to-string
        (build (lambda (json)
                 (key json :hoge 10))))
=>"[{\"id\":1}]"
```

### API

- &lt;json-buider&gt;

Internal representation of json.

- build (builder-fn)

builder-fn take one argument of &lt;json-builder&gt instance.
```lisp
(build (lambda (json)
          (tag json :hoge 10))))
=> <json-builder>;
```

- key (&lt;json-builder&gt; key value-form)

Add key value-form to &lt;json-builder&gt;.
If value-form is function, then value-form is called with one argument &lt;json-builder&gt; instance and,
add key and return-value pair to &lt;json-builder&gt;.
If value-form is not a function, then key-value pair is added to &lt;json-builder&gt;.

```lisp
(encode-to-string
        (build (lambda (json)
                 (key json :hoge 10))))
=> "[{\"id\":1}]"
```

- array! (&lt;json-builder&gt; seq &optional fn)

if fn is given then fn is called with two arguments (&lt;json-builder&gt; item-in-seq).
if fn is not given then seq is directly added to &lt;json-builder&gt;

```lisp
(encode-to-string
        (build (lambda (json)
                 (array! json '(1 2 3)))))
=> "[1,2,3]"

(encode-to-string
        (build (lambda (json)
                 (array! json '(1 2 3) (lambda (json item)
                                          (key json :id item))))))
=> "[{\"id\":1},{\"id\":2},{\"id\":3}]"
```

- extract! (&lt;json-builder&gt; obj &rest keys)

extract slots from given object. if no keys given then extract whole slot.

```lisp
(defstruct dummy
  id name)

(let ((dummy-obj (make-dummy :id 10 :name "I am dummy")))
  (encode-to-string
     (build (lambda (json)
              (extract! json dummy-obj)))))
=> "{:id 10, :name \"I am dummy\"}"

(let ((dummy-obj (make-dummy :id 10 :name "I am dummy")))
  (encode-to-string
     (build (lambda (json)
              (extract! json dummy-obj :id)))))
              
=> "{:id 10}"
```

- encode (&lt;json-builder&gt; &optional stream)

Write a JSON representation of object to stream and return nil.

- encode (&lt;json-builder&gt;)

Return the JSON representation of object as a string.

## Installation

## Author

* Masato Sogame (poketo7878@gmail.com)

## Copyright

Copyright (c) 2015 Masato Sogame (poketo7878@gmail.com)
