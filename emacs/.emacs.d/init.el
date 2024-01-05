;;
;; Michael B. Kulik
;; custom emacs file
;;

;; install and autoload emacs packages
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
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
(setq kill-whole-line t)

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

(setq eldoc-echo-area-prefer-doc-buffer t
      eldoc-echo-area-use-multiline-p nil)

;;enable .rs file open in rust-mode
;;(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

;; for project.el root
(setq project-vc-extra-root-markers '("build.gradle.kts" ".project"))
(setq project-vc-ignores '("bin/", "build/"))

(setq explicit-shell-file-name "/bin/bash")

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


(use-package gcmh
  :ensure t
  :config
  (gcmh-mode t))

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

;;; --------------------------------------------------------------------------
;;;
;;; customized sketch theme (vendored)
;;;
;;; --------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/theme/")
(require 'sketch-themes)
(load-theme 'sketch-white t)

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
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  (corfu-separator ?\s)
  (corfu-scroll-margin 5)
  :init
  (global-corfu-mode))

(use-package emacs
  :init
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete)
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (java "https://github.com/tree-sitter/tree-sitter-java")))
  (setq major-mode-remap-alist '((c++-mode . c++-ts-mode)
                                 (python-mode . python-ts-mode)
                                 (c-mode . c-ts-mode)
                                 (java-mode . java-ts-mode))))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package eglot
  :ensure t
  :init
  (fset #'jsonrpc--log-event #'ignore)
  :config
  (setq eglot-autoreconnect t)
  (setq eglot-autoshutdown t)
  (setq eglot-events-buffer-size 0)
  (add-to-list 'eglot-server-programs '((c++-ts-mode c-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(python-ts-mode) "pylsp")
  (add-to-list 'eglot-server-programs '(java-ts-mode) "jdtls")
  ;;(add-to-list 'eglot-server-programs '(rust-ts-mode) "rust-analyzer")
  (add-hook 'c-ts-mode-hook 'eglot-ensure)
  (add-hook 'c++-ts-mode-hook 'eglot-ensure)
  (add-hook 'python-ts-mode-hook 'eglot-ensure)
  (add-hook 'java-ts-mode-hook 'eglot-ensure))
  ;;(add-hook 'rust-ts-mode-hook 'eglot-ensure))

(use-package eat
  :ensure t
  :config
  (setq eat-kill-buffer-on-exit t))

(use-package mastodon
  :ensure t
  :config
  (setq mastodon-instance-url "https://mastodon.online"
        mastodon-active-user "michaelbkulik")
  (setq mastodon-toot--enable-completion t))

;; ----------------------------------------------------------------------
;;
;; machine specific configuration: elfeed, mastodon
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
            "http://planet.gnome.org/rss20.xml"
            "https://www.phoronix.com/rss.php"
            "https://blogs.gnome.org/shell-dev/rss"
            "https://lemire.me/blog/feed/"
            "https://grapheneos.org/releases.atom"
            "http://fedoraplanet.org/rss20.xml"))))

;; --------------------------------------------------------------------------
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;; --------------------------------------------------------------------------
(global-set-key (kbd "C-x k") #'(lambda() (interactive)
                                  (kill-buffer (current-buffer))))

(global-set-key (kbd "C-x t") #'eat)

(global-set-key (kbd "C-x p") #'eat-send-password)

(global-set-key (kbd "C-x r") #'(lambda() (interactive)
                                  (byte-recompile-directory package-user-dir
                                                            nil 'force)))

(global-set-key (kbd "C-x e") #'(lambda() (interactive)
                                  (flymake-show-buffer-diagnostics)))

(setq native-comp-async-report-warnings-errors nil)
