;;
;; Emacs UI
;;


(load-theme 'monokai t)
(if (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Consolas-10:bold" :height 105)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
		      charset (font-spec :family "Microsoft Yahei" :size 12))))

;; ���ø�����ǰ�е���ɫ
(set-face-background 'hl-line "#3e4446")
;; ͬʱ�����﷨��������

(set-face-foreground 'highlight nil)


(provide 'init-ui)
