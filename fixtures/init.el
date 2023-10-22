;;; init.el --- Emacs configuration

;;; Commentary:

;; This is my Emacs configuration file.  It sets up various
;; preferences, packages, and keybindings.

;; This is a second paragraph.

;;; Code:

;;;; Package

;;;;; Initialize package manager

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; This is a sample sentence including `inline-code'.

;;;;; Install and configure `use-package' for managing packages

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;;; Basic UI and keybindings

(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1) ;sample comment
(menu-bar-mode -1)
(column-number-mode 1)

(global-hl-line-mode 1) ;sample comment 1
                        ;sample comment 2

;;;; Font

(set-face-attribute 'default nil :font "DejaVu Sans Mono-11")

;;;; Theme

(use-package dracula-theme
  :config
  (load-theme 'dracula t))

;;;; Hooks

(add-hook 'prog-mode-hook #'prettify-symbols-mode)

;;;; Finalize and run

(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)

;;; init.el ends here
