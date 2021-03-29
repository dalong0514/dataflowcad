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

(defun c:foo ()
  ;(entget (GetDictionaryByKeyEntryUtils (namedobjdict) "ACAD_GROUP"))
  (CreateCustomDictionaryByEntityNameUtils (car (GetEntityNameListBySSUtils (ssget))))
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;