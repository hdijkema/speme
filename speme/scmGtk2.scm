(package scmGtk2 0.1
         (gtk-main gtk-main-quit)

(use Gtk2 "-init")

(define (gtk-main)
  (perl eval "Gtk2->main"))

(define (gtk-main-quit)
   (perl eval "Gtk2->main_quit"))

)

