;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Thread
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :rca.thread)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (1) Threads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: MUTABLE
(defconstant +num-threads+ 1)

;;; Status: MUTABLE
(defconstant +execution-threshold+ 1.0)  ; Units in ms

;;; Status: MUTABLE
(defstruct effect
  (activity (make-activity-info))
  (handoff  (make-cell-data :none))
  (finished nil :type boolean))

;;; Status: MUTABLE
(defstruct program-thread
  (counter 0           :type fixnum)
  (tasks   (cell-defaults))
  (handoff (make-cell-data :none)))

(defun task-name (task)
  (ecase task
    (:default      "Default")
    (:double-value "DoubleValue")))

(defun build-tasks (&key (counter 0) tasks handoff)
  (make-program-thread
   :counter counter
   :tasks   (or tasks (cell-defaults))
   :handoff (or handoff (make-cell-data :none))))

(defun thread-is-finished (pt)
  (>= (program-thread-counter pt) (length (program-thread-tasks pt))))

(defun thread-step (pt ctx)
  "Execute one cell. Returns (values updated-thread effect)."
  (let* ((idx         (program-thread-counter pt))
         (current-cell (nth idx (program-thread-tasks pt)))
         (activity    (make-activity-info
                       :description (task-name (cell-task current-cell))))
         ;; Handoff transfer: take current, pass to cell, store result back
         (handoff-transfer (program-thread-handoff pt))
         (new-handoff (cell-execute current-cell ctx handoff-transfer))
         (new-counter (1+ idx)))

    (setf (program-thread-counter pt) new-counter)
    (setf (program-thread-handoff pt) new-handoff)

    (let ((finished (thread-is-finished pt)))
      (values pt
              (make-effect :activity activity
                           :handoff  new-handoff
                           :finished finished)))))
