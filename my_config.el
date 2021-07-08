(setq user-full-name "Aidin Biibosunov"
      user-mail-address "biibosunov.aidin@gmail.com")

;; (set-frame-font "Hack 11" nil t)

;; (custom-theme-set-faces
;;    'user
;;    '(variable-pitch ((t (:family "Open Sans" :height 120 :weight light))))
;;    '(fixed-pitch ((t ( :family "Fira Code" :height 110)))))

;; Main typeface
(set-face-attribute 'default nil :family "Hack" :height 110) ;;height = point size × 10

;; Proportionately spaced typeface; headlines,
(set-face-attribute 'variable-pitch nil :family "ETBookOT" :height 1.2)

;; Monospaced typeface. Code block titles, table, ...
(set-face-attribute 'fixed-pitch nil :family "Hack" :height 1.0)


;; (custom-theme-set-faces
;;    'user
;;    '(org-block ((t (:inherit fixed-pitch))))
;;    '(org-code ((t (:inherit (shadow fixed-pitch)))))
;;    '(org-document-info ((t (:foreground "dark orange"))))
;;    '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;;    '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
;;    '(org-link ((t (:foreground "royal blue" :underline t))))
;;    '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;    '(org-property-value ((t (:inherit fixed-pitch))) t)
;;    '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;    '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;;    '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;;    '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))



;; (add-hook 'org-mode-hook 'visual-line-mode)
;;(add-hook 'org-mode-hook 'variable-pitch-mode)

(setq org-directory "~/org/"
      org-download-dir "~/org/org_download/")

(setq org-hide-emphasis-markers t)
(setq org-ellipsis "⤵")
(setq org-hide-leading-stars t)
(setq org-fontify-done-headline t
      org-fontify-whole-heading-line t)

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(require 'pretty-symbols)



(add-to-list 'load-path (expand-file-name "/home/aidin/.emacs.d/personal/my_packages/evil-collection-master/" user-emacs-directory))
(evil-collection-init)


;; open html links in firefox
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "firefox")

(require 'cl-lib)
(setq byte-compile-warnings '(cl-functions))

;; https://gitlab.com/jessieh/mood-line
(mood-line-mode)

(setq prelude-flyspell nil)

(setq fancy-splash-image "/home/aidin/Pictures/banners/emacs.png")

(mini-frame-mode 1)
(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 400)
     (width . 0.7)
     (left . 0.5))))


(blink-cursor-mode 1)

;; to save/load emacs sessions
(desktop-save-mode 1)

;;(native-comp-async-report-warnings-errors nil)
;; (display-warning "warning-series" '(message logmsg) :error)
(setq warning-minimum-level :error)

;; (require 'dashboard)
;; (dashboard-setup-startup-hook)

(require 'vterm)
(defun evil-collection-vterm-escape-stay ()
"Go back to normal state but don't move
cursor backwards. Moving cursor backwards is the default vim behavior but it is
not appropriate in some cases like terminals."
(setq-local evil-move-cursor-back nil))
(add-hook 'vterm-mode-hook #'evil-collection-vterm-escape-stay)

(defun vterm-counsel-yank-pop-action (orig-fun &rest args)
  "counsel-yank-pop to work"
  (if (equal major-mode 'vterm-mode)
      (let ((inhibit-read-only t)
            (yank-undo-function (lambda (_start _end) (vterm-undo))))
        (cl-letf (((symbol-function 'insert-for-yank)
               (lambda (str) (vterm-send-string str t))))
            (apply orig-fun args)))
    (apply orig-fun args)))

(advice-add 'counsel-yank-pop-action :around #'vterm-counsel-yank-pop-action)




;; org capture
(require 'org-capture)
(setq org-agenda-files (list "~/Dropbox/orgzly"))

(setq org-default-notes-file (concat org-directory "~/Documents/notes/org-capture/notes.org"))

(setq org-capture-templates
    `(("i" "Inbox")
      ("ii" "inbox" entry (file+olp "~/Dropbox/orgzly/inbox.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
      ("im" "Meeting" entry
           (file+olp+datetree "~/Dropbox/orgzly/inbox.org" "Meetings")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("j" "Journal" entry
           (file+olp+datetree "~/Dropbox/orgzly/journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)

      ("e" "Checking Email" entry (file+olp+datetree "~/Dropbox/orgzly/inbox.org" "Email" )
       "* Checking Email :email:\n\n%? \n%a" :clock-in :clock-resume :empty-lines 1)))

;; archive location
(setq org-archive-location "/home/aidin/Dropbox/orgzly/archive.org::* completed tasks")

;; function to archive DONE subtrees
(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))




;;magit
(with-eval-after-load 'magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-unpulled-from-upstream)
  (setq magit-module-sections-nested nil))


;; minor mode that enables mixing fixed-pitch
(add-hook 'text-mode-hook 'mixed-pitch-mode)


;; setting the width of inline images in org-mode files to a fixed value (third of the width of the screen)
;; #+ATTR_ORG: :width 1000 will not override it.
(setq org-image-actual-width (/ (display-pixel-width) 3))

;;keep the indentation well structured
(setq org-startup-indented t)

(require 'pretty-mode)
; if you want to set it globally
(global-pretty-mode t)

;;Makes lines wrap at word boundaries.
(global-visual-line-mode t)

;;wraps lines at fill-column
(require 'visual-fill-column)
(global-visual-fill-column-mode)
(setq-default fill-column 100)
;; (setq visual-fill-column-center-text t)
;; (setq visual-fill-column-extra-text-width '(250 . 30))


;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Useless-Whitespace.html
(require 'whitespace)
(setq whitespace-line-column 110)
(setq whitespace-line 110)
(setq whitespace-style '(spaces tabs newline empty))
;;never want whitespace at the end of lines. Remove it on save.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(smartparens-strict-mode -1)

;;to support vterm
(defun crux-vterm (buffer-name)
    (vterm (format "*%s*" buffer-name)))
(setq crux-shell-func #'crux-vterm)


;; Ability to use a to visit a new directory or file in dired instead of using RET. RET works just fine, but it will create a new buffer for every interaction whereas a reuses the current buffer.
(put 'dired-find-alternate-file 'disabled nil)


;; set the org-src buffer size
(setq org-src-window-setup 'current-word)


;;elfeed
;;functions to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching
(defun bjm/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))

(setq elfeed-db-directory "/home/aidin/Dropbox/elfeed/db/")

;; use an org file to organise feeds
(require' elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list "/home/aidin/Dropbox/elfeed/elfeed.org"))


;;mu4e
;;(prelude-require-package 'mu4e)
(require 'mu4e)

  (setq mu4e-mu-binary "/usr/bin/mu"
        mu4e-maildir (expand-file-name "~/.mail")
        mu4e-sent-folder "/gmail/Sent"
        mu4e-drafts-folder "/gmail/Drafts"
        mu4e-trash-folder  "/gmail/Trash"
        mu4e-refile-folder "/gmail/Archive"   ;; archive
        message-signature-file "~/.mail_signature" ; put your signature in this file
        )


  ;;get mail
  (setq mu4e-get-mail-command "mbsync -c ~/.mbsyncrc gmail"
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
(require 'smtpmail)
(setq
        sendmail-program "/usr/bin/msmtp"
        send-mail-function 'smtpmail-send-it
        ;;message-send-mail-function 'message-send-mail-with-sendmail
        ;; (smtpmail-smtp-user     . "henrik@lissner.net")
        starttls-use-gnutls t
        smtpmail-starttls-credentials '(("smtp.gmail.com" "587" nil nil))
        smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg")
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-debug-info t)

  ;; Signing and Encrypting messages
  ;;(setq epg-gpg-program "gpg2")

  ;;(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)

  ;;(setq mu4e-compose-crypto-reply-encrypted-policy t)

                                        ;(setq mu4e-compose-crypto-reply-policy 'sign-and-encrypt)

  (setq mu4e-maildir-shortcuts
        '( ("/gmail/Inbox"       . ?i)
           ("/gmail/Trash"       . ?t)
           ("/gmail/Drafts"      . ?d)
           ("/gmail/Archive"     . ?a)))


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
(setq mu4e-reply-to-address "biibosunov.aidin@gmail.com")

;; don't save messages to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)
(add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-mode -1)))

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
  (add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

  ;;When storing a link to a message in the headers view, link to the message instead of the search that resulted in that view.
  (setq org-mu4e-link-query-in-headers-mode nil)


  (add-hook 'mu4e-headers-mode-hook
    (defun my/mu4e-change-headers ()
      (interactive)
      (setq mu4e-headers-fields
            `((:date . 25) ;; alternatively, use :date
              (:flags . 6)
              (:from . 22)
              (:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
              (:size . 7)))))

  (setq mu4e-headers-date-format "%Y-%m-%d %H:%M")


(setq mail-user-agent 'mu4e-user-agent)
(require 'org-msg)

;; Send email with both HTML and plain text (like a good well adjusted human)
(setq org-msg-default-alternatives '(text html))

;; Set up email signature
;; (setq org-msg-signature "\n\nAidin Biibosunov\n")
(org-msg-mode)

(require 'yasnippet)
(yas-global-mode 1)

;; disable anaconda-mode. instead use pyright lsp-server
(anaconda-mode -1)

;; lsp-mode
(require 'lsp-mode)
(add-hook 'python-mode-hook #'lsp)

;; to work with TRAMP
(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; (setq tramp-remote-path '("mnt/home/icb/aidin.biibosunov/"))

;; (prelude-require-package 'lsp-pyright)
;; ;; (add-hook 'org-mode-hook 'variable-pitch-mode)
;; (add-hook 'python-mode-hook  (lambda ()
;;                           (require 'lsp-pyright)
;;                           (lsp)))  ; or lsp-deferred

;; (prelude-require-package 'lsp-python-ms)
;; (require 'lsp-python-ms)
;; (setq lsp-python-ms-auto-install-server t)
;; (add-hook 'python-mode-hook #'lsp) ; or lsp-deferred


;; (setq lsp-python-ms-executable (executable-find "python-language-server"))

;; (lsp-register-client
;;     (make-lsp-client :new-connection (lsp-tramp-connection "python-language-server")
;;                      :major-modes '(python-mode)
;;                      :remote? t
;;                      :multi-root t
;;                      :priority 3
;;                      :notification-handlers (lsp-ht ("python/languageServerStarted" 'lsp-python-ms--language-server-started-callback)
;;                                                    ("telemetry/event" 'ignore)
;;                                                    ("python/reportProgress" 'lsp-python-ms--report-progress-callback)
;;                                                    ("python/beginProgress" 'lsp-python-ms--begin-progress-callback)
;;                                                    ("python/endProgress" 'lsp-python-ms--end-progress-callback))
;;                      :initialization-options 'lsp-python-ms--extra-init-params
;;                      :initialized-fn (lambda (workspace)
;;                                       (with-lsp-workspace workspace
;;                                                           (lsp--set-configuration (lsp-configuration-section "python"))))
;;                     :server-id 'mspyls-remote))

;; (executable-find "python-language-server" "/ssh:vicb_01:/home/icb/aidin.biibosunov/")


(prelude-require-package 'lsp-jedi)
(require 'lsp-jedi)
(with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-disabled-clients 'pyls)
    (add-to-list 'lsp-enabled-clients 'jedi))

(lsp-register-client
    (make-lsp-client :new-connection (lsp-tramp-connection "vicb_01")
                     :major-modes '(python-mode)
                     :remote? t
                     :server-id 'jedi-remote))

(add-hook 'after-init-hook 'global-flycheck-mode)
(setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
;; (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)


(prelude-require-package 'py-autopep8)
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)



(defadvice split-window (after move-point-to-new-window activate)
  "Moves the point to the newly created window after splitting."
  (other-window 1))

;; Prompt for confirmation only when deleting a modified buffer
(setq ibuffer-expert t)

;; Group buffers in ibuffer list by projectile project
;; (prelude-require-package 'ibuffer-projectile)
;; (add-hook 'ibuffer-hook
;;     (lambda ()
;;       (ibuffer-projectile-set-filter-groups)
;;       (unless (eq ibuffer-sorting-mode 'alphabetic)
;;         (ibuffer-do-sort-by-alphabetic))))

(prelude-require-package 'ibuffer-vc)
(require 'ibuffer-vc)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (ibuffer-do-sort-by-alphabetic)))



(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode -1)))

;; to speed up projectile with tramp files
(setq projectile-mode-line "Projectile")

;; scratch in org-mode
(setq initial-major-mode 'org-mode)
(prelude-require-package 'persistent-scratch)
(persistent-scratch-autosave-mode 1)


;; When editing a list item, pressing "Return" will insert a new list item automatically.
(prelude-require-package 'org-autolist)
(require 'org-autolist)
(org-autolist-mode)
(add-hook 'org-mode-hook (lambda () (org-autolist-mode)))
;; (setq org-M-RET-may-split-line '((item . nil)))

(require 'org-inlinetask)

;; M-x enhancement
(prelude-require-package 'smex)
(require 'smex)
