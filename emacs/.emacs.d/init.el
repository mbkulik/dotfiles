;;
;; Michael B. Kulik
;; custom emacs file
;;

;; start as a server
(server-start)

;; disable menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0)

(global-linum-mode t)

;; stop splash screen from showing
(setq inhibit-splash-screen t)

;; disable version control
(setq vc-handled-backends ())

;; better auto indentation
(electric-indent-mode)

;;ido mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-match t)
(setq ido-create-new-buffer 'always)

;; GUI Only Stuff
(if window-system (load-theme 'tango-dark))
(if window-system (tool-bar-mode -1))

;; Text Only Stuff
(if (not window-system) (setq frame-background-mode 'dark))
(if (not window-system) (set-face-foreground 'minibuffer-prompt "white"))

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

(add-hook 'doc-view-mode-hook 'auto-revert-mode)`

;; spell check in tex mode
(add-hook 'tex-mode-hook
          #'(lambda () (setq ispell-parser 'tex)))

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; whitespace highlighting
(require 'whitespace)
(setq whitespace-line-column 80)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'latex-mode-hook 'whitespace-mode)

;; install and autoload emacs packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("elpy" . "https://jorgenschaefer.github.io/packages/")))

(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;;;markdown-mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc -f markdown_github -t html5 -s --css ~/lib/pandoc.css"))

;;;elpy
(use-package elpy
  :ensure t)

(elpy-enable)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-rpc-python-command "python3")
 '(python-shell-extra-pythonpaths (quote ("~/.local/lib/python35/site-packages")))
 '(python-shell-interpreter "python3"))

;;;writegood-mode
(use-package writegood-mode
  :ensure t
  :bind ("C-c g" . writegood-mode))
