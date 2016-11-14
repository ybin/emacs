;;
;; package: init-better-defaults
;;


;;;;;; util functions ;;;;;;
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(defun my-comment-dwim (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and
we are not at the end of the line, then comment current line.
Replaces default behaviour of comment-dwim,
when it inserts comment at the end of the line. "

  (interactive "*P")
  (comment-normalize-vars)

  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))



;;;;;; Emacs默认提供的功能设定 ;;;;;;

;; 关闭工具栏
(tool-bar-mode -1)
;; 关闭启动时的帮助页面
(setq inhibit-startup-message t)
;; 关闭滚动条
(scroll-bar-mode -1)
;; 设置默认窗口大小
(when window-system (set-frame-size (selected-frame) 110 35))
;; 显示行号
(global-linum-mode)
;; 关闭备份文件，使用版本控制去吧
(setq make-backup-files t)
;; 关闭自动保存文件
(setq auto-save-default nil)
;; 选中一段文字后输入新文字进行替换而不是追加
(delete-selection-mode t)
;; 高亮当前行
(global-hl-line-mode t)
;; 自动加载文件（如果文件被其他软件修改了）
(global-auto-revert-mode t)
;; 括号补全、缩进、自动插入新行
;; Emacs 24.4再使用electric-pair，之前的版本使用autopair
;(electric-pair-mode t)
;(electric-indent-mode t)
;(electric-layout-mode t)
;; 智能'C-a'
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\C-a" 'smart-beginning-of-line)
;; Do What I Mean for current line
(global-set-key "\M-;" 'my-comment-dwim)
;; 匹配括号高亮，配合 highlight-parentheses 插件使用更美好
(show-paren-mode t)
;; 显示列号
(column-number-mode t) ; 同理，显示列号(default): (line-number-mode t)
;; line truncate turn on
(set-default 'truncate-lines t)


(provide 'init-better-defaults)
