;; -*- Emacs-List -*-

;; org-mode, remember settings

;;========================================
;; org-mode
(setq org-directory "~/Dropbox/Docs/orgs/")

(setq org-todo-keywords '("TODO" "STARTED" "WAITING" "|" "DONE" "CANCELED"))

(setq org-enforce-todo-dependencies 1)

(setq org-startup-folded 'content)

(setq org-hide-leading-stars 'hidestars)

;; org-agenda settings
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-agenda-files '("~/Dropbox/Docs/orgs/agenda.org"
                         "~/Dropbox/Docs/orgs/work.org"
                         "~/Dropbox/Docs/orgs/notes.org"))

(provide 'gtd-settings)
