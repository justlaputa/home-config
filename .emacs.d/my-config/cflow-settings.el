;; -*- Emacs-List -*-

;; cflow settings for emacs

(autoload 'cflow-mode "cflow-mode")
(setq auto-mode-alist (append auto-mode-alist
                              '(("\\.cflow$" . cflow-mode))))

(provide 'cflow-settings)