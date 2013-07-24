(package tgtk 0.1
    (main)

(use Gtk2 "-init")
(use scmGtk2)

(define (main) 
   (let ((w (-> Gtk2::Window new))
         (b (-> Gtk2::Button new "Hello!")))
     (-> w show)
     (-> b show)

     (-> w add b)
     (-> b signal_connect "clicked"
        (let ((x 0))
          (lambda ()
             (if (< x 4)
                (begin
                  (println x)
                  (set! x (+ x 1)))
                (quit w)))))

     (-> w signal_connect "destroy" quit)
       (gtk-main)))

(define (quit w) 
  (-> w destroy)
  (gtk-main-quit))

)
