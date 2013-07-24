(use scmTree)

(define (l x y) (< x y))
(define (e x y) (= x y))

(define x (tree-new l e))

(tree-put x 5)
(tree-put x 10)
(tree-put x 9)
(tree-put x 122)
(tree-put x 33)

(define z (let ((c '()))
            (tree-traverse x (lambda (e) (set! c (cons e c))))
            c))
