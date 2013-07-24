(package scmHash 0.1
      (new)

(use scmCore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OO interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (new class) 
  (let ((obj (hash-new)))
    (bless obj class)
    obj))

(define (put self key val)
  (hash-put self key val)
  self)

(define (get self key)
  (hash-get self key))

(define (exists? self key)
  (hash-exists? self key))

(define (remove self key)
  (hash-remove self key))

(define (keys self)
  (hash-keys self))

(define (each self)
  (hash-each self))

)
