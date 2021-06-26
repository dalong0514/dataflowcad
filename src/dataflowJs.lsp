; 冯大龙开发于 2020-2021 年
; Dataflow for JS
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
(defun c:JsCalculateVentingArea () 
  (ExecuteFunctionAfterVerifyDateUtils 'CalculateVentingAreaMacro '())
)

; 2021-06-26
(defun CalculateVentingAreaMacro () 
  (foreach item (GetJsJsVentingGraphyFloorsList) 
    (mapcar '(lambda (x) 
                (UpdateOneFloorGsBzEquipGraphyPostiontData 
                  x
                  (GetDottedPairValueUtils item (GetAllFloorGsBzLevelAxisoTwoPointData))
                  (GetDottedPairValueUtils item (GetAllFloorGsBzVerticalAxisoTwoPointData))
                )
             ) 
      (GetDottedPairValueUtils item (GetAllFloorGsBzEquipGraphyDictListData))
    ) 
  )
)

; 2021-04-09
(defun GetJsJsVentingGraphyFloorsList ()
  (mapcar '(lambda (x) (car x)) 
    (GetAllFloorGsBzEquipGraphyDictListData)
  )   
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

; 2021-04-09
(defun GetAllJsVentingGraphyData () 
  (GetSelectedEntityDataUtils (ssget "X" '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))
)

(defun c:foo ()
  (GetAllJsVentingGraphyData)
)


; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;