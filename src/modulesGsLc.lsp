;冯大龙编于 2020-2021 年
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

; 2021-03-26
(defun UpdateXDataToObjectUtils (entityName xdataString / entityData) 
  (setq entityData (entget entityName '("DataFlowXData")))
  (if (/= (assoc -3 entityData) nil) 
    (setq entityData (subst (CreateStringXDataUtils xdataString) (assoc -3 entityData) entityData)) 
  )  
  (entmod entityData)
  (entupd entityName)
  (princ)
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

(defun c:updatefoo (/ xdataString)
  ;(BindXDataToObjectUtils (CreateStringXDataUtils "{\"Tag\" : {\"subTag\" : \"subTagValue\" , \"Num\" : -123.4}, \"Num\" : -123.4}"))
  (setq xdataString 
    (DictListToJsonStringUtils 
      (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils (ssget))))
    ) 
  )
  (UpdateXDataToObjectUtils 
    (car (GetEntityNameListBySSUtils (ssget)))
    xdataString
  )
)

(defun c:getfoo (/ temp) 
  (setq temp 
    (ParseJSONToListUtils (GetStringXDataByEntityNameUtils (car (GetEntityNameListBySSUtils (ssget)))))
  )
  ;(GetDottedPairValueUtils "Tag" temp)
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;