#lang racket

(provide TODO #;preview)

(require scribble/base
         scribble/core)

(define (TODO . t)
  (displayln "UNFINISHED TODOS: DO NOT PUBLISH")
  ((compose larger italic bold)
   (elem #:style (style #f `(,(color-property "red")))
         "TODO: " t)))

;;; this could eventually get rid of needing the <!-- more --> comment, which is quite annoying.
(define (preview . content)
  (list content #;(more)))