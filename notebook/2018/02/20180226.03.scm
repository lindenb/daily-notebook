(define (draw-line layer x-from y-from x-to y-to) 
  (let* (
          (points (cons-array 4 'double))
        )

        (aset points 0 x-from)
        (aset points 1 y-from)
        (aset points 2 x-to  )
        (aset points 3 y-to  )

        (gimp-pencil layer 4 points)
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
       (r 0)
       (dr 5)
       (precision 50.0)
       (nsteps 0)
       (ang 0)
       (i 0)
       (perimeter 0)
      )
;; begin
(set! img (car (gimp-image-new  imgwidth imgheight 0)))
(set! bg (car (gimp-layer-new img  imgwidth imgheight RGBA-IMAGE "background" 100 NORMAL-MODE)))
(gimp-image-add-layer img bg 0)
(gimp-layer-add-alpha bg)
(gimp-drawable-set-visible bg TRUE)


(set! r 0)
(while (< r imgwidth)
	(set! perimeter (* (+ dr r) (* 2 pi2)))
	(set! nsteps  (/ perimeter precision))
	(set! i 0)
	(display  (number->string r)) (display  "\n")
	(display  (number->string perimeter)) (display  "\n")
	(while (< i nsteps)
		(set! ang (* (/ i nsteps) pi2))
		(draw-line  bg 
			(+ cx 0)
			(+ cy 0)
			(+ cx 0)
			(+ cy 0)
			)
		(set! i (+ i 1))
	)
	(set! r (+ r dr))
)

(display (number->string (cos 1)))
(gimp-xcf-save 1 img img "jeter2.xcf"  "jeter2.xcf")
;; end
)

)
(runbatch 512 512) (gimp-quit 0)

