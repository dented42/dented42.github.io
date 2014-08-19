#lang racket

(provide define-documentation-links
         cocoa-class-ref
         api)

(require racket/generic
         scribble/base
         scribble/manual
         (for-syntax syntax/parse)
         "scribble.rkt")

(define current-doc-urls
  (make-parameter '()))

(define current-apple-doc-base-url
  (make-parameter "https://developer.apple.com/library/"))

(define (apple-url . strs)
  (apply string-append (current-apple-doc-base-url) strs))

(define-syntax (define-documentation-links stx)
  (syntax-parse stx
    [(_ (name:str url:expr) ...)
     #`(current-doc-urls
        (cons (make-hash (list (cons name url) ...))
              (current-doc-urls)))]))

(define-generics url-ref
  [ref->url url-ref]
  [ref-style url-ref content]
  [api-ref? url-ref]
  #:defaults ([string?
               (define ref->url identity)])
  #:fallbacks [(define api-ref? (const #f))
               (define (ref-style ref content) content)])

(struct cocoa-class-ref (base class)
  #:transparent
  #:methods gen:url-ref
  [(define api-ref? (const #t))
   (define (ref-style ref content)
     (racketidfont content))
   (define (ref->url ref)
     (apple-url "mac/documentation/"
                (cocoa-class-ref-base ref)
                "/"
                (cocoa-class-ref-class ref)
                "_Class"))])

(define (lookup-ref name (doc-urls (current-doc-urls)))
  (define (lookup urls)
    (cond
      [(null? urls) #f]
      [(hash-has-key? (car urls) name)
       (hash-ref (car urls) name)]
      [else
       (lookup (cdr urls))]))
  (lookup doc-urls))

(define (api name (title name))
  (let* ([ref (lookup-ref name)])
    (if url
        (hyperlink (ref->url ref) (ref-style ref title))
        (TODO title "(broken link)"))))