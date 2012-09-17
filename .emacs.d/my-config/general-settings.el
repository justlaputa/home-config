;; -*- Emacs-List -*-

;;General settings for emacs

;; color & face
;; set for all frame
(setq default-frame-alist
      '( (background-color . "black")
	 (foreground-color . "gray")
	 (cursor-color . "green")
	 (cursor-type . hbar)))

(blink-cursor-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; disable startup splash
(setq inhibit-startup-screen t)
(setq initial-buffer-choice nil)

;;
(fset 'yes-or-no-p 'y-or-n-p)

;; save minibuffer history
(savehist-mode t)

;; display matched parenthesis
(show-paren-mode t)

;; kill whole line with new-line
(setq-default kill-whole-line t)

;; display column and line number
(column-number-mode 1)
;(global-linum-mode)

;; disable backup files & auto-save
(setq make-backup-files nil)
(setq auto-save-default nil)

;; replace tab with space
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq tab-stop-list '(4 8 12 16 20))

;; If t, hitting TAB always just indents the current line.
;; If nil, hitting TAB indents the current line if point is at the left margin
;; or in the line's indentation, otherwise it inserts a "real" TAB character.
;; If `complete', TAB first tries to indent the current line, and if the line
;; was already indented, then try to complete the thing at point.

(setq tab-always-indent 'complete)

;; auto revert dirty file
(global-auto-revert-mode 1)

;; shift + arrow to switch window
;;(windmove-default-keybindings)

;; smooth scrolling
(setq scroll-margin 3
      scroll-conservatively 10000)

;; auto move mouse point
(mouse-avoidance-mode 'animate)

;; enable copy-paste with other program
(setq x-select-enable-clipboard t)

;; display command sequence quickly
(setq echo-keystrokes 0.1)

;; buffer settings

(define-key global-map (kbd "C-x M-n") 'next-buffer)
(define-key global-map (kbd "C-x M-p") 'previous-buffer)
(define-key global-map (kbd "C-z") nil)

;; immediatly kill buffer after "C-x k"
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; 
(global-set-key (kbd "C-;") 'whitespace-mode)
(provide 'general-settings)
