(define (f x) 
   (println "f " x)
   (if (equal? x 1)
      1
      (begin
        (println x)
        (* x (f (- x 1)))))
        )

(println (f 4))
