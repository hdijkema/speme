(package t8 0.1
  (export fill)

(define (fill vec index val)
  (if (< index (vector-length vec))
     (begin
        (vector-set! vec index val)
        (fill vec (+ index 1) val))
     0))

)
