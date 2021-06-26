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

; 2021-06-23
; PL in DataFlow
(defun c:DPL () 
  (ExecuteFunctionAfterVerifyDateUtils 'GeneratePipeForGsPipeLayoutMacro '())
)

; 2021-06-23
(defun GeneratePipeForGsPipeLayoutMacro (/ pipeHeight)
  (vl-cmdf "_.pline")
  ; the key code for the function
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  (setq pipeHeight (getstring "\n设定管道底标高（单位m）："))
  (SetPLGraphHeightUtils (entlast) (atof pipeHeight))
  (princ "管道绘制完成！")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function



; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;