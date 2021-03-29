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
  (setq stringData (DictListToJsonStringUtils (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils (ssget))))))
  (BindGsStringDictionaryDataToObjectUtils (car (GetEntityNameListBySSUtils (ssget))) stringData)
)

(defun c:fooget (/ entityName) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (ParseJSONToListUtils (GetStringDictionaryDataByEntityNameUtils entityName "DATAFLOW_GS"))
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;