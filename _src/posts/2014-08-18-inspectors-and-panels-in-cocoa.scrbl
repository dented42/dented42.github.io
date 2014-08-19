#lang scribble/manual

@(require frog/scribble
          "utils/external-docs.rkt"
          "utils/scribble.rkt")

@(define-documentation-links
   ("NSViewController" (cocoa-class-ref "cocoa/reference/" "NSViewController")))

Title: Inspectors and Panels in Cocoa
Date: 2014-08-18T18:06:47
Tags: Programming, Cocoa, Objective-C

Panels are used in Cocoa application to provide supplementary windows that are independant of any
particular document. A common panel idiom in Cocoa applications is the Inspector. An inspector is a
floating panel that shows contextual information about the current selection in the active document.
In this post I'll go over one way to create a flexible inspector which adapt to many different kinds
of selections without much trouble by taking advantage of @api["NSViewController"].

<!-- more -->

stuff

@pygment-code[#:lang "objc"]|{
-(void)doSomethingWithTitle:(NSString*)title surname:(NSString*)name {
  return [NSString stringWithFormat:@"%@ %@", title, name];
}}|

@section{Goal}

@subsection{Types of inspectors and panels}

@subsection{Sample code}

@section{Making the inspector}

@subsection{Inspector UI}

@subsection{Inspector controller}

@section{Integrating the inspector with the rest of the application}

@subsection{Application delegate changes}

@subsection{NSDocument subclass changes}

@subsection{Opening the Inspector from the UI}

@subsubsection{Toolbar}

@subsubsection{Menu bar}