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
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
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

;; https://tony-zorman.com/posts/2022-10-22-emacs-potpourri.html
(setq frame-inhibit-implied-resize t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq font-use-system-font t)
(setq pixel-scroll-precision-mode t)
(setq visible-bell t)

;; ignore suspend-frame
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

(setq org-directory "~/Documents/org/")
(setq org-indent-mode-turns-on-hiding-stars nil)
(setq org-default-notes-file "~/Documents/org/inbox.org")
(setq org-latex-pdf-process '("podman run --rm -v `pwd`:/docs:Z latex:latest %f"))

;; disable version control
(setq vc-handled-backends ())

;; dont indent based on previous line
(setq-default electric-indent-inhibit t)

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
(setq-default frame-title-format '("%b"))

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")
(add-hook 'text-mode-hook 'flyspell-mode)

;; spell check in tex mode
(add-hook 'tex-mode-hook
          #'(lambda () (setq ispell-parser 'tex)))

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; tree-sitter
(require 'treesit)
(add-hook 'python-mode-hook 'python-ts-mode)
(add-hook 'c-mode-hook 'c-ts-mode)
(add-hook 'java-mode-hook 'java-ts-mode)

;; for project.el root
(setq project-vc-extra-root-markers '("build.gradle.kts" ".project"))

(add-to-list 'tramp-connection-properties
           (list (regexp-quote nil)
                 "remote-shell" "/usr/bin/bash"))


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

(add-function :after after-focus-change-function 'garbage-collect)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(use-package minions
  :ensure t
  :init
  (minions-mode))

;;; --------------------------------------------------------------------------
;;;
;;; markdown mode
;;;
;;;---------------------------------------------------------------------------
(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;;; ---------------------------------------------------------------------------
;;;
;;; almost-mono-white color theme
;;;
;;; ---------------------------------------------------------------------------
(use-package almost-mono-themes
  :ensure t
  :config
  (load-theme 'almost-mono-white t))

;;; --------------------------------------------------------------------------
;;;
;;; writegood-mode
;;;
;;; --------------------------------------------------------------------------
(use-package writegood-mode
  :ensure t
  :defer t
  :bind ("C-c g" . writegood-mode))

;;; --------------------------------------------------------------------------
;;;
;;; lsp  packages
;;;
;;; --------------------------------------------------------------------------
(use-package company
  :ensure t
  :init
  (setq company-minimum-prefix-length 1)
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
  :hook (prog-mode . company-mode))

(use-package vertico
  :ensure t
  :config
  (setq read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t)
  :init
  (vertico-mode))

(use-package eglot
  :ensure t
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs '((c++-ts-mode c-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(python-ts-mode) "pylsp")
  (add-to-list 'eglot-server-programs '(java-mode) "jdtls")
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'java-mode-hook 'eglot-ensure))

(use-package vterm
  :ensure t
  :config
  (setq vterm-always-compile-module t)
  (setq vterm-kill-buffer-on-exit t))

(use-package pdf-tools
  :ensure t)

;; --------------------------------------------------------------------------
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;; --------------------------------------------------------------------------
(global-set-key (kbd "C-x k") #'(lambda() (interactive)
                                  (kill-buffer (current-buffer))))

(global-set-key (kbd "C-x t") #'(lambda() (interactive)
                                  (vterm t)))

(setq native-comp-async-report-warnings-errors nil)
(when (fboundp 'native-compile-async)
  (setq comp-deferred-compilation t))


;; ----------------------------------------------------------------------
;;
;; machine specific configuration: elfeed and mastodon
;;
;; ----------------------------------------------------------------------
(when (string= (system-name) "precision")
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
            "https://lemire.me/blog/feed/"
            "https://kbd.news/rss.php"
            "https://www.youtube.com/feeds/videos.xml?channel_id=UCT6AJiTYspOILBK3hMWEq2g"
            "https://www.youtube.com/feeds/videos.xml?channel_id=UCOFH59uoSs8SUF0L_p3W0sg"
            "https://www.youtube.com/feeds/videos.xml?channel_id=UCXlDgfWY2JbsYEam2m68Hyw"
            "https://grapheneos.org/releases.atom")))

  (use-package mastodon
    :ensure t
    :config
    (setq mastodon-instance-url "https://mastodon.online"
          mastodon-active-user "michaelbkulik")
    (setq mastodon-toot--enable-completion t))
  )
