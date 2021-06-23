; 冯大龙开发于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

(defun c:fooget (/ entityName)
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (GetGsDictDictionaryDataByEntityNameUtils entityName)
)

(defun c:fooupdate (/ dictData entityName) 
  (setq dictData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils (ssget)))))
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (UpdateGsDictDictionaryDataUtils entityName dictData)
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;