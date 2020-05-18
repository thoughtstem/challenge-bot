#lang racket

(require "main.rkt"
	 rackunit)

(module+ test
	 (check-not-false
	   (challenge-bot "challenge"))
	 
	(check-exn
	  exn:fail?
	  (thunk 
	    (challenge-bot "dog")))

	 (check-not-exn
	   (thunk
	     (challenge-bot "try (circle 40 'solid 'red)")))
	 )
