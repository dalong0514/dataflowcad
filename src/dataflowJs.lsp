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

; 2021-06-11
(defun VerifyAllJsBzSymbol ()
  (if (= *jsBzSymbolStatus* nil) 
    (progn 
      (VerifyJsBzBlockLayerText)
      (setq *jsBzSymbolStatus* T) 
    )
  )
)

; 2021-06-26
(defun VerifyJsBzBlockLayerText () 
  (VerifyBsTextStyleByName "DataFlow")
  (VerifyJsBzLayerByName "0DataFlow*")
)

; 2021-06-26
(defun c:GenerateJsVentingAreaPL () 
  (ExecuteFunctionAfterVerifyDateUtils 'GenerateJsVentingAreaPLMacro '())
)

; 2021-06-23
(defun GenerateJsVentingAreaPLMacro (/ pipeHeight) 
  (VerifyAllJsBzSymbol)
  (vl-cmdf "_.pline")
  ; the key code for the function
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  (setq pipeHeight (getstring "\n设定泄爆区层高（单位m）："))
  (SetPLGraphHeightUtils (entlast) (atof pipeHeight))
  (SetGraphLayerUtils (entlast) "0DataFlow-JsVentingArea")
  (princ "\n泄爆区划分完成！")(princ)
)

; 2021-06-23
; PL in DataFlow
(defun c:JsCalculateVentingArea () 
  (ExecuteFunctionAfterVerifyDateUtils 'CalculateVentingAreaMacro '())
)

; 2021-06-26
(defun CalculateVentingAreaMacro () 
  (foreach item (GetJsVentingGraphFloorsList) 
    (mapcar '(lambda (x) 
                (UpdateOneFloorGsBzEquipGraphyPostiontData 
                  x
                  (GetDottedPairValueUtils item (GetAllFloorGsBzLevelAxisoTwoPointData))
                  (GetDottedPairValueUtils item (GetAllFloorGsBzVerticalAxisoTwoPointData))
                )
             ) 
      (GetDottedPairValueUtils item (GetAllFloorJsVentingGraphyDictListData))
    ) 
  )
)

; 2021-06-26
(defun GetJsVentingGraphFloorsList ()
  (mapcar '(lambda (x) (car x)) 
    (GetAllFloorJsVentingGraphyDictListData)
  )   
)

; 2021-06-26
(defun GetAllFloorJsVentingGraphyDictListData () 
  (ChunkListByColumnIndexUtils (GetAllJsBzVentingGraphDictListData) 0) 
)

; 2021-04-09
(defun GetAllJsBzVentingGraphDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils -1 (cadr x))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetStrategyEntityDataByDrawFrame (GetAllJsVentingGraphData))
  ) 
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

; 2021-04-09
(defun GetAllJsVentingGraphData () 
  (GetSelectedEntityDataUtils (ssget "X" '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))
)

(defun c:foo ()
  (GetAllFloorGsBzLevelAxisoTwoPointData)
)


; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;