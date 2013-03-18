(ql:quickload 'cl-charms)

(defpackage #:game-of-life
  (:use #:cl #:cl-charms)
  (:nicknames #:gol))

(in-package #:gol)

(defconstant +xmax+ 80)
(defconstant +ymax+ 80)
(defvar *time-steps*)
(defvar *board* (make-array (list +xmax+ +ymax+) :initial-element nil))

(defun update-board ()
  (let ((updates nil))
    (dotimes (x +xmax+)
            (dotimes (y +ymax+)
              (push (get-cell-update x y) updates)))
    (perform-updates updates)))

(defun perform-updates (updates)
  (dolist (update updates)
    (when update
      (let ((fn (first update))
            (args (second update)))
        (apply fn args)))))

(defun get-cell-update (x y)
  (let ((nn (num-neighbors x y))
        (alive (not (null (aref *board* x y)))))
    (cond
      ((and alive (or (> nn 3) (< nn 2))) (list #'kill (list x y)))
      ((and (not alive) (= nn 3)) (list #'birth (list  x y)))
      (t nil))))

(defun kill (x y)
  (setf (aref *board* x y) nil))

(defun birth (x y)
  (setf (aref *board* x y) 't))

(defun num-neighbors (x y)
  (let ((dirs '((-1 0) (-1 -1) (-1 1) (1 -1) (1 0) (1 1) (0 1) (0 -1))))
    (flet ((neighbor (dir)
             (neighbor x y dir)))
      (reduce #'+ (mapcar #'neighbor dirs)))))

(defun neighbor (x y dir)
  (let ((nx (+ x (first dir)))
        (ny (+ y (second dir))))
    (if (or (minusp nx) (>= nx +xmax+)
            (minusp ny) (>= ny +ymax+)
            (null (aref *board* nx ny)))
        0
        1)))

(defun run (structure-creating-fn)
  (init structure-creating-fn)
  (game-loop)
  (exit-life))

(defun init (structure-creating-fn)
  (funcall structure-creating-fn)
  (initscr)
  (raw)
  (keypad *stdscr* TRUE)
  (curs-set 0)
  (noecho)
  (set-num-timesteps))

(defun game-loop ()
  (dotimes (i *time-steps*)
    (progn (draw-board)
           (update-board)
           (sleep 0.5))))

(defun draw-board ()
    (dotimes (x +xmax+)
      (dotimes (y +ymax+)
        (if (aref *board* x y)
            (draw x y (char-code #\*))
            (draw x y (char-code #\Space)))))
    (refresh))

(defun draw (x y ch)
  (mvaddch x y ch))

(defun exit-life ()
  (endwin)
  (sb-ext:exit))

(defun populate (coords)
  (loop for (x y) on coords by #'cddr
       do (setf (aref *board* x y) 't)))

(defun create-blinker ()
  (populate '(5 5
              5 6
              5 7)))

(defun create-block ()
    (populate '(5 5
                5 6
                6 5
                6 6)))

(defun create-beehive ()
  (populate '(20 20
              20 21
              21 19
              21 22
              22 20
              22 21)))

(defun create-boat ()
  (populate '(20 20
              20 21
              21 20
              21 22
              22 21)))

(defun create-toad ()
  (populate '(20 20
              20 21
              20 22
              21 19
              21 20
              21 21)))

(defun create-beacon ()
  (populate '(20 20
              20 21
              21 20
              21 21
              22 22
              22 23
              23 22
              23 23)))

(defmacro get-fn-from-argv ()
  (let* ((args sb-ext:*posix-argv*)
         (num-args (length args))
         (default-structure "TOAD")
         (structure (if (> num-args 1)
                        (second args)
                        default-structure))
         (fn-name (intern (concatenate 'string "CREATE-" structure))))
    `(function ,fn-name)))

(defun get-num-timesteps-from-argv ()
  (let* ((args sb-ext:*posix-argv*)
         (num-args (length args)))
    (if (> num-args 2)
        (safely-read-from-string (third args))
        20)))

(defun set-num-timesteps ()
  (setf *time-steps* (get-num-timesteps-from-argv)))

(defun safely-read-from-string (str &rest read-from-string-args)
  "Read an expression from the string STR, with *READ-EVAL* set
to NIL. Any unsafe expressions will be replaced by NIL in the
resulting S-Expression."
  (let ((*read-eval* nil))
    (ignore-errors
      (apply 'read-from-string str read-from-string-args))))

(let ((fn (get-fn-from-argv))
      (steps (get-num-timesteps-from-argv)))
  (format t "your arguments, sir: ~A, ~A~%" fn steps))

(run (get-fn-from-argv))
