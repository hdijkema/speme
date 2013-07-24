(package tmacro3 0.1
   (bar)

(define-syntax bar
  (syntax-rules ()
    ((_ a) (let ((l a))
		(print l)))))

)

	
