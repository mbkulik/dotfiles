;;
;; Michael B. Kulik
;; custom emacs file
;;

;; start as a server
;;(server-start)
(require 'server)
(unless (server-running-p)
  (server-start))


;; install and autoload emacs packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

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

(setq custom-safe-themes t)
(menu-bar-mode -1) ;; disable menubar
(tool-bar-mode -1) ;; disable toolbar
(scroll-bar-mode 0)
;;(global-linum-mode t) ;;enable global line numbers
(setq inhibit-splash-screen t) ;;disable splash screen
(setq initial-scratch-message nil) ;;blank scratch buffer
(load-theme 'tango)
(set-background-color "#FFFFDD")

;; disable version control
(setq vc-handled-backends ())

;; better auto indentation
(electric-indent-mode)

;;ido mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-match t)
(setq ido-create-new-buffer 'always)

;; set backup and autosave to temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq tab-width 4)

;; key bindings
(global-set-key (kbd "<C-backspace>") 'kill-this-buffer)
(global-set-key (kbd "<f3>") 'compile)
(setq compilation-read-command nil)


;; spell check in tex mode
(add-hook 'tex-mode-hook
          #'(lambda () (setq ispell-parser 'tex)))

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; disable linenumbers when in eww
(add-hook 'eww-mode-hook (lambda () (linum-mode 0)))

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
;;; markdown-mode
;;;
;;; ---------------------------------------------------------------------------
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc -f markdown_github -t html5 -s --css ~/lib/pandoc.css --self-contained"))


;;; ---------------------------------------------------------------------------
;;;
;;; elpy
;;;
;;; ---------------------------------------------------------------------------
(use-package elpy
  :ensure t
  :config
  (elpy-enable))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-rpc-python-command "python3")
 '(elpy-syntax-check-command "~/.local/bin/flake8")
 '(package-selected-packages
   (quote
    (elfeed writegood-mode elpy markdown-mode use-package)))
 '(python-shell-extra-pythonpaths (quote ("~/.local/lib/python35/site-packages")))
 '(python-shell-interpreter "python3"))


;;; --------------------------------------------------------------------------
;;;
;;; writegood-mode
;;;
;;; --------------------------------------------------------------------------
(use-package writegood-mode
  :ensure t
  :bind ("C-c g" . writegood-mode))
