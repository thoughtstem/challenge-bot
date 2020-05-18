#lang racket

(require "main.rkt"
	 rackunit
	 discord-bot)

(module+ test

	(session-clear "unknown-user")

	 (check-not-false
	   (challenge-bot "challenge"))
	 
	(check-exn
	  exn:fail?
	  (thunk
	   (challenge-bot "<@!1234567>")))
	
	(check-exn
	  exn:fail?
	  (thunk
	   (challenge-bot "<@1234567> challenge")))
	
	(check-not-exn
	  (thunk
	    (challenge-bot "<@!123456> challenge")))

	(check-exn
	  exn:fail?
	  (thunk 
	    (challenge-bot "dog")))

	 (check-not-exn
	   (thunk
	     (challenge-bot "try (circle 40 'solid 'red)")))

	 (check-exn
	   exn:fail?
	   (thunk
	     (challenge-bot "try (carcle 40 'solid 'red)")))

	 (define expected 
	   (session-load "unknown-user" 'expected-answer))

	 (define expected-string 
	   (string-join (map ~s expected)
			"\n"))

	 (check-not-exn
	   (thunk
	     (challenge-bot (~a "try " expected-string))))

	 )
