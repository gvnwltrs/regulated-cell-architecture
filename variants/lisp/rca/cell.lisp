;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Cell
;;;
;;; Each cell can access the system context/data but cannot modify it.
;;; Only the engine has authority to modify state.
;;; Each cell HAS-A task.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :rca.cell)

;;; Status: MUTABLE
(defconstant +num-cells+ 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (1) Cell Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: MUTABLE
;;; Cell data is represented as a tagged list: (:none) or (:byte value)
;;; Add cell data types here

(defun make-cell-data (tag &optional value)
  (ecase tag
    (:none  (list :none))
    (:byte  (list :byte value))))

(defun cell-data-tag (cd)
  (first cd))

(defun cell-data-value (cd)
  (second cd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (2) Tasks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: MUTABLE
(defun task-access (task ctx handoff)
  "Dispatch task execution. ctx is read-only (not modified)."
  (declare (ignore ctx))
  (ecase task
    (:default
     (make-cell-data :byte #x2A))  ; 42

    (:double-value
     (if (eq (cell-data-tag handoff) :byte)
         (make-cell-data :byte (+ (cell-data-value handoff)
                                  (cell-data-value handoff)))  ; 84
         handoff))

    ;; Add task procedures here
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (3) Cell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: FREEZE
(defstruct cell
  (id   0    :type fixnum)
  (task :default))

(defun cell-execute (cell ctx handoff)
  (task-access (cell-task cell) ctx handoff))

(defun cell-defaults ()
  (loop for i below +num-cells+
        collect (make-cell :id i :task :default)))
