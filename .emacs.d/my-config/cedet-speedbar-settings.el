;; -*- Emacs-Lisp -*-

(eal-define-keys
 `speedbar-key-map
 `(("j"   speedbar-next)
   ("k"   speedbar-prev)
   ("o"   other-window)
   ("m"   speedbar-toggle-line-expansion)
   ("SPC" View-scroll-half-page-forward)
   ("u"   View-scroll-half-page-backward)))

(eal-define-keys
 `speedbar-file-key-map
 `(("SPC" View-scroll-half-page-forward)))

(provide 'cedet-speedbar-settings)