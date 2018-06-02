(in-package :cl-user)

(load-all-patches)

(lw:set-default-character-element-type 'cl:character)

(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(uiop:symbol-call :ql :quickload :lem-capi)

(setq lem-capi::*quit* t)

(defun run-lem ()
  (lem:lem))

(push '("lem" (:priority 60000000 :restart-action :continue) run-lem)
      mp:*initial-processes*)

(save-image "lw-lem"
            :console t
            :multiprocessing t
            :environment nil)
