; 冯大龙开发于 2020-2021 年
; The Pipe Layout for Gs
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


; 2021-04-09
; PL for DataFlow
(defun c:DPL () 
  (ExecuteFunctionAfterVerifyDateUtils 'GeneratePipeForGsPipeLayoutMacro '())
)

; refactored at 2021-04-09
(defun GeneratePipeForGsPipeLayoutMacro (/ pipeHeight plineEntityName)
  (vl-cmdf "_.pline")
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  
  
  ; (setq plineEntityName (entlast))
  ; (princ plineEntityName)(princ)
  ; (SetGsPGPipeHeight (entlast) 38 pipeHeight)
  ; (DarawGsPGPile)
  (setq pipeHeight (getstring "\n设定管道底标高（单位m）："))
  (SetGsPGPipeHeight (entlast) 38 (atof pipeHeight))
)

; 2021-06-23
(defun SetGsPGPipeHeight (entityName DXFcode pipeHeight /)
  (SetDXFValueUtils entityName DXFcode pipeHeight)
)

(defun DarawGsPGPile ( / *error* ent sel val var )
  (vl-cmdf "_.pline")
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  (princ)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.
 
(defun DL:startundo ( doc )
  (DL:endundo doc)
  (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.
(defun DL:endundo ( doc )
  (while (= 8 (logand 8 (getvar 'undoctl)))
    (vla-endundomark doc)
  )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object
(defun DL:acdoc nil
  (eval (list 'defun 'DL:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
  (DL:acdoc)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function



; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;