(define (f x)
   (let ((y (if (equal? x 3) (* x x) x)) (z 2))
      (* x y z)))

(println (f 10))
(println (f 3))
