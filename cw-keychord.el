;;; cw-keychord.el -*- lexical-binding: t; -*-


(use-package! key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-one-keys-delay 0.02
        key-chord-two-keys-delay 0.05))
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

(after! (key-chord ess-r-mode)
  (key-chord-define-global ">>" "%>%")
  (key-chord-define-global "<>" "%<>%")
  (key-chord-define-global "`r" 'block-insert-r)
  (key-chord-define-global "`s" 'block-insert-sh))
