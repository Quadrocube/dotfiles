;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Vlad Sterzhanov"
      user-mail-address "gliderok@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string.
;;
;(setq doom-font (font-spec :family "monospace" :size 14))
; spolakh/FAVS:
  (setq doom-font "Anonymous Pro-13")
;  (setq doom-font "Fira Code-12")
;  (setq doom-font "Ubuntu Mono-14")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `visual)


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

; THEMES:

(setq doom-theme 'doom-gruvbox)
(add-to-list 'load-path "~/.doom.d/vendor/auto-dark-emacs/")
(require 'auto-dark-emacs)
(setq auto-dark-emacs/dark-theme 'doom-nova)
(setq auto-dark-emacs/light-theme 'doom-solarized-light)


; Other Favs:
;   - Light:
;(load-theme 'doom-solarized-light 'NO-CONFIRM)
;(load-theme 'doom-one-light 'NO-CONFIRM)
;(load-theme 'doom-tomorrow-day 'NO-CONFIRM)
;(load-theme 'dichromacy 'NO-CONFIRM)
;(load-theme 'spacemacs-light 'NO-CONFIRM)
;   - Dark:
;(load-theme 'doom-gruvbox 'NO-CONFIRM)
;(load-theme 'doom-one 'NO-CONFIRM)
;(load-theme 'doom-vibrant 'NO-CONFIRM)
;(load-theme 'doom-spacegrey 'NO-CONFIRM)
;(load-theme 'doom-tomorrow-night 'NO-CONFIRM)
;(load-theme 'doom-nord 'NO-CONFIRM)
;(load-theme 'doom-nova 'NO-CONFIRM)

; NAVIGATION:

(map!
 (:map evil-motion-state-map
  "<s-]>" #'better-jumper-jump-forward
  "s-]" #'better-jumper-jump-forward
  "<s-[>" #'better-jumper-jump-backward
  "s-[" #'better-jumper-jump-backward))

(map!
 (:map general-override-mode-map
  "s-l" #'evil-window-right
  "s-h" #'evil-window-left
  "s-j" #'evil-window-down
  "s-k" #'evil-window-up
  "s-L" #'evil-window-move-far-right
  "s-H" #'evil-window-move-far-left
  "s-J" #'evil-window-move-very-bottom
  "s-K" #'evil-window-move-very-top))

(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))

(after! ivy
(map!
 (:map ivy-minibuffer-map
 "S-SPC" nil
 "M-SPC" #'ivy-restrict-to-matches)
 )
)

; ORG-MODE:

(after! org
  (map!
   (:map evil-normal-state-map
    "<s-return>" nil)
   (:map org-mode-map
    "<s-return>" #'org-todo))
  (require 'find-lisp)
  (setq spolakh/org-agenda-directory "~/Dropbox/org/private/gtd/"
        spolakh/org-dailies-directory "~/Dropbox/org/private/dailies/"
        spolakh/org-directory "~/Dropbox/org/")
  (setq org-agenda-files
        (cons (concat spolakh/org-directory "phone.org")
              (find-lisp-find-files spolakh/org-agenda-directory "\.org$")))
  (defun spolakh/open-projects ()
    (interactive)
    (find-file (concat spolakh/org-agenda-directory "projects.org")))
  (map! :map org-mode-map
      :leader
      (:prefix ("n" . "notes")
       :desc "Refile" "R" 'org-refile
       :desc "Projects" "p" 'spolakh/open-projects
       :desc "Capture Task to Inbox" "i" (lambda () (interactive) (org-capture nil "i"))
       :desc "Capture Idea to Inbox" "I" (lambda () (interactive) (org-capture nil "I"))))
  (setq org-capture-templates
        `(("i" "inbox TODO" entry (file ,(concat spolakh/org-agenda-directory "inbox.org"))
           "* TODO %?")
          ("a" "org-protocol-capture from Alfred" entry (file ,(concat spolakh/org-agenda-directory "inbox.org"))
            "* TODO %i"
            :immediate-finish t)))
  (setq
   org-use-fast-todo-selection nil
   org-startup-with-inline-images t
   org-image-actual-width 400
   org-log-done 'time
   org-todo-keywords '(
    (sequence "TODO" "|" "DONE")
    (sequence "Idea" "[NOTE.Inkling]" "|" "[NOTE.EVERGREEN]") ; Use Stub to filter for Notes that we need expanding on. Once ok - move to Evergreen
    (sequence "WAITING(w@/!)" "|""PASS(p@/!)")
    (sequence "TODIGEST" "|" "DIGESTED") ; Nibbles(Articles / Books / Videos / ...) for quotations
    (sequence "CANCELLED")
    )
   org-todo-keyword-faces
       '(
         ("Idea" . (:foreground "#5F9EA0"))
         ("WAITING" . (:background "firebrick" :weight bold :foreground "gold"))
         ("[NOTE.EVERGREEN]" . (:foreground "olivedrab" :weight bold))
         ("[NOTE.Inkling]" . (:foreground "mediumpurple" :weight bold))
         )
   org-directory spolakh/org-directory)
  (setq org-tag-alist (quote (
                            ;(:startgrouptag)
                            ;("work/mine")
                            ;(:grouptags)
                            ("@work" . ?w)
                            ("@mine" . ?m)
                            ;(:endgrouptag)
                            ;(:startgrouptag)
                            ;("People")
                            ;(:grouptags)
                            ("Lily" . ?l)
                            ;(:endgrouptag)
                            )))
  (setq org-fast-tag-selection-single-key nil)
  (setq org-refile-targets `((,(concat spolakh/org-agenda-directory "later.org") :maxlevel . 1)
                              (,(concat spolakh/org-agenda-directory "oneoff.org") :level . 0)
                              (,(concat spolakh/org-agenda-directory "repeaters.org") :level . 0)
                              (,(concat spolakh/org-agenda-directory "projects.org") :maxlevel . 1)))
  (defun spolakh/shift-dwim-at-point ()
    (interactive)
    (let ((org-link-frame-setup (quote
                               ((vm . vm-visit-folder-other-window)
                                (gnus . gnus)
                                (file . find-file-other-window)
                                (wl . wl)))
                              ))
    (+org/dwim-at-point)))
  (map! (:map org-mode-map
         "<S-return>" #'spolakh/shift-dwim-at-point
         ))
)

(use-package! org-agenda
  :init
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t
        org-agenda-log-mode-items '(closed clock state))
  (add-hook 'evil-org-agenda-mode-hook #'display-line-numbers-mode)
  (setq org-agenda-time-grid
      '((daily today)
        (1200 1400 1600 1800 2000 2200 0000 0200)
        "    " "- - - - - - - - - - - - - - - - - - - - - - - - - - -"))
  (setq org-agenda-use-time-grid t)
  (setq org-extend-today-until 2)
  (setq org-agenda-todo-list-sublevels t)
  (map! :after evil-org-agenda
        :map (evil-org-agenda-mode-map org-agenda-mode-map)
        ; org-agenda-keymap
        ; org-agenda-mode-map
        ; evil-org-agenda-mode-map
      :m "i" #'org-agenda-clock-in
      "o" #'org-agenda-clock-out
      :m "I" #'spolakh/set-todo-idea
      ;"a" #'org-agenda-add-note ; we always link notes in the default item processing flow
      "d" #'org-agenda-deadline
      :m "e" #'spolakh/invoke-fast-effort-selection
      "s" #'org-agenda-schedule
      "a" #'org-agenda-archive-default-with-confirmation
      "p" #'spolakh/org-agenda-process-single-inbox-item
      :m "P" #'spolakh/org-agenda-bulk-process-inbox
      :m "t"  #'org-agenda-columns
      "R" #'org-agenda-refile
      "<s-return>" #'org-agenda-todo
      "<s-S-return>" #'spolakh/set-todo-done
      "S" #'spolakh/set-todo-waiting
      "D" #'spolakh/set-todo-pass
      "s-1" #'spolakh/org-agenda-parent-to-top
      :m "J" #'spolakh/org-agenda-next-section
      :m "K" #'spolakh/org-agenda-previous-section
      :m "1" #'spolakh/org-agenda-item-to-top
      :m "d" nil
      :m "s" nil
      :m "a" nil
      :m "p" nil
      :m "R" nil
      :m "S" nil
      :m "D" nil
      :m "<s-return>" nil
      :m "<s-S-return>" nil
      )
  (defun spolakh/set-todo-waiting ()
    (interactive)
    (org-agenda-todo "WAITING"))
  (defun spolakh/set-todo-idea ()
    (interactive)
    (org-agenda-todo "Idea"))
  (defun spolakh/set-todo-done ()
    (interactive)
    (org-agenda-todo "DONE"))
  (defun spolakh/set-todo-pass ()
    (interactive)
    (org-agenda-todo "PASS"))
  ; This is heavily adopted from Sacha Chua's https://sachachua.com/blog/2013/01/emacs-org-display-projects-with-a-few-subtasks-in-the-agenda-view/
  ;; (defun spolakh/org-agenda-project-agenda ()
  ;;   "Return the project headline and up to `org-agenda-max-entries' tasks."
  ;;   (save-excursion
  ;;     (let* ((marker (org-agenda-new-marker))
  ;;            (heading
  ;;             (org-agenda-format-item "" (org-get-heading) (org-get-category) nil))
  ;;            (org-agenda-restrict t)
  ;;            (org-agenda-restrict-begin (point))
  ;;            (org-agenda-restrict-end (org-end-of-subtree 'invisible))
  ;;            ;; Find the TODO items in this subtree
  ;;            (list (org-agenda-get-day-entries (buffer-file-name) (calendar-current-date) :todo)))
  ;;       (org-add-props heading
  ;;           (list 'face 'defaults
  ;;                 'done-face 'org-agenda-done
  ;;                 'undone-face 'default
  ;;                 'mouse-face 'highlight
  ;;                 'org-not-done-regexp org-not-done-regexp
  ;;                 'org-todo-regexp org-todo-regexp
  ;;                 'org-complex-heading-regexp org-complex-heading-regexp
  ;;                 'help-echo
  ;;                 (format "mouse-2 or RET jump to org file %s"
  ;;                         (abbreviate-file-name
  ;;                          (or (buffer-file-name (buffer-base-buffer))
  ;;                              (buffer-name (buffer-base-buffer))))))
  ;;         'org-marker marker
  ;;         'org-hd-marker marker
  ;;         'org-category (org-get-category)
  ;;         'type "tagsmatch")
  ;;       (concat heading "\n"
  ;;               (org-agenda-finalize-entries list)))))
  ;; (defun spolakh/org-agenda-projects-and-tasks (match)
  ;;   "Show TODOs for all `org-agenda-files' headlines matching MATCH."
  ;;   (interactive "MString: ")
  ;;   (let ((todo-only nil))
  ;;     (let* ((org-tags-match-list-sublevels
  ;;             org-tags-match-list-sublevels)
  ;;            (completion-ignore-case t)
  ;;            rtn rtnall files file pos matcher
  ;;            buffer)
  ;;       (when (and (stringp match) (not (string-match "\\S-" match)))
  ;;         (setq match nil))
  ;;       (when match
  ;;         (setq matcher (org-make-tags-matcher match)
  ;;               match (car matcher) matcher (cdr matcher)))
  ;;       (catch 'exit
  ;;         (if org-agenda-sticky
  ;;             (setq org-agenda-buffer-name
  ;;                   (if (stringp match)
  ;;                       (format "*Org Agenda(%s:%s)*"
  ;;                               (or org-keys (or (and todo-only "M") "m")) match)
  ;;                     (format "*Org Agenda(%s)*" (or (and todo-only "M") "m")))))
  ;;         (org-agenda-prepare (concat "TAGS " match))
  ;;         (org-compile-prefix-format 'tags)
  ;;         (org-set-sorting-strategy 'tags)
  ;;         (setq org-agenda-query-string match)
  ;;         (setq org-agenda-redo-command
  ;;               (list 'org-tags-view `(quote ,todo-only)
  ;;                     (list 'if 'current-prefix-arg nil `(quote ,org-agenda-query-string))))
  ;;         (setq files (org-agenda-files nil 'ifmode)
  ;;               rtnall nil)
  ;;         (while (setq file (pop files))
  ;;           (catch 'nextfile
  ;;             (org-check-agenda-file file)
  ;;             (setq buffer (if (file-exists-p file)
  ;;                              (org-get-agenda-file-buffer file)
  ;;                            (error "No such file %s" file)))
  ;;             (if (not buffer)
  ;;                 ;; If file does not exist, error message to agenda
  ;;                 (setq rtn (list
  ;;                            (format "ORG-AGENDA-ERROR: No such org-file %s" file))
  ;;                       rtnall (append rtnall rtn))
  ;;               (with-current-buffer buffer
  ;;                 (unless (derived-mode-p 'org-mode)
  ;;                   (error "Agenda file %s is not in `org-mode'" file))
  ;;                 (save-excursion
  ;;                   (save-restriction
  ;;                     (if org-agenda-restrict
  ;;                         (narrow-to-region org-agenda-restrict-begin
  ;;                                           org-agenda-restrict-end)
  ;;                       (widen))
  ;;                     (setq rtn (org-scan-tags 'spolakh/org-agenda-project-agenda matcher todo-only))
  ;;                     (setq rtnall (append rtnall rtn))))))))
  ;;         (if org-agenda-overriding-header
  ;;             (insert (org-add-props (copy-sequence org-agenda-overriding-header)
  ;;                         nil 'face 'org-agenda-structure) "\n")
  ;;           (insert "Headlines with TAGS match: ")
  ;;           (add-text-properties (point-min) (1- (point))
  ;;                                (list 'face 'org-agenda-structure
  ;;                                      'short-heading
  ;;                                      (concat "Match: " match)))
  ;;           (setq pos (point))
  ;;           (insert match "\n")
  ;;           (add-text-properties pos (1- (point)) (list 'face 'org-warning))
  ;;           (setq pos (point))
  ;;           (unless org-agenda-multi
  ;;             (insert "Press `C-u r' to search again with new search string\n"))
  ;;           (add-text-properties pos (1- (point)) (list 'face 'org-agenda-structure)))
  ;;         (org-agenda-mark-header-line (point-min))
  ;;         (when rtnall
  ;;           (insert (mapconcat 'identity rtnall "\n") ""))
  ;;         (goto-char (point-min))
  ;;         (or org-agenda-multi (org-agenda-fit-window-to-buffer))
  ;;         (add-text-properties (point-min) (point-max)
  ;;                              `(org-agenda-type tags
  ;;                                                org-last-args (,todo-only ,match)
  ;;                                                org-redo-cmd ,org-agenda-redo-command
  ;;                                                org-series-cmd ,org-cmd))
  ;;         (org-agenda-finalize)
  ;;         (setq buffer-read-only t)))))
  (defun spolakh/org-current-is-first-level-headline ()
    (= 1 (org-current-level)))
  (defun spolakh/org-current-is-todo ()
    (or (string= "TODO" (org-get-todo-state))))
  (defun spolakh/org-current-is-scheduled ()
	      (re-search-forward org-scheduled-time-regexp (line-end-position 2) t)
    )

  ; org-with-limited-levels?
  ; org-current-level
  (defun spolakh/org-agenda-leave-only-first-three-children ()
  "Returns each 1st level heading and at most 3 of it's TODO subheadings"
  (let (should-skip-entry)
    (unless (spolakh/org-current-is-todo)
      (setq should-skip-entry t))
    (if (spolakh/org-current-is-scheduled)
        (setq should-skip-entry t))
    (save-excursion
      (let ((nth-task 1))
      (while (and (<= nth-task 3) (org-goto-sibling t))
        (when (spolakh/org-current-is-todo)
          (setq nth-task (+ nth-task 1))))
      (when (> nth-task 3)
        (setq should-skip-entry t))))
    (when (spolakh/org-current-is-first-level-headline)
      (setq should-skip-entry t))
    (when (> (org-current-level) 2)
      (setq should-skip-entry t))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))
  (defun spolakh/org-agenda-leave-first-level-only ()
    (when (not (spolakh/org-current-is-first-level-headline))
      (or (outline-next-heading)
          (goto-char (point-max))))
    )
  :config
(defun spolakh/project-agenda-section-for-filter (filter)
    `(tags-todo ,(concat "TODO=\"TODO\"" filter)
                                          ((org-agenda-overriding-header ,(concat "🚀 Projects (" filter "): MAX 4 >"))
                                          (org-agenda-hide-tags-regexp "")
                                          (org-agenda-prefix-format
                                           '((tags . "")))
                                          (org-agenda-skip-function #'spolakh/org-agenda-leave-first-level-only)
                                          (org-agenda-files
                                                              '(
                                                                ,(concat spolakh/org-agenda-directory "projects.org")
                                                                  ))))
    )
  (defun spolakh/agenda-for-filter (filter)
    `((agenda ""
            ((org-agenda-span 2)
             (org-agenda-start-day "today")
             (org-agenda-start-on-weekday nil)
             (org-deadline-warning-days 14)))
    (todo "TODO"
          ((org-agenda-overriding-header "📤 To Refile >")
           (org-agenda-files '(,(concat spolakh/org-agenda-directory "inbox.org")
                               ,(concat spolakh/org-directory "phone.org")
                               ,(concat spolakh/org-directory "ipad.org")
                               ))
           (org-agenda-max-entries 10)))
    (todo "Idea"
          ((org-agenda-overriding-header "🔖 to Finalize into Permanent Notes >")
           (org-agenda-files (append
                              (find-lisp-find-files spolakh/org-dailies-directory "\.org$")
                              '(
                                ,(concat spolakh/org-agenda-directory "inbox.org")
                                ,(concat spolakh/org-directory "phone.org")
                                ,(concat spolakh/org-directory "ipad.org")
                                )
                               ))
           (org-agenda-max-entries 5)))
    (tags-todo ,(concat "TODO=\"TODO\"" filter)
          ((org-agenda-overriding-header "🚀 Projects >")
          (org-agenda-files '(,(concat spolakh/org-agenda-directory "projects.org")))
          (org-agenda-skip-function #'spolakh/org-agenda-leave-only-first-three-children)
          (org-agenda-hide-tags-regexp "")
          ))
    (tags-todo ,(concat "TODO=\"WAITING\"" filter)
          ((org-agenda-overriding-header "🌒 Waiting >")
          (org-agenda-hide-tags-regexp "")
          ))
    ;; (spolakh/org-agenda-projects-and-tasks "+PROJECT"
    ;;  ((org-agenda-max-entries 3)
    ;;   (org-agenda-files '(,(concat spolakh/org-agenda-directory "projects.org")))))
    (tags-todo ,(concat "TODO=\"TODO\"" filter)
          ((org-agenda-overriding-header "👾 One-off Tasks (under 1 Pomodoro) >")
          (org-agenda-files '(,(concat spolakh/org-agenda-directory "oneoff.org")))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
          (org-agenda-hide-tags-regexp "")
          ))))
  (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s%b")
        (todo . "[%-4e] %?-17b")
        (tags . "[%-4e] %-17(org-format-outline-path (org-get-outline-path))")
        (search . "[%-4e] %?-17b")))
  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
  (add-to-list 'org-global-properties
         '("Effort_ALL". "100:00 0:15 0:30 1:00 2:00"))
  (setq org-agenda-custom-commands `(
                                     ("m" "Agenda" ,(spolakh/agenda-for-filter "+@mine"))
                                     ("w" "Work Agenda" ,(spolakh/agenda-for-filter "+@work"))
                                     ("l" "Lily" ,(spolakh/agenda-for-filter "+Lily"))
                                     ("i" "Ideas (full list)" (
                                    (todo "Idea"
                                          ((org-agenda-overriding-header "🔖 to Finalize into Permanent Notes >")
                                          (org-agenda-files (append
                                                              (find-lisp-find-files spolakh/org-dailies-directory "\.org$")
                                                              '(
                                                                ,(concat spolakh/org-agenda-directory "inbox.org")
                                                                ,(concat spolakh/org-directory "phone.org")
                                                                ,(concat spolakh/org-directory "ipad.org")
                                                                )))))))
                                    ("r" "Repeaters (Non-Scheduled)" (
                                      (todo "TODO"
                                          ((org-agenda-overriding-header "Unscheduled Repeaters")
                                           (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                                          (org-agenda-files
                                                              '(
                                                                ,(concat spolakh/org-agenda-directory "repeaters.org")
                                                                  ))))))
                                    ("?" "What feels important now?" (
                                                                       ,(spolakh/project-agenda-section-for-filter "+@mine")
                                                                       ,(spolakh/project-agenda-section-for-filter "+@work")
                                                                       ,(spolakh/project-agenda-section-for-filter "+Lily")
                                                                       ,(spolakh/project-agenda-section-for-filter "-Lily-@work-@mine")
                                                                       ))
                                     ))
  (defun spolakh/switch-to-agenda ()
    (interactive)
    (org-agenda nil "m")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (defun spolakh/switch-to-lily-agenda ()
    (interactive)
    (org-agenda nil "l")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (defun spolakh/switch-to-work-agenda ()
    (interactive)
    (org-agenda nil "w")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (defun spolakh/switch-to-ideas-agenda ()
    (interactive)
    (org-agenda nil "i")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (defun spolakh/switch-to-repeaters-agenda ()
    (interactive)
    (org-agenda nil "r")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (defun spolakh/switch-to-weekly-agenda ()
    (interactive)
    (org-agenda nil "?")
    (spolakh/org-agenda-find-beginning-of-inbox)
    )
  (map! :map org-mode-map :leader
        (:prefix ("n" . "Notes") "a" nil)
        (:prefix ("a" . "Agenda")
         :desc "Agenda" "m" #'spolakh/switch-to-agenda
         :desc "Lily" "l" #'spolakh/switch-to-lily-agenda
         :desc "Ideas" "i" #'spolakh/switch-to-ideas-agenda
         :desc "Repeaters (Non-Scheduled)" "r" #'spolakh/switch-to-repeaters-agenda
         :desc "What feels important now?" "?" #'spolakh/switch-to-weekly-agenda
         :desc "Work Agenda" "w" #'spolakh/switch-to-work-agenda))
  (defun spolakh/org-fast-effort-selection ()
    "Modification of `org-fast-todo-selection' for use with org-set-effert. Select an effort value with single keys.
      Returns the new effort value, or nil if no state change should occur.
      Motivated by https://emacs.stackexchange.com/questions/59424/org-set-effort-fast-effort-selection"
    ;; Format effort values into an alist keyed by index
    (let* ((fulltable (seq-map-indexed (lambda (e i) (cons (car e) (string-to-char (int-to-string i))))
                                      (org-property-get-allowed-values nil org-effort-property t)))
          (maxlen (apply 'max (mapcar
                                (lambda (x)
                                  (if (stringp (car x)) (string-width (car x)) 0))
                                fulltable)))
          (expert (equal org-use-fast-todo-selection 'expert))
          (prompt "")
          (fwidth (+ maxlen 3 1 3))
          (ncol (/ (- (window-width) 4) fwidth))
          tg cnt e c tbl subtable)
      (save-excursion
        (save-window-excursion
          (if expert
              (set-buffer (get-buffer-create " *Org effort"))
            (delete-other-windows)
            (set-window-buffer (split-window-vertically) (get-buffer-create " *Org effort*"))
            (org-switch-to-buffer-other-window " *Org effort*"))
          (erase-buffer)
          (setq tbl fulltable cnt 0)
          (while (setq e (pop tbl))
            (setq tg (car e)
                  c (cdr e))
            (print (char-to-string c))
            (when (and (= cnt 0))
              (insert "  "))
            (setq prompt (concat prompt "[" (char-to-string c) "] " tg " "))
            (insert "[" c "] " tg (make-string
                                  (- fwidth 4 (length tg)) ?\ ))
            (when (and (= (setq cnt (1+ cnt)) ncol)
                      ;; Avoid lines with just a closing delimiter.
                      (not (equal (car tbl) '(:endgroup))))
              (insert "\n")
              (setq cnt 0)))
          (insert "\n")
          (goto-char (point-min))
          (unless expert (org-fit-window-to-buffer))
          (message (concat "[1-9..]:Set [SPC]:clear"
                          (if expert (concat "\n" prompt) "")))
          (setq c (let ((inhibit-quit t)) (read-char-exclusive)))
          (setq subtable (nreverse subtable))
          (cond
          ((or (= c ?\C-g)
                (and (= c ?q) (not (rassoc c fulltable))))
            (setq quit-flag t))
          ((= c ?\ ) nil)
          ((setq e (or (rassoc c subtable) (rassoc c fulltable))
                  tg (car e))
            tg)
          (t (setq quit-flag t)))))))
  (defun spolakh/invoke-fast-effort-selection ()
    (interactive)
      (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
        (org-agenda-error)))
      (buffer (marker-buffer hdmarker))
      (pos (marker-position hdmarker))
      (inhibit-read-only t)
      newhead)
      (org-with-remote-undo buffer
       (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (org-set-effort nil (spolakh/org-fast-effort-selection))
        (end-of-line 1)
        (setq newhead (org-get-heading)))
        (org-agenda-change-all-lines newhead hdmarker)))
  )
  (defun spolakh/org-agenda-next-section ()
    (interactive)
    (forward-char)
    (re-search-forward ">$" nil 1)
    (let ((current-prefix-arg '(4))) (call-interactively 'recenter-top-bottom))
    )
  (defun spolakh/org-agenda-previous-section ()
    (interactive)
    (backward-char)
    (re-search-backward ">$" nil 1)
    (let ((current-prefix-arg '(4))) (call-interactively 'recenter-top-bottom))
    )
  (defvar spolakh/org-agenda-process-inbox-do-bulk nil)
  (defun spolakh/org-agenda-refile ()
     (advice-remove 'org-store-log-note #'spolakh/org-agenda-refile)
     (switch-to-buffer "*Org Agenda*")
     (org-agenda-refile nil nil nil)
     (if (looking-at ".*>$") (setq spolakh/org-agenda-process-inbox-do-bulk nil))
     (if spolakh/org-agenda-process-inbox-do-bulk (spolakh/org-agenda-process-inbox-item))
     )
  (defun spolakh/org-agenda-process-inbox-item ()
    ;; "process a single item in the org-agenda."
    (interactive)
     (org-with-wide-buffer
       (beginning-of-line)
       (if spolakh/org-agenda-process-inbox-do-bulk
           (let ((current-prefix-arg 0)) (call-interactively 'recenter-top-bottom)))
       (advice-add 'org-store-log-note :after #'spolakh/org-agenda-refile)
       (org-agenda-set-tags)
       (spolakh/invoke-fast-effort-selection)
       (org-agenda-add-note)
       (org-add-log-note)
     )
  )
  (defun spolakh/org-agenda-process-single-inbox-item ()
    (interactive)
    (setq spolakh/org-agenda-process-inbox-do-bulk nil)
    (spolakh/org-agenda-process-inbox-item))
  (defun spolakh/org-agenda-find-beginning-of-inbox ()
    (beginning-of-buffer)
    (spolakh/org-agenda-next-section)
    (next-line)
    (point)
    )
  (defun spolakh/org-agenda-bulk-process-inbox ()
    (interactive)
    (spolakh/org-agenda-find-beginning-of-inbox)
    (setq spolakh/org-agenda-process-inbox-do-bulk t)
    (spolakh/org-agenda-process-inbox-item)
     )

  ; This makes org-agenda integration w/ mobile capture (Orgzly) work without conflicts
  ; (in tandem with adding ((nil . ((eval . (auto-revert-mode 1))))) into .dir-locals.el in gtd directory)
  (setq auto-save-timeout 1
      auto-save-default t
      auto-save-visited-file-name t
      auto-revert-use-notify nil
      auto-revert-interval 1)
  (defun spolakh/org-agenda-redo ()
    (interactive)
    (with-current-buffer "*Org Agenda*"
      (org-agenda-maybe-redo)))
  (add-hook 'after-revert-hook #'spolakh/org-agenda-redo)

  ; http://pragmaticemacs.com/emacs/reorder-todo-items-in-your-org-mode-agenda/
  (defun spolakh/org-headline-to-top ()
  "Move the current org headline to the top of its section"
  (interactive)
  ;; check if we are at the top level
  (let ((lvl (org-current-level)))
    (cond
     ;; above all headlines so nothing to do
     ((not lvl)
      (message "No headline to move"))
     ((= lvl 1)
      ;; if at top level move current tree to go above first headline
      (org-cut-subtree)
      (beginning-of-buffer)
      ;; test if point is now at the first headline and if not then
      ;; move to the first headline
      (unless (looking-at-p "*")
        (org-next-visible-heading 1))
      (org-paste-subtree))
     ((> lvl 1)
      ;; if not at top level then get position of headline level above
      ;; current section and refile to that position. Inspired by
      ;; https://gist.github.com/alphapapa/2cd1f1fc6accff01fec06946844ef5a5
      (let* ((org-reverse-note-order t)
             (pos (save-excursion
                    (outline-up-heading 1)
                    (point)))
             (filename (buffer-file-name))
             (rfloc (list nil filename nil pos)))
        (org-refile nil nil rfloc))))))
    (defun spolakh/org-agenda-parent-to-top ()
      "Same as 'spolakh/org-agenda-item-to-top but for the parent of the current item"
      (interactive)
      (org-save-all-org-buffers)
      (org-agenda-switch-to)
      (outline-up-heading 1)
      (spolakh/org-headline-to-top)
      (switch-to-buffer "*Org Agenda*")
      (org-agenda-redo)
    )
    (defun spolakh/org-agenda-item-to-top ()
    "Move the current agenda item to the top of the subtree in its file"
      (interactive)
      ;; save buffers to preserve agenda
      (org-save-all-org-buffers)
      ;; switch to buffer for current agenda item
      (org-agenda-switch-to)
      ;; move item to top
      (spolakh/org-headline-to-top)
      ;; go back to agenda view
      (switch-to-buffer "*Org Agenda*")
      ;; refresh agenda
      (org-agenda-redo)
    )
)

(use-package! org-gcal
  :init
  ;; Storing my creds in a secret file so I don't commit them here.
  (require 'json)
  (defun get-gcal-config-value (key)
    "Return the value of the json file gcal_secret for key"
    (cdr (assoc key (json-read-file "~/Dropbox/code/credentials/gcal.json")))
    )

  (setq org-gcal-client-id (get-gcal-config-value 'org-gcal-client-id)
        org-gcal-client-secret (get-gcal-config-value 'org-gcal-client-secret)
        org-gcal-file-alist `(
                              (,(get-gcal-config-value 'calendar-id) .  ,(concat spolakh/org-agenda-directory "gcal.org"))
                              (,(get-gcal-config-value 'work-calendar-id) .  ,(concat spolakh/org-agenda-directory "gcal-grail.org"))
                              )
        org-gcal-remove-api-cancelled-events t
        org-gcal-update-cancelled-events-with-todo nil
        org-gcal-remove-events-with-cancelled-todo t
        org-gcal-up-days 7
        org-gcal-down-days 7
        org-gcal-notify-p nil
        org-gcal-auto-archive nil

        )
  :config
    ;; org-gcal exclude declined events
    (defun cce/filter-gcal-event-declined (event)
      "Function for [org-gcal-fetch-event-filters]."
      (let* ((case-fold-search t)
            (attendees (plist-get event :attendees))
            (my-response (when attendees
                            (cl-reduce (lambda (last next)
                                      (if (plist-get next :self) next last))
                                    attendees
                                    :initial-value nil))))
        (cond ((string-match "office hour" (plist-get event :summary))
              nil)
              ((string-equal (plist-get my-response :responseStatus) "declined")
              nil)
              (t t))))

    (add-to-list 'org-gcal-fetch-event-filters 'cce/filter-gcal-event-declined)
    (defun spolakh/wipe-work-gcal-and-refetch ()
      (interactive)
      ;(with-current-buffer
      ;    (find-file-noselect (concat spolakh/org-agenda-directory "gcal-grail.org"))
      ;  (erase-buffer)
      ;  (save-buffer))
      (call-interactively #'org-gcal-fetch)
      (message "org-gcal-fetch finished"))
    (run-with-idle-timer 60 t 'spolakh/wipe-work-gcal-and-refetch)
)


; ORG-ROAM:

(use-package! org-roam
  :init
  (setq org-roam-directory "~/Dropbox/org")
  (setq org-roam-link-title-format "[[%s]]")
  (setq org-roam-index-file "~/Dropbox/org/index.org")
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+TITLE: ${title}\n#+CREATED: [%<%Y-%m-%d %a %H:%M>]\n\n* Indexes\n* "
           :unnarrowed t)))
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain (function org-roam-capture--get-point)
           ""
           :immediate-finish t
           :file-name "private/dailies/%<%Y-%m-%d>"
           :head "#+title: %<%Y-%m-%d>"))
        )
  (map! :map org-roam-mode-map
        :leader
        (:prefix ("n" . "notes")
         (:prefix ("r" . "roam")
          :desc "Entrypoint" "e" 'org-roam-jump-to-index
          :desc "Insert a link to a Note" "l" 'org-roam-insert
          )))
  (map!
   (:map global-map
    "M-z" "Ω"
    "M-6" "§"
    "M-5" "∞"
    ))
  )
