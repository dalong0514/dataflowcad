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
(defun CalculateVentingAreaMacro (/ entityName acadObject ventingHeight ventingPerimeter ventingVolume) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))))
  (setq acadObject (vlax-ename->vla-object entityName))
  (setq ventingHeight (vlax-get-property acadObject 'Length))
  (setq ventingPerimeter (vlax-get-property acadObject 'Elevation))
  (setq ventingVolume (* ventingHeight ventingPerimeter))
  (princ ventingVolume)
  (GetJSVentingRegionLengthWidth entityName)
)

; 2021-06-27
; bug will appear when length=width because vl-sort will de-duplication
(defun GetJSVentingRegionLengthWidth (entityName / xyValues) 
  (setq xyValues (GetMinMaxXYValuesUtils (GetJSColumnPositionForVenting entityName)))
  (vl-sort 
    (list 
      (- (nth 1 xyValues) (nth 0 xyValues))
      (- (nth 3 xyValues) (nth 2 xyValues))
    )
    '>
  )
)

; 2021-06-27
(defun GetJSColumnPositionForVenting (entityName / filterRegion) 
  (setq filterRegion (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
  (vl-remove-if-not '(lambda (x) 
                       (IsPositionInTheRegionUtils x (car filterRegion) (cadr filterRegion) (caddr filterRegion) (cadddr filterRegion)) 
                     ) 
    (GetAllJSDrawColumnPosition)
  )    
)

(defun c:foo ()
  (CalculateVentingAreaMacro)
  ; (VlaGetEntityPropertyAndMethodBySelectUtils)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

; 2021-06-26
(defun GetAllJsVentingGraphData () 
  (GetSelectedEntityDataUtils (ssget "X" '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))
)

; 2021-06-27
(defun GetAllPointForPolyLineUtils (entityData /)
  (mapcar '(lambda (x) 
             (cdr x)
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) 10)
                      ) 
      entityData
    ) 
  ) 
)

; 2021-06-27
; PositionList: ((10 0.0 16600.0) (10 70100.0 7100.0) (10 0.0 0.0) (10 0.0 16600.0))
(defun GetMinMaxXYValuesUtils (PositionList /) 
  (list 
    (car (car (vl-sort PositionList '(lambda (x y) (< (car x) (car y))))))
    (car (car (vl-sort PositionList '(lambda (x y) (> (car x) (car y))))))
    (cadr (car (vl-sort PositionList '(lambda (x y) (< (cadr x) (cadr y))))))
    (cadr (car (vl-sort PositionList '(lambda (x y) (> (cadr x) (cadr y))))))
  )
)

; Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;