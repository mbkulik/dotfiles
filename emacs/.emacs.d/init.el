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
(set-frame-font "Monospace 11" nil t)
(set-background-color "#FFFFEE")


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

;; inhibit custom stuff being added to init.el
(setq custom-file (concat user-emacs-directory "/custom.el"))

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq tab-width 4)

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")

;; spell check in tex mode
(add-hook 'tex-mode-hook
          #'(lambda () (setq ispell-parser 'tex)))

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

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
;;; Markdown Mode
;;;
;;; ---------------------------------------------------------------------------
(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;;;--------------------------------------------------------------------------
;;;
;;; elpy
;;;
;;;--------------------------------------------------------------------------
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (setq python-shell-interpreter "python3")
  (setq elpy-rpc-python-command "python3"))

;;; --------------------------------------------------------------------------
;;;
;;; writegood-mode
;;;
;;; --------------------------------------------------------------------------
(use-package writegood-mode
  :ensure t
  :defer t
  :bind ("C-c g" . writegood-mode))

;;;
;;;
;;; disable-mouse
;;;
;;;
(use-package disable-mouse
  :ensure t
  :init
  (global-disable-mouse-mode))


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
          "http://calnewport.com/blog/feed/"
          "https://xkcd.com/rss.xml"
          "http://fedoraplanet.org/rss20.xml"
          "http://planet.gnome.org/rss20.xml"
          "https://www.phoronix.com/rss.php"
          "https://gflint.wordpress.com/feed/"
          "https://cestlaz.github.io/rss.xml"
          "http://innovativeteacher.org/feed/"
          "https://codinginmathclass.wordpress.com/feed/"
          "https://setanothergoal.blogspot.com/feeds/posts/default"
          "https://medium.com/feed/bits-and-behavior"
          "http://blog.acthompson.net/feeds/posts/default"
          "https://computinged.wordpress.com/feed/"
          "https://talospace.com/feeds/posts/default"
          "https://blogs.gnome.org/shell-dev/rss")))

(defun todo()
  (interactive)
  (switch-to-buffer "*scratch*")
  (find-file "~/Documents/TODO.md"))

(global-set-key (kbd "C-x t") 'todo)

(defun insert-date ()
  (interactive)
  (insert "**")
  (insert (format-time-string "%m-%d-%Y"))
  (insert "** "))

(global-set-key (kbd "C-x d") 'insert-date)

;;
;;http://pragmaticemacs.com/emacs/dont-kill-buffer-kill-this-buffer-instead/
;;
(defun mbk/kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'mbk/kill-this-buffer)
