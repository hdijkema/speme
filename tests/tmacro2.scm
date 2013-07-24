(package tmacro2 0.1
	(f1 f2 f3 f4 f5 f10 g1 g2 g3 g4 g5)
	(use tmacro1)
	
(define (f1 a b) (foo a b))
(define (f2 a b c) (foo a b c))
(define (f3 a b c d) (foo a b c d))
(define (f4 a b c d e) (foo a b c d e))
(define (f5 a b c d e f) (foo a b c d e f))
(define (f10 a b c d e f g h i j k l m) (foo a b c d e f g h i j k l m))

(define (g1 a b) (bar a b))
(define (g2 a b c) (bar a b c))
(define (g3 a b c d) (bar a b c d))
(define (g4 a b c d e) (bar a b c d e))
(define (g5 a b c d e f) (bar a b c d e f))
	
)
