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

(defun c:foo (/ entityName stringData) 
  ; (setq stringData (DictListToJsonStringUtils (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils (ssget))))))
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  ;(entget (GetDictEntityNameByKeyEntryUtils (GetDictionaryEntityNameUtils entityName) "DATAFLOW_GS"))
  ; (UpdateStringDictDataByEntityNameUtils entityName stringData "DATAFLOW_GS")
  ; (GetDictEntityDataByKeyEntryUtils entityName "DATAFLOW_GS")
  (RemoveDictEntityDataByKeyEntryUtils entityName "DATAFLOW_GS")
  
  (entget (GetDictionaryEntityNameUtils entityName))
)

(defun c:fooget (/ entityName) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (entget (GetDictEntityNameByKeyEntryUtils (GetDictionaryEntityNameUtils entityName) "DATAFLOW_GS"))
)

(defun c:ssfoo (/ entityName)
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (GetGsDictDictionaryDataByEntityNameUtils entityName)
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;