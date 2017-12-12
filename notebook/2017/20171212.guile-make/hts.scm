;; A simple Guile HTS library for GNU make

(define (filter-filenames filenames filter)
	(string-split filenames #\:)
)

(define (ends_with name)
	(display name)
	)

(define (variant-file name)
	"OOKKKKKKKKKKKKKK" 
	)
	
;;  (filter (lambda (s) (> (string-length s) 0)) (string-split "a  bb      c   d e " #\space ) )
;; (string-split "a  bb      c   d e " (lambda (c) (char-whitespace? c)))
;; (filter (lambda (s) (> (string-length s) 0)) (string-split "a  bb      c   d\te\t\te" (lambda (c) (char-whitespace? c))) )

