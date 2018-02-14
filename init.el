(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))
(setq package-enable-at-startup nil)

;;-----------------------------------------------------------------------------
;; Turn off start-up message
;;-----------------------------------------------------------------------------
(setq inhibit-startup-message t) 

;;-----------------------------------------------------------------------------
;; Default font 
;;-----------------------------------------------------------------------------
(set-default-font "Monospace 11")

;;-----------------------------------------------------------------------------
;; Tool- and scroll-bars
;;-----------------------------------------------------------------------------

;;turn on/off toolbar
;;(tool-bar-mode nil)

;; turn on/off the menubar
;;(menu-bar-mode nil) 

;; turn on/off scroll bars
(scroll-bar-mode -1)

;;-----------------------------------------------------------------------------
;; Misc
;;-----------------------------------------------------------------------------
;; If we read a compressed file, uncompress it on the fly:
;; (this works with .tar.gz and .tgz file as well)
(auto-compression-mode 1)

;; The following key-binding iconifies a window -- we disable it:
(global-unset-key "\C-x\C-z")

;; Disable binding of C-z to iconify a window.
(global-unset-key "\C-z")

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a timeG
;;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; display date and time always
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time)

;; save minibuffer history
(savehist-mode 1)

;; type "y"/"n" instead of "yes"/"no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Display the time
(display-time)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;; don't beep on error
(setq-default visible-bell t)

;; disable backups completely
(setq backup-inhibited t)

;; turn off word wrap
(setq default-truncate-lines 1)

;; save bookmark when emacs quits
(setq bookmark-save-flag t)

;; show line and column number
(setq line-number-mode t)
(setq column-number-mode t)

;; quickly move between windows (SHIFT-<up,down,left,right>)
(windmove-default-keybindings)
;;(windmove-default-keybindings 'meta)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Use Tab to Indent and Complete
(setq tab-always-indent 'complete)

;; find non ascii characters
(defun occur-non-ascii ()
  "Find any non-ascii characters in the current buffer."
  (interactive)
  (occur "[^[:ascii:]]"))

;; switch between header and source (C-c o)
(setq my-cpp-other-file-search-dirs '("."))

(setq ff-search-directories 'my-cpp-other-file-search-dirs)

(setq-default ff-always-try-to-create nil)

(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

;;-----------------------------------------------------------------------------
;; Font lock
;;-----------------------------------------------------------------------------

;; Use font-lock everywhere.
(global-font-lock-mode t)

;; We have CPU to spare; highlight all syntax categories.
(setq font-lock-maximum-decoration t)

;;-----------------------------------------------------------------------------
;; Highlighting
;;-----------------------------------------------------------------------------

;; Highlight the marked region.
(setq-default transient-mark-mode t)

;; turn on parentheses highlighting
(require 'paren)
(show-paren-mode 1)

;;-----------------------------------------------------------------------------
;; Which function mode - displays the current function name in the mode line
;;-----------------------------------------------------------------------------
(which-function-mode 1)

;;-----------------------------------------------------------------------------
;; SlickCopy - if no text is selected, the copy and cut commands act
;; on the current line instead.
;;-----------------------------------------------------------------------------
(defadvice kill-ring-save (before slick-copy activate compile)
   "When called interactively with no active region, copy single line instead."
   (interactive
    (if mark-active (list (region-beginning) (region-end))
      (message "Copied line")
      (list (line-beginning-position)
 	   (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
   "When called interactively with no active region, kill single line instead."
   (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
 	   (line-beginning-position 2)))))

(defadvice comment-region (before slick-comment activate compile)
   "When called interactively with no active region, comment single line instead."
   (interactive
    (if mark-active (list (region-beginning) (region-end))
      (message "Commented line")
      (list (line-beginning-position)
 	      (line-beginning-position 2)))))

(defadvice uncomment-region (before slick-comment activate compile)
   "When called interactively with no active region, un-comment single line instead."
   (interactive
    (if mark-active (list (region-beginning) (region-end))
      (message "Uncommented line")
      (list (line-beginning-position)
 	      (line-beginning-position 2)))))

;; remove all whitespace and linebreaks when inserting
(defun insert-kill-without-whitespace()
  "Insert last kill without all containing whitespace, linebreaks,
   etc."
  (interactive)
  (insert
   (replace-regexp-in-string "[ \t\n]*" ""
    (substring-no-properties (current-kill 0)))))

;;-----------------------------------------------------------------------------
;; Auto-completion
;;-----------------------------------------------------------------------------
(require 'company)
(setq company-global-modes '(not gud-mode))
(add-hook 'after-init-hook 'global-company-mode)
;; (add-to-list 'company-backends 'company-gtags)
(add-to-list 'company-backends 'company-c-headers)

;;-----------------------------------------------------------------------------
;; toggle code folding
;;-----------------------------------------------------------------------------
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))
(global-set-key (kbd "C-c }") 'toggle-hiding)

;;-----------------------------------------------------------------------------
;; clang-format
;;-----------------------------------------------------------------------------
(require 'clang-format)

;;-----------------------------------------------------------------------------
;; GNU global (gtags)
;;-----------------------------------------------------------------------------
(require 'ggtags)

;;-----------------------------------------------------------------------------
;; ggtags mode for GNU global
;;-----------------------------------------------------------------------------
(setq ggtags-oversize-limit 100000)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)


;;-----------------------------------------------------------------------------
;; GDB
;;-----------------------------------------------------------------------------

;; use gdb-many-windows by default
(setq gdb-many-windows nil)

;; Non-nil means display source file containing the main routine at startup
(setq gdb-show-main nil)

;; Speed up gdb startup
(setq gdb-create-source-file-list nil)

;;-----------------------------------------------------------------------------
;; Makefiles
;;-----------------------------------------------------------------------------

;; Accept more filenames as Makefiles.
(setq auto-mode-alist (cons '("\\.mak" . makefile-mode) auto-mode-alist))


;;-----------------------------------------------------------------------------
;; General coding style
;;-----------------------------------------------------------------------------

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

;;-----------------------------------------------------------------------------
;; C mode
;;-----------------------------------------------------------------------------
(defun my-c-mode-hook ()
  (setq c-basic-offset 2)
  (c-set-offset 'substatement-open '0) ; brackets should be at same indentation level as the statements they open
  (c-set-offset 'inline-open '0) ; inline functions should be at same indentation level as the statements they open
  (c-set-offset 'block-open '+)
  (c-set-offset 'brace-list-open '+)   ; all "opens" should be indented by the c-indent-level
  (c-set-offset 'case-label '+))       ; indent case labels by c-indent-level, too
(add-hook 'c-mode-hook 'my-c-mode-hook)

;;-----------------------------------------------------------------------------
;; C++ mode
;;-----------------------------------------------------------------------------
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(add-hook 'c++-mode-hook
          (lambda () (setq comment-start "/* ") (setq comment-end " */")))


;;-----------------------------------------------------------------------------
;; Compilation
;;-----------------------------------------------------------------------------
;; Helper for compilation. Close the compilation window if
;; there was no error at all. (emacs wiki)
(defun compilation-exit-autoclose (status code msg)
  ;; If M-x compile exists with a 0
  (when (and (eq status 'exit) (zerop code))
    ;; then bury the *compilation* buffer, so that C-x b doesn't go there
    (bury-buffer)
    ;; and delete the *compilation* window
    (delete-window (get-buffer-window (get-buffer "*compilation*"))))
  ;; Always return the anticipated result of compilation-exit-message-function
  (cons msg code))
;; Specify my function (maybe I should have done a lambda function)
(setq compilation-exit-message-function 'compilation-exit-autoclose)


;; (setq split-height-threshold 0)
;; (setq compilation-window-height 10)

;; (defun my-compilation-hook ()
;;   (when (not (get-buffer-window "*compilation*"))
;;     (save-selected-window
;;       (save-excursion
;;         (let* ((w (split-window-vertically))
;;                (h (window-height w)))
;;           (select-window w)
;;           (switch-to-buffer "*compilation*")
;;           (shrink-window (- h compilation-window-height)))))))
;; (add-hook 'compilation-mode-hook 'my-compilation-hook)


(add-to-list 'display-buffer-alist
             '("^\\*compilation\\*" .
               ((display-buffer-reuse-window
                 display-buffer-in-side-window) .
                ((reusable-frames . visible)
                 (side            . bottom)
                 (window-height   . 0.2)))))

(add-to-list 'display-buffer-alist
             '("^\\*grep\\*" .
               ((display-buffer-reuse-window
                 display-buffer-in-side-window) .
                ((reusable-frames . visible)
                 (side            . bottom)
                 (window-height   . 0.2)))))

(add-to-list 'display-buffer-alist
             '("^\\*shell\\*" .
               ((display-buffer-reuse-window
                 display-buffer-in-side-window) .
                ((reusable-frames . visible)
                 (side            . bottom)
                 (window-height   . 0.2)))))

(add-to-list 'display-buffer-alist
             '("^\\*ggtags-global\\*" .
               ((display-buffer-reuse-window
                 display-buffer-in-side-window) .
                ((reusable-frames . visible)
                 (side            . bottom)
                 (window-height   . 0.2)))))

(defun hubmax-quit-bottom-side-windows ()
  "Quit bottom side windows of the current frame."
  (interactive)
  (dolist (window (window-at-side-list))
    (quit-window nil window)))

(global-set-key (kbd "C-c q") #'hubmax-quit-bottom-side-windows)



(defun prev-window ()
   (interactive)
   (other-window -1))

(define-key global-map (kbd "C-x p") 'prev-window)




;;-----------------------------------------------------------------------------
;; load local settings
;;-----------------------------------------------------------------------------
(when (file-exists-p "~/.emacs.d/init.local.el")
  (load-file "~/.emacs.d/init.local.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((TeX-master . "application") (TeX-master . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
