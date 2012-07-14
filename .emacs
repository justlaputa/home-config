;; -*- Emacs-Lisp -*-

;; .emacs file, load all my emacs settings

(defconst emacs-path "~/.emacs.d/" "Emacs configuration file path")
(defconst emacs-lisps-path (concat emacs-path "lisps/") "lisp modules")
(defconst emacs-my-config-path (concat emacs-path "my-config/") "my config files")

(load (concat emacs-my-config-path "helper-func"))
(my-add-subdirs-to-load-path emacs-lisps-path)
(my-add-subdirs-to-load-path emacs-my-config-path)

;; optimize the startup speed
;; http://emacser.com/eval-after-load.htm
(require 'eval-after-load)

(require 'general-settings)

(require 'cscope-settings)

;(require 'cedet-settings)

;(require 'ecb-settings)

(require 'auto-complete-settings)

(require 'lua-settings)

(global-set-key (kbd "C-SPC") nil)

(add-to-list 'auto-mode-alist '("[.]md$" . markdown-mode))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left-speedbar-symref" (0.192090395480226 . 0.5862068965517241) (0.192090395480226 . 0.39655172413793105)) ("left-speedbar-analyse" (0.1864406779661017 . 0.6724137931034483) (0.1864406779661017 . 0.3103448275862069)))))
 '(ecb-options-version "2.40")
 '(use-file-dialog nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
