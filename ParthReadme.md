# Technical Interview - Parth Modi

## Prerequisites
In order to run the program, you require the Dr. Racket software installed. 
You can download it here: https://download.racket-lang.org/

 Racket is a general-purpose, multi-paradigm programming language based on the Scheme dialect of Lisp. It is designed to be a platform for programming language design and implementation

## Files 
* main.rkt is where the actual functions are. It references the constants.rkt and db.rkt to run.
* main-test.rkt is the same as main.rkt but also includes testing for the program. It runs in approximately 6 seconds.
* db.rkt contains all the testing datasets. In order to add more tests, add a dataset in the same format as the others shown and **inlclude it in the (provide ...)**
* constants.rkt contains constants like operators, alphabets and brackets which the main functions reference 

## Running the program
In order to run the program, you must have all 4 files, main-test.rkt, main.rkt, db.rkt and constants.rkt in the same directory.
In the Dr. Racket software find the 'Run' button on the top right of the panel to run the code to initialize the functions.

To test the functions, add the testing database to to the db.rkt file as explained the files section. 

### Task 1
Parsing formulas is a requirement for many spreadsheets. To get the result of "=A1+A2", we first need to deconstruct that string into something meaningful for a computer.

 For our purposes, we are looking for the formula to be transformed into a tree. In order to create a formula tree, run the following in the racket console:
```
> (formula->tree "=1+2")
(make-binode '+ 1 2) 
> (formula->tree "=A1*A2/(2-3)") 
(make-binode '* 'A1 (make-binode '/ 'A2 (make-binode '- 2 3))) 
> (formula->tree "=1 + 2 /(1+2)") 
(make-binode '+ 1 (make-binode '/ 2 (make-binode '+ 1 2))) 
> (formula->tree "=(C5*(C3/C2))+B1") 
(make-binode '+ (make-binode '* 'C5 (make-binode '/ 'C3 'C2)) 'B1)
```
![alt text](https://github.com/parthmodi152/Synqrinus-Coding-Test/blob/master/screenshots/Task1-Console.png?raw=true)
### Task 2
To check for circular dependency of a dataset, run the following in the racket console, swapping 'dataset' for the one specified in db.rkt:
``` 
>(circular-dependency? dataset-1)
#true
>(circular-dependency? dataset-2)
#false
```
To check the simplification of a dataset, run the following in the racket console, swapping 'dataset' for the one specified in db.rkt:
```
>(simplify-dataset dataset-1)
(list
 (make-data 'B2 '() 3)
 (make-data 'B1 '() 4)
 (make-data 'A3 '() 2)
 (make-data 'A1 (list 'A2) (make-binode '* (make-var-cell 1 'A2) 2))
 (make-data 'A2 (list 'B3) (make-var-cell 1 'B3))
 (make-data 'B3 (list 'A1) (make-binode '+ (make-var-cell 1 'A1) 3)))
 ``` 
![alt text](https://github.com/parthmodi152/Synqrinus-Coding-Test/blob/master/screenshots/Task2-Console.png?raw=true)




