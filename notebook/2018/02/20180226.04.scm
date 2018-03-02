; https://stackoverflow.com/questions/49056476/
(define (drawdiagonal W H)
(let* (
      (img 0)
       (bg 0)
       (points (cons-array 4 'double) )
      )
(set! img (car (gimp-image-new  W H 0)))
(gimp-image-undo-group-start img)
(gimp-context-push)
(set! bg (car (gimp-layer-new img  W H RGBA-IMAGE "background" 100 NORMAL-MODE)))
(gimp-image-add-layer img bg 0)
(gimp-drawable-set-visible bg TRUE)
(gimp-image-set-active-layer img bg)
(gimp-context-set-brush "Circle (01)")
(gimp-context-set-brush-size 100.0)
(gimp-context-set-opacity 100)
(gimp-context-set-paint-mode NORMAL-MODE)
(gimp-context-set-foreground '(255 127 0))
(gimp-selection-all img)

(aset points 0 0)
(aset points 1 0)
(aset points 2 W)
(aset points 3 H)
(gimp-paintbrush-default  bg 4 points)

(gimp-context-pop)
(gimp-image-undo-group-end img)

(gimp-xcf-save 1 img bg "tmp.xcf"  "tmp.xcf")
(display "DONE")
)
)

(drawdiagonal 512 512) (gimp-quit 0)

