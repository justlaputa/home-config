;; -*- Emacs-Lisp -*-

(semantic-load-enable-excessive-code-helpers)
(global-semantic-idle-completions-mode -1)
(semantic-load-enable-semantic-debugging-helpers)

(require 'semantic-tag-folding nil 'noerror)

(eal-define-keys-commonly
 semantic-tag-folding-mode-map
 `(("C-c , -" semantic-tag-folding-fold-block)
   ("C-c , +" semantic-tag-folding-show-block)
   ("C-_"     semantic-tag-folding-fold-all)
   ("C-+"     semantic-tag-folding-show-all)))

(eal-define-keys-commonly
 global-map
 `(("C-x M-j" semantic-complete-jump)))

(defun cedet-semantic-settings ()
  "Settings for `semantic'."
  (eal-define-keys
   `(c-mode-base-map makefile-gmake-mode-map python-mode-map perl-mode-map sh-mode-map)
   `(("<f3>" semantic-ia-fast-jump)
     ("<f4>" semantic-complete-jump)
     ("<C-f9>" semantic-mrub-switch-tags)
     ;;("C-c C-j" semantic-ia-fast-jump)
     ;;("C-c j"   semantic-complete-jump-local)
     ("C-c n"   senator-next-tag)
     ("C-c p"   senator-previous-tag)
     ("C-c M-m" semantic-goto-local-main)
     ("C-c M-M" semantic-goto-main)))

  (defun semantic-goto-main ()
    "Jump to main function."
    (interactive)
    (semantic-goto-tag 'main))

  (defun semantic-goto-local-main ()
    "Jump to local main function."
    (interactive)
    (semantic-goto-local-tag 'main))
  
  (defun semantic-goto-local-tag (tag)
    "Jump to local tag."
    (interactive "STag goto: ")
    (let* ((semantic-completion-collector-engine (semantic-collector-buffer-deep "" :buffer (current-buffer)))
           (semantic-completion-display-engine (semantic-displayor-traditional-with-focus-highlight "simple"))
           (semantic-complete-active-default nil)
           (semantic-complete-current-matched-tag nil)
           (tag (semantic-complete-default-to-tag tag)))

      (when (semantic-tag-p tag)
        (push-mark)
        (goto-char (semantic-tag-start tag))
        (semantic-momentary-highlight-tag tag)
        (working-message "%S: %s " (semantic-tag-class tag) (semantic-tag-name  tag)))))

  (defun semantic-goto-tag (tag)
    "Jump to tag."
    (interactive "STag goto: ")
    (let* ((semantic-completion-collector-engine
            (semantic-collector-project-brutish "" :buffer (current-buffer) :path (current-buffer)))
           (semantic-completion-display-engine (semantic-displayor-traditional-with-focus-highlight "simple"))
           (semantic-complete-active-default nil)
           (semantic-complete-current-matched-tag nil)
           (tag (semantic-complete-default-to-tag tag)))

      (when (semantic-tag-p tag)
      (push-mark)
      (semantic-go-to-tag tag)
      (switch-to-buffer (current-buffer))
      (semantic-momentary-highlight-tag tag)
      (working-message "%S: %s " (semantic-tag-class tag) (semantic-tag-name  tag)))))
  
  (defun cedet-semantic-settings-4-emaci ()
    "cedet `semantic' settings for `emaci'."  
    (emaci-add-key-definition
     "." 'semantic-ia-fast-jump
     '(memq major-mode dev-modes))
    (emaci-add-key-definition
     "," 'recent-jump-backward
     '(memq major-mode dev-modes)))

  (eval-after-load "emaci"
    `(cedet-semantic-settings-4-emaci))

  (eal-define-keys
   'emaci-mode-map
   `(("." emaci-.)
     ("," emaci-\,))))

(defun semantic-decorate-include-settings ()
  "Settings of `semantic-decorate-include'."
  (eal-define-keys
   'semantic-decoration-on-include-map
   `(("." semantic-decoration-include-visit))))

(defun cedet-semantic-idle-settings ()
  "Settings for `semantic-idle'."
  (defun semantic-idle-tag-highlight-idle-command ()
    "Highlight the tag, and references of the symbol under point.
Call `semantic-analyze-current-context' to find the refer ence tag.
Call `semantic-symref-hits-in-region' to identify local references."
    (interactive)
    (semantic-idle-tag-highlight-idle-function))

  (defun semantic-idle-summary-idle-command ()
    "Display a tag summary of the lexical token under the cursor.
Call `semantic-idle-summary-current-symbol-info' for getting the
current tag to display information."
    (interactive)
    (semantic-idle-summary-idle-function))

  (defun semantic-refresh-tags ()
    "Execute `semantic-idle-scheduler-refresh-tags'"
    (interactive)
    (semantic-idle-scheduler-refresh-tags))
  
  (eal-define-keys
   `(c-mode-base-map)
   `(("C-c M-s" semantic-idle-summary-idle-command))))

(defun semantic-decorate-mode-settings ()
  "Settings of `semantic-decorate-mode'."
  (defun semantic-decoration-decorate ()
    "`semantic-decorate-add-decorations' all `semantic-fetch-available-tags'."
    (interactive)
    (semantic-decorate-add-decorations (semantic-fetch-available-tags))))

(eal-define-keys
 `(semantic-symref-results-mode-map)
 `(("1" delete-other-windows)
   ("2" split-window-vertically)
   ("3" split-window-horizontally)
   ("q" delete-current-window)))

(eval-after-load "semantic-decorate-include"
  `(semantic-decorate-include-settings))

(eval-after-load "semantic-decorate-mode"
  `(semantic-decorate-mode-settings))

(eval-after-load "semantic-idle"
  `(cedet-semantic-idle-settings))

(eval-after-load "semantic"
  `(cedet-semantic-settings))

(provide 'cedet-semantic-settings)