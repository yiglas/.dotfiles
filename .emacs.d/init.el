(setq inhibit-startup-message t)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

(recentf-mode 1)

;; Save what you entered into the mini-buffer prompt
(setq history-length  25)
(savehist-mode 1)

;; Remember and restore the last cursor location of opened file
(save-place-mode 1)

;; Move customized variables to a seperate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; Don't popup UI dialog when prompting
(setq use-dialog-box nil)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Revert dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Set transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 50))
(add-to-list 'default-frame-alist '(alpha . (90 . 50)))

;; Set theme
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(load-theme 'nord t)
