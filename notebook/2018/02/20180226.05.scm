
(define (runbatch imagename)
(let* (
      (img (car (gimp-file-load 1 imagename imagename)))
      (layer 0)
      (img (car (gimp-file-load 1 imagename imagename)))
      (imgwidth (car (gimp-image-width img)))
      (imgheight (car (gimp-image-height img)))
      (cx (/ imgwidth 2.0))
      (cy (/ imgheight 2.0))
      (radius (/ (max imgwidth imgheight) 2.0 ))
      (dr 3.0)
      )
(gimp-image-undo-group-start img)


(set! layer (car (gimp-image-get-active-layer img)))
(gimp-drawable-set-visible layer TRUE)

(while (> radius 100) 
	(gimp-image-select-ellipse img CHANNEL-OP-REPLACE (- cx radius) (- cy radius) (* radius 2.0) (* radius 2.0))
	(gimp-selection-invert img)
	(plug-in-blur 1 img layer)
	(set! radius (- radius dr))
)

(gimp-image-undo-group-end img)
(gimp-xcf-save 1 img layer "jeter.xcf"  "jeter.xcf")


)
;(gimp-quit 0)
)
(runbatch "lenna.png") (gimp-quit 0)

