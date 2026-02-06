;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; =============================================================================
;; Python Virtual Environment Configuration
;; =============================================================================
;; Automatically detects .venv directories and configures LSP servers:
;; - Pyright: completions and go-to-definition
;; - Ruff: linting and formatting
;; - Ty: type checking (optional)

(after! python
  ;; Load pyvenv for virtual environment management
  (require 'pyvenv)

  (defun +python/find-venv-root ()
    "Find the git repository root if it contains a .venv directory."
    (when-let* ((git-root (locate-dominating-file default-directory ".git"))
                (venv-path (expand-file-name ".venv" git-root)))
      (when (file-directory-p venv-path)
        (expand-file-name git-root))))

  (defun +python/auto-activate-project-venv ()
    "Auto-activate .venv virtualenv and configure all LSP servers."
    (when-let* ((root (+python/find-venv-root))
                (venv (expand-file-name ".venv" root))
                (venv-python (expand-file-name "bin/python" venv)))
      (when (file-directory-p venv)
        ;; Only activate if not already in this venv
        (unless (and pyvenv-virtual-env
                     (string= (file-truename pyvenv-virtual-env)
                              (file-truename venv)))
          (pyvenv-activate venv))

        ;; Configure Python shell
        (setq-local python-shell-interpreter venv-python)
        (setq-local python-shell-virtualenv-root venv)

        ;; Pyright - completions and go-to-definition
        (setq-local lsp-pyright-python-executable-cmd venv-python)
        (setq-local lsp-pyright-venv-path root)

        ;; Ruff - linting and formatting
        (setq-local lsp-ruff-python-path venv-python)
        (when-let* ((venv-ruff (expand-file-name "bin/ruff" venv))
                    (_ (file-executable-p venv-ruff)))
          (setq-local lsp-ruff-server-command `(,venv-ruff "server")))

        ;; Ty - type checking (optional)
        (when-let* ((venv-ty (expand-file-name "bin/ty" venv))
                    (_ (file-executable-p venv-ty)))
          (setq-local lsp-python-ty-clients-server-command
                      `(,venv-ty "server" "--python" ,venv-python))))))

  ;; Disable pyvenv tracking (avoids WORKON_HOME errors)
  (setq pyvenv-tracking-mode nil)

  ;; Run for both python-mode and python-ts-mode
  (add-hook! '(python-mode-local-vars-hook python-ts-mode-local-vars-hook)
             #'+python/auto-activate-project-venv)

  (add-hook! '(python-mode-local-vars-hook python-ts-mode-local-vars-hook)
    (defun +python/refresh-modeline ()
      (force-mode-line-update)))

  )

;; Add this to your config to update modeline after venv activation

;; =============================================================================
;; Pyright Configuration
;; =============================================================================
;; Use pyright only for completions and navigation, not diagnostics

(after! lsp-pyright
  ;; Disable pyright diagnostics (we use ruff for linting)
  (setq lsp-pyright-diagnostic-mode "off")

  ;; Set project root based on .venv location
  (put 'pyright 'lsp-project-root-fn
       (lambda (path)
         (when-let* ((dir (locate-dominating-file path ".venv")))
           (expand-file-name dir)))))

;; =============================================================================
;; LSP Project Root Configuration
;; =============================================================================
;; Anchor LSP workspace roots to the directory containing .venv

(after! lsp-ruff
  (put 'ruff 'lsp-project-root-fn
       (lambda (path)
         (when-let* ((dir (locate-dominating-file path ".venv")))
           (expand-file-name dir)))))

(after! lsp-python-ty
  (put 'ty-ls 'lsp-project-root-fn
       (lambda (path)
         (when-let* ((dir (locate-dominating-file path ".venv")))
           (expand-file-name dir)))))

;; =============================================================================
;; Flycheck Configuration
;; =============================================================================
;; Disable flycheck Python checkers (we use LSP for diagnostics)

(after! flycheck
  (setq-default flycheck-disabled-checkers
                '(python-flake8 python-pycompile python-pylint python-mypy)))

(add-hook! 'python-ts-mode-hook
  (defun +python/disable-flycheck ()
    (flycheck-mode -1)))

;; =============================================================================
;; LSP UI & Documentation Display
;; =============================================================================
;; - Breadcrumb navigation in header (shows: module > class > function)
;; - Disable file watchers (improves performance on large projects)
;; - Route signature help to eldoc buffer instead of minibuffer
;; - SPC c h toggles persistent documentation panel at bottom

(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t
        lsp-enable-file-watchers nil
        ;; Enable lsp-signature (the posframe)
        lsp-signature-auto-activate t
        lsp-signature-mode t
        lsp-signature-render-documentation nil
        ;; Enable eldoc integration
        lsp-eldoc-enable-hover nil
        lsp-eldoc-render-all nil
        lsp-disabled-clients '(semgrep-ls)
        ))

;; Eldoc settings
(setq eldoc-echo-area-use-multiline-p t
      eldoc-echo-area-prefer-doc-buffer t
      max-mini-window-height 0.4)

(set-popup-rule! "^\\*eldoc" :side 'bottom :size 0.3 :select nil :quit nil :ttl nil)

(map! :leader
      :desc "Eldoc buffer" "c h"
      #'eldoc-doc-buffer)

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-header t
        lsp-ui-doc-position 'top
        lsp-ui-doc-max-height 30))

;; =============================================================================
;; Disable warnings for work tags file.
;; =============================================================================
(setq large-file-warning-threshold 200000000)  ;; 200MB threshold

;; =============================================================================
;; Custom Keybindings
;; =============================================================================

;; Open cheatsheet
(map! :leader
      :desc "Cheatsheet" "o c"
      (cmd! (find-file "~/org/doom-cheatsheet.org")))

;; =============================================================================
;; emacs-pr-review configuration
;; =============================================================================
(setq auth-sources '("~/.authinfo"))
(evil-ex-define-cmd "prr" #'pr-review)
(evil-ex-define-cmd "prs" #'pr-review-search)
(evil-ex-define-cmd "prn" #'pr-review-notification)
(add-to-list 'browse-url-default-handlers
             '(pr-review-url-parse . pr-review-open-url));;


;; =============================================================================
;; PR Review Custom Functions
;; =============================================================================

(defun +pr-review/current-repo-open-prs ()
  "Search for open PRs in the current buffer's repository."
  (interactive)
  (if-let* ((default-directory (or (locate-dominating-file default-directory ".git")
                                   default-directory))
            (remote (string-trim (shell-command-to-string "git remote get-url origin")))
            (repo (cond
                   ;; git@github.com:owner/repo.git
                   ((string-match "git@github\\.com:\\(.+/.+\\)\\.git" remote)
                    (match-string 1 remote))
                   ;; git@github.com:owner/repo (no .git)
                   ((string-match "git@github\\.com:\\(.+/.+\\)$" remote)
                    (match-string 1 remote))
                   ;; https://github.com/owner/repo.git
                   ((string-match "github\\.com/\\(.+/.+\\)\\.git" remote)
                    (match-string 1 remote))
                   ;; https://github.com/owner/repo (no .git)
                   ((string-match "github\\.com/\\(.+/.+\\)$" remote)
                    (match-string 1 remote)))))
      (pr-review-search (format "is:pr archived:false is:open repo:%s base:master" repo))
    (user-error "Could not determine GitHub repository from current buffer")))

(defun +pr-review/current-repo-my-reviews ()
  "Search for PRs requesting my review in the current buffer's repository."
  (interactive)
  (if-let* ((default-directory (or (locate-dominating-file default-directory ".git")
                                   default-directory))
            (remote (string-trim (shell-command-to-string "git remote get-url origin")))
            (repo (cond
                   ((string-match "git@github\\.com:\\(.+/.+\\)\\.git" remote)
                    (match-string 1 remote))
                   ((string-match "git@github\\.com:\\(.+/.+\\)$" remote)
                    (match-string 1 remote))
                   ((string-match "github\\.com/\\(.+/.+\\)\\.git" remote)
                    (match-string 1 remote))
                   ((string-match "github\\.com/\\(.+/.+\\)$" remote)
                    (match-string 1 remote)))))
      (pr-review-search (format "is:pr archived:false user-review-requested:@me is:open repo:%s base:master" repo))
    (user-error "Could not determine GitHub repository from current buffer")))

(map! :leader
      :prefix ("G" . "GitHub")
      :desc "This Repo Open PRs" "p" #'+pr-review/current-repo-open-prs
      :desc "This Repo My Reviews" "r" #'+pr-review/current-repo-my-reviews
      :desc "PR Notifications" "n" #'pr-review-notification
      :desc "Open PR by URL" "o" #'pr-review)

(defun +pr-review/open-in-vsplit ()
  "Open PR at point in a vertical split to the right."
  (interactive)
  (let ((current-window (selected-window)))
    (select-window (split-window-right))
    (pr-review-listview-open)))

(defun +pr-review/open-in-hsplit ()
  "Open PR at point in a horizontal split below."
  (interactive)
  (let ((current-window (selected-window)))
    (select-window (split-window-below))
    (pr-review-listview-open)))

;; Add to pr-review-listview-mode (the search results buffer)
(map! :map pr-review-listview-mode-map
      :n "s" #'+pr-review/open-in-hsplit
      :n "v" #'+pr-review/open-in-vsplit)

;; =============================================================================
;; channge leader key to what I use in vim
;; =============================================================================
(setq doom-leader-key "\\"
      doom-localleader-key "\\")
