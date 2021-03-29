;·ë´óÁú±àÓÚ 2020-2021 Äê
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

(defun c:foo (/ stringData) 
  ; (car (GetEntityNameListBySSUtils (ssget)))
  ;(GetDictionaryDataByEntityNameUtils (car (GetEntityNameListBySSUtils (ssget))))
  (BindStringDictionaryDataToObjectUtils (car (GetEntityNameListBySSUtils (ssget))) "dalong" "DATAFLOW_NS")
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;