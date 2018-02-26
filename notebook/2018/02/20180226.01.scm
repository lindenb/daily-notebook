(define (runbatch w)
(let* ((imagesize w)
      (img (car(gimp-image-new imagesize imagesize RGB)))
      (bg (car (gimp-layer-new img imagesize imagesize RGBA-IMAGE "bg" 100 NORMAL-MODE)))
)


(gimp-image-add-layer img bg 0)
(gimp-drawable-set-visible bg TRUE)
(gimp-drawable-fill bg 2)
(gimp-image-flatten img)
(gimp-xcf-save 1 img img "jeter.xcf"  "jeter.xcf")


)
;(gimp-quit 0)
)
(runbatch 100) (gimp-quit 0)

