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



;;;;;; EmacsĬ���ṩ�Ĺ����趨 ;;;;;;

;; �رչ�����
(tool-bar-mode -1)
;; �ر�����ʱ�İ���ҳ��
(setq inhibit-startup-message t)
;; �رչ�����
(scroll-bar-mode -1)
;; ����Ĭ�ϴ��ڴ�С
(when window-system (set-frame-size (selected-frame) 110 35))
;; ��ʾ�к�
(global-linum-mode)
;; �رձ����ļ���ʹ�ð汾����ȥ��
(setq make-backup-files t)
;; �ر��Զ������ļ�
(setq auto-save-default nil)
;; ѡ��һ�����ֺ����������ֽ����滻������׷��
(delete-selection-mode t)
;; ������ǰ��
(global-hl-line-mode t)
;; �Զ������ļ�������ļ�����������޸��ˣ�
(global-auto-revert-mode t)
;; ���Ų�ȫ���������Զ���������
;; Emacs 24.4��ʹ��electric-pair��֮ǰ�İ汾ʹ��autopair
;(electric-pair-mode t)
;(electric-indent-mode t)
;(electric-layout-mode t)
;; ����'C-a'
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\C-a" 'smart-beginning-of-line)
;; Do What I Mean for current line
(global-set-key "\M-;" 'my-comment-dwim)
;; ƥ�����Ÿ�������� highlight-parentheses ���ʹ�ø�����
(show-paren-mode t)
;; ��ʾ�к�
(column-number-mode t) ; ͬ����ʾ�к�(default): (line-number-mode t)


(provide 'init-better-defaults)
