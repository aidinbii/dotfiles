;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Aidin Biibosunov"
      user-mail-address "biibosunov.aidin@gmail.com")

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
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 15))

;;(setq doom-unicode-font (font-spec :name "SF-Pro-Display-Regular" :size 15))

(setq doom-big-font (font-spec :family "Source Code Pro" :size 32))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord-light)
;;doom-one-light

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; org capture
(require 'org-capture)

(setq org-default-notes-file (concat org-directory "~/Documents/notes/org-capture/notes.org"))

(setq org-capture-templates
      '(
        ("j" "Journal" entry
         (file+datetree "~/Documents/notes/org-capture/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")

        ("z" "Zettelkasten" entry
         (file+headline "~/Documents/notes/org-capture/zettelkasten.org" "Zettelkasten")
         "* %^{Write the title here} \n IDEA: %? \n LINKS: %a \n Written on %U\n ")
        ))



;;ox-hugo
(use-package ox-hugo
  :after ox)

(defun org-hugo-new-subtree-post-capture-template ()
  "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
  (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
         (fname (org-hugo-slug title)))
    (mapconcat #'identity
               `(
                 ,(concat "* TODO " title)
                 ":PROPERTIES:"
                 ,(concat ":EXPORT_HUGO_BUNDLE: " fname)
                 ":EXPORT_FILE_NAME: index"
                 ":END:"
                 "%?\n")                ;Place the cursor here finally
               "\n")))



;;magit
(with-eval-after-load 'magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-unpulled-from-upstream)
  (setq magit-module-sections-nested nil))






;;auto-indent
(use-package aggressive-indent
   :hook ((java-mode . aggressive-indent-mode)))
  ;;(python-mode . aggressive-indent-mode)
  ;;:custom (aggressive-indent-comments-to))


;;Re-display parts of the Emacs buffer as pretty Unicode symbols.
(use-package pretty-mode
    :init
    (global-pretty-mode))

(global-prettify-symbols-mode t)

(use-package lsp-mode
  :after lsp
  :config (add-hook 'java-mode-hook 'lsp-java))

;;never want whitespace at the end of lines. Remove it on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;Makes lines wrap at word boundaries.
(global-visual-line-mode t)

;;deft
(use-package deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Documents/notes/")
  (deft-file-naming-rules
      '((noslash . "-")
        (nospace . "-")
        (case-fn . downcase))))

;;org-roam
(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Documents/notes/")
  :config
  (setq org-roam-link-title-format "R:%s")
  (setq org-roam-index-file "~/index.org")
  (setq org-roam-buffer-width 0.3)
  :bind (:map org-mode-map
         (("C-c n i" . org-roam-insert))
         :map org-roam-mode-map
          (("C-c n j" . org-roam-jump-to-index))))



;; use an org file to organise feeds
(use-package elfeed-org
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Documents/elfeed/elfeed.org")))


;;mu4e
(after! mu4e
  (setq! ;mail-user-agent 'mu4e-user-agent
        mu4e-mu-binary "/usr/bin/mu"
        mu4e-maildir (expand-file-name "~/.mail/main")
        mu4e-drafts-folder "/[Gmail].Drafts"
        mu4e-sent-folder   "/[Gmail].Sent Mail"
        mu4e-trash-folder  "/[Gmail].Trash"
        mu4e-refile-folder "/[Gmail].Archive"   ;; saved messages
        message-signature-file "~/.mail_signature" ; put your signature in this file
        )


  ;;get mail
  (setq mu4e-get-mail-command "mbsync -c ~/.emacs.d/.mbsyncrc gmail"
        mu4e-html2text-command "w3m -dump -T text/html"
        mu4e-update-interval 300
        mu4e-headers-auto-update t
        mu4e-compose-signature-auto-include t
        mu4e-change-filenames-when-moving t
        mu4e-attachment-dir "~/Downloads/mail_attachments"
        mu4e-use-fancy-chars t
        message-kill-buffer-on-exit t
        mu4e-compose-dont-reply-to-self t
        mu4e-confirm-quit nil)


  ;;smtp - for sending messages
  (setq sendmail-program "/usr/bin/msmtp"
        send-mail-function 'smtpmail-send-it
        message-send-mail-function 'message-send-mail-with-sendmail
        ;;starttls-use-gnutls t
        ;; smtpmail-starttls-credentials
        ;; '(("smtp.gmail.com" 587 nil nil))
        ;; smtpmail-default-smtp-server "smtp.gmail.com"
        ;; smtpmail-smtp-server "smtp.gmail.com"
        ;; smtpmail-smtp-service 587
        smtpmail-debug-info t)

  ;; Signing and Encrypting messages
  ;;(setq epg-gpg-program "gpg2")

  ;;(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)

  ;;(setq mu4e-compose-crypto-reply-encrypted-policy t)

                                        ;(setq mu4e-compose-crypto-reply-policy 'sign-and-encrypt)

  (setq mu4e-maildir-shortcuts
        '( ("/INBOX"               . ?i)
           ("/[Gmail].Sent Mail"   . ?s)
           ("/[Gmail].Trash"       . ?t)
           ("/[Gmail].Drafts"    . ?d)
           ("/[Gmail].All Mail"   . ?a)))

  ;; show images
  ;; (setq mu4e-view-show-images t
  ;;       mu4e-show-images t
  ;;       mu4e-view-image-max-width 800
  ;;       mu4e-image-max-width 800)

  ;; ;; use imagemagick, if available
  ;; (when (fboundp 'imagemagick-register-types)
  ;;   (imagemagick-register-types))


  ;; general emacs mail settings; used when composing e-mail
  ;; the non-mu4e-* stuff is inherited from emacs/message-mode
  (setq mu4e-reply-to-address "biibosunov.aidin@gmail.com"
        user-mail-address "biibosunov.aidin@gmail.com"
        user-full-name "Aidin Biibosunov")
  ;; don't save message to Sent Messages, IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)

  ;; ;; spell check
  ;; (add-hook 'mu4e-compose-mode-hook
  ;;           (defun my-do-compose-stuff ()
  ;;             "My settings for message composition."
  ;;             (set-fill-column 72)
  ;;             (flyspell-mode)))

  ;; allows reading other emails while composing
  (setq mu4e-compose-in-new-window t)


  (setq mu4e-view-prefer-html t)

  ;;While HTML emails are undeniably sinful, we often have to read them. That’s sometimes best done in a browser. This effectively binds a h to open the current email in my default Web browser.
  (add-to-list 'mu4e-view-actions
               '("ViewInBrowser" . mu4e-action-view-in-browser) t)
  (setq browse-url-browser-function 'browse-url-generic)
  (setq browse-url-generic-program "firefox")


  ;;Org integration
  ;;org-mu4e lets me store links to emails. I use this to reference emails in my TODO list while keeping my inbox empty.
  (require 'org-mu4e)

  ;;When storing a link to a message in the headers view, link to the message instead of the search that resulted in that view.
  (setq org-mu4e-link-query-in-headers-mode nil)


  (add-hook! 'mu4e-headers-mode-hook
    (defun my/mu4e-change-headers ()
      (interactive)
      (setq mu4e-headers-fields
            `((:date . 25) ;; alternatively, use :date
              (:flags . 6)
              (:from . 22)
              (:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
              (:size . 7)))))

  (setq mu4e-headers-date-format "%Y-%m-%d %H:%M")
  )
