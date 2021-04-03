(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))

;; ----- Install packages ----- ;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

(defun install-packages (packages)
  (let ((refreshed nil))
    (dolist (pack packages)
      (unless (package-installed-p pack)
        (unless refreshed
          (package-refresh-contents)
          (setq refreshed t))
        (package-install pack)))))

(install-packages '(magit
                    markdown-mode
                    smex
                    projectile
                    leaf))

;; ----- keybind ----- ;;

(mapc #'(lambda (pair)
          (global-set-key (kbd (car pair)) (cdr pair)))
      '(("M-g"  . goto-line)
        ("C-h"  . delete-backward-char)
        ("C-z"  . nil)
        ("C-_"  . undo)
        ("C-\\" . undo)
        ("C-o"  . nil)
        ("M-*"  . pop-tag-mark)
        ("C-x ;" . comment-region)
        ("C-x :" . uncomment-region)
        ("C-x C-i"   . indent-region)
        ("M-o" . other-window)))

;; ----- Environment ----- ;;

(setq scroll-conservatively 1)
(set-face-foreground 'font-lock-comment-face "#ee0909")
(show-paren-mode t)

(leaf ido
  :config
  (ido-mode t)
  (ido-everywhere t)
  (setq ido-enable-flex-matching t))

(leaf smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))

;; -- -- ;;

;; mode-line
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
(which-function-mode 1)

;; backup
(setq delete-auto-save-files t)
(setq backup-inhibited t)

;; use space instead of tab
(setq-default indent-tabs-mode nil)

;; dired
(defvar my-dired-before-buffer nil)
(defadvice dired-up-directory
    (before kill-up-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-up-directory
    (after kill-up-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

(setq dired-listing-switches "-lXa")

;; others

;; swap windows (only for 2 windows case)
(defun swap-windows ()
  (interactive)
  (let ((cur-buf (current-buffer)))
    (other-window 1)
    (let ((next-buf (current-buffer)))
      (switch-to-buffer cur-buf)
      (other-window 1)
      (switch-to-buffer next-buf)
      (other-window 1))))

(global-set-key (kbd "C-c s w") 'swap-windows)

(setq shell-file-name "/bin/bash")
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)

;; ----- Other libraries ----- ;;

;; display the directory name of the file when files that have a same name are opened
(leaf uniquify
  :custom ((uniquify-buffer-name-style . 'post-forward-angle-brackets)))

;; ----- Rust ----- ;;

(install-packages '(rust-mode
                    lsp-mode
                    lsp-ui
                    cargo
                    company))

(add-to-list 'exec-path (expand-file-name "/root/.cargo/bin"))
(add-to-list 'exec-path (expand-file-name "/usr/local/cargo/bin"))

(leaf rust-mode
  :custom ((rust-format-on-save . t)))

(leaf cargo
  :hook ((rust-mode-hook . cargo-minor-mode)))

(leaf lsp-mode
  :hook ((rust-mode-hook . lsp))
  :bind (("C-c h" . lsp-describe-thing-at-point))
  :custom ((lsp-rust-server 'rust-analyzer)))

;; --- projectile --- ;;

(leaf projectile
  ;; TODO: Try the following settigns for newer version of leaf
  ;; :bind-keymap
  ;; ("C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; --------------------- ;;
;; --- auto settings --- ;;
;; --------------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-merge-arguments (quote ("--no-ff")))
 '(package-selected-packages
   (quote
    (projectile leaf wgrep smex w3m paredit markdown-mode magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
