(define rnd (/ (random 10000) 10000.0))
(define (random-range a b) (+ a (* (- b a) rnd) ))
(define (noise a) (+ a (random-range -3 3)))


(define (draw-line layer x-from y-from x-to y-to) 
  (let* (
          (points (cons-array 4 'double))
        )

        (vector-set! points 0 x-from)
        (vector-set! points 1 y-from)
        (vector-set! points 2 x-to  )
        (vector-set! points 3 y-to  )

        (gimp-paintbrush-default  layer 4 points)
        ;(display (number->string x-to)) (display " ")
        ;(display (number->string y-to)) (display ":  ")
        ;(display (number->string x-from)) (display " ")
        ;(display (number->string y-from)) (display "\n")
  )
)



(define pi 3.14159)
(define pi2 (* 2 pi))



(define (runbatch imgwidth imgheight)
(let* (
      (img 0)
       (bg 0)
       (cx (/ imgwidth 2))
       (cy (/ imgheight 2))
       (r 0.0)
       (dr 13.0)
       (precision 5.0)
       (nsteps 0)
       (ang 0)
       (startang 0)
       (deltaang 0)
       (i 0)
       (perimeter 0)
      )
;; begin
(set! img (car (gimp-image-new  imgwidth imgheight 0)))
(gimp-image-undo-group-start img)
(gimp-context-push)


(set! bg (car (gimp-layer-new img  imgwidth imgheight RGBA-IMAGE "background" 100 NORMAL-MODE)))
(gimp-image-add-layer img bg 0)
;(gimp-layer-add-alpha bg)
(gimp-drawable-set-visible bg TRUE)
(gimp-image-set-active-layer img bg)
(gimp-context-set-opacity 100)
(gimp-context-set-paint-mode NORMAL-MODE)
(gimp-context-set-brush "Circle (01)")
(gimp-context-set-brush-size 10.0)
(gimp-context-set-foreground '(0 0 0))
(gimp-selection-all img)

(set! r dr)
(while (< r imgwidth)
	(set! perimeter (* (+ dr r)  pi2))
	(set! nsteps  (/ perimeter precision))
	(display (number->string (+ dr r))) (display " 2pi:")  (display pi2)  (display " p:") (display  (number->string perimeter)) (display " ") (display  (number->string nsteps)) (display "\n") 
	(set! i 0.0)
	(set! startang (* rnd pi2))
	(while (< i nsteps)
		(set! ang (+ (+ startang (* (/ i nsteps) pi2)) (random-range 0.0 (/ pi2 nsteps)) ))
		(draw-line  bg 
			(noise (+ cx (* (- r dr) (cos ang))))
			(noise (+ cy (* (- r dr) (sin ang))))
			(noise (+ cx (* r (cos ang))))
			(noise (+ cy (* r (sin ang))))
			)
		(set! i (+ i 1.0))
	)
	(set! r (+ r dr))
)
(display "END")
(gimp-context-pop)
(gimp-image-undo-group-end img)

(gimp-xcf-save 1 img bg "jeter2.xcf"  "jeter2.xcf")
(display "DONE")
;; end
)

)
(runbatch 300 300) (gimp-quit 0)

