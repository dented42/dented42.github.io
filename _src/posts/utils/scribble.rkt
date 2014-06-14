#lang racket

(provide TODO)

(require scribble/base
         scribble/core)

(define (TODO . t)
  (displayln "UNFINISHED TODOS: DO NOT PUBLISH")
  ((compose larger italic bold)
   (elem #:style (style #f `(,(color-property "red")))
         "TODO: " t)))