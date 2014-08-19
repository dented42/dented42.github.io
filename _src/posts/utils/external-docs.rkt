#lang racket

(provide define-documentation-links
         apple-ref cocoa-class-ref
         api doc-link)

(require racket/generic
         scribble/base
         scribble/manual
         (for-syntax syntax/parse)
         "scribble.rkt")

(define current-apple-doc-urls
  (make-parameter '()))

(define current-apple-doc-base-url
  (make-parameter "https://developer.apple.com/library/"))

(define (apple-url . strs)
  (apply string-append (current-apple-doc-base-url) strs))

(define-syntax (define-documentation-links stx)
  (syntax-parse stx
    [(_ (name:str url:expr) ...)
     #`(current-apple-doc-urls
        (cons (make-hash (list (cons name url) ...))
              (current-apple-doc-urls)))]))

(define-generics url-ref
  [ref->url url-ref]
  #:defaults ([string?
               (define ref->url identity)]))

(struct apple-ref (file) #:transparent
  #:methods gen:url-ref
  [(define (ref->url ref)
     (apple-url (apple-ref-file ref)))])
(struct cocoa-class-ref (method) #:transparent)

(define (lookup-apple-url name)
  (define (lookup doc-urls)
    (cond
      [(null? doc-urls) #f]
      [(hash-has-key? (car doc-urls) name)
       (ref->url (hash-ref (car doc-urls) name))]
      [else
       (lookup (cdr doc-urls))]))
  (lookup (current-apple-doc-urls)))

(define (api name (title name))
  (doc-link name (racketidfont title)))

(define (doc-link name (title name))
  (let ([url (lookup-apple-url name)])
    (if url
        (hyperlink (string-append "https://developer.apple.com/library/" url) title)
        (TODO title "(broken link)"))))

(module+ main
  (require macro-debugger/expand)
  #;(expand-only #'(define-apple-documentation-links ("NSObject" (apple-ref "ns/object/link")))
               (list #'define-apple-documentation-links))
  (define-documentation-links ("NSObject" (apple-ref "ns/object/link")))
  (lookup-apple-url "NSObject"))