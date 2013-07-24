;;; Tests if generation of lists leaks 

(define (generate-list k)
   (if (> k 0)
      (cons k (generate-list (- k 1)))
      (list)))

(define (leak-test n)
   (do ((i 0 (+ i 1)))
      ((>= i n) #t)
     (generate-list 100)))

(define (leak-test1 n)
   (if (> n 0)
     (cons (generate-list 100) (leak-test1 (- n 1)))
     (list)))

