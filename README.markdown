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

builder-fn take one argument of <json-builder> instance.
```lisp
(build (lambda (json)
          (tag json :hoge 10))))
=> <json-builder>
```

- key (<json-builder> key value-form)

Add key value-form to <json-builder>.
If value-form is function, then value-form is called with one argument <json-builder> instance and,
add key and return-value pair to <json-builder>.
If value-form is not a function, then key-value pair is added to <json-builder>.

```lisp
(encode-to-string
        (build (lambda (json)
                 (key json :hoge 10))))
=>"[{\"id\":1}]"
```

- array! (<json-builder> seq &optional fn)

if fn is given then fn is called with two arguments (<json-builder> item-in-seq).
if fn is not given then seq is directly added to <json-builder>

```lisp
(encode-to-string
        (build (lambda (json)
                 (array! json '(1 2 3)))))
=>"[1,2,3]"

(encode-to-string
        (build (lambda (json)
                 (array! json '(1 2 3) (lambda (json item)
                                          (key json :id item))))))
=>"[{\"id\":1},{\"id\":2},{\"id\":3}]"
```

- encode (<json-builder> &optional stream)

Write a JSON representation of object to stream and return nil.

- encode (<json-builder>)

Return the JSON representation of object as a string.

## Installation

## Author

* Masato Sogame (poketo7878@gmail.com)

## Copyright

Copyright (c) 2015 Masato Sogame (poketo7878@gmail.com)
