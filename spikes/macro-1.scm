 (define y 2)

 (define-syntax max
     (syntax-rules ()
       ((_ a) (* y a))
       ((_ a b) (+ (max a) (max b)))
       ((_ a b ...) (+ (max a) (max b ...)))))
       
(max 3)
((lambda (a) (* y a)) 3)
(let ((form1 (lambda (a) (* y a))))
	(form1 3))

(max b)
((lambda (a) (* y a)) b)
(let ((form1 (lambda (a) (* y a))))
   (form1 b))

(max x y)
((lambda (a b) (+ ((lambda (a) (* y a)) a) ((lambda (a) (* y a)) b))) x y)
(let ((form2 (lambda (a b) 
				(let ((form11 (lambda (a) (* y a)))
				      (form12 (lambda (a) (* y a))))
				      (+ (form11 a) (form12 b))))))
     (form2 x y))
     



