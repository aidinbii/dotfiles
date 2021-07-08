(global-nlinum-mode -1)
(setq display-line-numbers-type 'relative)

(menu-bar-mode -1)
(scroll-bar-mode -1)

(require 'modus-themes)

;; Your customisations here.  For example:
(setq modus-themes-slanted-constructs t)
(setq modus-themes-org-blocks 'tinted-background)
(setq modus-themes-scale-headings t)
(setq modus-themes-mode-line '(accented borderless))
(setq modus-themes-variable-pitch-headings t)
(setq modus-themes-region 'no-extend)
;; (setq modus-themes-no-mixed-fonts t)

;; Load the theme files before enabling a theme (else you get an error).
(modus-themes-load-themes)

;; Enable the theme of your preference:
(modus-themes-load-operandi)

(setq prelude-theme 'modus-operandi)

;; Optionally add a key binding for the toggle between the themes:
;;(define-key global-map (kbd "<f5>") #'modus-themes-toggle)
