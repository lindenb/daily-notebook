(define (runbatch w)
(let* (
      (imagesize w)
      (img (car(gimp-image-new imagesize imagesize RGB)))
      (bg (car (gimp-layer-new img imagesize imagesize RGBA-IMAGE "bg" 100 NORMAL-MODE)))
      (y 0)
      )


(gimp-image-add-layer img bg 0)
(gimp-drawable-set-visible bg TRUE)
(gimp-drawable-fill bg 2)
;; https://github.com/dchest/tinyscheme/blob/master/init.scm
(set! y 0)
(while (< y imagesize)
	(gimp-rect-select img 0 y imagesize (+ 1 (random 5)) REPLACE 0 0)
	(gimp-edit-fill bg FOREGROUND-FILL )
	(set! y (+ y 10))
)


(set! bg (car (gimp-image-flatten img)))
(gimp-xcf-save 1 img bg "jeter.xcf"  "jeter.xcf")

)
;(gimp-quit 0)
)
(runbatch 100) (gimp-quit 0)

