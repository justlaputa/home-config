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

(setq org-agenda-files '("~/Dropbox/Docs/orgs/tasks.org"
                         "~/Dropbox/Docs/orgs/work.org"
                         "~/Dropbox/Docs/orgs/notes.org"))

;; org-capture settings
(setq org-default-notes-file (concat org-directory "notes.org"))
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(("n" "Notes" entry (file+datetree (concat org-directory "notes.org"))
         "* %^{Description} %^g %?
  Added: %U")
        ("t" "Todo items")
        ("tl" "Life" entry (file+headline (concat org-directory "tasks.org") "Life")
         "* TODO %^{What I want to do?}\n  Added: %U")
        ("th" "Hack" entry (file+headline (concat org-directory "tasks.org") "Hack")
         "* TODO %^{What I want to hack?}\n  Added: %U")
        ("w" "Work tasks")
        ("wm" "Meetings" entry (file+headline (concat org-directory "work.org") "Meeting")
         "* TODO %^{Meeting again?}\n  %^U\n  Added: %U")
        ("wd" "Development" entry (file+headline (concat org-directory "work.org") "Development")
         "* TODO %^{What ticket?}\n   Added: %U")
        ("s" "Shop item" checkitem (file+headline (concat org-directory "tasks.org") "Shop")
         "- [ ] %^{Item I want buy}\n  Added: %U")
        ("l" "TimeLogger" entry (file+datetree (concat org-directory "timelog.org"))
         "** %U - %^{Activity} :TIME:")
        ))

(provide 'gtd-settings)
