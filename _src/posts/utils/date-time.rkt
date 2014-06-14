#lang racket

(provide age)

(require srfi/19)

(define birthday
  (make-date 0 0 8 1 16 10 1990 -6))

(define birthtime
  (date->time-utc birthday))

(define age
  (number->string
   (date-year (time-tai->date (add-duration (date->time-tai (make-date 0 0 0 0 0 1 0 0))
                                            (time-difference (current-time) birthtime))))))