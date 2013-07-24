(package b 0.1
   (log sin lg)
   (define (sin a) (perl sin a))
;   (define (log a) (perl log a))
	(perl-import log)
	
	(define (lg x) (log x))
)
