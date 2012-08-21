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

(require 'gtd-settings)

(require 'lua-settings)

(require 'yaml-settings)

;(require 'webdevel-settings)

;(global-set-key (kbd "C-SPC") nil)

(add-to-list 'auto-mode-alist '("[.]md$" . markdown-mode))
