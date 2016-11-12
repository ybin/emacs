;;
;; package manager
;; package name: init-packages
;;


;; package configuration
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://www.mirrorservice.org/sites/stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; cl - common lisp extension
(require 'cl)

;; add packages
(defvar my/packages '(
		      company
		      paredit
		      autopair
		      clojure-mode
		      cider
		      highlight-parentheses
		      markdown-mode
		      monokai-theme
		      ) "Default packages")

(setq package-selected-packages my/packages)
(defun my/packages-installed-p ()
    (loop for pkg in my/packages
          when (not (package-installed-p pkg)) do (return nil)
          finally (return t)))

(unless (my/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg my/packages)
      (when (not (package-installed-p pkg))
        (package-install pkg))))


;;;;;; ������� ;;;;;;

;; ����ȫ��Company��ȫ����ҪCompany��
(global-company-mode)

;; add-hooks
(defun paredit-mode-enable () (paredit-mode 1))
(defun cider-mode-enable () (cider-mode 1))
(add-hook 'clojure-mode-hook 'cider-mode-enable)
(add-hook 'clojure-mode-hook 'paredit-mode-enable)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode-enable)

;; parentheses mode
(global-highlight-parentheses-mode t)

;; autopair
(autopair-global-mode)


(provide 'init-packages)
