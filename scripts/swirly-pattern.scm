; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; Pattern00 --- create a swirly tileable pattern
; Copyright (C) 1997 Federico Mena Quintero
; federico@nuclecu.unam.mx
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


(define (script-fu-swirly-pattern qsize angle times)
  (define (whirl-it img drawable angle times)
    (if (> times 0)
        (begin
          (plug-in-whirl-pinch 1 img drawable angle 0.0 1.0)
          (whirl-it img drawable angle (- times 1)))))

  (let* ((hsize (* qsize 2))
         (img-size (* qsize 4))
         (img (car (gimp-image-new img-size img-size RGB)))
         (drawable (car (gimp-layer-new img img-size img-size
                                        RGB-IMAGE "Swirly pattern"
                                        100 NORMAL-MODE))))

    (gimp-context-push)
    (gimp-image-undo-disable img)
    (gimp-image-add-layer img drawable 0)

    ; Render checkerboard

    (gimp-context-set-foreground '(0 0 0))
    (gimp-context-set-background '(255 255 255))

    (plug-in-checkerboard 1 img drawable 0 qsize)

    ; Whirl upper left

    (gimp-rect-select img 0 0 hsize hsize CHANNEL-OP-REPLACE 0 0)
    (whirl-it img drawable angle times)
    (gimp-invert drawable)

    ; Whirl upper right

    (gimp-rect-select img hsize 0 hsize hsize CHANNEL-OP-REPLACE 0 0)
    (whirl-it img drawable (- angle) times)

    ; Whirl lower left

    (gimp-rect-select img 0 hsize hsize hsize CHANNEL-OP-REPLACE 0 0)
    (whirl-it img drawable (- angle) times)

    ; Whirl lower right

    (gimp-rect-select img hsize hsize hsize hsize CHANNEL-OP-REPLACE 0 0)
    (whirl-it img drawable angle times)
    (gimp-invert drawable)

    ; Terminate

    (gimp-selection-none img)
    (gimp-image-undo-enable img)
    (gimp-context-pop)
    (gimp-display-new img)
  )
)

(script-fu-register "script-fu-swirly-pattern"
    _"_Swirly..."
    _"Create an image filled with a swirly pattern"
    "Federico Mena Quintero"
    "Federico Mena Quintero"
    "June 1997"
    ""
    SF-ADJUSTMENT _"Quarter size" '(20 0 2048 1 10 0 1)
    SF-ADJUSTMENT _"Whirl angle" '(90 0 360 1 1 0 0)
    SF-ADJUSTMENT _"Number of times to whirl" '(4 0 128 1 1 0 1)
)

(script-fu-menu-register "script-fu-swirly-pattern"
                         "<Toolbox>/Xtns/Patterns")
