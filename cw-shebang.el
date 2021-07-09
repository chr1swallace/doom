;;; cw-shebang.el -*- lexical-binding: t; -*-


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

(defun cw-delete-buffer-and-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))
