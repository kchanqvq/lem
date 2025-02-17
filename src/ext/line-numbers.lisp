(defpackage :lem/line-numbers
  (:use :cl :lem)
  (:export :*relative-line*
           :line-numbers-attribute
           :line-numbers
           :toggle-line-numbers)
  #+sbcl
  (:lock t))
(in-package :lem/line-numbers)

(defparameter *relative-line* nil)

(defvar *initialized* nil)
(defvar *line-number-format* nil)

(define-attribute line-numbers-attribute
  (t :foreground :base07 :background :base01))

(define-editor-variable line-numbers nil ""
  (lambda (value)
    (line-numbers-mode value)))

(define-minor-mode line-numbers-mode
    (:name "Line numbers"
     :global t))

(define-command toggle-line-numbers () ()
  (line-numbers-mode))

(defun compute-line (buffer point)
  (if *relative-line*
      (let* ((cursor-line (line-number-at-point (buffer-point buffer)))
             (line (line-number-at-point point)))
        (if (= cursor-line line)
            line
            (abs (- cursor-line line))))
      (line-number-at-point point)))

(defmethod lem-core:compute-left-display-area-content ((mode line-numbers-mode) buffer point)
  (when (buffer-filename (point-buffer point))
    (let* ((string (format nil "~6D " (compute-line buffer point))))
      (lem-base::make-content :string string
                              :attributes `((0 ,(length string) line-numbers-attribute))))))
