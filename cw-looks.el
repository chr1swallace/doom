;;; cw-looks.el -*- lexical-binding: t; -*-



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
  (setq doom-font (font-spec :family "Fira Code" :size 15))
  (setq doom-font (font-spec :family "Bitstream Vera Sans Mono" :size 15))
  (setq doom-font (font-spec :family "SourceCodePro" :size 15))
(setq ;doom-font (font-spec :family "inconsolata" :size 16)
      ;; doom-font (font-spec :family "Hack" :size 14)
      doom-font (font-spec :family "SourceCodePro" :size 15)
      doom-big-font-increment 2
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
;; (require 'acario-theme)
;; (setq doom-theme 'doom-outrun-sourcerer)
;; (require 'darkburn-theme)
;; (setq doom-theme 'darkburn)
(setq doom-theme 'doom-old-hope)
;; (setq doom-theme 'modus-vivendi)
;; (setq modus-vivendi-theme-syntax 'yellow-comments)
(custom-set-faces!
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(default :background "#000000")
  '(region :background "#101010")
 '(font-lock-comment-face :foreground "#d4d4a4")
 '(font-lock-comment-face :slant italic)
 '(org-headline-done :foreground "yellow green")
 '(org-level-1 :foreground "DFAF8F" :height 1.5))
;; (setq doom-theme 'doom-gruvbox)
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic)
;;   '(font-lock-keyword-face :slant italic))
(mood-line-mode)
(doom-themes-org-config)
(defun ap/load-doom-theme (theme)
  "Disable active themes and load a Doom theme."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name)
                                                   (--select (string-prefix-p "doom-" it)))))))
  (ap/switch-theme theme)
  (set-face-foreground 'org-indent (face-background 'default)))

(defun ap/switch-theme (theme)
  "Disable active themes and load THEME."
  (interactive (list (intern (completing-read "Theme: "
                                              (->> (custom-available-themes)
                                                   (-map #'symbol-name))))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme 'no-confirm))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(menu-bar-mode 't)
