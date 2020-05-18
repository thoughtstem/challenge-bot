#lang racket 

(require 2htdp/image)

;Makes a version of f (which may be from
; any library), but it redefines it so that
; it will use the new #%app semantics
; defined in util.rkt
(define-syntax-rule 
  (wrap f)
  (begin
    (provide f)
    (define (f . args)
      (apply (dynamic-require '2htdp/image
			      'f)
	     args))))

(wrap circle)
(wrap square)
(wrap triangle)
(wrap above)
(wrap beside)
(wrap overlay)

