;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Control Plane
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :rca.control)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (1) States  - Status: FREEZE
;;; (2) Modes   - Status: MUTABLE
;;; (3) Events  - Status: MUTABLE
;;;
;;; Represented as keyword symbols:
;;;   States: :init :idle :running :halt :failure :shutdown
;;;   Modes:  :none :debug
;;;   Events: :none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: FREEZE
(defstruct control-plane
  (state :init)
  (mode  :debug)
  (event :none))

(defun default-control-plane ()
  (make-control-plane))
