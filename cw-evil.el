;;; cw-evil.el -*- lexical-binding: t; -*-

(after! evil
(evil-set-undo-system 'undo-fu)
  (evil-commentary-mode)
;; make evil nice
    (setq-default evil-cross-lines t
                  evil-move-cursor-back nil ; don#t jump back after existing insert
                  evil-want-fine-undo t
                  evil-want-C-w-delete nil
                  evil-want-C-i-jump nil) ; emacs TAB wins
    (define-key key-translation-map (kbd ",,") (kbd "C-c C-c"))
    (advice-remove #'evil-visual-update-x-selection #'ignore) ; I use x-selection a lot!
    (require 'evil-textobj-anyblock)
  (evil-define-text-object my-evil-textobj-anyblock-inner-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count nil)))

  (evil-define-text-object my-evil-textobj-anyblock-a-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count t)))

  (define-key evil-inner-text-objects-map "q" 'my-evil-textobj-anyblock-inner-quote)
  (define-key evil-outer-text-objects-map "q" 'my-evil-textobj-anyblock-a-quote))

;; I don't use snipe, and it interferes with comma as local leader
(after! evil-snipe
  (evil-snipe-mode -1))
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'org-agenda-mode 'emacs)
