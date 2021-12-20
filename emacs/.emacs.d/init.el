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

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq font-use-system-font t)

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
(setq-default frame-title-format '("%b"))

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
(add-function :after after-focus-change-function 'garbage-collect)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

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


:;; ---------------------------------------------------------------------------
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
;;; lsp mode packages
;;;
;;; --------------------------------------------------------------------------
(use-package company
  :ensure t
  :init
  (setq company-minimum-prefix-length 1)
  :hook (prog-mode . company-mode))

(use-package ivy
  :ensure t
  :config (ivy-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  ;;  (setq lsp-keymap-prefix "C-c l")
  (setq c-c++-backend 'lsp-ccls)
  (setq lsp-restart 'auto-restart)
  :hook
  (c-mode . lsp-deferred)
  :commands lsp lsp-deferred)

(use-package lsp-java
  :ensure t
  :hook (java-mode . lsp-deferred))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

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
          "https://lemire.me/blog/feed/"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCeeFfhMcJa1kjtfZAGskOCA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UC4w1YQAJMWOz4qtxinq55LQ"
          "https://kbd.news/rss.php"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCT6AJiTYspOILBK3hMWEq2g"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCOFH59uoSs8SUF0L_p3W0sg"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCXlDgfWY2JbsYEam2m68Hyw")))

;; --------------------------------------------------------------------------
;;
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;; --------------------------------------------------------------------------
(defun mbk/kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'mbk/kill-this-buffer)

(when (fboundp 'native-compile-async)
  (setq comp-deferred-compilation t))
