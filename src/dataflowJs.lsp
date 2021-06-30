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
; refactored at 2021-06-29
(defun GenerateJsVentingAreaPLMacro (/ pipeHeight) 
  (VerifyAllJsBzSymbol)
  (vl-cmdf "_.pline")
  ; the key code for the function
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  (SetGraphLayerUtils (entlast) "0DataFlow-JsVentingArea")
  (princ "\n泄爆区划分完成！")(princ)
)

; 2021-06-23
; PL in DataFlow
(defun c:JsCalculateVentingArea () 
  (ExecuteFunctionAfterVerifyDateUtils 'CalculateVentingAreaByBox '("calculateVentingAreaBox"))
)

; 2021-06-29
(defun GetJSVentingRatio ()
  '("0.11" "0.25")
)

; 2021-06-29
(defun CalculateVentingAreaByBox (tileName / dcl_id status entityName xxyyValues ventingRatio ventingRatioValue ventingHeight ventingHeightInt 
                                  ventingRegionLengthWidth ventingLength ventingWidth aspectRatio ventingArea ventingAxisoDictData ventingVertiacalAxisoDictData  
                                  ventingRatioStatus ventingAreaStatus twoSectionVentingAspectRatio threeSectionVentingAspectRatio fristAxis lastAxis 
                                  antiVentingEntityData actualVentingArea)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowJs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnCalculate" "(done_dialog 3)")
    (action_tile "btnInsert" "(done_dialog 4)")
    ; the default value of input box
    (mode_tile "ventingRatio" 2)
    (mode_tile "ventingHeight" 2)
    (action_tile "ventingRatio" "(setq ventingRatio $value)")
    (action_tile "ventingHeight" "(setq ventingHeight $value)")
    (progn
      (start_list "ventingRatio" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetJSVentingRatio))
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
      (progn 
        (set_tile "aspectRatioMsg" (strcat "初始长径比：" (vl-princ-to-string aspectRatio) "  区域：" fristAxis " 轴到 " lastAxis " 轴  计算泄压面积：" (vl-princ-to-string ventingArea)))
        (set_tile "calculateVentingAreaMsg" (strcat "计算泄压面积之和：" (vl-princ-to-string ventingArea)))
      )
    ) 
    (if (= ventingRatioStatus 2)
      (progn 
        (set_tile "aspectRatioMsg" (strcat "初始长径比：" (vl-princ-to-string aspectRatio) "  区域：" fristAxis " 轴到 " lastAxis " 轴"))
        (set_tile "aspectRatioOneMsg" 
                  (strcat "分区一长径比：" (vl-princ-to-string (car (cdr twoSectionVentingAspectRatio))) "  区域：" fristAxis " 轴到 " (car twoSectionVentingAspectRatio) " 轴  计算泄压面积：" (vl-princ-to-string (nth 2 (cdr twoSectionVentingAspectRatio)))))
        (set_tile "aspectRatioTwoMsg" 
                  (strcat "分区二长径比：" (vl-princ-to-string (cadr (cdr twoSectionVentingAspectRatio))) "  区域：" (car twoSectionVentingAspectRatio) " 轴到 " lastAxis " 轴  计算泄压面积：" (vl-princ-to-string (nth 3 (cdr twoSectionVentingAspectRatio)))))
        (set_tile "calculateVentingAreaMsg" (strcat "计算泄压面积之和：" (vl-princ-to-string (+ (nth 2 (cdr twoSectionVentingAspectRatio)) (nth 3 (cdr twoSectionVentingAspectRatio))))))
      )
    ) 
    (if (= ventingRatioStatus 3)
      (set_tile "aspectRatioThreeMsg" "两段分区的长径比无法同时小于 3！")
    ) 
    (if (= ventingAreaStatus 1)
      (set_tile "actualVentingAreaMsg" (strcat "实际泄压面积：" (vl-princ-to-string actualVentingArea)))
    ) 
    (set_tile "ventingRatio" ventingRatio)
    (set_tile "ventingHeight" ventingHeight)
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (if (= ventingHeight "") 
        (alert "请先输入层高！")
        (progn 
          (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))))
          ; (148340.0 172840.0 -588785.0 -572785.0) four corner of the venting region
          (setq xxyyValues (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))

          (setq ventingRegionLengthWidth (GetJSVentingRegionLengthWidth entityName))
          (setq ventingHeightInt (* (atof ventingHeight) 1000))
          (setq ventingLength (car ventingRegionLengthWidth))
          (setq ventingWidth (cadr ventingRegionLengthWidth))
          (setq ventingRatioValue (atof (nth (atoi ventingRatio) (GetJSVentingRatio))))
          (setq aspectRatio (GetVentingAspectRatio ventingHeightInt ventingLength ventingWidth))
          (setq ventingArea (GetJSVentingArea ventingHeightInt ventingLength ventingWidth ventingRatioValue))
          (setq ventingAxisoDictData (ProcessJSHorizontialVentingAxisoDictData entityName))
          (setq ventingVertiacalAxisoDictData (ProcessJSVerticalVentingAxisoDictData entityName))
          
          
          (setq fristAxis (car (car ventingAxisoDictData)))
          (setq lastAxis (car (car (reverse ventingAxisoDictData))))
          (if (< aspectRatio 3) 
            (setq ventingRatioStatus 1)
            (progn 
              (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatio ventingAxisoDictData ventingHeightInt ventingLength ventingWidth ventingRatioValue))
              (if (/= twoSectionVentingAspectRatio nil) 
                (progn 
                  (setq twoSectionVentingAspectRatio (nth (/ (length twoSectionVentingAspectRatio) 2) twoSectionVentingAspectRatio))
                  (setq ventingRatioStatus 2)
                )
                (progn 
                  (setq threeSectionVentingAspectRatio (GetThreeSectionVentingAspectRatio ventingAxisoDictData ventingHeightInt ventingLength ventingWidth))
                  (setq ventingRatioStatus 3)
                  ; (princ threeSectionVentingAspectRatio)(princ)
                )
              )
            )
          )
          
        )
      )
    )
    ; calculate venting Area
    (if (= 3 status)
      (progn 
        (setq antiVentingEntityData (GetJSAntiVentingEntityData))
        (setq actualVentingArea (GetJSActualVentingArea entityName antiVentingEntityData ventingHeight xxyyValues))
        (setq ventingAreaStatus 1)
      )
    )
    ; insert Venting Draw
    (if (= 4 status)
      (progn 
        (InsertJSVentingRegion entityName xxyyValues 1 ventingAxisoDictData ventingVertiacalAxisoDictData)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-06-30
(defun InsertJSVentingRegion (entityName xxyyValues scaleFactor ventingAxisoDictData ventingVertiacalAxisoDictData / insPt)
  (setq insPt (getpoint "\n拾取泄压面简图插入点："))
  ; return to (0 0 0), and then move to the insPt
  (setq newEntityData 
    (MovePolyLineDataByBasePosition 
      (ProcessOneEntityDataForCopyUtils entityName) 
      (list (- (car insPt) (car xxyyValues)) (- (cadr insPt) (nth 3 xxyyValues))))
  )
  (entmake newEntityData)
  ;; Scale the polyline
  (vla-ScaleEntity (vlax-ename->vla-object (entlast)) (vlax-3d-point insPt) scaleFactor)
  (InsertJSHorizontialAxiso insPt ventingAxisoDictData)
  (InsertJSVerticalAxiso insPt ventingVertiacalAxisoDictData)
)

; 2021-06-30
(defun InsertJSHorizontialAxiso (insPt ventingAxisoDictData /)
  (mapcar '(lambda (x) 
            (InsertOneHorizontialJSAxiso insPt x)
          ) 
    ventingAxisoDictData
  )
)

; 2021-06-30
(defun InsertJSVerticalAxiso (insPt ventingAxisoDictData /)
  (mapcar '(lambda (x) 
            (InsertOneVerticalJSAxiso insPt x)
          ) 
    ventingAxisoDictData
  )
)

; 2021-06-30
(defun InsertOneHorizontialJSAxiso (insPt ventingAxisoDict /) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt (cdr ventingAxisoDict) 800) (MoveInsertPositionUtils insPt (cdr ventingAxisoDict) 2600) "AXIS")
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt (cdr ventingAxisoDict) 3200) "_AXISO" "AXIS" (list (cons 0 (car ventingAxisoDict))) 1200)
)

; 2021-06-30
(defun InsertOneVerticalJSAxiso (insPt ventingAxisoDict /) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt -800 (cdr ventingAxisoDict)) (MoveInsertPositionUtils insPt -2600 (cdr ventingAxisoDict)) "AXIS")
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt -3200 (cdr ventingAxisoDict)) "_AXISO" "AXIS" (list (cons 0 (car ventingAxisoDict))) 1200)
)

; 2021-06-29
(defun GetJSActualVentingArea (entityName antiVentingEntityData ventingHeight xxyyValues / ventingPerimeter antiVentingTotalLength) 
  (setq ventingPerimeter (vlax-get-property (vlax-ename->vla-object entityName) 'Length))
  (setq antiVentingTotalLength (GetJSAntiVentingTotalLength antiVentingEntityData xxyyValues))
  (* (atof ventingHeight)  (/ (- ventingPerimeter antiVentingTotalLength) 1000.0))
)

; 2021-06-29
(defun GetJSAntiVentingTotalLength (antiVentingEntityData xxyyValues / )
  (+ 
    (GetJSAntiVentingColmnLength antiVentingEntityData) 
    (GetJSAntiVentingWallLength antiVentingEntityData xxyyValues) 
    ; four corner column
    2400
  )
  (princ (GetJSAntiVentingWallLength antiVentingEntityData xxyyValues) )
)

; 2021-06-29
(defun GetJSAntiVentingColmnLength (antiVentingEntityData /)
  (apply '+ 
    (mapcar '(lambda (x) 
              (GetDottedPairValueUtils 41 x)
            ) 
      (GetJSAntiVentingColmnData antiVentingEntityData)
    ) 
  )
)

; 2021-06-29
(defun GetJSAntiVentingWallLength (antiVentingEntityData xxyyValues /)
  (apply '+ 
    (mapcar '(lambda (x) 
              (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length)
            ) 
      (GetJSAntiVentingWallData antiVentingEntityData xxyyValues)
    ) 
  )
)

; 2021-06-29
(defun GetJSAntiVentingColmnData (antiVentingEntityData /)
  (vl-remove-if-not '(lambda (x) 
                       ; ready to better
                       (= (GetDottedPairValueUtils 0 x) "INSERT") 
                     ) 
    antiVentingEntityData
  ) 
)

; 2021-06-29
(defun GetJSAntiVentingWallData (antiVentingEntityData xxyyValues / newXXYYValues)
  (setq newXXYYValues 
    (list 
      (+ (car xxyyValues) 40)
      (- (cadr xxyyValues) 40)
      (+ (caddr xxyyValues) 40)
      (- (cadddr xxyyValues) 40)
    )
  )
  (vl-remove-if-not '(lambda (x) 
                       ; ready to better
                       (IsJSAntiVentingWall x newXXYYValues) 
                     ) 
    antiVentingEntityData
  ) 
)

; 2021-06-29
(defun IsJSAntiVentingWall (entityData newXXYYValues /)
  (and 
    (= (GetDottedPairValueUtils 0 entityData) "LINE")
    (or 
      (< (car (GetDottedPairValueUtils 10 entityData)) (car newXXYYValues))
      (> (car (GetDottedPairValueUtils 10 entityData)) (cadr newXXYYValues))
      (< (cadr (GetDottedPairValueUtils 10 entityData)) (caddr newXXYYValues))
      (> (cadr (GetDottedPairValueUtils 10 entityData)) (cadddr newXXYYValues))
    )
  )
)

; 2021-06-29
(defun GetJSAntiVentingEntityData ()
  (GetEntityDataBySSUtils (GetJSAntiVentingSS))
)

; 2021-06-29
(defun GetJSAntiVentingSS () 
    (ssget '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WALL")
          (8 . "COLUMN")
        (-4 . "OR>")
      )
    )
)

; 2021-06-29
; ready to refactor
(defun GetThreeSectionVentingAspectRatio (ventingAxisoDictData ventingHeight ventingLength ventingWidth / fristAxisPt sencondAxisPt) 
  ; (princ ventingAxisoDictData)(princ)
  (setq fristAxisPt (nth (/ (length ventingAxisoDictData) 3) ventingAxisoDictData))
  (setq sencondAxisPt (nth (* (/ (length ventingAxisoDictData) 3) 2) ventingAxisoDictData))
  (list 
    (GetVentingAspectRatio ventingHeight (cdr fristAxisPt) ventingWidth)
    (GetVentingAspectRatio ventingHeight (- (cdr sencondAxisPt) (cdr fristAxisPt)) ventingWidth)
    (GetVentingAspectRatio ventingHeight (- ventingLength (cdr sencondAxisPt)) ventingWidth)
  )
)

; 2021-06-29
(defun GetTwoSectionVentingAspectRatio (ventingAxisoDictData ventingHeight ventingLength ventingWidth ventingRatio /) 
  (vl-remove-if-not '(lambda (x) 
                       (and 
                         (< (car (cdr x)) 3)
                         (< (cadr (cdr x)) 3)
                       ) 
                     ) 
    (mapcar '(lambda (x) 
              (cons (car x) 
                  (list 
                    (GetVentingAspectRatio ventingHeight (cdr x) ventingWidth)
                    (GetVentingAspectRatio ventingHeight (- ventingLength (cdr x)) ventingWidth)
                    ; calculate VentingArea
                    (GetJSVentingArea ventingHeight (cdr x) ventingWidth ventingRatio)
                    (GetJSVentingArea ventingHeight (- ventingLength (cdr x)) ventingWidth ventingRatio)
                  )
              )
            ) 
      ventingAxisoDictData
    )
  )
)

; 2021-06-28
(defun GetVentingAspectRatio (ventingHeight ventingLength ventingWidth / crossSectionPerimeter) 
  (setq crossSectionPerimeter (* (+ ventingHeight ventingWidth) 2))
  (/ (* ventingLength crossSectionPerimeter) (* (* ventingHeight ventingWidth) 4))
)

; 2021-06-29
; unit test completed
(defun GetJSVentingArea (ventingHeight ventingLength ventingWidth ventingRatio /) 
  (setq ventingHeight (/ ventingHeight 1000.0))
  (setq ventingLength (/ ventingLength 1000.0))
  (setq ventingWidth (/ ventingWidth 1000.0))
  (fix (* 10 ventingRatio (expt (* ventingHeight ventingLength ventingWidth) (/ 2.0 3))))
)

; 2021-06-27
; bug will appear when length=width because vl-sort will de-duplication
; refactored at 2021-06-29
(defun GetJSVentingRegionLengthWidth (entityName / xxyyValues) 
  (setq xxyyValues (GetMinMaxXYValuesUtils (GetJSColumnPositionForVenting entityName)))
  (vl-sort 
    (list 
      (- (nth 1 xxyyValues) (nth 0 xxyyValues))
      (- (nth 3 xxyyValues) (nth 2 xxyyValues))
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
(defun ProcessJSHorizontialVentingAxisoDictData (entityName / ventingAxisoDictData baseXPosition) 
  (setq ventingAxisoDictData (vl-sort (GetJSHorizontialVentingAxisoDictData entityName) '(lambda (x y) (< (cdr x) (cdr y)))))
  (setq baseXPosition (cdr (car ventingAxisoDictData)))
  (mapcar '(lambda (x) 
             (cons (car x) (- (cdr x) baseXPosition))
           ) 
    ventingAxisoDictData
  ) 
)

; 2021-06-30
(defun ProcessJSVerticalVentingAxisoDictData (entityName / ventingAxisoDictData baseXPosition) 
  (setq ventingAxisoDictData (vl-sort (GetJSVerticalVentingAxisoDictData entityName) '(lambda (x y) (> (cdr x) (cdr y)))))
  (setq baseXPosition (cdr (car ventingAxisoDictData)))
  (mapcar '(lambda (x) 
             (cons (car x) (- (cdr x) baseXPosition))
           ) 
    ventingAxisoDictData
  ) 
)

; 2021-06-29
(defun GetJSHorizontialVentingAxisoDictData (entityName /) 
  (mapcar '(lambda (x) 
             (cons 
                (GetDottedPairValueUtils "a" (GetAllPropertyDictForOneBlock (GetDottedPairValueUtils -1 x)))
                (car (GetDottedPairValueUtils 10 x))
             )
           ) 
    (GetJSHorizontialAxisPositionForVenting entityName)
  ) 
)

; 2021-06-30
(defun GetJSVerticalVentingAxisoDictData (entityName /) 
  (mapcar '(lambda (x) 
             (cons 
                (GetDottedPairValueUtils "a" (GetAllPropertyDictForOneBlock (GetDottedPairValueUtils -1 x)))
                (cadr (GetDottedPairValueUtils 10 x))
             )
           ) 
    (GetJSVerticalAxisPositionForVenting entityName)
  ) 
)

; 2021-06-29
(defun GetJSHorizontialAxisPositionForVenting (entityName / filterRegion) 
  (setq filterRegion (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
  (vl-remove-if-not '(lambda (x) 
                       (IsPositionInTheRegionUtils 
                         (GetDottedPairValueUtils 10 x) 
                         (car filterRegion) (cadr filterRegion) (cadddr filterRegion) (+ (cadddr filterRegion) 30000)) 
                     ) 
    (GetAllJsAxisoData)
  ) 
)

; 2021-06-30
(defun GetJSVerticalAxisPositionForVenting (entityName / filterRegion allJsAxisoData resultList) 
  (setq filterRegion (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
  (setq allJsAxisoData (GetAllJsAxisoData))
  (setq resultList 
    (vl-remove-if-not '(lambda (x) 
                        (IsPositionInTheRegionUtils 
                          (GetDottedPairValueUtils 10 x) 
                          (- (car filterRegion) 30000) (car filterRegion) (caddr filterRegion) (cadddr filterRegion)) 
                      ) 
      allJsAxisoData
    ) 
  )
  (if (= resultList nil) 
    (setq resultList 
      (vl-remove-if-not '(lambda (x) 
                          (IsPositionInTheRegionUtils 
                            (GetDottedPairValueUtils 10 x) 
                            (cadr filterRegion) (+ (cadr filterRegion) 30000) (caddr filterRegion) (cadddr filterRegion)) 
                        ) 
        allJsAxisoData
      ) 
    )
  )
  resultList
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function

; 2021-06-26
(defun GetAllJsVentingGraphData () 
  (GetEntityDataBySSUtils (ssget "X" '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))
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