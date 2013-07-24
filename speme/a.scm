(package a 0.1
   (rr)

(define (f l1 l2)
  (for-each (lambda (x) (println x)) l1 l2))

(defperl
"sub r($) { return $_[0]*2; } our $scm_r=\&r;"
)

(define (rr x) (r x))

;(f '(1 2 3 4))
)
