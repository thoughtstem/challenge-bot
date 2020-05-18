#lang racket

(provide problems)

(require "lang.rkt")

(define p1
  (problem
   ([? circle circle square triangle]
    (? 40 30 20 10)
    (? 'solid 'solid 'outline)
    (? 'red   'red 'green 'blue 'orange 'purple))))

(define p2
  (problem
   (define c
     (circle 
      [? 40 30 20 10]
      [? 'solid 'solid 'outline]
      [? 'red   'red 'green 'blue]))


   ([? beside above] c c)))

(define p3
  (problem
   (define c1
     (circle 
      [? 40 30]
      [? 'solid 'solid 'outline]
      [? 'green  'green 'orange 'purple]))

   (define c2
     (circle
      [? 20 10]
      [? 'solid 'solid 'outline]
      [? 'red   'red 'yellow 'blue]))


   ([? beside above overlay] c2 c1)))

(define problems
  (list p1 p2 p3))

(module+ main

	 #|
  (define s1 (servable p1))
  (serve s1)

  ;(displayln s1)

  (define a1 (read))
  (polite-check s1 (list a1))
  
  ;(serve p2)
  ;(serve p3)

  |#

  )
