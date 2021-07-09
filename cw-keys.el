;;; cw-keys.el -*- lexical-binding: t; -*-

;;
(bind-key "TAB" #'indent-for-tab-command)
(bind-key "M-i" #'company-complete)
;; (define-key evil-insert-state-map "M-c" doom-leader-alt-key)

;; evil and comma keys
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
(define-key evil-motion-state-map "," 'nil) ; release ` for hydras
(define-key evil-normal-state-map "," 'nil) ; release ` for hydras
;; isearching on /
(define-key evil-normal-state-map (kbd "/") 'isearch-forward)
;; global
    ;; comma-ess
    ;; (evil-define-key 'normal ess-help-mode-map "\C-c\C-c"   'ess-eval-region-or-function-or-paragraph-and-step)
(evil-define-key 'normal ess-r-mode-map "\C-c\C-c"   'ess-eval-paragraph-and-step
  [(control return)] 'ess-eval-region-or-line-and-step
  "\C-c\M-j" 'ess-eval-line-and-go)
(evil-define-key 'normal ess-help-mode-map "\C-c\C-c"   'ess-eval-paragraph-and-step
  [(control return)] 'ess-eval-region-or-line-and-step
  "\C-c\M-j" 'ess-eval-line-and-go)

;; fix some defaults
(map! [remap switch-to-buffer] nil
      [remap find-file] nil
      [remap find-file] #'find-file-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; general

(setq doom-leader-key "SPC"
      ;; doom-localleader-key ","
      )

(map!
 ;; comma stuff
 :nmv "," nil ; release

;; I like my window map keys
 :map evil-window-map
 "v" 'toggle-window-split
 "4" 'toggle-window-split
      ;; ",j" #'dumb-jump-go
      ;; ",q" #'dumb-jump-quick-look
 ;; ",b" #'dumb-jump-back
 ;; :map evil-org-mode-map
 ;; :i "C-h" 'help

 :map emacs-lisp-mode-map
       :n ",e" 'eval-last-sexp
       :n ",f" 'eval-defun
       :n ",r" 'eval-region

       :map bibtex-mode-map
       :n ",k" #'bibtex-copy-key

      :map LaTeX-mode-map
      ;; :n ",," 'TeX-command-master
      :n ",="   'reftex-toc
      :n ",*"   'LaTeX-mark-section      ;; C-c *
      :nm ",."   'LaTeX-mark-environment  ;; C-c .
      :nm ",r" 'TeX-command-region
      :n ",s" 'LaTeX-section
      :n ",e" (lambda () (interactive) (LaTeX-environment()) (evil-append()))
      :n ",c"   'LaTeX-close-environment ;; C-c ]
      :n ",p" 'preview-buffer
      :n [(control return)] 'LaTeX-insert-item

      :map ess-r-mode-map
      :v ",," 'ess-eval-region-and-step
      :v ",r" 'ess-eval-region
    :n ",l" 'ess-eval-line-and-step
    ;; ",," 'ess-eval-paragraph-and-step
    :n ",f" 'ess-eval-function
    :n ",o" 'ess-roxy-update-entry
    :n ",p" 'ess-eval-function-or-paragraph-and-step
    ;; ",," 'ess-eval-function-or-paragraph-and-step
    :n ",s" 'ess-switch-process
    :n ",g" 'ess-switch-to-inferior-or-script-buffer
    ;;",vf" 'ess-mark-function-or-para
    :m "h" 'evil-backward-char
    :m "j" 'evil-next-visual-line
    :m "k" 'evil-previous-visual-line
    :m "l" 'evil-forward-char
    ;; :n "h" 'nil
    ;; :n "j" 'nil
    ;; :n "k" 'nil
    ; :n "l" 'nil
    [(control return)] 'ess-eval-region-or-line-and-step
    "\C-c\M-j" 'ess-eval-line-and-go

     :leader ; from now on
     :desc "smex" "SPC" 'smex
     "b b" 'switch-to-buffer
     "a a" 'org-agenda
     "s d" 'deadgrep)
;; (define-key evil-motion-state-map "`" nil) ; release ` for hydras
;; (define-key evil-normal-state-map "C-SPC" nil) ; release ` for hydras
;; (use-package! general)
  ;; (general-evil-setup t)
  ;; (general-def
    ;; :states '(normal motion emacs)
  ;;   "," nil)
  ;; (general-create-definer comma-def
  ;;   :prefix ","
  ;;   :states '(normal motion emacs))
  ;; (mmap
  ;;   "`" 'hydra-everything/body)
  ;; (comma-def
  ;;   ;; dumb-jump
  ;;   "j" 'dumb-jump-go
  ;;   "q" 'dumb-jump-quick-look
  ;;   "b" 'dumb-jump-back)
  ;; (comma-def
  ;;   :keymaps 'emacs-lisp-mode-map
  ;;   "e" 'eval-last-sexp
  ;;   "f" 'eval-defun
  ;;   "r" 'eval-region)
  ;; comma-org
  ;; comma-latex
  ;; (evil-define-key 'normal bibtex-mode-map ",k" 'bibtex-copy-key) ;; function defined below
  ;; (evil-define-key 'insert LaTeX-mode-map
  ;;   "T" (lambda () (interactive) (insert "T"))
  ;;   (kbd "C-<tab>") 'cdlatex-tab)
  ;; (evil-define-key 'normal LaTeX-mode-map
  ;;   ",," 'TeX-command-master
  ;;   ",="   'reftex-toc
  ;;   ",*"   'LaTeX-mark-section      ;; C-c *
  ;;   ",."   'LaTeX-mark-environment  ;; C-c .
  ;;   ",r" 'TeX-command-region
  ;;   ",s" 'LaTeX-section
  ;;   ",e" (lambda () (interactive) (LaTeX-environment()) (evil-append()))
  ;;   ",c"   'LaTeX-close-environment ;; C-c ]
  ;;   ",p" 'preview-buffer
  ;;   [(control return)] 'LaTeX-insert-item)


;; bind in motion state (inherited by the normal, visual, and operator states)
(general-define-key
 :states '(normal visual)
 :prefix "SPC"
 :non-normal-prefix "C-SPC"
   ;; (mmap ;; :states '(normal visual insert emacs)
   ;; :keymaps 'dired-mode-map
   ;; :prefix "SPC"
   "/"   'counsel-ag
   "<SPC>" 'smex

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ag" 'magit-status
   "ar" 'ranger
   "ad" 'dired

   ;; files and buffers
   "f" '(:ignore t :which-key "Files")
        "f1" (lambda () (interactive) (find-file "~/Dropbox/org/1.org"))
        "fA" (lambda () (interactive) (find-file "~/.config/awesome/rc.lua"))
        "fi" (lambda () (interactive) (find-file "~/.i3/config"))
        "fb" (lambda () (interactive) (find-file "~/genconfig/bash"))
        "fe" (lambda () (interactive) (find-file "~/genconfig/emacs"))
        ;; "ff" 'counsel-find-file
        "ff" 'find-file-at-point
        ;; "fh" 'helm-find-files
        "fj" 'hydra-jump/body
        "fk" (lambda () (interactive) (find-file "~/genconfig/cw-keys.el"))
        ;; "fo" (lambda () (interactive) (find-file "~/Dropbox/org"))
        "fo" 'deft
        "fh" 'helm-mini
        "fm" 'helm-mini
        ;; "fr" 'ido-recentf-open
        "fr" 'helm-recentf
        "fR" 'recover-this-file
        "fs"  (lambda () (interactive) (find-file "~/Dropbox/org/Meetings/Seminars.org"))
        "ft" (lambda () (interactive) (find-file "~/Dropbox/org/today.org"))
        "f4" (lambda () (interactive) (find-file "~/Dropbox/org/4projects.org"))
        "f2" (lambda () (interactive) (find-file "~/Dropbox/org/projects.org"))

        ;; "fb" 'hydra-bookmarks/body
        "b" '(:ignore t :which-key "Buffers/bookmarks")
        "bb" 'anything-buffers-list ;;switch-to-buffer
        "bh" 'helm-buffers-list
        "bk" 'kill-this-buffer
        "bl" 'list-buffers
        "bm" 'hydra-bookmarks/body
        "bo" (lambda () (interactive) (switch-to-buffer (other-buffer)))

        ;; "c" counsel
        "c" '(:ignore t :which-key "counsel")
        "ca" 'counsel-ag
        "cA" 'counsel-linux-app
        "cf" 'counsel-describe-function
        "ci" 'counsel-imenu
        "cv" 'counsel-describe-variable
        "cw" 'counsel-wmctrl
        ;; "cg" 'counsel-git
        ;; "cj" 'counsel-git-grep
        "cy" 'counsel-yank-pop
        "cl" 'counsel-locate
        ;; "co" 'counsel-rhythmbox

        ;; helm
        "h" '(:ignore t :which-key "helm")
        "hh" 'helm-mini
        "hm" 'helm-evil-markers
        "ha" 'helm-apropos
        "hb" 'helm-buffers-list
        "hf" 'helm-mini
        "hp" 'helm-projectile

        ;; imenu
        "i" '(:ignore t :which-key "Imenu")
        ;; "ii" 'ido-imenu-anywhere
        "im" 'popup-imenu
        ;; "ig" 'ivy-imenu-goto
        "il" 'imenu-list-smart-toggle
        "ii" 'helm-imenu
        "ic" 'counsel-imenu

        ;;
        "m" '(:ignore t :which-key "Markdown")
        "mc" 'markdown-insert-gfm-code-block
        "md" 'org-time-stamp

        ;; org
        "o" '(:ignore t :which-key "Org")
        "oa" 'air-pop-to-org-agenda
        "oc" 'counsel-org-capture
        "oj" 'org-journal-new-entry
        "oo" 'other-window

        ;; windows
        "w" '(:ignore t :which-key "Windows")
        "w0" 'delete-window
        ;; "w1" 'my-delete-frames-windows
        "w1" 'zygospore-toggle-delete-other-windows
        "w2" 'split-window-below
        "w3" 'split-window-right
        ;; "0" 'delete-window
        ;; "1" 'my-delete-frames-windows
        ;; "2" 'split-window-below
        ;; "3" 'split-window-right
        ;; "w4" (lambda  () (interactive) (ace-window 4))
        "wa" 'ace-window
        "wb" 'list-buffers
        "wh" 'windmove-left
        "wj" 'windmove-down
        "wk" 'windmove-up
        "wl" 'windmove-right
        "wi" #'imenu-list-smart-toggle
        "wn" 'neotree-toggle
        "wo" 'other-window
        "wr" 'writeroom-mode
        "ws" (lambda  () (interactive) (ace-window 4))
        "wv" 'toggle-window-split
        "w|" 'toggle-window-split
        "ww" 'other-window
        "w+" 'enlarge-window
        "w-" 'shrink-window
        ;; "w-" 'new-window-below
        ;; "ws" (lambda () (interactive) (ace-window 4)) ;"swap")
        ;; "w|" 'split-window-right

        "z" 'hydra-zoom/body
        "!" 'shell-pop)



(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)
(global-set-key "\M-/" 'comint-dynamic-complete-filename)
(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "s-j") 'windmove-up)
(global-set-key (kbd "s-k") 'windmove-down)

;; search and replace
(global-set-key [f6] 'query-replace)
(define-key esc-map [f6] 'query-replace-regexp)
;; kbd-macros
(global-set-key [f2] 'start-kbd-macro)
(global-set-key [f3] 'end-kbd-macro)
(global-set-key [f4] 'call-last-kbd-macro)
(define-key esc-map [f2] 'start-generating)
(define-key esc-map [f3] 'stop-generating)
(define-key esc-map [f4] 'expand-macro)
(global-set-key [f5] 'kill-this-buffer)
(global-set-key [M-f5] 'revert-buffer)
(global-set-key [C-f5] 'revert-buffer)
;; isearch/replace
;(global-set-key [f6] 'isearch-forward)
;(define-key esc-map [f6] 'isearch-forward-regexp)
                                        ;(define-key isearch-mode-map [f6] 'isearch-repeat-forward)

;; surrounding
;; ysiw' word     yss' line    cs' change  ds' delete
;; (use-package evil-surround
;;   :ensure t
;;   :config
;;   (global-evil-surround-mode 1))
;; goto-line
(global-set-key [f8] 'goto-line)
(define-key esc-map [f8] 'align)
;; esc-f8 is neotree-toggle
;; ispell
(global-set-key [f9] 'ispell-word)
(global-set-key [C-f9] 'ispell-buffer)


;; fill or unfill
(defun cw/fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'cw/fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively 'fill-paragraph)))
(global-set-key [remap fill-paragraph] 'cw/fill-or-unfill)

;; wheel mouse
(defun up-slightly ()
  (interactive)
  (scroll-up 3))
(defun down-slightly ()
  (interactive)
  (scroll-down 3))
(defun up-slightly-other ()
  (interactive)
  (scroll-other-window 3))
(defun down-slightly-other ()
  (interactive)
  (scroll-other-window-down 3))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
(global-set-key  [M-mouse-4] 'down-slightly-other)
(global-set-key  [M-mouse-5] 'up-slightly-other)

;;use page up/down in minibuffer
(global-set-key [minibuffer-local-map up]   'previous-history-element)
(global-set-key [minibuffer-local-map down] 'next-history-element)

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behaviour.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

(global-set-key "\C-x\ \C-t" 'toggle-truncate-lines)
                                        ;(global-set-key "\C-o" 'ace-window)
(global-set-key "\C-o" 'other-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; bubble lines
;; Line Bubble Functions
(defun move-line-up ()
  "move the current line up one line"
  (interactive)
  (transpose-lines 1)
  (previous-line 2))
(defun move-line-down ()
  "move the current line down one line"
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))
(defun evil-move-lines (direction)
  "move selected lines up or down"
  (interactive)
  (evil-delete (region-beginning) (region-end))
  (evil-normal-state)
  (if (equal direction "up")
    (evil-previous-line)
    (evil-next-line))
  (evil-move-beginning-of-line)
  (evil-paste-before 1)
  (evil-visual-line (point) (- (point) (- (region-end) (region-beginning)))))
(defun evil-move-lines-up ()
  "move selected lines up one line"
  (interactive)
  (evil-move-lines "up"))
(defun evil-move-lines-down ()
  "move selected lines down one line"
  (interactive)
  (evil-move-lines "down"))
(map! :n "C-k" 'move-line-up
      :n "C-j" 'move-line-down
      :v "C-k" 'evil-move-lines-up
      :v "C-j" 'evil-move-lines-down)



;; (define-key evil-normal-state-map (kbd "C-k") 'move-line-up)
;; (define-key evil-normal-state-map (kbd "C-j") 'move-line-down)
;; (define-key evil-visual-state-map (kbd "C-k") 'evil-move-lines-up)
;; (define-key evil-visual-state-map (kbd "C-j") 'evil-move-lines-down)
;; (define-key minibuffer-inactive-mode-map (kbd "C-k") 'kill-line)
;; (define-key minibuffer-local-map (kbd "C-k") 'kill-line)
;; (map! :map minibuffer-local-map
;;       :i "C-k" 'kill-line)

(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)

        "ws"(select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x |") 'toggle-window-split)
