;;; cw-latex.el -*- lexical-binding: t; -*-



;; cdlatex has a snippet insertion capability which is disabled in favor of
;; yasnippet when using ~:editor snippets~. If you still wanna use it, simply rebind
;; the ~TAB~ key for cdlatex, which takes care of snippet-related stuff:
(map! :map cdlatex-mode-map
    :i "TAB" #'cdlatex-tab)

(setq reftex-external-file-finders
      '(("tex" . "kpsewhich -format=.tex %f")
        ("bib" . "kpsewhich -format=.bib %f"))
      reftex-bibpath-environment-variables '("/home/chrisw/texmf/bibtex/bib")
      reftex-default-bibliography '("/home/chrisw/Dropbox/Words/papers/jabref.bib")
      ;; reftex-default-bibliography '("/home/chrisw/texmf/bibtex/bib/paperpile.bib"))
      reftex-ref-macro-prompt nil) ;; do not prompt whether I want \pageref or not.)
