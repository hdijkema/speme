(core-package scmCore 0.1
    (cddr cadr cdar caar cdddr caddr cdadr cddar caadr cadar cdaar caaar
     cddddr cadddr cdaddr cddadr cdddar caaddr cadadr cdadar cdaadr cddaar caaadr caadar cadaar cdaaar caaaar
     list? empty? pair? null?
     vector? make-vector vector-ref vector-set! vector-length vector-fill vector->list list->vector
     string<=? string>? string>=? string=? string<? string-append string-trim chop chr chomp
     equal?
     symbol->string string->symbol
     hash-new hash-put hash-get hash? hash-exists? hash-remove hash-keys hash-each
     exit
     bless
     mapf
     regexp re-match re-replace
     
     ;; Numeric stack
     floor ceiling truncate round 
     modulo remainder quotient gcd lcm
     max min
     integer? real? rational? complex? 
     zero? positive? negative? even? odd?
     log sin cos atan2
     
     ;; Perl stuff
     defined
     
     ;; Shell, environment
     env
     
     ;; I/O
     port? stdin stdout stderr
     open close eof 
     readline display displayline newline write-char
     write 
     chdir chmod chown
     
     ;; Directories, files
     opendir readdir closedir readdir telldir rewinddir seekdir
     glob
     unlink rename
     is-file? is-dir? test-r? test-e? test-f? test-d? test-z? test-x? test-w?
     
     ;; DBM
     dbmopen dbmclose
     
     ;; language constructs
     for-each

     ;; version etc.
     speme-author speme-version speme-copyright speme-name
    )
(use POSIX)
(use scmVersion)
(use File::Glob ":glob")

(define not-part "This function is not part of this scheme implementation")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; list operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cddr l) (cdr (cdr l)))
(define (cadr l) (car (cdr l)))
(define (cdar l) (cdr (car l)))
(define (caar l) (car (car l)))

(define (cdddr l) (cdr (cddr l)))
(define caddr (lambda (l) (car (cddr l))))
(define cdadr (lambda (l) (cdr (cadr l))))
(define cddar (lambda (l) (cdr (cdar l))))
(define caadr (lambda (l) (car (cadr l))))
(define cadar (lambda (l) (car (cdar l))))
(define cdaar (lambda (l) (cdr (caar l))))
(define caaar (lambda (l) (car (caar l))))

(define cddddr (lambda (l) (cdr (cdddr l))))
(define cadddr (lambda (l) (car (cdddr l))))
(define cdaddr (lambda (l) (cdr (caddr l))))
(define cddadr (lambda (l) (cdr (cdadr l))))
(define cdddar (lambda (l) (cdr (cddar l))))
(define caaddr (lambda (l) (car (caddr l))))
(define cadadr (lambda (l) (car (cdadr l))))
(define caddar (lambda (l) (car (cddar l))))
(define cdadar (lambda (l) (cdr (cadar l))))
(define cdaadr (lambda (l) (cdr (caadr l))))
(define cddaar (lambda (l) (cdr (cdaar l))))
(define caaadr (lambda (l) (car (caadr l))))
(define caadar (lambda (l) (car (cadar l))))
(define cadaar (lambda (l) (car (cdaar l))))
(define cdaaar (lambda (l) (cdr (caaar l))))
(define caaaar (lambda (l) (cdr (cdddr l))))

(define (list? x) (_seq (typeof x) "list"))
(define (empty? x) (if (list? x) (= (length x) 0) (die "argument is no list") ))
(define (null? x) (empty? x))
(define (pair? x) (list? x))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vector operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector? x) (perl_is_v x))
(define (make-vector k . fill) (if (null? fill) (perl_vn k 0) (perl_vn k (car fill))))
(define (vector-ref v index) (perl_vg v index))
(define (vector-set! v index val) (perl_vp v index val))
;(define (vector l) (perl_vn_fl l))   // defined in Operators.pm
(define (vector-length v) (perl_vl v))

(define (vector-fill v f)
   (let ((l (vector-length v)))
     (define (fill i)
        (if (< i l)
           (begin
             (vector-set! v i f)
             (fill (+ i 1)))
           v))
     (fill 0)))

(define (vector->list v)
  (let ((l (vector-length v)))
    (define (tol i)
      (if (< i l)
         (cons (vector-ref v i) (tol (+ i 1)))
         (list)))
    (tol 0)))

(define (list->vector l)
   (let* ((len (length l))
          (v (make-vector (length l))))
      (let loop ((i 0)
                 (r l))
         (if (null? r)
            v
            (begin
              (vector-set! v i (car r))
              (loop (+ i 1) (cdr r)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (_sle a b) 
  (or (_slt a b) (_seq a b)))

(define (_sgt a b)
  (not (_sle a b)))

(define (_sge a b)
  (not (_slt a b)))

(define (sexe f l)
  (if (empty? (cddr l))
    (f (car l) (cadr l))
    (and (f (car l) (cadr l)) (sexe f (cdr l)))))

(define (sexe1 f l)
  (if (empty? l)
     0
     (if (empty? (cdr l))
        0
        (sexe f l))))

(define (str-app l)
  (if (empty? l)
     ""
     (str_cat (car l) (str-app (cdr l)))))

(define (string>? . l) (sexe1 _sgt l))
(define (string<? . l) (sexe1 _slt l))
(define (string=? . l) (sexe1 _seq l))
(define (string<=? . l) (sexe1 _sle l))
(define (string>=? . l) (sexe1 _sge l))

(define (string-append . l)
  (str-app l))

(define triml (regexp "^\\s+"))
(define trimr (regexp "\\s+\$"))
(define (string-trim s)
	(re-replace trimr (re-replace triml s "") ""))

(define (chop x) (perl chop x))
(define (chr x) (perl chr x))
(define (chomp x) (perl chomp x))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; numbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (zero? x) (= 0 x))
(define (positive? x) (< 0 x))
(define (negative? x) (> 0 x))
(define (odd? num) (= (modulo num 2) 1))
(define (even? num) (= (modulo num 2) 0))

(define (abs a)
	(if (< a 0) (* -1 a) a))
	
	
(define (max . l)
	(letrec ((max1 (lambda (m r) 
						(if (empty? r)
							m
							(if (> m (car r))
								(max1 m (cdr r))
								(max1 (car r) (cdr r)))))))
		(if (empty? l)
			(die "max needs at least 2 arguments")
			(if (empty? (cdr l))
				(die "max needs at least 2 arguments")
				(max1 (car l) (cdr l))))))
				
(define (min . l)
	(letrec ((min1 (lambda (m r) 
						(if (empty? r)
							m
							(if (< m (car r))
								(min1 m (cdr r))
								(min1 (car r) (cdr r)))))))
		(if (empty? l)
			(die "min needs at least 2 arguments")
			(if (empty? (cdr l))
				(die "min needs at least 2 arguments")
				(min1 (car l) (cdr l))))))
			
(define (int a) 
	(perl "sub { return int(shift); }" a))

(define (floor a)
  (perl POSIX::floor a))

(defperl "sub round { return ($_[0]<0) ? int($_[0]-0.5) : int($_[0]+0.5); };our $scm_round=\&round;use vars qw($scm_round);")
  
(define (ceiling a)
  (perl POSIX::ceil a))
  
(define (truncate a)
  (if (< a 0) 
    (* -1 (floor (* -1 a)))
    (floor a)))
    
(define (modulo a b)
	(perl "sub { my ($a,$b)=@_;return $a%$b; }" a b))
	
(define (remainder a b)
	(if (< a 0) 
		(* -1 (modulo (abs a) (abs b)))
		(modulo (abs a) (abs b))))
		
(define (quotient a b)
	(perl "sub { my ($a,$b)=@_;return int($a/$b); }" a b))
		
    
(define (gcd2 a b)
    (if (= b 0)
      (abs a)
      (gcd2 b (modulo a b))))
    
(define (gcd . l)
	(letrec ((gcdl (lambda (g l)
						(if (null? l)
							g
							(gcdl (gcd2 g (car l)) (cdr l))))))
	    (if (null? l)
    		0
    		(if (null? (cdr l))
    			(die "Need at least 2 arguments for gcd")
    			(gcdl (gcd2 (car l) (cadr l)) (cddr l))))))

(define (lcm2 a b)
    (abs (/ (* a b) (gcd2 a b))))

(define (lcm . l)
	(letrec ((lcml (lambda (m l)
						(if (null? l)
							m
							(lcml (car l) (cdr l))))))
		(if (null? l)
			0
			(if (null? (cdr l))
				(die "Need at least 2 arguments for lcm")
				(lcml (lcm2 (car l) (cadr l)) (cddr l))))))
	
(define (integer? a) 
  (= (int a) a))
  
(define (real? a)
  (not (integer? a)))
  
(define (complex? a)
  (die not-part))
  
(define (rational? a)
  (die not-part))

(define (sin x) (perl sin x))
(define (cos x) (perl cos x))
(define (log x) (perl log x))
(define (atan2 x y) (perl atan2 x y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; symbol / string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (symbol->string x) 
	(if (symbol? x) 
		(-> x tostring) 
		(die "type 'symbol' expected")))
		
(define (string->symbol x) 
	(if (scalar? x) 
		(-> scmSymbol new x) 
		(die "type 'scalar' expected")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; perl hashes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (hash-new) (perl_hn))
(define (hash-put h k v) (perl_hp h k v))
(define (hash? h) (perl_is_h h))
(define (hash-get h k) (perl_hg h k))
(define (hash-exists? h k) (perl_he h k))
(define (hash-remove h k) (perl_hr h k))
(define (hash-keys h) (perl_h_keys h))
(define (hash-each h) (perl_h_each h))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (exit . y) 
  (if (empty? y)
    (perl exit 0)
    (perl exit (car y))))

(define (bless obj class) (perl bless obj class))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (mapf proc lst)
   (if (empty? lst)
      '()
      (cons (proc (car lst)) (mapf proc (cdr lst)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compares
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax equal? 
	(syntax-rules ()
		((_ a b) (string=? (tostring a) (tostring b)))
		((_ a b ...) (string=? (tostring a) (tostring b) (tostring ...)))))
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; regular expressions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get-modifier tok)
	(if (eq? tok 'glob)
		"g"
		(if (eq? tok 'insensitive)
			"i"
			(if (eq? tok 'g)
			  "g"
			  (if (eq? tok 'i)
			     "i"
				(die (string-append "Unknown modifier " (tostring tok))))))))

			
(define (make-modifier l)
	(if (empty? l)
		""
		(string-append
			(get-modifier (car l))
			(make-modifier (cdr l)))))

(define (regexp e . modifier) 
	(perl-re e (make-modifier modifier)))

(define (re-match re str . modifier)
	(perl-re-match re str (make-modifier modifier)))
	
(define (re-replace re str repl . modifier)
	(perl-re-replace re str repl (make-modifier modifier)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell, Environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (env e) 
	(if (symbol? e)
		(env (symbol->string e))
		(perl "sub { my $e=shift;return $ENV{$e}; }" e)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I/O
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define stdout (perl "sub { return \\*STDOUT; }"))
(define stdin  (perl "sub { return \\*STDIN; }"))
(define stderr (perl "sub { return \\*STDERR; }"))

(define (open description) 
	(perl "sub { my $d=shift;open my $fh,$d;return $fh }" description))
	
(define (port? fd)
	(string=? (perl ref fd) "GLOB"))
	
(define (eof fd)
	(perl eof fd))
	
(define (readline fd) 
	(perl "sub { my $fd=shift;my $line=<$fd>;return $line; }" fd))
	
(define (write obj . port)
	(die "write is Not implemented yet"))
	
(define (write-char c . port)
	(if (null? port)
		(display c)
		(display c (car port))))
	
(define (newline . port)	
	(if (null? port)
		(display "\n" stdout)
		(display "\n" (car port))))
	
(define (display obj . port)
	(if (null? port)
		(display obj stdout)
		(perl "sub { my $fd=shift;my $obj=shift;print $fd $obj; }" (car port) obj)))

(define (_writeline fd stuff)
	(let ((writer (lambda (elem) (display elem fd))))
		(for-each writer stuff)
		(writer "\n")
		fd))
	
(define (displayline . stuff)
	(if (null? stuff)
		(_writeline stdout stuff)
		(if (port? (car stuff))
			(_writeline (car stuff) (cdr stuff))
			(_writeline stdout stuff))))
	
(define (close fd) (perl close fd))

(define (chmod x . f)
  (let ((chm (lambda (l)
               (if (null? l)
                   #t
                   (begin
                     (perl chmod x (car l))
                     (chm (cdr l)))))))
    (chm f)))

(define (chown u g . f)
  (let ((cho (lambda (l)
               (if (null? l)
                   #t
                   (begin
                     (perl chown u g (car l))
                     (cho (cdr l)))))))
    (cho f)))

(define (chdir d)
  (perl chdir d))

(define (opendir d)
  (perl "sub { my $expr=shift;opendir(my $fh,$expr);return $fh; }" d))

(define (closedir dh)
  (perl closedir dh))
  
;(define (glob pattern flags)
;	(let ((p (if (symbol? pattern) (symbol->string pattern) pattern)))
;		(if (eq? (car flags) 'nocase) 
;			(perl bsd_glob p ":nocase")
;			(perl bsd_glob p))))

(define (defined x)
	(perl defined x))

(define (glob pattern . flags)
  (let ((p (if (symbol? pattern) (symbol->string pattern) pattern)))
  	(let ((result   	(if (null? flags)
					  		(@perl bsd_glob p)
							(if (eq? (car flags) 'nocase)
					  			(@perl "sub { my @r=return bsd_glob(@_,GLOB_NOCASE|GLOB_NOSORT);return @r; }" p)
  								(@perl bsd_glob p)))))
  		(if (defined result)
  			result
  			(list)))))

(define (unlink filename)
	(perl unlink filename))
	
(define (rename filename1 filename2)
	(perl rename filename1 filename2))

(define (readdir dh . filterfunction)
  (if (null? filterfunction)
      (let ((rd (lambda () 
                  (let ((f (perl readdir dh)))
                    (if f (cons f (rd)) (list))))))
        (rd))
      (let ((filter (car filterfunction))
            (rd (lambda ()
                  (let ((f (perl readdir dh)))
                    (if f 
                        (if (filter f)
                            (cons f (rd))
                            (rd))
                        (list))))))
        (rd))))

(define (rewinddir dh)
  (perl rewinddir dh))

(define (telldir dh)
  (perl telldir dh))

(define (seekdir dh pos)
  (perl seekdir dh pos))

(define (appl-testfile tester f l)
  (if (tester f)
      (if (null? l)
          #t
          (appl-testfile tester (car l) cdr l))
      #f))

(define (is-file? f . l) 
  (appl-testfile (lambda (x) (perl -f x)) f l))

(define (is-dir? d . l)
  (appl-testfile (lambda (x) (perl -d x)) d l))

(define (test-f? f . l)
  (appl-testfile (lambda (x) (perl -f x)) f l))

(define (test-d? d . l)
  (appl-testfile (lambda (x) (perl -d x)) d l))

(define (test-r? d . l)
  (appl-testfile (lambda (x) (perl -r x)) d l))

(define (test-e? f . l)
  (appl-testfile (lambda (x) (perl -e x)) f l))

(define (test-z? f . l)
  (appl-testfile (lambda (x) (perl -z x)) f l))

(define (test-s? f . l)
  (appl-testfile (lambda (x) (perl -s x)) f l))

(define (test-l? f . l)
  (appl-testfile (lambda (x) (perl -l x)) f l))

(define (test-w? f . l)
  (appl-testfile (lambda (x) (perl -w x)) f l))

(define (test-x? f . l)
  (appl-testfile (lambda (x) (perl -x x)) f l))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DBM Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use Memoize::AnyDBM_File)
(define (dbmopen dbf mode)
  (perl "sub { my $dbf=shift;my $mode=shift; dbmopen(my %hash,$dbf,$mode);return \%hash }" dbf mode))

(define (dbmclose dbh)
  (perl "sub { my $h=shift;dbmclose(%{$h}); }" dbh))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Some perl constructs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (for-each f . lists)
	(letrec ((g (lambda (l)
					(if (null? l)
						#t
						(begin 
							(f (car l))
							(g (cdr l)))))))
		(letrec ((h (lambda (lists)
						(if (null? lists)
							#t
							(begin
								(g (car lists))
								(h (cdr lists)))))))
			(h lists))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; version info
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (speme-author) "Hans Oesterholt")
(define (speme-version) (__VERSION__))
(define (speme-copyright) (string-append "(c) " (speme-author)))
(define (speme-name)   "speme")

;;; end of package
)
