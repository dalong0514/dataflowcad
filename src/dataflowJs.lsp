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
  (ExecuteFunctionAfterVerifyDateUtils 'CalculateVentingAreaByBox '("calculateVentingAreaBox"))
)

; 2021-06-28
(defun CalculateVentingAreaByBox (tileName / dcl_id status entityName ventingRatio ventingHeight ventingHeightInt ventingRegionLengthWidth aspectRatio ventingRatioStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowJs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnCalculate" "(done_dialog 3)")
    ; the default value of input box
    (mode_tile "ventingRatio" 2)
    (mode_tile "ventingHeight" 2)
    (action_tile "ventingRatio" "(setq ventingRatio $value)")
    (action_tile "ventingHeight" "(setq ventingHeight $value)")
    (progn
      (start_list "ventingRatio" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("0.11" "0.25"))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil ventingRatio)
      (setq ventingRatio "0")
    ) 
    (if (= nil ventingHeight)
      (setq ventingHeight "")
    ) 
    (if (= ventingRatioStatus 1)
      (set_tile "aspectRatioMsg" (strcat "长径比：" (vl-princ-to-string aspectRatio)))
    ) 
    (set_tile "ventingRatio" ventingRatio)
    (set_tile "ventingHeight" ventingHeight)
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))))
        (setq ventingRegionLengthWidth (GetJSVentingRegionLengthWidth entityName))
        (setq ventingHeightInt (* (atof ventingHeight) 1000))
        (setq aspectRatio (GetVentingAspectRatio ventingHeightInt (car ventingRegionLengthWidth) (cadr ventingRegionLengthWidth)))
        (setq ventingRatioStatus 1)
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (princ ventingHeight)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; (VlaGetEntityPropertyAndMethodBySelectUtils)
; 2021-06-28
(defun CalculateVentingAreaMacro (entityName / acadObject ventingHeight ventingPerimeter ventingArea ventingVolume ventingLength ventingWidth ventingAspectRatio) 
  (setq acadObject (vlax-ename->vla-object entityName))
  (setq ventingHeight (* (vlax-get-property acadObject 'Elevation) 1000))
  (setq ventingPerimeter (vlax-get-property acadObject 'Length))
  (setq ventingArea (vlax-get-property acadObject 'Area))
  
  (setq ventingVolume (* ventingHeight ventingPerimeter))
  (setq ventingLength (car (GetJSVentingRegionLengthWidth entityName)))
  (setq ventingWidth (cadr (GetJSVentingRegionLengthWidth entityName)))
  (setq ventingAspectRatio (GetVentingAspectRatio ventingHeight ventingLength ventingWidth))
  ; (princ ventingAspectRatio)(princ)
)

; 2021-06-28
(defun GetVentingAspectRatio (ventingHeight ventingLength ventingWidth / crossSectionPerimeter) 
  (setq crossSectionPerimeter (* (+ ventingHeight ventingWidth) 2))
  (/ (* ventingLength crossSectionPerimeter) (* (* ventingHeight ventingWidth) 4))
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

; 2021-06-29
(defun ProcessJSVentingAxisoDictData (entityName / ventingAxisoDictData baseXPosition) 
  (setq ventingAxisoDictData (vl-sort (GetJSVentingAxisoDictData entityName) '(lambda (x y) (< (cdr x) (cdr y)))))
  (setq baseXPosition (cdr (car ventingAxisoDictData)))
  (mapcar '(lambda (x) 
             (cons (car x) (- (cdr x) baseXPosition))
           ) 
    ventingAxisoDictData
  ) 
)

; 2021-06-29
(defun GetJSVentingAxisoDictData (entityName /) 
  (mapcar '(lambda (x) 
             (cons 
                (GetDottedPairValueUtils "a" (GetAllPropertyDictForOneBlock (GetDottedPairValueUtils -1 x)))
                (car (GetDottedPairValueUtils 10 x))
             )
           ) 
    (GetJSAxisPositionForVenting entityName)
  ) 
)

; 2021-06-29
(defun GetJSAxisPositionForVenting (entityName / filterRegion) 
  (setq filterRegion (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
  (vl-remove-if-not '(lambda (x) 
                       (IsPositionInTheRegionUtils 
                         (GetDottedPairValueUtils 10 x) 
                         (car filterRegion) (cadr filterRegion) (cadddr filterRegion) (+ (cadddr filterRegion) 20000)) 
                     ) 
    (GetAllJsAxisoData)
  ) 
)

(defun c:foo (/ entityName)
  (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))))
  (ProcessJSVentingAxisoDictData entityName)
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