
(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)   ;Disable the toolbar
(tooltip-mode -1)    ;Disable the tool tips
(set-fringe-mode 10) ;Adds padding?
(menu-bar-mode -1)   ;Disable top menu

;; y or n instead of yes-or no
(fset 'yes-or-no-p 'y-or-n-p)

;;Enable visible bell rather than audio bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono")

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(term-mode-hook eshell-mode-hook shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(load-theme 'tango-dark) 

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Include manually installed packages
(add-to-list 'load-path "~/.emacs.d/lisp/")

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package move-text
  :config
  (move-text-default-bindings)
  )

(use-package nerd-icons)

(use-package helm
  :ensure t
  :config
    ;; Use C-c h instead of default C-x c, it makes more sense.
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))

    (setq
     ;; move to end or beginning of source when reaching top or bottom of source.
     helm-move-to-line-cycle-in-source t
     ;; search for library in `require' and `declare-function' sexp.
     helm-ff-search-library-in-sexp t
     ;; scroll 8 lines other window using M-<next>/M-<prior>
     helm-scroll-amount 8
     helm-ff-file-name-history-use-recentf t
     helm-echo-input-in-header-line t)

    (global-set-key (kbd "M-x") 'helm-M-x)
    (setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x

    (global-set-key (kbd "C-x C-f") 'helm-find-files)

    (global-set-key (kbd "M-y") 'helm-show-kill-ring)

    (global-set-key (kbd "C-x b") 'helm-mini)
    (setq helm-buffers-fuzzy-matching t
          helm-recentf-fuzzy-match t)

    ;; TOOD: helm-semantic has not syntax coloring! How can I fix that?
    (setq helm-semantic-fuzzy-match t
          helm-imenu-fuzzy-match t)

    ;; Lists all occurences of a pattern in buffer.
    (global-set-key (kbd "C-c h o") 'helm-occur)

    (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

    ;; open helm buffer inside current window, not occupy whole other window
    (setq helm-split-window-in-side-p t)
    (setq helm-autoresize-max-height 50)
    (setq helm-autoresize-min-height 30)
    (helm-autoresize-mode 1)

    (helm-mode 1)
    )

(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  ;;(doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  :config
  (load-theme 'doom-tokyo-night t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-icon t)
  (setq doom-modeline-percent-position '(-3 "%p"))
  (setq doom-modeline-position-column-line-format '("%l:%c"))
  (setq doom-modeline-major-mode-icon t)
  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package company
  :init (global-company-mode)
  :diminish global-company-mode
  :bind
  (("M-/" . company-complete-common-or-cycle))
  :config
  (setq company-idle-delay 0)
  )

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package projectile)

(use-package magit)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
