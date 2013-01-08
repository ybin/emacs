(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;;============ customize GUI interface ============
;; set window size when startup
(when window-system
  (setq default-frame-alist
	'((height . 35) (width . 130))))
;; set some other default values
(set-default-font "YaHei Consolas Hybrid-10")
(setq default-directory "E:/Emacs")
(setq make-backup-files nil)
;; do NOT show startup splash
(setq inhibit-startup-message t)
;; do NOT show tool bar
(tool-bar-mode nil)
;; do NOT show menu bar
;; (menu-bar-mode nil)
;; highlight current line
(global-hl-line-mode t)
;;============ GUI interface end ============


;;============ require minor modes ============
;; show the line number
(require 'linum)
(global-linum-mode t)
(column-number-mode t)

;; use yasnippet plugin
(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet/")
(require 'yasnippet)
(yas-global-mode 1)

;; use python-mode instead of the builtin python-mode
(add-to-list 'load-path
	     "~/.emacs.d/plugins/python-mode")
(setq py-install-directory "~/.emacs.d/plugins/python-mode")
(require 'python-mode)

;; show parenthesis ()
(show-paren-mode t)

;; show function name in status bar
(which-func-mode t)

;; move text like eclipse
(add-to-list 'load-path
	     "~/.emacs.d/plugins/move-text")
(require 'move-text)
(move-text-default-bindings)

;; save place when exit or switch buffers
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/plugins/savepleces")

;; markdown mode
(add-to-list 'load-path
	     "~/.emacs.d/plugins/markdown")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; undo tree mode
;; C-x u : enter undo-tree-visualizer-mode
;; n,p : move up/down
;; b,f : move between branches
;; t   : show timestamp
;; q   : quit
(add-to-list 'load-path
	     "~/.emacs.d/plugins/undo-tree-mode")
(require 'undo-tree)
(global-undo-tree-mode)

;; git-emacs mode
(add-to-list 'load-path
	     "~/.emacs.d/plugins/git-emacs")
(require 'git-emacs)
;;============ require minor modes end ============


;;============ customize key banding ============
(defun my-comment-dwim(&optional arg)
  "comment/uncomment the current line or comment the selected region"
  (interactive "*p") 
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "M-;") 'my-comment-dwim)

(global-set-key (kbd "C-M-m") 'push-mark-command)
;; revert buffer from file - update buffer from file
;(global-set-key (kbd "<f5>") 'revert-buffer)
;; write region to a file: overriding.
(global-set-key (kbd "C-x w") 'write-region)

(defun my-newline-and-indent()
  "goto end of line and newline-and-indent"
  (interactive)
  (end-of-line)
  (newline-and-indent))
(global-set-key (kbd "C-j") 'my-newline-and-indent)

;; mode cursor among multiple windows
; (global-set-key [M-left] 'windmove-left)
; (global-set-key [M-up] 'windmove-up)
; (global-set-key [M-right] 'windmove-right)
; (global-set-key [M-down] 'windmove-down)

(defun my-duplicate-line-or-region(N)
  "copy & paste the current line if region is not active,
otherwise, copy & paste the selected region."
  (interactive "*p")
  (if (not (region-active-p))
      ; copy and paste the current line
      (progn
	;; (kill-ring-save (line-beginning-position) (line-end-position))
	(setq content (buffer-substring (line-beginning-position) (line-end-position))
	      column (current-column))
	(if (< N 0)
	    (forward-line N))
	(end-of-line)
	(newline)
	(insert content)
	(move-to-column column))
    ; copy and paste the selected region
    (progn
      (setq r-start (region-beginning)
	    r-end (region-end))
      (goto-char r-start)
      (setq start (line-beginning-position))
      (goto-char r-end)
      (setq end (line-end-position))
      (deactivate-mark)
      (setq r-content (buffer-substring start end))
      (if (< N 0)
	  (progn
	    (goto-char start)
	    (forward-line N)
	    (end-of-line))
	(goto-char end))
      (newline)
      (insert r-content))))

(defun my-duplicate-line-or-region-up()
  ""
  (interactive)
  (my-duplicate-line-or-region -1))
(defun my-duplicate-line-or-region-down()
  ""
  (interactive)
  (my-duplicate-line-or-region 1))
(global-set-key [C-M-down] 'my-duplicate-line-or-region-down)
(global-set-key [C-M-up] 'my-duplicate-line-or-region-up)

(defun my-move-line-or-region(N)
  ""
  (interactive "*p")
  (if (not (region-active-p))
      ; move the current line
      (progn
	(setq column (current-column))
	(if (< N 0)
	    (progn
	      (transpose-lines 1)
	      (forward-line -2))
	  (progn
	    (forward-line 1)
	    (transpose-lines 1)
	    (forward-line -1)))
	(move-to-column column))
    ; move the selected region
    (progn
      (setq r-start (region-beginning)
	    r-end (region-end)
	    need-transpose nil
	    line (1+ (count-lines 1 (point)))
	    column (current-column))
      (deactivate-mark)
      (goto-char r-start)
      (setq start-1 (line-beginning-position))
      (goto-char r-end)
      (setq end-1 (line-end-position))
      (if (and (> N 0) (< end-1 (point-max)))
	  (progn
	    (goto-char end-1)
	    (forward-line 1)
	    (setq start-2 (line-beginning-position)
		  end-2 (line-end-position)
		  need-transpose t)))
      (if (and (< N 0) (> start-2 (point-min)))
	  (progn
	    (goto-char start-1)
	    (forward-line -1)
	    (setq line (- line 2))
	    (setq start-2 (line-beginning-position)
		  end-2 (line-end-position)
		  need-transpose t)))
      (if need-transpose
	  (progn
	    (transpose-regions start-1 end-1 start-2 end-2 t)
	    (goto-line line)
	    (move-to-column column))))))
(defun my-move-line-or-region-up()
  ""
  (interactive)
  (my-move-line-or-region -1))
(defun my-move-line-or-region-down()
  ""
  (interactive)
  (my-move-line-or-region 1))
; (global-set-key [M-up] 'my-move-line-or-region-up)
; (global-set-key [M-down] 'my-move-line-or-region-down)

;; aaaaaaaaaaaaaaaaaaaaaaaaa
;; bbbbbbbbbbbbbbbbbbbbbbbbb
;; ccccccccccccccccccccccccc
;; ddddddddddddddddddddddddd

(defun my-delete-region()
  ""
  (interactive)
  (if (region-active-p)
      (progn
	(setq r-start (region-beginning)
	      r-end (region-end))
	(deactivate-mark)
	(goto-char r-start)
	(setq start (line-beginning-position))
	(goto-char r-end)
	(setq end (line-end-position))
	(delete-region start end))))
(defun my-new-ctrl-d()
  ""
  (interactive)
  (if (region-active-p)
      (my-delete-region)
    (delete-char 1)))
(global-set-key (kbd "C-d") 'my-new-ctrl-d)

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))
    
;;============ key banding end ============


;;============ Misc ============
;; Exchange information with OS clipboard
; clipboard-kill-ring-save ;; copy selection from Emacs to clipboard
; clipboard-kill-region ;; cut selection from Emacs to clipboard
; clipboard-yank ;; paste from clipboard to Emacs

;; 设置编码格式
; set-buffer-file-coding-system ;; change coding system of current buffer
; revert-buffer-with-coding-system ;; revert current buffer with coding system
; describe-coding-system ;; describe the current coding system
;;============ Misc end ============


;(add-to-list 'load-path
;	     "~/.emacs.d/plugins/auto-complete")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories
;	     "~/.emacs.d/plugins/auto-complete/ac-dict")
;(ac-config-default)
;(set-face-background 'ac-selection-face "steelblue")
;(define-key ac-completing-map "\M-n" 'ac-next)
;(define-key ac-completing-map "\M-p" 'ac-previous)

;(add-to-list 'load-path
;	     "~/.emacs.d/plugins/pymacs/")
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-load "pymacs" nil t)
;(eval-after-load "pymacs"
;  (add-to-list 'pymacs-load-path "xxxx")

;(add-to-list 'load-path
;	     "~/.emacs.d/plugins/pycomplete/")
;(require 'pycomplete)

