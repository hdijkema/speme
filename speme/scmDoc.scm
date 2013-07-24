(package scmDoc 0.1
 		 (doc help?)
 		 
(define _cat (hash-new))
(define _syntax (hash-new))
(define _descr (hash-new))
 
(define (doc category function synt description)
    (let ((l (if (hash-exists? _cat category) (hash-get _cat category) '())))
    	(hash-put _cat category (cons function l)))
	(hash-put _syntax function synt)
	(hash-put _descr function description)
	)
	
(define (help? function)
  (println (hash-get _syntax function) (hash-get _descr function)))
  

 		 
)
