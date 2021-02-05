;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname constants) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;
;; ***************************************************
;;     Parth Modi
;;     Position Applied: Full Stack Web Developer
;;     Synqrinus Coding Test
;;     constants.rkt
;; ***************************************************
;;


(require racket/base)
(provide alphabets operator sym-operators brackets)

;; -------------------  CONSTANT DEFINITIONS  -----------------------

;; List of Alphabets from A to Z
(define alphabets
  (list #\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M #\N #\O
        #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z))


;; List of Operators as Char
(define operator
  (list #\+ #\- #\* #\/))


;; List of Operators as Sym
(define sym-operators
  (list '+ '- '* '/))


;; List of Brackets
(define brackets
  (list #\( #\)))