;;
;; Michael B. Kulik
;; custom emacs file
;;

;; start as a server
(require 'server)
(unless (server-running-p)
  (server-start))


;; install and autoload emacs packages
(require 'package)
(setq package-archives '(("org" . "https://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;;------------------------------------------------------------------------------
;;
;; Theme and Visual behavior
;;
;;------------------------------------------------------------------------------

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)

(setq visible-bell t)

;; disable version control
(setq vc-handled-backends ())

;; better auto indentation
(electric-indent-mode)

;; set backup and autosave to temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; inhibit custom stuff being added to init.el
(setq custom-file (concat user-emacs-directory "/custom.el"))

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq tab-width 4)

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")
(add-hook 'text-mode-hook 'flyspell-mode)

;; spell check in tex mode
(add-hook 'tex-mode-hook
          #'(lambda () (setq ispell-parser 'tex)))

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; make docview fit window size
(add-hook 'doc-view-mode-hook 'doc-view-fit-height-to-window)

;;enable gc on loss of focus
(add-hook 'focus-out-hook 'garbage-collect)

;;; ---------------------------------------------------------------------------
;;;
;;; whitespace highlighting
;;;
;;;----------------------------------------------------------------------------
(require 'whitespace)
(setq whitespace-line-column 80)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'latex-mode-hook 'whitespace-mode)

;;; ---------------------------------------------------------------------------
;;;
;;; org-mode
;;;
;;; multline-emphasis: https://ox-hugo.scripter.co/test/posts/multi-line-bold/
;;; ---------------------------------------------------------------------------
(use-package org
 :ensure t
 :config
 (setq org-html-validation-link nil)
 (setq org-agenda-files '("~/Documents/org/todo.org"))
 (setcar (nthcdr 4 org-emphasis-regexp-components) 20)
 (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components))

;;; ---------------------------------------------------------------------------
;;;
;;; almost-mono-white color theme
;;;
;;; ---------------------------------------------------------------------------
(use-package almost-mono-themes
  :ensure t
  :config
  (load-theme 'almost-mono-white t)
  (set-frame-font "Monospace 12" nil t)
  (set-background-color "#FFFEEE")
  (set-foreground-color "#111111"))

;;; --------------------------------------------------------------------------
;;;
;;; writegood-mode
;;;
;;; --------------------------------------------------------------------------
(use-package writegood-mode
  :ensure t
  :defer t
  :bind ("C-c g" . writegood-mode))

(use-package company
  :ensure t
  :hook (prog-mode . company-mode))

(use-package ivy
  :ensure t
  :defer 0.1
  :config (ivy-mode))

(use-package feebleline
  :ensure t
  :config (feebleline-mode t))


(defconst my-eclipse-jdt-home "/home/mkulik/.emacs.d/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar")
(defun my-eglot-eclipse-jdt-contact (interactive)
  "Contact with the jdt server input INTERACTIVE."
  (let ((cp (getenv "CLASSPATH")))
    (setenv "CLASSPATH" (concat cp ":" my-eclipse-jdt-home))
    (unwind-protect (eglot--eclipse-jdt-contact nil)
      (setenv "CLASSPATH" cp))))

(use-package eglot
  :ensure t
  :config
  (setcdr(assq 'java-mode eglot-server-programs) #'my-eglot-eclipse-jdt-contact)
  :hook
  (c++-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (java-mode . eglot-ensure))

;; ---------------------------------------------------------------------------
;;
;; elfeed (rss reader)
;;
;; ---------------------------------------------------------------------------
(use-package elfeed
  :ensure t
  :defer t
  :bind ("C-x w" . elfeed)
  :init
  (setq elfeed-feeds
        '("http://planet.emacslife.com/atom.xml"
          "http://fedoraplanet.org/rss20.xml"
          "http://planet.gnome.org/rss20.xml"
          "https://www.phoronix.com/rss.php"
          "https://blogs.gnome.org/shell-dev/rss"
          "https://lemire.me/blog/feed/")))

;; --------------------------------------------------------------------------
;;
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;; --------------------------------------------------------------------------
(defun mbk/kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'mbk/kill-this-buffer)
