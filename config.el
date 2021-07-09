;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(load "~/.doom.d/info.el")
;; updated

(setq
      next-line-add-newlines nil ; no blank lines and end of buffer
      require-final-newline t    ; Always end a file with a newline
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      tab-always-indent t
      comment-line-break-function nil ; doom annoyances - use M-j to break line and continue comment when I want to
      rg-executable "rg"     ; rg.el
      display-line-numbers-type nil ; speed things up
 )
;; Patch up the evil-org key map, so that org is usable with daemon
;; https://github.com/hlissner/doom-emacs/issues/1897

;; try and fix TAB
(define-key input-decode-map [(control ?i)] [control-i])
(define-key input-decode-map [(control ?I)] [(shift control-i)])
(map! :map 'evil-motion-state-map "C-i" nil)
(define-key evil-motion-state-map [control-i] 'evil-jump-forward)
(after! org
  (map! :map org-mode-map
        :m [tab] 'org-cycle
        :m "TAB" 'org-cycle)
  (remove-hook 'org-tab-first-hook #'+org-indent-maybe-h))
(after! evil-org
  (evil-define-key '(normal visual input) evil-org-mode-map (kbd <tab>) 'org-cycle)
  (evil-define-key '(normal visual input) evil-org-mode-map (kbd "TAB") 'org-cycle))
;; (advice-remove #'switch-to-buffer #'doom-run-switch-buffer-hooks-a) ; I am really used to standard ordering
;; (advice-remove #'display-buffer #'doom-run-switch-buffer-hooks-a) ; I am really used to standard ordering
;; (advice-remove #'display-buffer #'ignore) ; I use x-selection a lot!
(after! core-ui
  (remove-hook 'kill-emacs-hook #'recentf-cleanup)
  (add-hook 'find-file-hook #'recentf-save-list)
  ;; (remove-hook 'buffer-list-update-hook #'doom-run-switch-window-hooks-h)
  ;; (remove-hook 'buffer-list-update-hook #'flycheck-handle-buffer-switch)
  (remove-hook 'buffer-list-update-hook #'doom-run-switch-window-hooks-h)
  (remove-hook 'doom-first-buffer-hook #'smartparens-global-mode) ; smartparens does my head in
  (setq helm-ff-cache-mode nil))


;; (after! ivy
;; ivy-done and ivy-immediate-done
;; )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; turn off projectile slowness
(setq projectile-track-known-projects-automatically nil)
(setq projectile-file-exists-remote-cache-expire 86400) ;; make remote caching last 24 hours
(projectile-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; essentials
(load "~/.doom.d/cw-evil.el")
(load "~/.doom.d/cw-keys.el")
(load "~/.doom.d/cw-keychord.el")
;; looks
(load "~/.doom.d/cw-looks.el")
;; modes
(load "~/.doom.d/cw-ess.el")
(load "~/.doom.d/cw-latex.el")
(load "~/.doom.d/cw-org.el")
(load "~/.doom.d/cw-rakefile.el")
(load "~/.doom.d/cw-shebang.el")
(load "~/.doom.d/cw-jekyll.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-hl-line-mode 1)
(setq evil-complete-next-func 'hippie-expand)

;; (defun my-workspace-buffer-list (&optional persp)
;;   (unless persp
;;     (setq persp (get-current-persp)))
;;   (if (eq persp t)
;;       (cl-remove-if #'persp--buffer-in-persps (buffer-list))
;;     (when (stringp persp)
;;       (setq persp (+workspace-get persp t)))
;;     (cl-loop for buf in (buffer-list)
;;              if (persp-contain-buffer-p buf persp)
;;              collect buf)))
;; (advice-add #'+workspace-buffer-list :override #'my-workspace-buffer-list)

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



;; sometimes we want emacs state
;; (dolist (mode
;;          '('org-agenda-mode
;;            'dired-mode))
;;   (evil-set-initial-state mode 'emacs))


;; (define-key global-map [remap switch-to-buffer] nil)
;; (define-key evil-org-mode-map :i nil)
;; (define-key global-map [remap find-file] nil)
;; (define-key global-map [remap find-file] #'find-file-at-point)

;; key keys
;; (define-key evil-motion-state-map "`" 'evil-goto-mark) ; release ` for hydras
;; this is how to map leader keys in doom


;; some nice functions




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


;; (with-library which-key
;;   (which-key-mode)
;;   (which-key-setup-side-window-right-bottom))



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
