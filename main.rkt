#lang racket

(require discord-bot)
(require discourse-bot)

(require 
  (except-in "lang.rkt" #%app)
  "problems.rkt")

(define (challenge)
  (define s
    (servable 
      (first (shuffle problems))))

  (session-store 
    (messaging-user-name) ;Make this default?
    'expected-answer
    (servable-answer s))

  (serve s))

(define (try . stuff)
  (define user-code-string
    ;This is brittle, and I keep getting errors.  Write more tests.
    (string-join (drop (string-split
			 (messaging-user-full-message)
			 "\n")
		       1)
		 " "))

  (define user-code 
    (read (open-input-string 
	    (~a "(let ()" user-code-string ")"))))

  (define expected-answer (session-load 
			    (messaging-user-name) ;Make default?
			    'expected-answer))

  ;Should we eval??

  (list
    (if (not (equal? user-code `(let () ,@expected-answer)))
	(~a "Hmmm.  Here's what your code produces.  It's beautiful, but it doesn't look like what I was expecting...") 
	(~a "You got it!  It looks exactly right! Use `! challenge` to ge a new challenge!"))

    (eval user-code
	  (module->namespace "lang.rkt"))))

(define b 
  (bot 
    ["help" (help-link "https://forum.metacoders.org/t/documentation-challenge-bot/104")]
    ["challenge" challenge]
    [else try] ;Eval their code and show the image.  Tell them if right or wrong.  If right, suggest they type "! challenge" again.
    ;  Note, we'll need some kind of "database"...
    ))

(launch-bot b)


