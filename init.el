(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(setq just-say-yes t)

;; Auto install packages
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not"
  (mapcar
   (lambda (package)
     (if
	 (package-installed-p package)
         nil
         (package-install package)
	 (if (or just-say-yes (y-or-n-p (format "Package %s is missing. Install it? " package)))
           (package-install package)
         package)
       ))
   packages))

(ensure-package-installed
 'multiple-cursors
 'smartparens
 'rainbow-delimiters
 'rainbow-mode
 'undo-tree
 'smex
 'ido-ubiquitous
 'powerline
 'company
 'smooth-scrolling
 'find-file-in-project
 'exec-path-from-shell 
 'magit
 )

;(dolist (key '("\C-a" "\C-b" "\C-c" "\C-d" "\C-e" "\C-f"
;               "\C-h" "\C-k" "\C-l" "\C-n" "\C-o" "\C-p" "\C-q"
;               "\C-t" "\C-u" "\C-v" "\C-x" "\C-z"))
;  (global-unset-key key))

;; A package for getting the PATH when starting emacs via OSX (not from terminal)
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Startup
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
;; (set-frame-parameter nil 'fullscreen 'fullboth)

;; Little modes and fixes
(delete-selection-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0)

;looks poop on edge
(set-fringe-mode 0)

(hl-line-mode -1)

(setq truncate-lines nil)
(setq ring-bell-function 'ignore)
(setq initial-scratch-message "")
(setq undo-limit 999999)

(setq compilation-ask-about-save nil)

(setq make-backup-files nil)

(setq ns-pop-up-frames nil) ;; open files in same frame (don't create new separate ones)

(defalias 'yes-or-no-p 'y-or-n-p)

(defadvice split-window (after move-point-to-new-window activate)
  "Moves the point to the newly created window after splitting."
  (other-window 1))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(desktop-save-mode 1) ; reopen buffers from last session

;(provide 'my-fix-defaults)

;LOOK 'N FEEL


; Theme and font
;(load-theme 'Striptease)
(set-face-attribute 'default nil :height 190)
(let ((font "Source Code Pro")) ;; "Monaco" / "Menlo" / "Hasklig" / "Fira"
  (when (member font (font-family-list))
    (set-face-attribute 'default nil :font font)))

;; Window size and position
(setq-default left-margin-width 0 right-margin-width 0)
;;(when window-system (set-frame-size (selected-frame) 90 38))

;; Cursor
(setq cursor-type 'bar)
(setq-default cursor-type 'bar)

;; Line numbers
(require 'linum)
(global-linum-mode 1)
(setq linum-format (quote "%4d  "))

(add-hook 'prog-mode-hook 'rainbow-mode)

;; Mouse wheel
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Smooth scrolling
(require 'smooth-scrolling)
(setq smooth-scroll-margin 5)

;; Scroll
;; (setq redisplay-dont-pause t
;;       scroll-margin 1
;;       scroll-step 10
;;       scroll-conservatively 10000
;;       scroll-preserve-screen-position 1)

;; Ibuffer (buffer switcher)
(setq ibuffer-formats 
      '((mark modified read-only " "
              (name 30 30 :left :elide) ; change: 30s were originally 18s
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

;; make ibuffer refresh automatically
(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode 1)))

;; ibuffer groups
(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Magit" (name . "\*magit"))
	 ("Dired" (mode . dired-mode))
	 ("Emacs" (or (mode . help-mode)
		      (name . "\*"))))))

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))

(setq ibuffer-show-empty-filter-groups nil)


;; Ido
(ido-mode 1)
(ido-ubiquitous 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-case-fold  t)

;; Smex (Ido completition for M-x menu)
(global-set-key (kbd "M-x") (lambda ()
                             (interactive)
                             (or (boundp 'smex-cache)
                                 (smex-initialize))
                             (global-set-key [(meta x)] 'smex)
                             (smex)))

;; Undo Tree
(undo-tree-mode 1)
(global-set-key (kbd "C-x C-z") 'undo-tree-visualize)

;; Auto complete
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "<C-escape>") 'company-search-mode)
;;(global-set-key (kbd "TAB") #'company-complete)
(setq company-tooltip-align-annotations t)
(setq company-minimum-prefix-length 3)
(setq company-idle-delay 0.4)


;; Switch to new window when using help
(defadvice describe-key (after move-point-to-new-window activate)
  (other-window 1))

(defadvice describe-function (after move-point-to-new-window activate)
  (other-window 1))

(defadvice describe-variable (after move-point-to-new-window activate)
  (other-window 1))

(defadvice describe-mode (after move-point-to-new-window activate)
  (other-window 1))

(defadvice find-commands-by-name (after move-point-to-new-window activate)
  (other-window 1))

;; Function for finding out info about font at cursor
(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))


;; Mouse wheel
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Smooth scrolling
(require 'smooth-scrolling)
(setq smooth-scroll-margin 5)

;; Scroll
;; (setq redisplay-dont-pause t
;;       scroll-margin 1
;;       scroll-step 10
;;       scroll-conservatively 10000
;;       scroll-preserve-screen-position 1)

;; Ibuffer (buffer switcher)
(setq ibuffer-formats 
      '((mark modified read-only " "
              (name 30 30 :left :elide) ; change: 30s were originally 18s
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

;; make ibuffer refresh automatically
(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode 1)))

;; ibuffer groups
(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Magit" (name . "\*magit"))
	 ("Dired" (mode . dired-mode))
	 ("Emacs" (or (mode . help-mode)
		      (name . "\*"))))))

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))

(setq ibuffer-show-empty-filter-groups nil)


;; Ido
(ido-mode 1)
(ido-ubiquitous 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-case-fold  t)

;; Smex (Ido completition for M-x menu)
(global-set-key (kbd "M-x") (lambda ()
                             (interactive)
                             (or (boundp 'smex-cache)
                                 (smex-initialize))
                             (global-set-key [(meta x)] 'smex)
                             (smex)))

;; Undo Tree
(undo-tree-mode 1)
(global-set-key (kbd "C-x C-z") 'undo-tree-visualize)

;; Auto complete
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "<C-escape>") 'company-search-mode)
;;(global-set-key (kbd "TAB") #'company-complete)
(setq company-tooltip-align-annotations t)
(setq company-minimum-prefix-length 3)
(setq company-idle-delay 0.4)

;; Let me write these characters, plx
(global-set-key (kbd "M-2") "@")
(global-set-key (kbd "M-4") "$")
(global-set-key (kbd "M-8") "[")
(global-set-key (kbd "M-9") "]")
(global-set-key (kbd "M-(") "{")
(global-set-key (kbd "M-)") "}")
(global-set-key (kbd "M-7") "|")
(global-set-key (kbd "M-/") "\\")
(global-set-key (kbd "C-x M-l") "λ")

;; "better" keys
(global-set-key (kbd "s-b") 'ibuffer)
(global-set-key (kbd "C-x C-f") 'ido-find-file)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "s-w") 'kill-this-buffer)
(global-set-key (kbd "s-W") 'delete-window)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "s-/") 'comment-or-uncomment-region)
(global-set-key (kbd "s-i") 'imenu) ; lists the functions in file
(global-set-key (kbd "s-f") 'rgrep) ; search for files
(global-set-key (kbd "s-+") 'enlarge-window)
(global-set-key (kbd "s--") 'shrink-window)
(global-set-key (kbd "M-+") 'enlarge-window-horizontally)
(global-set-key (kbd "M--") 'shrink-window-horizontally)
(global-set-key (kbd "C-<") 'shell)

;; Home/End keyboard shortcuts
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
   Move point to the first non-whitespace character on this line.
   If point was already at that position, move point to beginning of line."
  (interactive "^") ; Use (interactive "^") in Emacs 23 to make shift-select work
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(global-set-key [s-left] 'smart-beginning-of-line)
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key (kbd "C-a") 'smart-beginning-of-line)

(global-set-key [s-right] 'end-of-line)
(define-key global-map [end] 'end-of-line)
(global-set-key (kbd "C-e") 'end-of-line)

(global-set-key [s-up] 'beginning-of-buffer)
(global-set-key [s-down] 'end-of-buffer)

;; Multiple cursors
(require 'multiple-cursors)

(global-set-key (kbd "<s-mouse-1>") 'mc/add-cursor-on-click)

;; Minor mode to ensure key map
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap")
(define-key my-keys-minor-mode-map (kbd "s-d") 'mc/mark-next-like-this)
(define-key my-keys-minor-mode-map (kbd "M-l") 'mc/edit-lines)
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)

(defun move-lines (n)
  (let ((beg) (end) (keep))
    (if mark-active
        (save-excursion
          (setq keep t)
          (setq beg (region-beginning)
                end (region-end))
          (goto-char beg)
          (setq beg (line-beginning-position))
          (goto-char end)
          (setq end (line-beginning-position 2)))
      (setq beg (line-beginning-position)
            end (line-beginning-position 2)))
    (let ((offset (if (and (mark t)
                           (and (>= (mark t) beg)
                                (< (mark t) end)))
                      (- (point) (mark t))))
          (rewind (- end (point))))
      (goto-char (if (< n 0) beg end))
      (forward-line n)
      (insert (delete-and-extract-region beg end))
      (backward-char rewind)
      (if offset (set-mark (- (point) offset))))
    (if keep
        (setq mark-active t
              deactivate-mark nil))))

(defun move-lines-up (n)
  "move the line(s) spanned by the active region up by N lines."
  (interactive "*p")
  (move-lines (- (or n 1))))

(defun move-lines-down (n)
  "move the line(s) spanned by the active region down by N lines."
  (interactive "*p")
  (move-lines (or n 1)))

(global-set-key (kbd "M-<down>") 'move-lines-down)
(global-set-key (kbd "M-<up>") 'move-lines-up)


;; Funktioner för att hantera paranteser
(require 'smartparens)

(define-key sp-keymap (kbd "C-)") 'sp-forward-slurp-sexp)
(define-key sp-keymap (kbd "C-(") 'sp-backward-slurp-sexp)
(define-key sp-keymap (kbd "C-M-)") 'sp-forward-barf-sexp)
(define-key sp-keymap (kbd "C-M-(") 'sp-backward-barf-sexp)

(define-key sp-keymap (kbd "C-M-k") 'sp-kill-sexp)
(define-key sp-keymap (kbd "C-M-w") 'sp-copy-sexp)
(define-key sp-keymap (kbd "C-M-<backspace>") 'sp-unwrap-sexp)

(define-key sp-keymap (kbd "C-M-t") 'sp-transpose-sexp)
(define-key sp-keymap (kbd "C-M-j") 'sp-join-sexp)
(define-key sp-keymap (kbd "C-M-s") 'sp-split-sexp)

(sp-pair "'" nil :actions :rem) ; Don't make the single quote open a pair (smart parens do that by default)


;; Lisp
(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(define-key emacs-lisp-mode-map (kbd "<s-return>") 'eval-defun)


;; MAGIT!!!!!!!!!!!!!!!!!!!!!!!!
(require 'magit)

(setq magit-last-seen-setup-instructions "1.4.0")

;; Got a warning on startup about setting this variable:
(setq magit-auto-revert-mode nil)
(setq magit-push-always-verify nil)

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)	  
(global-set-key (kbd "C-x g") 'magit-status)

