;;; cw-rakefile.el -*- lexical-binding: t; -*-


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
