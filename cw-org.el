;;; cw-org.el -*- lexical-binding: t; -*-



;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; undo doom changes
;; (after! evil-org
;;   (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))
(add-hook 'org-mode-hook #'evil-normalize-keymaps)
(after! org
  (remove-hook 'org-tab-first-hook #'+org-yas-expand-maybe-h)
  (remove-hook 'org-mode-hook #'org-superstar-mode)
  (setq org-fontify-quote-and-verse-blocks nil
        org-fontify-whole-heading-line t
        org-fontify-todo-headline t
        org-log-refile nil
        org-adapt-indentation nil
        org-cycle-separator-lines 1 ;; blank lines mean something
        org-startup-folded t
        org-reverse-note-order t ;; refile to beginning of sections
        org-src-tab-acts-natively t
        org-hide-emphasis-markers t
        org-hide-leading-stars t
        org-startup-indented nil)
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           ;; "HOLD(h)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d)"  ; Task successfully completed
           ;; "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
           )
          (sequence "PROJ" "COLLAB" "ADMIN" "ST") ;; my headings that I fake as TODOs
          ))
  (setq org-todo-keyword-faces
        '(("STRT" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("COLLAB" . +org-todo-project)
          ("ST" . +org-todo-project)
          ("PROJ" . +org-todo-project)
          ("ADMIN" . +org-todo-project))))
                                        ;(setq org-roam-directory "~/.org-roam")
                                        ;(add-hook 'after-init-hook 'org-roam-mode)

;; (bind-key “TAB” #’indent-for-tab-command)
;; (bind-key “M-i” #’company-complete)

;; (defun me/get-parent-props ()
;;   "run org-entry-properties on parent heading"
;;   (interactive)
;;   (save-excursion
;;     (org-up-element)
;;     (org-entry-properties)))

;; from https://pages.sachachua.com/.emacs.d/Sacha.html
(defun my/org-refile-and-jump ()
  (interactive)
  (if (derived-mode-p 'org-capture-mode)
      (org-capture-refile)
    (call-interactively 'org-refile))
  (org-refile-goto-last-stored))
(eval-after-load 'org-capture
  '(bind-key "C-c C-r" 'my/org-refile-and-jump org-capture-mode-map))

(defun me/get-date-tag ()
  "run org-entry-properties on parent heading"
  (interactive)
  (save-excursion
    (org-up-heading-safe)
    (concat (org-entry-get nil "TIMESTAMP_IA") " " (org-entry-get nil "TAGS"))))

;; (defun me/add-date-tag ()
;;   "add org-entry-properties TIMESTAMP_IA from parent heading"
;;   (interactive)
;;   (let* ((str (me/get-date-tag)))
;;     (end-of-line)
;;     (insert " " str)))

;; advice org-refile to copy parent date where available
(defun me/refile-journal-advisor ()
  "copy date and tags from parent heading"
  (interactive)
  (when (and (string= (file-name-nondirectory (buffer-file-name)) "journal.org")
             (org-at-heading-p))
    (end-of-line)
    (insert " " (me/get-date-tag))))
;; (defun advice-unadvice (sym)
;;   "Remove all advices from symbol SYM."
;;   (interactive "aFunction symbol: ")
;;   (advice-mapc (lambda (advice _props) (advice-remove sym advice)) sym))
;; (advice-unadvice 'org-refile)

(advice-add 'org-refile
            :before
            (lambda (&rest _)
              (me/refile-journal-advisor)))

;; (defun me/refile-and-go ()
;;   (org-refile))

;; inline tasks
(require 'org-inlinetask)
(setq deft-extensions '("org"))
(setq deft-directory "~/Dropbox/org")
(setq deft-use-filename-as-title t)

;; agenda
(require 'org-agenda)
(setq org-agenda-files '("~/Dropbox (Cambridge University)/org/admin.org"
                         "~/Dropbox (Cambridge University)/org/students.org"
                         "~/Dropbox (Cambridge University)/org/staff.org"
                         "~/Dropbox (Cambridge University)/org/collab.org"
                         "~/Dropbox (Cambridge University)/org/Meetings/group.org"
                         "~/Dropbox (Cambridge University)/org/projects.org"))

;; org-super-agenda
(require 'org-super-agenda)
(org-super-agenda-mode)
(setq org-super-agenda-groups
      '(;; Each group has an implicit boolean OR operator between its selectors.
        (:name "Important"
         ;; Single arguments given alone
         :priority "A")
        (:name "Everything else"
         :auto-tags t)))
(org-agenda-list)
;; (let ((org-super-agenda-groups
;;        '((:auto-group t))))
;;   (org-agenda-list))
;; (let ((org-super-agenda-groups
;;        '((:log t)  ; Automatically named "Log"
;;          (:name "Schedule"
;;                 :time-grid t)
;;          (:name "Today"
;;                 :scheduled today)
;;          (:habit t)
;;          (:name "Due today"
;;                 :deadline today) aa
;;          (:name "Overdue"
;;                 :deadline past)
;;          (:name "Due soon"
;;                 :deadline future)
;;          (:name "Unimportant"
;;                 :todo ("SOMEDAY" "MAYBE" "CHECK" "TO-READ" "TO-WATCH")
;;                 :order 100)
;;          (:name "Waiting..."
;;                 :todo "WAITING"
;;                 :order 98)
;;          (:name "Scheduled earlier"
;;                 :scheduled past))))
;;   (org-agenda-list))
(after! org-agenda
  (add-hook 'org-agenda-mode-hook '(lambda ()
                                     (set-face-background 'hl-line "#336")
                                     (hl-line-mode 1))) ;; make current line clear
  (setq org-agenda-custom-commands
        '(("1" todo "PROJ|COLLAB|ADMIN|ST"
           ((org-agenda-files '("~/Dropbox (Cambridge University)/org/admin.org"
                                "~/Dropbox (Cambridge University)/org/students.org"
                                "~/Dropbox (Cambridge University)/org/collab.org"
                                "~/Dropbox (Cambridge University)/org/projects.org"))
            (org-agenda-overriding-header "My Active items")
            (org-tags-match-list-sublevels t)
            (org-agenda-prefix-format "%l%?-12t ")))
          ("2" todo "PROJ|COLLAB|ADMIN|ST|TODO"
           ((org-agenda-files '("~/Dropbox (Cambridge University)/org/admin.org"
                                "~/Dropbox (Cambridge University)/org/students.org"
                                "~/Dropbox (Cambridge University)/org/collab.org"
                                "~/Dropbox/org/projects.org"))
            (org-agenda-overriding-header "My Active items")
            (org-tags-match-list-sublevels t)
            (org-agenda-prefix-format "%l%?-12t ")))
          ("3" todo "PROJ|COLLAB|ADMIN|ST|TODO|STRT|WAIT|HOLD"
           ((org-agenda-files '("~/Dropbox/org/projects.org"))
            (org-agenda-overriding-header "My Active items")
            (org-tags-match-list-sublevels t)
            (org-agenda-prefix-format "%l%?-12t ")))))
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

  ;; https://www.reddit.com/r/orgmode/comments/bgy3v6/automate_refiling_according_to_tag/euqg8e8/?context=8&depth=9
  (defun my/refile-based-on-current-tags ()
    (interactive)
    (let* ((tags (org-get-tags))
           (org-refile-targets `(,@(seq-map (lambda (tag)
                                              (cons 'org-agenda-files (cons :tag tag)))
                                            tags))))
      (call-interactively 'org-refile)))
  ;; (defun my/org-agenda-add-update (&optional arg)
  ;;   "Add a time-stamped note to the entry at point."
  ;;   (interactive "P")
  ;;   (org-agenda-check-no-diary)
  ;;   (let* ((marker (or (org-get-at-bol 'org-marker)
  ;; 		     (org-agenda-error)))
  ;; 	 (buffer (marker-buffer marker))
  ;; 	 (pos (marker-position marker))
  ;; 	 (hdmarker (org-get-at-bol 'org-hd-marker))
  ;; 	 (inhibit-read-only t))
  ;;     (with-current-buffer buffer
  ;;       (widen)
  ;;       (goto-char pos)
  ;;       (org-show-context 'agenda)
  ;;       (org-add-log-note))))

  (setq org-capture-templates
        ;; why won't this work?
        ;; '(("k" "Project note" entry
        ;;  (file+headline  "~/Dropbox/org/projects.org" %((my/agenda-heading)))
        ;;  "** UPDATE %U\n%?\n" :prepend t)
        '(;("T" "Personal todo" entry
                                        ;(file+headline +org-capture-todo-file "Inbox")
                                        ;"* [ ] %?\n%i\n%a" :prepend t)
          ("t" "Todo" entry
           (file "~/Dropbox/org/projects.org")
           "** TODO %?\n%i\n" :prepend t)
          ("n" "add Note" entry
           ;;(file+headline +org-capture-notes-file "Inbox")
           (file +org-capture-notes-file)
           "* %u %?\n%i\n" :prepend t)
          ("c" "Clipboard" entry
           (file "~/Dropbox/org/projects.org")
           "** %? %U\n   %c" :prepend t :empty-lines 1)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "** %? %U\n%i\n%a" :prepend t)
          ("U" "Project update" plain
           (function
            (lambda ()
              (let ((filename "/home/chrisw/Dropbox/org/projects.org")
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
          ("T" "Project todo" plain
           (function
            (lambda ()
              (let ((filename "/home/chrisw/Dropbox/org/projects.org")
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

;; https://github.com/abo-abo/org-download
(require 'org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)
