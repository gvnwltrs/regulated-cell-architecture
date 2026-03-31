;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Data Plane
;;;
;;; Establish data endpoints.
;;; Establish & confirm complete data.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :rca.data)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Apex data models
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: FREEZE
(defstruct cell-info
  (count 0 :type fixnum))

;;; Status: FREEZE
(defstruct activity-info
  (description "" :type string))

;;; Status: FREEZE
(defstruct display-info
  (title  "" :type string)
  (body   "" :type string)
  (status "" :type string))

;;; Status: FREEZE
(defstruct system-data
  (description "" :type string))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Data Plane
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: FREEZE
(defstruct data-plane
  (config   :none)              ; Init state: initialization & configuration
  (read-io  :none)              ; Running state: import data
  (write-io :none)              ; Running state: export data
  (perf     :none)              ; Running state: system information
  (logs     :none)              ; Running/Failure/Shutdown: event logs
  (cells    (make-cell-info))   ; Running state: cell metadata
  (activity (make-activity-info)) ; Running state: current task details
  (display  (make-display-info))) ; Running state: terminal/display output

(defun default-data-plane (num-cells)
  (make-data-plane :cells (make-cell-info :count num-cells)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Add custom data models here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
