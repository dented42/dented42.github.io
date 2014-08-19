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
  [ref-deps url-ref] ; (hashof key name)
  [ref->url url-ref deps]
  [ref-style url-ref content]
  [api-ref? url-ref]
  #:defaults ([string?
               (define (ref->url ref deps) ref)])
  #:fallbacks [(define ref-deps (const (hash)))
               (define api-ref? (const #f))
               (define (ref-style ref content) content)])

(struct cocoa-class-ref (sdk base class)
  #:transparent
  #:methods gen:url-ref
  [(define api-ref? (const #t))
   (define (ref-style ref content)
     (racketidfont content))
   (define (ref->url ref deps)
     (apple-url (cocoa-class-ref-sdk ref)
                "/documentation/"
                (cocoa-class-ref-base ref)
                "/reference/"
                (cocoa-class-ref-class ref)
                "_Class"))])

(struct independent-reference (ref deps) #:transparent
  #:methods gen:url-ref
  [(define/generic super-ref->url ref->url)
   (define/generic super-ref-style ref-style)
   (define/generic super-api-ref? api-ref?)
   (define (ref->url ref deps)
     (super-ref->url (independent-reference-ref ref) (independent-reference-deps ref)))
   (define (ref-style ref content)
     (super-ref-style (independent-reference-ref ref) content))
   (define (api-ref? ref)
     (super-api-ref? (independent-reference-ref ref)))])

(define (lookup-ref name (doc-urls (current-doc-urls)))
  (define (lookup urls)
    (cond
      [(null? urls) #f]
      [(hash-has-key? (car urls) name)
       (let ([ref (hash-ref (car urls) name)])
         (independent-reference ref (flush (ref-deps ref))))]
      [else
       (lookup (cdr urls))]))
  (define (flush deps)
    (for/hash ([key (in-hash-keys deps)]
               [name (in-hash-values deps)])
      (values key (lookup-ref name doc-urls))))
  (lookup doc-urls))

(define (api name (title name) (deps #hash()))
  (let* ([ref (lookup-ref name)])
    (if url
        (hyperlink (ref->url ref deps) (ref-style ref title))
        (TODO title "(broken link)"))))