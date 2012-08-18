;; -*- Emacs-Lisp -*-

(add-hook 'gdb-mode-hook '(lambda ()
        (gud-tooltip-mode 1)
        (tool-bar-mode t)
        (gdb-show-changed-values t)
    )
)

(defun gud-break-remove ()                                                   
  "Set/clear breakpoin."                                                     
  (interactive)                                                              
  (save-excursion                                                            
    (if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)               
        (gud-remove nil)                                                     
      (gud-break nil))))

(defun gdb-or-gud-go ()                                                      
  "If gdb isn't running; run gdb, else call gud-go."                         
  (interactive)                                                       
  (if (and gud-comint-buffer                                                 
           (buffer-name gud-comint-buffer)                                   
           (get-buffer-process gud-comint-buffer)                            
           (with-current-buffer gud-comint-buffer (eq gud-minor-mode 'gdba))) ;;if part
      ;;then part 
      (funcall (lambda ()
            (gud-call (if gdb-active-process "continue" "run") "")
            (speedbar-update-contents)
        )
      )           
    ;;else part
    (funcall(lambda ()
        (sr-speedbar-close)
        (gdb (gud-query-cmdline 'gdba)))
    )
  );;end:if
) 

(defun gdb-or-gud-go2 ()                                                      
  "Set/clear breakpoin."                                                     
  (interactive)                                                              
  (save-excursion                                                            
    (if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)               
        (gud-remove nil)                                                     
      (gud-break nil))))     
                                                      
(defun gud-kill ()                                                           
  "Kill gdb process."                                                        
  (interactive)                                                              
  (with-current-buffer gud-comint-buffer (comint-skip-input))                
  (kill-process (get-buffer-process gud-comint-buffer))) 

(defun gdb-key-settings ()                                                      
    "If gdb isn't running; run gdb, else call gud-go."                         
    (interactive)
        (global-set-key [f5] 'gdb-or-gud-go)    ;;F5:启动GUD/GUD-go ;;f5 开始调试/go
        (global-set-key [S-f5] 'gud-kill)       ;;shift+f5 停止调试
        
        (global-set-key [(f8)] 'gud-until)      ;;F8 运行到光标处
        
        (global-set-key [f1] 'gud-watch)        ;;f9 查看变量
        (global-set-key [f9] 'gud-break-remove) ;;f9 断点开关
        (global-set-key [f10] 'gud-next)        ;;f10 next
        (global-set-key [f11] 'gud-step)        ;;f11:setup-into
        (global-set-key [S-f11] 'gud-finish)    ;;shift+f11:setup-out
        (global-set-key [(f12)] 'speedbar-update-contents)      ;;F12 刷新speedbar(让监视点的数据刷新为最新)
            
)

(add-hook 'c-mode-common-hook 'gdb-key-settings)
(add-hook 'go-mode-hook 'gdb-key-settings)

(provide 'gdb-settings)
