(package tmacro3a 0.1
	(foo1 foo2 foo3)
	
	(use tmacro3)
	
	(define (foo1 l) (bar l))
	(define (foo2 q) (bar q))
	(define (foo3 r l) (begin (bar (foo1 r)) (bar (foo1 l))))

)

