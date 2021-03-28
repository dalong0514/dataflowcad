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

; 2021-03-26
; DXF Code for XData 1050
(defun CreateStringXDataUtils (xdataString / appName)
  (setq appName "DataFlowXData") 
  (regapp "DataFlowXData") 
  (list -3 (list appName 
                (cons 1000 xdataString)))
)

; 2021-03-26
(defun BindXDataToObjectUtils (xdataList / entityName entityData) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget))))
  (setq entityData (entget entityName))
  (setq entityData (append entityData (list xdataList)))
  (entmod entityData)
  (entupd entityName)
  (princ)
)

; 2021-03-28
(defun UpdateXDataByStringDataUtils (entityName xdataString / entityData) 
  (setq entityData (entget entityName '("DataFlowXData")))
  (if (/= (assoc -3 entityData) nil) 
    (setq entityData (subst (CreateStringXDataUtils xdataString) (assoc -3 entityData) entityData)) 
  )  
  (entmod entityData)
  (entupd entityName)
  (princ)
)

; 2021-03-28
(defun UpdateXDataByDictDataUtils (entityName dictData /)
  (UpdateXDataByStringDataUtils entityName (DictListToJsonStringUtils dictData))
)

; 2021-03-26
(defun GetStringXDataByEntityNameUtils (entityName / entityData)
  (setq entityData 
    (entget entityName '("DataFlowXData")))
  (if (/= (assoc -3 entityData) nil) 
    (GetDottedPairValueUtils 1000 
      (GetDottedPairValueUtils "DataFlowXData" (GetDottedPairValueUtils -3 entityData))
    )
  ) 
)

; 2021-03-28
(defun GetListXDataLByEntityNameUtils (entityName /) 
  (ParseJSONToListUtils (GetStringXDataByEntityNameUtils entityName))
)



(defun c:fooupdate ()
  (UpdateXDataByDictDataUtils 
    (car (GetEntityNameListBySSUtils (ssget)))
    (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils (ssget))))
    ;(GetTestDictList)
  )
)

(defun GetTestDictList ()
  (list (cons "tag" "V1101") 
    (cons "name" "¼×´¼´¢¹Þ") 
    (cons "num" "22") 
    (cons "tagName" 
      (list (cons "tag" "V1101") 
        (cons "num" "22") 
      )  
    )
  )
)

(defun c:fooget ()
  (GetListXDataLByEntityNameUtils (car (GetEntityNameListBySSUtils (ssget))))
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;