;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Author: Gavin Walters
;;; Created: 2026-03-06
;;;
;;; Description:
;;; Linear Sequential Runtime System
;;;
;;; Workflow:
;;; Data -> Constraints -> Cells -> Threads -> Engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Load modules
(load (merge-pathnames "rca/packages.lisp" *load-truename*))
(load (merge-pathnames "rca/data.lisp"     *load-truename*))
(load (merge-pathnames "rca/control.lisp"  *load-truename*))
(load (merge-pathnames "rca/cell.lisp"     *load-truename*))
(load (merge-pathnames "rca/thread.lisp"   *load-truename*))
(load (merge-pathnames "rca/engine.lisp"   *load-truename*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Runtime Engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun main ()
  (let ((engine (rca.engine:give-default)))
    (rca.engine:try-run-engine engine)))

(main)
