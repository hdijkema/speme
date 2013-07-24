;(define (make-vector k . fill) 
   ;(let ((em '())
         ;(mv (lambda (k v) (if (> k 0) (cons v (mv (- k 1) v)) em))))
      ;(if (empty? fill)
         ;(mv k 0)
         ;(mv k (car fill)))))


;(define (f x)
  ;(let ((m (lambda (x) (if (> x 0) (cons x (m (- x 1))) '()))))
    ;(m x)))


(define (f x)
  (if (> x 0) 
     (cons x (f (- x 1)))
     '()))

(define (g x)
  (let ((m (lambda (y) (if (> y 0) (cons y (m (- y 1))) '()))))
    (m (* x x))))

(println (f 0))
(println (f 10))
(println (g 0))
(println (g 1))
(println (g 2))
(println (f 10))
(println (g 10))

