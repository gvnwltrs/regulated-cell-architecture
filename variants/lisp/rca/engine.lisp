;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Regulated Cell Architecture (RCA) - Common Lisp Variant
;;; Engine
;;;
;;; Micro-kernel space (Loop Engine privilege only):
;;; Apply returned outputs to ctx.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :rca.engine)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Status printing helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun state-name (s)
  (ecase s
    (:init     "Init")
    (:idle     "Idle")
    (:running  "Running")
    (:halt     "Halt")
    (:failure  "Failure")
    (:shutdown "Shutdown")))

(defun mode-name (m)
  (ecase m
    (:none  "None")
    (:debug "Debug")))

(defun print-control (ctl)
  (format t "  Control:~%")
  (format t "    state: ~A~%" (state-name (control-plane-state ctl)))
  (format t "    mode:  ~A~%" (mode-name (control-plane-mode ctl))))

(defun print-data (dp)
  (format t "  Data:~%")
  (format t "    cells.count: ~A~%" (cell-info-count (data-plane-cells dp)))
  (format t "    activity:    \"~A\"~%" (activity-info-description (data-plane-activity dp))))

(defun print-cell-data (cd)
  (format t "  Effect:~%")
  (ecase (cell-data-tag cd)
    (:none (format t "    None~%"))
    (:byte (format t "    Byte(~A)~%" (cell-data-value cd)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (1) Engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Status: FREEZE
(defstruct engine
  (ctx (default-data-plane +num-cells+))
  (ctl (default-control-plane))
  (sys (make-system-data)))

(defun give-default ()
  (make-engine))

(defun print-init-status (e)
  (format t "~%>>>~%")
  (print-control (engine-ctl e))
  (format t "~%")
  (print-data (engine-ctx e))
  (format t "~%"))

(defun print-running-status (e efx)
  (format t "~%>>>~%")
  (print-control (engine-ctl e))
  (format t "~%")
  (print-cell-data efx)
  (format t "~%")
  (print-data (engine-ctx e))
  (format t "<<<~%"))

(defun print-shutdown-status (e)
  (format t "~%>>>~%")
  (print-control (engine-ctl e))
  (format t "~%")
  (print-data (engine-ctx e))
  (format t "~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Engine run
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun try-run-engine (engine)
  (print-init-status engine)

  (let ((current-thread (build-tasks
                         :tasks (list (make-cell :id 0 :task :default)
                                      (make-cell :id 1 :task :double-value)))))

    (setf (control-plane-state (engine-ctl engine)) :halt)
    (print-init-status engine)

    (setf (control-plane-state (engine-ctl engine)) :idle)
    (print-init-status engine)

    (setf (control-plane-state (engine-ctl engine)) :running)
    (print-init-status engine)

    (loop
      (ecase (control-plane-state (engine-ctl engine))
        (:running
         (multiple-value-bind (thread effect)
             (thread-step current-thread (engine-ctx engine))
           (setf current-thread thread)
           (setf (data-plane-activity (engine-ctx engine))
                 (effect-activity effect))

           (when (eq (control-plane-mode (engine-ctl engine)) :debug)
             (print-running-status engine (effect-handoff effect)))

           (when (effect-finished effect)
             (setf (control-plane-state (engine-ctl engine)) :shutdown)
             (setf (data-plane-activity (engine-ctx engine))
                   (make-activity-info))
             (print-shutdown-status engine)
             (return))))

        ((:init :idle :halt :failure :shutdown)
         (setf (control-plane-state (engine-ctl engine)) :shutdown)
         (print-shutdown-status engine)
         (return))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (2) Add custom engine functions here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
