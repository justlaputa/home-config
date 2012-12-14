;; -*- Emacs-Lisp -*-

(autoload 'coffee-mode "coffee-mode" "CoffeeScript mode." t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))

(provide 'js-settings)
