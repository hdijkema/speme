(package mor 0.1
	(mor)

(define-syntax mor 
	(syntax-rules ()
		((_ a) (if a #t #f))
		((_ a ...) (if a #t (mor ...)))))

)
	
