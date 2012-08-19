;; -*- Emacs-Lisp -*-

(autoload 'yaml-mode "yaml-mode" "Yaml editing mode." t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(provide 'yaml-settings)
