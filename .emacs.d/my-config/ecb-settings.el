;; -*- Emacs-Lisp -*-

(require 'ecb-autoloads)

(eal-define-keys-commonly
 global-map
 `(("<C-f12>" ecb-minor-mode)
   ("<C-f11>" ecb-toggle-compile-window)))

(setq ecb-tip-of-the-day nil)
(setq ecb-create-layout-file "~/.emacs.d/my-config/my-ecb-layouts.el")
(setq ecb-layout-name "left-speedbar-analyse")
;; (setq ecb-compile-window-height 8)

(provide 'ecb-settings)