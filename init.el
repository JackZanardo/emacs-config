;;; init.el --- Personal Emacs configuration  -*- lexical-binding: t; -*-
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

(set-face-attribute 'default nil :font "GoMono Nerd Font Mono")
;; Set the line number type to relative
(setq-default display-line-numbers-type 'relative)

(column-number-mode)
;; Enable line numbers globally across all programming and text modes
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
(add-to-list 'load-path "~/.config/emacs/lisp/")

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
  (global-set-key (kbd "C-x C-g") 'helm-do-grep-ag)

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
  (setq helm-completion-style 'emacs)
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
  (load-theme 'doom-solarized-dark-high-contrast t)

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

(use-package yasnippet)

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (bash-ts-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (csharp-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq gc-cons-threshold (* 100 1024 1024)
	read-process-output-max (* 1024 1024)
	treemacs-space-between-root-nodes nil
	company-idle-delay 0.0
        company-minimum-prefix-length 1
	lsp-idle-delay 0.1)  ;; clangd is fast
  )

(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode))

(use-package elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode))
;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp
  :commands helm-lsp-workspace-symbol
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; Automatically open the full 6-pane IDE dashboard on M-x gdb
(setq gdb-many-windows t)

;; Show the source code of the main function immediately upon starting
(setq gdb-show-main t)

;; optionally if you want to use debugger
(use-package dap-mode

  :config
  ;; (use-package dap-LANGUAGE) to load the dap adapter for your language
  (dap-mode 1)

  ;; The modes below are optional

  (dap-ui-mode 1)
  ;; enables mouse hover support
  (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode 1)
  ;; displays floating panel with debug buttons
  ;; requies emacs 26+
  (dap-ui-controls-mode 0)
  )

(with-eval-after-load 'lsp-mode
  (require 'dap-cpptools)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

(use-package projectile)

(use-package magit)

;; `fzf`
(use-package fzf-native
  :vc (:url "https://github.com/dangduc/fzf-native" :rev :newest))

(use-package fussy
  :ensure t
  :config
  (fussy-setup-fzf)
  (fussy-company-setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company dap-mode doom-modeline doom-themes elisp-autofmt flycheck
	     fussy helm helm-ag helm-lsp lsp-mode lsp-treemacs lsp-ui
	     magit move-text nerd-icons projectile rainbow-delimiters
	     yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
