(package scmTree 0.1
         (tree-new tree-put tree-get tree-remove tree-exists? tree-traverse)

(define (tree-new less eq) 
   (list 'tree less eq 'nil))      ; value left right

;;;;;;;;; put

(define (tree-put tree val) 
  (begin
     (set-car! (cdddr tree) (i-tree-put (cadr tree) (caddr tree) val (cadddr tree)))
     tree))

(define (i-tree-put less eq val node)
   (if (list? node) 
     ;(begin
     ;(println "i-tree-put: " node (eq val (car node)) (less val (car node)))
     (if (equal? (car node) 'nil)
        (list val (cadr node) (caddr node))
        (if (less val (car node))
           (list (car node) (i-tree-put less eq val (cadr node)) (caddr node))
           (if (eq val (car node))
             (list val (cadr node) (caddr node))
             (list (car node) (cadr node) (i-tree-put less eq val (caddr node))))))
     ;)
     (list val 'nil 'nil)))

;;;;;;;;;; get

(define (tree-get tree key)
   (i-tree-get (cadr tree) (caddr tree) key (cadddr tree)))

(define (i-tree-get less eq key node) 
   (if (list? node)
      (if (equal? (car node) 'nil)
         'nil
         (if (less key (car node))
            (i-tree-get less eq key (cadr node))
            (if (eq key (car node))
               (car node)
               (i-tree-get less eq key (caddr node)))))
      'nil))

;;;;;;;;; exists

(define (tree-exists? tree key)
   (i-tree-exists (cadr tree) (caddr tree) key (cadddr tree)))

(define (i-tree-exists less eq key node)
   (if (list? node)
     (if (equal? (car node) 'nil)
        #f
        (if (less key (car node))
           (i-tree-exists less eq key (cadr node))
           (if (eq key (car node))
              #t
              (i-tree-exists less eq key (caddr node)))))
    #f))


;;;;;;;;; remove

(define (tree-remove tree key)
  (begin
    (set-car! (cdddr tree) (i-tree-remove (cadr tree) (caddr tree) key (cadddr tree)))
    tree))

(define (i-tree-remove less eq key node)
  (if (list? node)
    (if (equal? (car node) 'nil)
       node
       (if (less key (car node))
         (list (car node) (i-tree-remove less eq key (cadr node)) (caddr node))
         (if (eq key (car node))
            (let ((left (cadr node))
                  (right (caddr node)))
               (if (equal? left 'nil)
                  (if (equal? right 'nil)
                     'nil
                     right)
                  (if (equal? right 'nil)
                     left
                     (list (car left) (cadr left) (i-tree-put-part less (caddr left) right)))))
            (list (car node) (cadr node) (i-tree-remove less eq key (caddr node))))))
    node))

(define (i-tree-put-part less node part)
  (if (list? node)
     (if (equal? (car node) 'nil)
        part
        (if (less (car part) (car node))
           (list (car node) (i-tree-put-part less (cadr node) part) (caddr node))
           (list (car node) (cadr node) (i-tree-put-part less (caddr node) part))))
     part))


;;;;;;;;;; traverse

(define (tree-traverse tree f)
  (i-tree-traverse (cadddr tree) f))


(define (i-tree-traverse node f)
  (if (list? node)
     (begin
       (i-tree-traverse (cadr node) f)
       (f (car node))
       (i-tree-traverse (caddr node) f))
     'nil))
    
)
