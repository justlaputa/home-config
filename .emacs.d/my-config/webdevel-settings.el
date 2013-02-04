;; -*- Emacs-Lisp -*-

;= use html-mode for JSP files
(add-to-list 'auto-mode-alist '("\\.jsp$" . html-mode))

;= CoffeeScript mode
(autoload 'coffee-mode "coffee-mode" "CoffeeScript mode." t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))

;= jade template editing major mode
;; https://github.com/brianc/jade-mode
(autoload 'sws-mode "sws-mode" "Sws mode." t)
(autoload 'jade-mode "jade-mode" "Jade template mode." t)
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

(require 'mustache-mode)

(provide 'webdevel-settings)
