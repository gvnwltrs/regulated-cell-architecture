;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Package Definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :rca.data
  (:use :cl)
  (:export #:make-data-plane
           #:make-activity-info
           #:make-display-info
           #:make-cell-info
           #:make-system-data
           #:data-plane-config
           #:data-plane-read-io
           #:data-plane-write-io
           #:data-plane-perf
           #:data-plane-logs
           #:data-plane-cells
           #:data-plane-activity
           #:data-plane-display
           #:cell-info-count
           #:activity-info-description
           #:display-info-title
           #:display-info-body
           #:display-info-status
           #:system-data-description
           #:default-data-plane))

(defpackage :rca.control
  (:use :cl)
  (:export #:make-control-plane
           #:control-plane-state
           #:control-plane-mode
           #:control-plane-event
           #:default-control-plane))

(defpackage :rca.cell
  (:use :cl :rca.data)
  (:export #:+num-cells+
           #:make-cell-data
           #:cell-data-tag
           #:cell-data-value
           #:make-cell
           #:cell-id
           #:cell-task
           #:cell-execute
           #:cell-defaults
           #:task-access))

(defpackage :rca.thread
  (:use :cl :rca.data :rca.cell)
  (:export #:make-effect
           #:effect-activity
           #:effect-handoff
           #:effect-finished
           #:make-program-thread
           #:program-thread-counter
           #:program-thread-tasks
           #:program-thread-handoff
           #:build-tasks
           #:thread-step
           #:thread-is-finished))

(defpackage :rca.engine
  (:use :cl :rca.data :rca.control :rca.cell :rca.thread)
  (:export #:make-engine
           #:engine-ctx
           #:engine-ctl
           #:engine-sys
           #:give-default
           #:try-run-engine))
