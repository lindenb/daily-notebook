(define (draw-line layer x-from y-from x-to y-to) 
  (let* (
          (points (cons-array 4 'double))
        )
				(display (number->string layer)) (display "\n")
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
       (r 0)
       (dr 25)
       (precision 100.0)
       (nsteps 0)
       (ang 0)
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
(gimp-context-set-brush-size 10.0)
(gimp-context-set-opacity 100)
(gimp-context-set-paint-mode NORMAL-MODE)
(gimp-context-set-foreground '(255 127 0))
(gimp-selection-all img)

(set! r dr)
(while (< r imgwidth)
	(set! perimeter (* (+ dr r)  pi2))
	(set! nsteps  (/ perimeter precision))
	(set! i 0.0)
	(while (< i nsteps)
		(set! ang (* (/ i nsteps) pi2))
		(draw-line  bg 
			512; (+ cx (* (- r dr) (cos ang)))
			512;(+ cy (* (- r dr) (sin ang)))
			0;(+ cx (* r (cos ang)))
			0;(+ cy (* r (sin ang)))
			)
		(set! i (+ i 1.0))
	)
	(set! r (+ r dr))
)
(set! bg (car (gimp-image-flatten img)))

(gimp-context-set-foreground '(0 0 0))
(draw-line  bg 0 0 100 100)
(gimp-context-set-foreground '(255 255 255))
(draw-line  bg 0 100 100 0)
(display (number->string (cos 1)))
(gimp-image-select-ellipse img CHANNEL-OP-REPLACE 0 0 imgwidth imgheight)
(gimp-context-pop)
(gimp-image-undo-group-end img)

(gimp-xcf-save 1 img img "jeter2.xcf"  "jeter2.xcf")
(display "DONE")
;; end
)

)
(runbatch 512 512) (gimp-quit 0)

