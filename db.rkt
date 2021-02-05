;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname db) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;
;; ***************************************************
;;     Parth Modi
;;     Position Applied: Full Stack Web Developer
;;     Synqrinus Coding Test
;;     db.rkt
;; ***************************************************
;;


(require racket/base)
(provide dataset-1
         dataset-2
         dataset-3)

;; Datasets Definition

;; Dataset 1
(define dataset-1
  (list (list 'A1 "=A2*2")
        (list 'A2 "=B3")
        (list 'A3 "2")
        (list 'B1 "4")
        (list 'B2 "3")
        (list 'B3 "=A1+B2")))

;; Dataset 2
(define dataset-2
  (list (list 'A1 "3")
        (list 'A2 "=A1+B1")
        (list 'A3 "1")
        (list 'B1 "=B3")
        (list 'B2 "2")
        (list 'B3 "3")))

;; Dataset 3
(define dataset-3
  (list (list 'A1 "=A2/(A2*B1)")
        (list 'A2 "=A3+B2")
        (list 'A3 "3")
        (list 'B1 "=A2*B2")
        (list 'B2 "=B3")
        (list 'B3 "1")))