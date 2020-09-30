;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Chris Wallace"
      user-mail-address "cew54@cam.ac.uk")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq ;doom-font (font-spec :family "inconsolata" :size 16)
      ;; doom-font (font-spec :family "Hack" :size 14)
      doom-font (font-spec :family "SourceCodePro" :size 15)
      ;; doom-font (font-spec :family "OfficeCodePro" :size 15)
      doom-variable-pitch-font (font-spec :family "sans" :size 15)
      line-spacing 0.25
      line-height 1.25
      next-line-add-newlines nil ; no blank lines and end of buffer
      require-final-newline t    ; Always end a file with a newline
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      tab-always-indent t
)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-opera)
(require 'darkburn-theme)
(setq doom-theme 'darkburn)
;; (setq doom-theme 'doom-gruvbox)
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic)
;;   '(font-lock-keyword-face :slant italic))
(mood-line-mode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(menu-bar-mode 't)

;; turn off projectile slowness
(setq projectile-track-known-projects-automatically nil)
(setq projectile-file-exists-remote-cache-expire 86400) ;; make remote caching last 24 hours
(projectile-mode -1)

(defun my-workspace-buffer-list (&optional persp)
  (unless persp
    (setq persp (get-current-persp)))
  (if (eq persp t)
      (cl-remove-if #'persp--buffer-in-persps (buffer-list))
    (when (stringp persp)
      (setq persp (+workspace-get persp t)))
    (cl-loop for buf in (buffer-list)
             if (persp-contain-buffer-p buf persp)
             collect buf)))
(advice-add #'+workspace-buffer-list :override #'my-workspace-buffer-list)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; make evil nice
(after! evil
  (evil-commentary-mode)
    (setq-default evil-cross-lines t
                  evil-move-cursor-back nil ; don#t jump back after existing insert
                  evil-want-fine-undo t
                  evil-want-C-w-delete nil
                  evil-want-C-i-jump nil) ; emacs TAB wins
    (define-key key-translation-map (kbd ",,") (kbd "C-c C-c"))
    (advice-remove #'evil-visual-update-x-selection #'ignore) ; I use x-selection a lot!
  )

;; I don't use snipe, and it interferes with comma as local leader
(after! evil-snipe
  (evil-snipe-mode -1))

;; doom annoyances - use M-j to break line and continue comment when I want to
(setq comment-line-break-function nil)

;; sometimes we want emacs state
;; (dolist (mode
;;          '('org-agenda-mode
;;            'dired-mode))
;;   (evil-set-initial-state mode 'emacs))
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'org-agenda-mode 'emacs)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keys

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
(define-key global-map [remap switch-to-buffer] nil)
;; (define-key evil-org-mode-map :i nil)
(define-key global-map [remap find-file] nil)
(define-key global-map [remap find-file] #'find-file-at-point)

;; key keys
;; (define-key evil-motion-state-map "`" 'evil-goto-mark) ; release ` for hydras
;; this is how to map leader keys in doom
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
     "a a" 'org-agenda)

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
  (evil-define-key 'insert LaTeX-mode-map
    "T" (lambda () (interactive) (insert "T"))
    (kbd "C-<tab>") 'cdlatex-tab)
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


;; some nice functions

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
(define-key evil-normal-state-map (kbd "C-k") 'move-line-up)
(define-key evil-normal-state-map (kbd "C-j") 'move-line-down)
(define-key evil-visual-state-map (kbd "C-k") 'evil-move-lines-up)
(define-key evil-visual-state-map (kbd "C-j") 'evil-move-lines-down)

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
        "fa" (lambda () (interactive) (find-file "~/.config/awesome/rc.lua"))
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
        "f4" (lambda () (interactive) (find-file "~/Dropbox/org/42.org"))

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
;; perl
;;(global-set-key [f10] 'run-perl)
;;(global-set-key [(shift f10)] 'debug-perl)
;; align/cite
                                        ;(global-set-key [C-f11] 'reftex-cite-txt)  ;; see cw-latex for defun
;; remember
;;(global-set-key [f12] 'remember)
;;(global-set-key [C-f12] 'remember-region)
;; (global-set-key [f12] 'neotree-toggle)
                                        ;(define-key esc-map [f12] 'minimap-toggle)

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

;; (with-library which-key
;;   (which-key-mode)
;;   (which-key-setup-side-window-right-bottom))
(defun block-surround-r ()
  (interactive)
  (save-excursion
    (goto-char (region-beginning))
    (insert "```{r}\n"))
  (goto-char (region-end))
  (insert "\n```"))
(defun block-insert-r ()
  "insert ```{r} ... ```"
  (interactive)
  (beginning-of-line)
  (insert "```{r}\n\n```")
  (forward-line -1))
(defun block-insert-sh ()
  "insert ```{sh} ... ```"
  (interactive)
  (beginning-of-line)
  (insert "```{sh}\n\n```")
  (forward-line -1))



;; ;; (with-library key-chord
;;   (key-chord-mode 1)
;;   (setq key-chord-two-keys-delay 0.5)
;;   ;(key-chord-define-global "xx" 'smex)
;; ;(key-chord-define-global "ww" 'hydra-everything/body)
;; ; (key-chord-define-global "`w" 'hydra-everything/body)
;; ; (key-chord-define-global "hh" 'hydra-helm/body)
;; ;  (key-chord-define-global "cx" 'Control-X-prefix)
;;   (key-chord-define-global "`r" 'block-insert-r)
;;   (key-chord-define-global "`s" 'block-insert-sh)) ;; TODO make this a hydra

;; (with-library multiple-cursors
;;   (global-set-key (kbd "C-c SPC") 'mc/edit-lines)
;;   ;; When you want to add multiple cursors not based on continuous lines, but based on keywords in the buffer, use:
;;   (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;   (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;   (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

;; (with-library drag-stuff
;;   (drag-stuff-global-mode 1)
;;   (setq drag-stuff-modifier '(meta)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; (require 'snakemake-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; emacs speaks stats
(defun Rcsd3 ()
  "Run R on CSD3 using the R.darwin script"
  (interactive)
  (let ((inferior-ess-r-program "/home/cew54/bin/R.csd3")
        ;; (ess-etc-directory "/ssh:csd3:/home/cew54/.ess/etc")
        ;; (default-directory "/ssh:cew54@csd3:~/"))
        ;; (ess-directory "/ssh:csd3:~/")
        )
    (R)))

(use-package! ess)
;; (add-to-list 'tramp-remote-path "~/bin")
(use-package! ess-r-mode
  :after ess
  :init
  (setq ess-eval-visibly-p 'nowait) ;; no waiting while ess evalating
  (setq-hook! 'ess-r-mode-hook comment-line-break-function nil) ;; use native ess comment breaking
  ;; (evil-set-initial-state 'ess-help-mode 'normal)
  (eval-after-load "comint"
    '(progn
       ;; The following makes the up/down keys behave like typical
       ;; console windows: for cycling through previous commands
       (define-key comint-mode-map [up]
         'comint-previous-matching-input-from-input)
       (define-key comint-mode-map [down]
         'comint-next-matching-input-from-input)

       ;; Make C-left and A-left skip the R prompt at the beginning of
       ;; line
       (define-key comint-mode-map [A-left] 'comint-bol)
       (define-key comint-mode-map [C-left] 'left-word)

       ;; This ensures that the R process window scrolls automatically
       ;; when new output appears (otherwise you're scrolling manually
       ;; all the time).
       (setq comint-scroll-to-bottom-on-output 'others
             comint-scroll-show-maximum-output t
             comint-prompt-read-only nil))))

(use-package! key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-one-keys-delay 0.02
        key-chord-two-keys-delay 0.03))

(after! (key-chord ess-r-mode)
  (key-chord-define-global ">>" "%>%")
  (key-chord-define-global "<>" "%<>%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode

;; undo doom changes
(after! evil-org
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h)
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h))
;; speed things up
(setq display-line-numbers-type nil)
(after! org
   (remove-hook 'org-mode-hook #'org-superstar-mode)
   (setq org-fontify-quote-and-verse-blocks nil
         org-fontify-whole-heading-line t
         org-adapt-indentation nil
         org-hide-leading-stars nil
         org-startup-indented nil)
   (setq org-todo-keywords
         '((sequence
            "TODO(t)"  ; A task that needs doing & is ready to do
            "STRT(s)"  ; A task that is in progress
            "WAIT(w)"  ; Something external is holding up this task
            "HOLD(h)"  ; This task is paused/on hold because of me
            "|"
            "DONE(d)"  ; Task successfully completed
            "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
           (sequence "PROJ" "COLLAB" "ADMIN" "STUDENTS") ;; my headings that I fake as TODOs
           ))
   (setq org-todo-keyword-faces
         '(("STRT" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("COLLAB" . +org-todo-project)
          ("PROJ" . +org-todo-project)
          ("ADMIN" . +org-todo-project))))

;; (bind-key “TAB” #’indent-for-tab-command)
;; (bind-key “M-i” #’company-complete)

;; inline tasks
(require 'org-inlinetask)

;; agenda
(require 'org-agenda)
(after! org-agenda
  (add-hook 'org-agenda-mode-hook '(lambda ()
                                     (set-face-background 'hl-line "#336")
                                     (hl-line-mode 1))) ;; make current line clear
  (setq org-agenda-custom-commands
        '(("1" todo "PROJ|COLLAB|ADMIN"
           ((org-agenda-files '("~/Dropbox/org/2.org"))))
          ("2" todo "PROJ|COLLAB|ADMIN|TODO"
           ((org-agenda-files '("~/Dropbox/org/2.org"))))))
  (setq org-agenda-dim-blocked-tasks nil ;; faster
        org-agenda-start-with-follow-mode t) ;; nicer
  ;; (setq org-log-note-headings
  ;;        '((done .  "CLOSING NOTE %t")
  ;;     (state . "State %-12s from %-12S %t")
  ;;     (note .  "Note %t")
  ;;     (reschedule .  "Rescheduled from %S on %t")
  ;;     (delschedule .  "Not scheduled, was %S on %t")
  ;;     (redeadline .  "New deadline from %S on %t")
  ;;     (deldeadline .  "Removed deadline, was %S on %t")
  ;;     (refile . "Refiled on %t")
  ;;     (clock-out . "")))

  (defun my/agenda-heading ()
    (let ((annotation (org-link-display-format (plist-get org-capture-plist :annotation))))
      (set-text-properties 0 (length annotation) nil annotation)
      annotation))

  (setq org-capture-templates
        ;; why won't this work?
        ;; '(("k" "Project note" entry
        ;;  (file+headline  "~/Dropbox/org/2.org" %((my/agenda-heading)))
        ;;  "** UPDATE %U\n%?\n" :prepend t)
        '(("T" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)
          ("u" "Project update" plain
           (function
            (lambda ()
              (let ((filename "/home/chrisw/Dropbox/org/2.org")
                    ;; (annotation (format "%s" (plist-get org-capture-plist :annotation)))
                    (annotation (org-link-display-format (plist-get org-capture-plist :annotation))))
                (set-text-properties 0 (length annotation) nil annotation)
                (set-buffer (find-file-noselect filename))
                (goto-char (point-min))
                (search-forward annotation)
                (forward-line)
                (beginning-of-line)
                (insert "\n"))))
           "** UPDATE %? %u\n\n")
          ("t" "Project todo" plain
           (function
            (lambda ()
              (let ((filename "/home/chrisw/Dropbox/org/2.org")
                    ;; (annotation (format "%s" (plist-get org-capture-plist :annotation)))
                    (annotation (org-link-display-format (plist-get org-capture-plist :annotation))))
                (set-text-properties 0 (length annotation) nil annotation)
                (set-buffer (find-file-noselect filename))
                (goto-char (point-min))
                (search-forward annotation)
                (forward-line)
                (beginning-of-line)
                (insert "\n"))))
           "** TODO %?\nAdded %u\n"))))
  ;; ("p" "Templates for projects")
  ;; ("pt" "Project-local todo" entry
  ;;  (file+headline +org-capture-project-todo-file "Inbox")
  ;;  "* TODO %?\n%i\n%a" :prepend t)
  ;; ("pn" "Project-local notes" entry
  ;;  (file+headline +org-capture-project-notes-file "Inbox")
  ;;  "* %U %?\n%i\n%a" :prepend t)
  ;; ("pc" "Project-local changelog" entry
  ;;  (file+headline +org-capture-project-changelog-file "Unreleased")
  ;;  "* %U %?\n%i\n%a" :prepend t)
  ;; ("o" "Centralized templates for projects")
  ;; ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
  ;; ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
  ;; ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

;; (defun my-org-mode-before-save-hook ()
;;   (when (eq major-mode 'org-mode)
;;     (goto-char (point-min))
;;     (while (search-forward-regexp "^ +- **" nil t)
;;       (replace-match ""))))
;; (add-hook 'before-save-hook #'my-org-mode-before-save-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; visuals

;; (use-package mixed-pitch
;;   :hook
;;   ;; If you want it in all text modes:
;;   (text-mode . mixed-pitch-mode)) ;; or org-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (define-derived-mode rakefile-mode ruby-mode "Rakefile"
    "Major mode for editing Rakefiles"
    (setq-local imenu-create-index-function 'rakefile-imenu-create-index))

  (defun rakefile-imenu-create-index ()
    (let ((default-directory (file-name-directory buffer-file-name))
          (rakefile-path (file-name-nondirectory (buffer-file-name)))
          (index-alist '()))

      (with-temp-buffer
        (rvm-activate-ruby-for default-directory)
        (insert (shell-command-to-string (concat "bundle exec rake -f " rakefile-path " -W")))
        (goto-char (point-min))

        (save-excursion (while (re-search-forward
                                ;; giant regex to match task name and line number
                                (concat
                                 "^.*rake \\([[:alnum:][:punct:]]+\\)[[:space:]]*"
                                 default-directory
                                 "Rakefile:\\([[:digit:]]+\\):.*$")
                                nil t)
                          (push (cons (match-string 1) (string-to-number (match-string 2))) index-alist)))
        index-alist)

      (--each index-alist
        (save-excursion
          (goto-char (point-min))
          (forward-line (- (cdr it) 1))
          (setcdr it (point))))
      index-alist))

  (add-to-list 'auto-mode-alist '("Rakefile$" . rakefile-mode))

;; * MakingScriptsExecutableOnSave
;; Check for shebang magic in file after save, make executable if found.
(setq my-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
            "^#!/usr/.*/sh"
            "^#!/usr/.*/bash"
            "^#!/.*/Rscript"
            "^#!/usr/bin/env"
            "^#!/bin/sh"
            "^#!/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
   (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
       (progn
         ;; This puts message in *Message* twice, but minibuffer
         ;; output looks better.
         (message (concat "Wrote " (buffer-file-name)))
         (save-excursion
           (goto-char (point-min))
           ;; Always checks every pattern even after
           ;; match.  Inefficient but easy.
           (dolist (my-shebang-pat my-shebang-patterns)
             (if (looking-at my-shebang-pat)
                 (if (= (shell-command
                         (concat "chmod u+x " (buffer-file-name)))
                        0)
                     (message (concat
                               "Wrote and made executable "
                               (buffer-file-name))))))))
     ;; This puts message in *Message* twice, but minibuffer output
     ;; looks better.
     (message (concat "Wrote " (buffer-file-name))))))
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; highlights FIXME: TODO: and BUG: in prog-mode
(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(HERE\\|FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(global-hl-line-mode 1)
(setq evil-complete-next-func 'hippie-expand)
