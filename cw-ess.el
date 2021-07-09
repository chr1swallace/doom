;;; cw-ess.el -*- lexical-binding: t; -*-

;; tramp
;; (use-package! tramp
(after! tramp
  (setq tramp-default-method "ssh")
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
;; )
(use-package! ess)
;; emacs speaks stats
(defun Rcsd3 ()
  "Run R on CSD3 using the R.darwin script"
  (interactive)
  (let ((inferior-ess-r-program "/home/cew54/bin/R.csd3"))
    (R)))
;; (ess-etc-directory "/ssh:csd3:/home/cew54/.ess/etc")
;; (default-directory "/ssh:cew54@csd3:~/"))
;; (ess-directory "/ssh:csd3:~/")
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

(use-package! polymode
  :ensure t
  :mode ("\\.[rR]md\\'" . poly-markdown+R-mode))
(use-package! poly-R
  :after polymode)

(defun rmd-fold-region (beg end &optional msg)
  "Eval all spans within region defined by BEG and END.
MSG is a message to be passed to `polymode-eval-region-function';
defaults to \"Eval region\"."
  (interactive "r")
  (save-excursion
    (let* ((base (pm-base-buffer))
                                        ; (host-fun (buffer-local-value 'polymode-eval-region-function (pm-base-buffer)))
           (host-fun (buffer-local-value 'polymode-eval-region-function base))
           (msg (or msg "Eval region"))
           )
      (if host-fun
          (pm-map-over-spans
           (lambda (span)
             (when (eq (car span) 'body)
               (with-current-buffer base
                 (ignore-errors (vimish-fold (max beg (nth 1 span)) (min end (nth 2 span)))))))
           beg end)
        (pm-map-over-spans
         (lambda (span)
           (when (eq (car span) 'body)
             (setq mapped t)
             (when polymode-eval-region-function
               (setq evalled t)
               (ignore-errors (vimish-fold
                               (max beg (nth 1 span))
                               (min end (nth 2 span))
                               )))))
         beg end)
        ))))
(defun rmd-fold-codes ()
  "Eval all inner chunks in the buffer. "
  (interactive)
  (vimish-fold-delete-all)
  (rmd-fold-region (point-min) (point-max) "Eval buffer")
  (polymode-previous-chunk 1)
  (next-line 2))



;; :config
;; (define-innermode poly-text-R-innermode
;;   :indent-offset 2
;;   :head-matcher (cons "^[ \t]*\\(```[ \t]*{?[[:alpha:]].*\n\\)" 1)
;;   :tail-matcher (cons "^[ \t]*\\(```\\)[ \t]*$" 1)
;;   :mode 'ess-r-mode
;;   :head-mode 'host
;;   :tail-mode 'host)
;; (define-polymode poly-text-R-mode
;;   :hostmode 'pm-host/text
;;   :innermodes '(poly-text-R-innermode)))
