;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)
(package! darkburn-theme)
;; (package! flatland-theme)
(package! gruvbox-theme)
;; (package! monokai-theme)
(package! evil-commentary)
(package! evil-surround)
(package! general)
(package! poly-markdown)
(package! poly-R)
(package! smex)
(package! zygospore)
(package! key-chord)
(package! org-sidebar)
;; (package! evil-org)
(package! org-super-agenda)
(package! org-download)
;; (Package! snakemake-mode)
(package! dash)
(package! rvm)
(package! ace-window)
(package! mood-line)
(package! imenu-list)
(package! markdown-toc)
;(package! org-kanban)
(package! easy-jekyll)
;; (package! mixed-pitch)
(package! rg)
(package! deadgrep)
;; (package! modus-operandi-theme)
;; (package! modus-vivendi-theme)
;; ** Disabling the built-in snippets
;; Don't want to use provided one? Then add this to your private module,
(package! doom-snippets :ignore t)
(package! yasnippet-snippets)
(package! rainbow-delimiters)
(package! all)
(package! stan-mode)
(package! vimish-fold)

;; disable projectile - don't use, may interfere with tramp
;; (package! projectile :disable t)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))
;; (package! ESS :recipe (:host github :repo "emacs-ess/ESS") :pin "983c54bd5c21bd9ae859290d32fb9a8a61509352")
(package! ESS)

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)
(package! evil-org :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
