; ����������� 2020-2021 ��
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
  (setq pipeHeight (getstring "\n�趨�ܵ��ױ�ߣ���λm����"))
  (SetPLGraphHeightUtils (entlast) (atof pipeHeight))
  (princ "�ܵ�������ɣ�")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function



; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;