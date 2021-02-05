;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;
;; ***************************************************
;;     Parth Modi
;;     Position Applied: Full Stack Web Developer
;;     Synqrinus Coding Test
;;     main.rkt
;; ***************************************************
;;

(require racket/set)
(require racket/list)
(require "constants.rkt")
(require "db.rkt")

;; -------------------  STRUCTURE DEFINITIONS  -----------------------

;; A argument (Arg) is one of:
;; * a Num
;; * a var Cell

;; A binary arithmetic expression (BinExp) is one of:
;; * a Arg
;; * a BINode

;; A dataset (Dataset) is (listof Data)

(define-struct binode (op arg1 arg2))
;; A Binary Arithmetic expression Internal Node (BINode)
;;    is a (make-binode (anyof #\+ #\- #\* #\/) BinExp BinExp)

(define-struct var-cell (coeff sym))
;; a var-cell (Var Cell) is a (make-var-cell Num Sym)

(define-struct data (id dep formula))
;; a data (Data) is a (Sym (listof Sym) Binexp)

;; -------------------------  TASK 1  --------------------------------


;; (formula->tree fml) inputs a formula i.e. fml in a form of String
;;   and parses the formula to convert it into a binary arithematic
;;   expression tree i.e. BinExp.


;; formula->tree: Str -> BinExp
;; requires: * formula starts with "="
;;           * formula contains only defined operators i.e. +, -, *, /
;;           * formula has either integer arguments or cell ID
(define (formula->tree fml)
  (local [;; Converts string formula to a list of arguments and 
          ;;   operators or brackets.
          ;; parsed-fml: (list (anyof Sym Char Int))
          (define parsed-fml (parse-formula fml))

          
          ;; (is-arg? arg) checks whether the input arg is an argument
          ;;   for a formula or not.
          ;; is-arg?: Any -> Bool
          (define (is-arg? arg)
            (or (number? arg) (symbol? arg)))


          ;; (bracket-arg) 
          ;; bracket-arg: (listof (anyof Sym Char Int)) Int (listof 
          ;;                (anyof Sym Char Int)) -> (list (listof 
          ;;                (anyof Sym Char Int)) (listof (anyof
          ;;                Sym Char Int))
          (define (bracket-arg ls-arg open arg-acc)
            (cond
              [(equal? open 0) (list arg-acc ls-arg)]
              [(equal? (first ls-arg) #\()
               (bracket-arg (rest ls-arg) (add1 open)
                            (append arg-acc (list (first ls-arg))))]
              [(and (equal? (first ls-arg) #\))
                    (equal? open 1))
               (bracket-arg (rest ls-arg) (sub1 open) arg-acc)]
              [(equal? (first ls-arg) #\))
               (bracket-arg (rest ls-arg) (sub1 open)
                            (append arg-acc (list (first ls-arg))))]
              [else (bracket-arg (rest ls-arg) open
                                 (append arg-acc
                                         (list (first ls-arg))))]))


          ;; (tree-maker ls-arg arg) inputs a parsed formula (ls-arg)
          ;;   and a base argument (arg) and returns a BinExp of the
          ;;   formula.
          ;; tree-maker: (list (anyof Sym Char Int)) (anyof Sym Int)
          ;;               -> BinExp
          (define (tree-maker ls-arg arg)
            (cond
              [(empty? ls-arg) arg]
              [(equal? (first ls-arg) #\()
               (local
                 [(define arg-rest-ls (bracket-arg
                                       (rest ls-arg) 1 empty))]
                 (tree-maker (second arg-rest-ls)
                             (tree-maker (first arg-rest-ls) 0)))]
              [(is-arg? (first ls-arg))
               (tree-maker (rest ls-arg) (first ls-arg))]
              [(member? (first ls-arg) operator)
               (make-binode (string->symbol (string (first ls-arg)))
                            arg (tree-maker (rest ls-arg) 0))]))]
    (tree-maker parsed-fml 0)))


;; Helper Function


;; (parse-formula str) parses the string formula and converts it into
;;  (listof (anyof Sym Char Num)) where every element (in original 
;;  order) is either a operator, brackets or argument.


;; parse-formula: Str -> (listof (anyof Sym Char Num))
(define (parse-formula str)
  (local [;; (remove-spaces loc) filters the loc i.e. a list of char
          ;;   and removes all the occurences of #\space.
          ;; remove-spaces: (listof Char) -> (listof Char)
          (define (remove-spaces loc)
            (filter (lambda (x) (not (equal? x #\space))) loc))

          
          ;; Constant Definition of string formula converted into list
          ;;   of char.
          ;; ls-char: (listof Char)
          (define ls-char (remove-spaces (rest (string->list str))))


          ;; (get-arg loc acc) return the list of next integer or 
          ;;   cell ID arg in the list of character (i.e. loc) and the
          ;;   remaining loc.
          ;; get-arg: (listof Char) (listof Char) -> (listof Char)
          ;;            (listof Char)
          (define (get-arg loc acc)
            (cond
              [(empty? loc) (list acc empty)]
              [(or (member? (first loc) operator)
                   (member? (first loc) brackets)) (list acc loc)]
              [(or (member? (first loc) alphabets)
                   (char-numeric? (first loc)))
               (get-arg (rest loc) (append acc (list (first loc))))]))


          ;; (parser loc) groups the argument characters in the list
          ;;   of chars and seperates them from operators or brackets
          ;;   in the list.
          ;; parser: (listof Char) -> (listof (anyof Sym Num Char))
          (define (parser loc)
            (cond
              [(empty? loc) empty]
              [(or (member? (first loc) operator)
                   (member? (first loc) brackets))
               (cons (first loc)
                     (parser (rest loc)))]
              [else (local [;; Constant definition of the next argume-
                            ;;   -nt string in the list.
                            (define arg (get-arg loc empty))

                            
                            ;; (convert-arg str) converts the argument
                            ;;   string to num if its a numeric string
                            ;;   or to symbol if it refers to a cellID
                            ;; convert-arg: Str -> (anyof Num Sym)
                            (define (convert-arg str)
                              (cond [(string-numeric? str)
                                     (string->number str)]
                                    [else (string->symbol str)]))]
                      (cons (convert-arg (list->string (first arg)))
                            (parser (second arg))))]))]
    (parser ls-char)))


;; -------------------------  TASK 2  --------------------------------

;; (circular-dependency? simplified-dataset) returns true if the
;;   dataset has circular dependency and false otherwise.


;; circular-dependency?: Dataset -> Bool
(define (circular-dependency? dataset)
  (local [;; Constant definition for the simplifed version of input
          ;;  dataset.
          (define simplified-dataset
            (simplify-dataset dataset))

          ;; (checker simple-dataset) checks whether a dataset has
          ;;   circular dependencies left or not. It returns true for
          ;;   circular dependencies and false if none is found.
          ;; checker: Dataset -> Bool
          (define (checker simple-dataset)
            (cond
              [(empty? simple-dataset) false]
              [(empty? (data-dep (first simple-dataset)))
               (checker (rest simple-dataset))]
              [else true]))]
    (checker simplified-dataset)))


;; -------------------------------------------------------------------


;; (simplify-dataset dataset) simplifies the input dataset by finding
;;   values of as many cells as possible untill dataset is left with
;;   circular dependencies.


;; simplify-dataset: Dataset -> Dataset
(define (simplify-dataset dataset)
  (local
    [;; Constant Definition which stores the parsed input dataset
     ;;   i.e. all the data is converted into required structures.
     (define parsed-dataset (parse-dataset dataset))

     ;; (solver values dependent) inputs two initial (listof Data)
     ;;  i.e. values is the data with no dependency and dependent is
     ;;  the data with atleast one dependency. It returns the
     ;;  simplified version of this data in a form of Dataset.
     (define (solver values dependent)
       (local
         [;; Constant definition of new list of dependents after
          ;;  updating new values.
          (define updated-dependents
            (dataset-input-values dependent values))

          
          ;; (dataset-info dataset values dependent) inputs dataset 
          ;;   and groups it into two (listof Data) where one list has
          ;;   all the elements of dataset which have no dependencies
          ;;   and have a numerical value andother is the remaining
          ;;   elements with some dependents. Function returns list of
          ;;   both lists.
          ;; dataset-info: Dataset -> (list (listof Data)
          ;;                 (listof Data))
          (define (dataset-info dataset values dependent)
            (cond
              [(empty? dataset) (list values dependent)]
              [(empty? (data-dep (first dataset)))
               (dataset-info
                (rest dataset)
                (cons (make-data
                       (data-id (first dataset)) empty 
                       (eval (data-formula
                              (first dataset)))) values)
                (remove (first dataset) dependent))]
              [else (dataset-info (rest dataset) values dependent)]))

          
          ;; Constant Definition of new list of list of data which are
          ;; still dependent and which have values with no dependency.
          (define info
            (dataset-info updated-dependents
                          values updated-dependents))]
         (cond
           [(empty? (second info)) (first info)]
           [(equal? (list->set dependent)
                    (list->set (second info)))
            (append (first info) (second info))]
           [else (solver (first info) (second info))])))]
    (solver empty parsed-dataset)))


;; -------------------------------------------------------------------


;; (eval fml) evaluates the formula fml and produces its value.
;; eval: BinExp -> Num
(define (eval fml)
  (cond [(number? fml) fml]
        [(binode? fml) (apply-op (binode-op fml)
                                 (binode-arg1 fml)
                                 (binode-arg2 fml))]))


;; (apply-op op arg1 arg2) applies the arithmetic operator op to
;;   its arguments arg1 and arg2.
;; apply-op: Sym BinExp BinExp -> Num
(define (apply-op op arg1 arg2)
  (local [(define eval-arg1 (eval arg1))
          (define eval-arg2 (eval arg2))]
    (cond [(symbol=? op '+) (+ eval-arg1
                               eval-arg2)]
          [(symbol=? op '-) (- eval-arg1
                               eval-arg2)]
          [(symbol=? op '*) (* eval-arg1
                               eval-arg2)]
          [(symbol=? op '/)
           (cond [(equal? eval-arg2 0) (error "Division by zero")]
                 [else (/ eval-arg1 eval-arg2)])])))


;; -------------------------------------------------------------------


;; (convert-cell arg) converts an cell ID argument to a structure Arg
;;   which contains its numerical coefficient and symbol and returns
;;   argument itself if its a number.


;; convert-cell: (anyof Num Sym) -> Arg
;; requires: arg is a number or it represents a valid cell ID
(define (convert-cell arg)
  (cond
    [(number? arg) arg]
    [else
     (local
       [;; Constant Definition which stores arg converted to a
        ;;  (listof Char)
        (define ls-char (string->list (symbol->string arg)))

        
        ;; (converter loc num) parses the (listof Char) of arg and
        ;;    converts it into a Var Cell.
        ;; converter: (listof Char) (listof Char) -> Var Cell
        (define (converter loc num)
          (cond [(member? (first loc) alphabets)
                 (cond
                   [(empty? num)
                    (make-var-cell 1 (string->symbol
                                      (list->string loc)))]
                   [else
                    (make-var-cell (string->number
                                    (list->string num))
                                   (string->symbol
                                    (list->string loc)))])]
                [else (converter
                       (rest loc)
                       (append num (list (first loc))))]))]
       (converter ls-char empty))]))


;; -------------------------------------------------------------------


;; (convert-binexp binexp) converts all the argument of input BinExp
;;   to Var Cell structure or Number.


;; convert-binexp: BinExp -> BinExp
(define (convert-binexp binexp)
  (cond
    [(binode? binexp)
     (make-binode
      (binode-op binexp)
      (convert-binexp (binode-arg1 binexp))
      (convert-binexp (binode-arg2 binexp)))]
    [else (convert-cell binexp)]))


;; -------------------------------------------------------------------


;; (get-dependencies binexp) returns a list of all dependencies of the
;;   binexp.


;; get-dependencies: BinExp -> (listof Sym)
(define (get-dependencies binexp)
  (local [(define (get-dep exp)
            (cond
              [(var-cell? exp)
               (list (var-cell-sym exp))]
              [(number? exp) empty]
              [(binode? exp)
               (append (get-dependencies (binode-arg1 exp))
                       (get-dependencies (binode-arg2 exp)))]))]
    (remove-duplicates (get-dep binexp))))


;; -------------------------------------------------------------------

;; (parse-dataset dataset) inputs a daataset and parses it such that
;;   it is converted into (listof Data) i.e. Dataset from
;;   (listof (list Sym Str)).


;; parse-dataset: (listof (list Sym Str)) -> Dataset
(define (parse-dataset dataset)
  (local
    [;; (convert dataset) converts the input data i.e. (listof
     ;;   (list Sym Str)) to (listof Data).
     ;; convert: (listof (list Sym Str)) -> (listof Data)
     (define (convert dataset)
       (cond
         [(empty? dataset) empty]
         [(string-numeric? (second (first dataset)))
          (cons (make-data
                 (first (first dataset))
                 empty
                 (string->number (second (first dataset))))
                (convert (rest dataset)))]
         [else
          (local
            [;; Constant definition for the binexp of formula of first
             ;;   element of input dataset.
             (define binexp
               (convert-binexp
                (formula->tree (second (first dataset)))))]
            (cons  (make-data
                    (first (first dataset))
                    (get-dependencies binexp) binexp)
                   (convert (rest dataset))))]))]
    (convert dataset)))


;; -------------------------------------------------------------------


;; (input-values binexp values) a binexp of a data and list of
;;   data which have no dependeny. This function returns a new
;;   binexp with all the values from the values list updated in the
;;   binexp.
;; input-values: BinExp (listof Data) -> BinExp
(define (input-values binexp values)
  (local [(define (get-value sym ls-value)
            (cond
              [(empty? ls-value) false]
              [(symbol=? sym (data-id (first ls-value)))
               (data-formula (first ls-value))]
              [else (get-value sym (rest ls-value))]))]
    (cond
      [(number? binexp) binexp]
      [(binode? binexp)
       (make-binode (binode-op binexp)
                    (input-values (binode-arg1 binexp) values)
                    (input-values (binode-arg2 binexp) values))]
      [(var-cell? binexp)
       (local
         [(define value (get-value (var-cell-sym binexp) values))]
         (cond
           [(and (not (false? value))
                 (number? value)) (* (var-cell-coeff binexp) value)]
           [else binexp]))])))


;; (dataset-input-values data values) inputs a dataset and list of
;;   data which have no dependeny. This function returns a new
;;   dataset with all the values from the list updated in dataset.
;; dataset-input-values: Dataset (listof Data) -> Dataset
(define (dataset-input-values dataset values)
  (cond
    [(empty? dataset) empty]
    [(empty? values) dataset]
    [else
     (local [;; Constant definition of updated binexp of first element
             ;;  of dataset.
             (define new-binexp
               (input-values (data-formula (first dataset)) values))]
       (cons
        (make-data (data-id (first dataset))
                   (get-dependencies new-binexp) new-binexp)
        (dataset-input-values (rest dataset) values)))]))

                      
;; -------------------------------------------------------------------