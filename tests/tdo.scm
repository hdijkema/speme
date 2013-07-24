(package tdo 0.1
  (tdo)

(define (tdo n)
  (let ((l (list)))
    (do ((i 0 (+ i 1))) 
       ((> i n) l)
      (set! l (cons i l)))))

)
	
     
