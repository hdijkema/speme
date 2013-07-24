(package tmacro1 0.1
	(foo bar)
	
	(define-syntax foo
		(syntax-rules ()
			((_ a b) (if (< a b) b a))
			((_ a b ...) (let ((c (foo b ...))) (foo a c)))))
			
	(define-syntax bar
		(syntax-rules ()
			((_ a b) (if (< a b) b a))
			((_ a b ...) (bar a (bar b ...)))))
			
)
