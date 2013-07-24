(package scmAnObj 0.1
      (new)

(use scmCore)

(define (new class) 
  (let ((obj (hash-new)))
    (bless obj class)
    obj))

(define (time self x)
	(hash-put self 'x x))

(define (get self)
   (let ((n (hash-get self 'x)))
     (makelist n)))

(define (makelist x)
  (if (> x 1) (cons x (makelist (- x 1))) '()))
	
)
