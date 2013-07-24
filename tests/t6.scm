(package t6 0.1
   (export f)

  (define (f x y)
     (define (g y) (y x x))
     (* (g +) (g *) y))

)
