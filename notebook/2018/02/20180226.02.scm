(define (element-at n l)
    (if (= n 0)
      (car l)
      (element-at (- n 1) (cdr l) )
    )
)

;;       (selbounds (if (eqv? (car (gimp-selection-is-empty img)) TRUE) '(0 0 imgwidth imgheight) (gimp-selection-bounds img)))

(define (runbatch imagename)
(let* (
      (img (car (gimp-file-load 1 imagename imagename)))
      (_ignore (car (gimp-selection-is-empty img)) (gimp-selection-all img) )
      (activedrawable 0)
      (img (car (gimp-file-load 1 imagename imagename)))
      (imgwidth (car (gimp-image-width img)))
      (imgheight (car (gimp-image-height img)))
      (selbounds (list 1 1 imgwidth imgheight  ))
      (x1 (element-at 0 selbounds))
      (y1 (element-at 1 selbounds))
      (x2 (element-at 2 selbounds))
      (y2 (element-at 3 selbounds))
      (bg (car (gimp-layer-new img  imgwidth imgheight RGBA-IMAGE "bg" 100 NORMAL-MODE)))
      (x 0)
      (y 0)
      (pickColor (list 0 0 0))
      (selection 0)
      (radius 0)
      )
(gimp-image-undo-group-start img)


(set! activedrawable (car (gimp-image-get-active-layer img)))

;(if (= (car (gimp-image-get-active-layer img)) -1) (display "bOUUUUUUUUUUUUUUUUUM\n") (display "OKOKKKKKKKKKKKKKKKKKKK\n") )

(gimp-drawable-set-visible activedrawable TRUE)
(gimp-image-add-layer img bg 0)
(gimp-layer-add-alpha bg)
(gimp-drawable-set-visible bg TRUE)
(gimp-image-select-ellipse img CHANNEL-OP-REPLACE 0 0 imgwidth imgheight)
(set! selection (car (gimp-selection-save img)))

;(display (string-append "active layer : " (car (gimp-item-get-name activedrawable)) "\n"))
;(display (string-append "active layer : " (car (gimp-item-get-name  (car (gimp-image-get-active-layer img)))) "\n"))

(display _ignore) (display "\n")
(display (- x2 x1)) (display "\n")
(display (- y2 y1)) (display "\n")
(display activedrawable) (display "\n")
(set! y y1)
(while (< y y2)
	(set! x x1)
	(while (< x x2)
		(set! radius 5)
		(set! pickColor (car (gimp-image-pick-color img activedrawable x y FALSE TRUE radius ) ) )
		
		(gimp-palette-set-foreground pickColor)
		;;(gimp-image-select-ellipse img CHANNEL-OP-INTERSECT (- x radius) (- y radius) (* 2 radius) (* 2 radius))
		(gimp-image-select-ellipse img CHANNEL-OP-INTERSECT x y 15 15)
		(gimp-edit-bucket-fill bg 0 0 (random 100) 0 0 0 0)
		(gimp-image-select-item img  CHANNEL-OP-REPLACE selection)
		(set! x (+ x 20))
	)
	(set! y (+ y 20))
)
; restore selection
(gimp-image-select-item img  CHANNEL-OP-REPLACE selection)
(gimp-image-undo-group-end img)

(gimp-xcf-save 1 img bg "jeter.xcf"  "jeter.xcf")


)
;(gimp-quit 0)
)
(runbatch "lenna.png") (gimp-quit 0)

