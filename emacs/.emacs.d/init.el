;;
;; Michael B. Kulik
;; custom emacs file
;;

;; install and autoload emacs packages
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(require 'use-package)

;; compile elisp to byte-code and/or native-code
(use-package compile-angel
  :ensure t
  :demand t
  :config
  (compile-angel-on-save-mode)
  (compile-angel-on-load-mode))

;;-----------------------------------------------------------------------------
;;
;; Theme and Visual behavior
;;
;;-----------------------------------------------------------------------------

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

(setq scroll-conservatively 10)
(setq scroll-margin 15)

;; ignore suspend-frame
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

(use-package gcmh
  :ensure t
  :hook (after-init . gcmh-mode)
  :custom
  ; Default is 15s; 0.5s is better for snappy performance
  (gcmh-idle-delay 0.5)
  (gcmh-high-cons-threshold (* 16 1024 1024))) ; 16MB limit during active use

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

;; disable version control
(setq vc-handled-backends ())

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

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

(setq eldoc-echo-area-prefer-doc-buffer t
      eldoc-echo-area-use-multiline-p nil)

;; for project.el root
(setq project-vc-extra-root-markers '("build.gradle.kts" ".project" "Cargo.toml"))
(setq project-vc-ignores '("bin/", "build/"))

(setq explicit-shell-file-name "/bin/bash")

(require 'org)
(setq org-default-notes-file "~/Documents/org/todo.org")
(setq org-cycle-separator-lines 2)
(setq org-archive-location "::* Archived")
(setq org-latex-pdf-process '("xelatex %f"))
(setq org-capture-templates
      '(("i" "Inbox" entry (file+headline org-default-notes-file "Inbox")
         "** %?")))

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
;;; customized sketch theme (vendored)
;;;
;;; --------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/theme/")
(require 'sketch-themes)
(load-theme 'sketch-white t)

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
         ("\\.markdown\\'" . markdown-mode)))

;;; --------------------------------------------------------------------------
;;;
;;; writegood-mode
;;;
;;; --------------------------------------------------------------------------
(use-package writegood-mode
  :ensure t
  :defer t
  :bind ("C-c g" . writegood-mode))

(use-package typst-ts-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode)))

;;; --------------------------------------------------------------------------
;;;
;;; lsp  packages
;;;
;;; --------------------------------------------------------------------------
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind
  ;; Bind TAB in the global map effectively, but ONLY for company-mode
  (:map company-mode-map
        ("<tab>" . company-indent-or-complete-common)
        ("TAB" . company-indent-or-complete-common)))

(use-package verilog-ts-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.s?vh?\\'" . verilog-ts-mode)))

(use-package emacs
  :init
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (java "https://github.com/tree-sitter/tree-sitter-java")
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (typst "https://github.com/uben0/tree-sitter-typst")))
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
  (setq major-mode-remap-alist '((c++-mode . c++-ts-mode)
                                 (python-mode . python-ts-mode)
                                 (c-mode . c-ts-mode)
                                 (java-mode . java-ts-mode))))

(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '(verilog-ts-mode . ("verible-verilog-ls")))
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist")))
  (setq eglot-events-buffer-size 0)
  (fset #'jsonrpc--log-event #'ignore)
  (setq eglot-ignored-server-capabilites '((:inlayHintProvider
                                            :didChangeWorkspaceFolders)))
  (add-hook 'c-ts-mode-hook 'eglot-ensure)
  (add-hook 'c++-ts-mode-hook 'eglot-ensure)
  (add-hook 'python-ts-mode-hook 'eglot-ensure)
  (add-hook 'java-ts-mode-hook 'eglot-ensure)
  (add-hook 'verilog-ts-mode-hook 'eglot-ensure)
  (add-hook 'rust-ts-mode-hook 'eglot-ensure)
  (add-hook 'typst-ts-mode-hook 'eglot-ensure))

(use-package eat
  :ensure t
  :config
  (setq eat-kill-buffer-on-exit t)
  :hook (eat-mode . (lambda ()
                      (company-mode -1))))

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
            "http://fedoraplanet.org/rss20.xml"
            "https://hackaday.com/feed"
            "https://inside.java/feed.xml"
            "https://hackaday.com/feed/"
            "https://calnewport.com/blog/feed/"
            "https://xkcd.com/atom.xml")))

;; --------------------------------------------------------------------------
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;; --------------------------------------------------------------------------
(global-set-key (kbd "C-x k") #'(lambda() (interactive)
                                  (kill-buffer (current-buffer))))

(global-set-key (kbd "C-x t") #'eat)

(global-set-key (kbd "C-x p") #'eat-send-password)

(global-set-key (kbd "C-x e") #'(lambda() (interactive)
                                  (flymake-show-buffer-diagnostics)))

(setq native-comp-async-report-warnings-errors nil)
