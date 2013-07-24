(package t7 0.1
   (export f)

 (define (f x)
   (let loop ((y 0)
              (a x)
              (b (* a a)))
      (println a " - " b)
      (if (< y x)
         (+ (loop (+ y 1) a b) y)
         y)))
        

)
