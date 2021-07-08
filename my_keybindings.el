(require 'general)

(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC"
 "" nil
 :non-normal-prefix "M-SPC"
  ;; "TAB" '(ivy-switch-buffer :which-key "prev buffer")
  "m" '(counsel-M-x :which-key "M-x")
  "r" '(revert-buffer :which-key "revert buffer")
  "F" '(make-frame :which-key "open new frame")
  "f" '(counsel-find-file :which-key "find file")
  "t" '(vterm-toggle :which-key "toggle vterm")
  "." '(ibuffer :which-key "ibuffer")
  "d" '(dired :which-key "dired")
  "M" '(mu4e :which-key "mail")
  "s" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "scratch buffer")
  "c" '(org-capture :which-key "capture")
  )

;; (evilnc-default-hotkeys)

(general-create-definer my-leader-def
  ;; :prefix my-leader
  :states 'normal
  :prefix "g")

(my-leader-def
  :states '(normal)
  ;; ;; :keymaps 'normal
  ;; :keymaps 'normal
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "."  'evilnc-copy-and-comment-operator
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
  )

(general-define-key
 :states '(normal emacs)
 "u" 'undo-tree-undo
 "C-r" 'undo-tree-redo)

(general-define-key
 "M-y" 'counsel-yank-pop)
(general-define-key
 :keymaps 'ivy-minibuffer-map
 "M-y" 'ivy-next-line)

(general-define-key
 :states '(normal)
 :keymaps 'org-mode-map
 "RET" 'prelude/org-return)

;; (general-define-key
;;  ;; :states 'normal
;;  :keymaps 'dired-mode-map
;;  "h" 'dired-single-up-directory
;;  "l" 'dired-single-buffer)

;; (evil-collection-define-key 'normal 'dired-mode-map
;;     "h" 'dired-single-up-directory
;;     "l" 'dired-single-buffer)
