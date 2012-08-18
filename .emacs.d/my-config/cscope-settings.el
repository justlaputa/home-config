;; -*- Emacs-Lisp -*-

(require 'xcscope)

(eal-define-keys-commonly
 global-map
 `(("<C-f1>" cscope-set-initial-directory)
   ("<C-f2>" cscope-index-files)
   ("<C-f3>" cscope-find-global-definition)
   ("<C-f4>" cscope-find-this-symbol)))

(provide 'cscope-settings)