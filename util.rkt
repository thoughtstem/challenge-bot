#lang racket 

(provide ?
	 problem
	 cannonical
	 non-cannonical
	 servable
	 servable-answer
	 (contract-out 
	   (serve
	     [-> servable? any/c])
	   (check
	     [-> servable? any/c boolean?])
	   (polite-check
	     [-> servable? any/c any/c]))
	 (rename-out
	   [my-#%app #%app]))

;A framework for defining problems of the form:
;  If [CANNONICAL CODE] produces [CANNONICAL RESPONSE],
;  What code will produce [NON-CANNONICAL RESPONSE]?

(define-syntax-rule (my-#%app p a ...)
  (let ()
    (#%app 
     (choose p) 
     (choose a) 
     ...)))

(define choice-behavior
  (make-parameter (compose first shuffle)))

(define (not-first l)
  (first (shuffle (rest l))))

(struct choice (options) #:transparent)
(define (? . stuff )
  (choice stuff ))

(define-syntax-rule 
  (choose choice)
  (let ()
    (define f (choice-behavior))

    (if (choice? choice)
	(f (choice-options choice))
	choice)))

(define (code-choose c)
  (cond 
    [(and (list? c)
	  (not (empty? c))
	  (eq? '? (first c)))
      
      ((choice-behavior) (rest c))]

    [(list? c) (map code-choose c)]
    [else c]))

(struct io (i o) #:transparent)

(define-syntax-rule (problem lines ...)
		    (let ()
		      (io
			(list 'lines ...)
			(thunk* lines ...))))

(define (cannonical p)
  (parameterize ([choice-behavior first])
    (values
      (code-choose (io-i p))
      ((io-o p)))))

(define (non-cannonical p)
  (parameterize ([choice-behavior not-first])
    (define x (random 0 10000))
    (values
      (let ()
	(random-seed x)
	(code-choose (io-i p)))
      (let () 
	(random-seed x)
	((io-o p))))))


(define (code->string c)
  (define (drop-quote s)
    (substring s 1))
  (~a 
    "```\n"
  (string-join
    (map (compose drop-quote pretty-format) c) 
    "\n\n")
    "\n```" ))

(define (servable? x)
  (and (list? x)
       (= 4 (length x))))

(define (servable p)
  (define-values (a b)
    (cannonical p))
  (define-values (c d)
    (non-cannonical p))

  (list a b c d))

(define (servable-answer s)
  (third s))

(define (serve servable-p)
  (match-define
    (list a b c d) servable-p)

  (list
    "If " (code->string a) " produces the first image below,\n What code produces the second?"
    b d))

(define (check servable-p answer)
  (match-define
    (list a b 
	  c d) 
    servable-p)
  (equal? c answer))

(define (polite-check servable-p answer)
  (match-define
    (list a b 
	  c d) 
    servable-p)

  (if (check servable-p answer)
      (~a "RIGHT!") 
      (~a "You gave " (code->string answer)
	  " but the answer I was expecting was: "
	  (code->string c))))

