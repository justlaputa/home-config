;; -*- Emacs-List -*-

;; org-mode, remember settings

;;========================================
;; org-mode

(setq org-todo-keywords '("TODO" "STARTED" "WAITING" "DONE"))

(setq org-enforce-todo-dependencies 1)

(setq org-startup-folded 'content)

(setq org-hide-leading-stars 'hidestars)

;; org-agenda settings
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-agenda-files '("~/Dropbox/Docs/orgs/agenda.org"
                         "~/Dropbox/Docs/orgs/work.org"))

;;========================================
;; remeber

(require 'remember-autoloads)

(provide 'gtd-settings)
