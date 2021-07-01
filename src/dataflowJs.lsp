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

; refactored at 2021-04-09
(defun c:MoveJSDrawForVenting () 
  (ExecuteFunctionAfterVerifyDateUtils 'MoveJSDrawForVentingMacro '())
)

; refactored at 2021-04-09
(defun MoveJSDrawForVentingMacro () 
  (CADLispCopy (GetAllMoveDrawLabelSS) '(0 0 0) '(400000 0 0))
  (CADLispCopy (GetAllCopyDrawLabelSS) '(0 0 0) '(400000 0 0)) 
  (CADLispCopy (GetAllJSAxisSS) '(0 0 0) '(400000 0 0)) 
  (generateJSDraw (MoveAllJSVentingEntityData))
  (alert "移出泄压相关底图成功！") 
)

; 2021-06-30
(defun MoveAllJSVentingEntityData () 
  (MoveCopyEntityDataByBasePosition (GetAllJSVentingEntityData) '(400000 0))
)

; 2021-06-30
(defun GetAllJSVentingEntityData () 
  (ProcessEntityDataForCopyUtils (GetJSDrawFroVentingSS))
)

; 2021-06-30
(defun GetJSDrawFroVentingSS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WINDOW")
          (8 . "COLUMN")
          (8 . "WALL-MOVE") 
          (8 . "STAIR") 
          (8 . "DOOR_FIRE")
          (8 . "柱*") 
        (-4 . "OR>")
      )
    )
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
  '("0.11" "0.2" "0.25")
)

; 2021-06-29
(defun GetJSVentingSplitMethod ()
  '("柱网分割" "每0.5m分割")
)

; 2021-06-29
(defun GetJSVentingSplitMode ()
  '("自动分割" "人工分割")
)

; 2021-06-30
(defun CalculateVentingAreaByBox (tileName / dcl_id status entityName xxyyValues ventingRatio ventingSplitMethod ventingSplitMode ventingRatioValue ventingHeight 
                                  ventingUnderBeamHeight ventingDrawScale ventingSplitPoint oneSectionVentingDictList aspectRatio ventingAxisoDictData ventingVertiacalAxisoDictData ventingRatioStatus ventingAreaStatus twoSectionVentingAspectRatio fristAxis lastAxis ventingEntityData oneSectionActualVentingDictList twoSectionActualVentingDictList)
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
    ; set the mode for tile, 0 for enabled, 1 for Disabled, 2 for Sets focus
    (mode_tile "ventingRatio" 0)
    (mode_tile "ventingSplitMethod" 0)
    (mode_tile "ventingSplitMode" 0)
    (mode_tile "ventingHeight" 2)
    (mode_tile "ventingUnderBeamHeight" 0)
    (mode_tile "ventingDrawScale" 0)
    (mode_tile "ventingSplitPoint" 0)
    ; the default value of input box
    (action_tile "ventingRatio" "(setq ventingRatio $value)")
    (action_tile "ventingSplitMethod" "(setq ventingSplitMethod $value)")
    (action_tile "ventingSplitMode" "(setq ventingSplitMode $value)")
    (action_tile "ventingHeight" "(setq ventingHeight $value)")
    (action_tile "ventingUnderBeamHeight" "(setq ventingUnderBeamHeight $value)")
    (action_tile "ventingDrawScale" "(setq ventingDrawScale $value)")
    (action_tile "ventingSplitPoint" "(setq ventingSplitPoint $value)")
    (progn
      (start_list "ventingRatio" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetJSVentingRatio))
      (end_list) 
      (start_list "ventingSplitMethod" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetJSVentingSplitMethod))
      (end_list) 
      (start_list "ventingSplitMode" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetJSVentingSplitMode))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil ventingRatio)
      (setq ventingRatio "0")
    ) 
    (if (= nil ventingSplitMethod)
      (setq ventingSplitMethod "0")
    ) 
    (if (= nil ventingSplitMode)
      (setq ventingSplitMode "0")
    )
    (if (= nil ventingHeight)
      (setq ventingHeight "")
    ) 
    (if (= nil ventingUnderBeamHeight)
      (setq ventingUnderBeamHeight "")
    ) 
    (if (= nil ventingDrawScale)
      (setq ventingDrawScale "0.3")
    ) 
    (if (= nil ventingSplitPoint)
      (setq ventingSplitPoint "")
    )
    (if (= ventingRatioStatus 1) 
      (progn 
        (set_tile "aspectRatioMsg" (strcat "初始长径比：" (vl-princ-to-string aspectRatio) "  区域：" fristAxis " 轴到 " lastAxis " 轴  计算泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "ventingArea" oneSectionVentingDictList)) "  实际泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "actualVentingArea" oneSectionActualVentingDictList)) "  实际泄压边长：" (vl-princ-to-string (GetDottedPairValueUtils "ventingTotalLength" oneSectionActualVentingDictList))))
        (set_tile "calculateVentingAreaMsg" (strcat "计算泄压面积之和：" (vl-princ-to-string (GetDottedPairValueUtils "ventingArea" oneSectionVentingDictList))))
        (set_tile "actualVentingAreaMsg" (strcat "实际泄压面积之和：" (vl-princ-to-string (GetDottedPairValueUtils "actualVentingArea" oneSectionActualVentingDictList))))
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
    ; (if (= ventingAreaStatus 1)
    ;   (set_tile "actualVentingAreaMsg" (strcat "实际泄压面积：" (vl-princ-to-string actualVentingArea)))
    ; ) 
    (set_tile "ventingRatio" ventingRatio)
    (set_tile "ventingSplitMethod" ventingSplitMethod)
    (set_tile "ventingSplitMode" ventingSplitMode)
    (set_tile "ventingHeight" ventingHeight)
    (set_tile "ventingUnderBeamHeight" ventingUnderBeamHeight)
    (set_tile "ventingDrawScale" ventingDrawScale)
    (set_tile "ventingSplitPoint" ventingSplitPoint)
    ; ---------------------------------------------------------------------------------------------------------------------------------------;
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (if (= ventingHeight "") 
        (alert "请先输入板底层高！")
        (progn 
          (setq ventingRatioValue (atof (nth (atoi ventingRatio) (GetJSVentingRatio))))
          (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-JSVentingArea"))))))
          ; (148340.0 172840.0 -588785.0 -572785.0) four corner of the venting region
          (setq xxyyValues (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
          (setq oneSectionVentingDictList (GetJSOneSectionVentingDictList entityName ventingRatioValue ventingHeight))
          (setq aspectRatio (GetDottedPairValueUtils "aspectRatio" oneSectionVentingDictList))
          (setq ventingAxisoDictData (ProcessJSHorizontialVentingAxisoDictData entityName))
          (setq ventingVertiacalAxisoDictData (ProcessJSVerticalVentingAxisoDictData entityName))
          (setq fristAxis (car (car ventingAxisoDictData)))
          (setq lastAxis (car (car (reverse ventingAxisoDictData))))
          (if (< aspectRatio 3) 
            (setq ventingRatioStatus 1)
            (progn 
              (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatio ventingAxisoDictData oneSectionVentingDictList ventingRatioValue))
              (if (/= twoSectionVentingAspectRatio nil) 
                (progn 
                  (setq twoSectionVentingAspectRatio (nth (/ (length twoSectionVentingAspectRatio) 2) twoSectionVentingAspectRatio))
                  (setq ventingRatioStatus 2)
                )
                (progn 
                  ; do not process the three sections frist 2021-06-30
                  ; (setq threeSectionVentingAspectRatio (GetThreeSectionVentingAspectRatio ventingAxisoDictData ventingHeightInt ventingLength ventingWidth))
                  ; (princ threeSectionVentingAspectRatio)(princ)
                  (setq ventingRatioStatus 3)
                )
              )
            )
          )
        )
      )
    )
    ; calculate venting Area
    (if (= 3 status) 
      (if (= ventingUnderBeamHeight "") 
        (alert "请先输入梁底层高！")
        (progn 
          (setq ventingEntityData (GetJSVentingEntityData))
          (cond 
            ((= ventingRatioStatus 1) (setq oneSectionActualVentingDictList (GetJSOneSectionActualVentingArea entityName ventingEntityData ventingUnderBeamHeight)))
            ((= ventingRatioStatus 2) (setq twoSectionActualVentingDictList (GetJSTwoSectionActualVentingArea entityName ventingEntityData ventingUnderBeamHeight)))
            ((= ventingRatioStatus 3) (alert "三个分区暂为开发！")))
          )
        )
      )
    )
    ; insert Venting Draw
    (if (= 4 status) 
      (progn 
        (setq infoDictList 
          (list 
            (cons "ventingRatioValue" ventingRatioValue)
            (cons "ventingHeight" (GetDottedPairValueUtils "ventingHeight" oneSectionVentingDictList))
            (cons "ventingLength" (GetDottedPairValueUtils "ventingLength" oneSectionVentingDictList))
            (cons "ventingWidth" (GetDottedPairValueUtils "ventingWidth" oneSectionVentingDictList))
            (cons "ventingArea" (GetDottedPairValueUtils "ventingArea" oneSectionVentingDictList))
            (cons "oneSectionActualVentingDictList" oneSectionActualVentingDictList)
            ; (cons "actualVentingArea" actualVentingArea)
            (cons "twoSectionVentingAspectRatio" (cdr twoSectionVentingAspectRatio))
          )
        )
        (if (= actualVentingArea nil)
          (alert "请先计算实际泄压面积！") 
          (InsertJSVentingRegion entityName xxyyValues (atof ventingDrawScale) ventingAxisoDictData ventingVertiacalAxisoDictData ventingRatioStatus infoDictList)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-06-30
(defun GetJSOneSectionVentingDictList (entityName ventingRatioValue ventingHeight / ventingHeightInt ventingRegionLengthWidth ventingLength ventingWidth aspectRatio ventingArea) 
  (setq ventingHeightInt (* (atof ventingHeight) 1000))
  (setq ventingRegionLengthWidth (GetJSVentingRegionLengthWidth entityName))
  (setq ventingLength (car ventingRegionLengthWidth))
  (setq ventingWidth (cadr ventingRegionLengthWidth))
  (setq aspectRatio (GetVentingAspectRatio ventingHeightInt ventingLength ventingWidth))
  (setq ventingArea (GetJSVentingArea ventingHeightInt ventingLength ventingWidth ventingRatioValue))
  (list 
    (cons "ventingLength" ventingLength)
    (cons "ventingWidth" ventingWidth)
    (cons "aspectRatio" aspectRatio)
    (cons "ventingArea" ventingArea)
    (cons "ventingHeight" ventingHeightInt)
  )
)

; 2021-06-30
(defun InsertJSVentingRegion (entityName xxyyValues scaleFactor ventingAxisoDictData ventingVertiacalAxisoDictData ventingRatioStatus infoDictList / insPt)
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
  (InsertJSHorizontialAxiso insPt ventingAxisoDictData scaleFactor)
  (InsertJSVerticalAxiso insPt ventingVertiacalAxisoDictData scaleFactor)
  (cond 
    ((= ventingRatioStatus 1) (InsertOneSectionJSVentingText insPt ventingVertiacalAxisoDictData scaleFactor infoDictList))
    ((= ventingRatioStatus 2) (InsertTwoSectionJSVentingText insPt ventingVertiacalAxisoDictData scaleFactor infoDictList))
  )
)

; 2021-06-30
(defun InsertTwoSectionJSVentingText (insPt ventingAxisoDictData scaleFactor infoDictList / 
                                      twoSectionVentingAspectRatio ventingVolumeOne ventingVolumeTwo ventingAreaOne ventingAreaTwo newInsPt) 
  (setq twoSectionVentingAspectRatio (GetDottedPairValueUtils "twoSectionVentingAspectRatio" infoDictList))
  (princ twoSectionVentingAspectRatio)(princ)
  (setq ventingVolumeOne 
    (fix 
      (CalculateJSVentingVolume 
        (GetDottedPairValueUtils "ventingHeight" infoDictList) 
        (nth 4 twoSectionVentingAspectRatio) 
        (GetDottedPairValueUtils "ventingWidth" infoDictList))
    )
  )
  (setq ventingVolumeTwo 
    (fix 
      (CalculateJSVentingVolume 
        (GetDottedPairValueUtils "ventingHeight" infoDictList) 
        (nth 5 twoSectionVentingAspectRatio) 
        (GetDottedPairValueUtils "ventingWidth" infoDictList))
    )
  )
  (setq ventingAreaOne (nth 2 twoSectionVentingAspectRatio))
  (setq ventingAreaTwo (nth 3 twoSectionVentingAspectRatio))
  (setq insPt 
    (MoveInsertPositionUtils insPt 0 (- (* (cdr (car (reverse ventingAxisoDictData))) scaleFactor) 1500)) 
  )
  (GenerateLevelLeftTextUtils insPt
    (strcat "泄压面积一计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolumeOne) "%%1402/3%%141=" (vl-princ-to-string ventingAreaOne) "平方米")
    "0DataFlow-Text" 
    450 0.7)
  (setq newInsPt 
    (MoveInsertPositionUtils insPt 0 -800) 
  )
  (GenerateLevelLeftTextUtils newInsPt
    (strcat "泄压面积二计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolumeTwo) "%%1402/3%%141=" (vl-princ-to-string ventingAreaTwo) "平方米")
    "0DataFlow-Text" 
    450 0.7)
  (setq newInsPt 
    (MoveInsertPositionUtils insPt 0 -1600) 
  )
  (GenerateLevelLeftTextUtils newInsPt
    (strcat "计算总泄压面积：" (vl-princ-to-string (+ ventingAreaOne ventingAreaTwo)) "平方米，实际总泄压面积：" (vl-princ-to-string (fix (GetDottedPairValueUtils "actualVentingArea" infoDictList))) "平方米，满足泄压面积要求")
    "0DataFlow-Text" 
    450 0.7)
)

; 2021-06-30
(defun InsertOneSectionJSVentingText (insPt ventingAxisoDictData scaleFactor infoDictList / ventingVolume) 
  (setq ventingVolume 
    (fix 
      (CalculateJSVentingVolume 
        (GetDottedPairValueUtils "ventingHeight" infoDictList) 
        (GetDottedPairValueUtils "ventingLength" infoDictList) 
        (GetDottedPairValueUtils "ventingWidth" infoDictList))
    )
  )
  (setq insPt 
    (MoveInsertPositionUtils insPt 0 (- (* (cdr (car (reverse ventingAxisoDictData))) scaleFactor) 1500)) 
  )
  (GenerateLevelLeftTextUtils insPt
    (strcat "泄压面积计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolume) "%%1402/3%%141=" (vl-princ-to-string (GetDottedPairValueUtils "ventingArea" infoDictList)) "平方米，实际泄压面积：" (vl-princ-to-string (fix (GetDottedPairValueUtils "actualVentingArea" infoDictList))) "平方米，满足泄压面积要求")
    "0DataFlow-Text" 
    450 0.7)
)

; 2021-06-30
(defun InsertJSHorizontialAxiso (insPt ventingAxisoDictData scaleFactor /)
  (mapcar '(lambda (x) 
            (InsertOneHorizontialJSAxiso insPt x)
          ) 
    (mapcar '(lambda (x) 
              (cons (car x) (* (cdr x) scaleFactor))
            ) 
      ventingAxisoDictData
    )
  )
)

; 2021-06-30
(defun InsertJSVerticalAxiso (insPt ventingAxisoDictData scaleFactor /)
  (mapcar '(lambda (x) 
            (InsertOneVerticalJSAxiso insPt x)
          ) 
    (mapcar '(lambda (x) 
              (cons (car x) (* (cdr x) scaleFactor))
            ) 
      ventingAxisoDictData
    )
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

; 2021-06-30
; add window-ventingWall
(defun GetJSOneSectionActualVentingArea (entityName ventingEntityData ventingHeight / ventingTotalLength actualVentingArea) 
  (setq ventingTotalLength (GetJSVentingTotalLength ventingEntityData))
  (setq actualVentingArea (* (atof ventingHeight)  (/ ventingTotalLength 1000.0)))
  (list 
    (cons "ventingTotalLength" ventingTotalLength)
    (cons "actualVentingArea" actualVentingArea)
  )
)

; 2021-06-30
; add window-ventingWall
(defun GetJSTwoSectionActualVentingArea (entityName ventingEntityData ventingHeight / ventingTotalLength actualVentingArea) 
  (setq ventingTotalLength (GetJSVentingTotalLength ventingEntityData))
  (setq actualVentingArea (* (atof ventingHeight)  (/ ventingTotalLength 1000.0)))
  (list 
    (cons "ventingTotalLength" ventingTotalLength)
    (cons "actualVentingArea" actualVentingArea)
  )
)

; 2021-06-30
(defun GetJSVentingTotalLength (ventingEntityData / )
  (+ 
    (GetJSVentingWindowLength ventingEntityData) 
    (GetJSVentingWallLength ventingEntityData) 
  )
)

; 2021-06-30
(defun GetJSVentingEntityData ()
  (GetEntityDataBySSUtils (GetJSVentingSS))
)

; 2021-06-30
(defun GetJSVentingSS () 
    (ssget '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WALL-MOVE")
          (8 . "WINDOW")
        (-4 . "OR>")
      )
    )
)

; 2021-06-30
(defun GetJSVentingWindowLength (ventingEntityData /)
  (apply '+ 
    (mapcar '(lambda (x) 
              (abs (GetDottedPairValueUtils 41 x))
            ) 
      (GetJSVentingBlockData ventingEntityData)
    ) 
  )
)

; 2021-06-30
(defun GetJSVentingWallLength (ventingEntityData /) 
  (GetHalfNumberUtils 
    (apply '+ 
      (mapcar '(lambda (x) 
                (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length)
              ) 
        (GetJSVentingWallData ventingEntityData)
      ) 
    )
  )
)

; 2021-06-30
(defun GetJSVentingBlockData (ventingEntityData /)
  (vl-remove-if-not '(lambda (x) 
                       (= (GetDottedPairValueUtils 0 x) "INSERT") 
                     ) 
    ventingEntityData
  ) 
)

; 2021-06-30
(defun GetJSVentingWallData (ventingEntityData /)
  (vl-remove-if-not '(lambda (x) 
                       (and 
                         (= (GetDottedPairValueUtils 0 x) "LINE") 
                         (> (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length) 150)
                       )
                     ) 
    ventingEntityData
  ) 
)

; 2021-06-29
; Perimeter subtract column-wall
(defun GetJSActualVentingAreaV1 (entityName antiVentingEntityData ventingHeight xxyyValues / ventingPerimeter antiVentingTotalLength) 
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
    (list 
      (car fristAxisPt)
      (car sencondAxisPt)
    )
    (list 
      (GetVentingAspectRatio ventingHeight (cdr fristAxisPt) ventingWidth)
      (GetVentingAspectRatio ventingHeight (- (cdr sencondAxisPt) (cdr fristAxisPt)) ventingWidth)
      (GetVentingAspectRatio ventingHeight (- ventingLength (cdr sencondAxisPt)) ventingWidth)
    )
    (list 
      (cdr fristAxisPt)
      (- (cdr sencondAxisPt) (cdr fristAxisPt))
      (- ventingLength (cdr sencondAxisPt))
    )
  )
)

; 2021-06-29
(defun GetTwoSectionVentingAspectRatio (ventingAxisoDictData oneSectionVentingDictList ventingRatio / ventingHeight ventingLength ventingWidth) 
  (setq ventingHeight (GetDottedPairValueUtils "ventingHeight" oneSectionVentingDictList))
  (setq ventingLength (GetDottedPairValueUtils "ventingLength" oneSectionVentingDictList))
  (setq ventingWidth (GetDottedPairValueUtils "ventingWidth" oneSectionVentingDictList))
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
                    (cdr x)
                    (- ventingLength (cdr x))
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
  (fix (* 10 ventingRatio (expt (CalculateJSVentingVolume ventingHeight ventingLength ventingWidth) (/ 2.0 3))))
)

; 2021-06-30
; return m3
(defun CalculateJSVentingVolume (ventingHeight ventingLength ventingWidth /)
  (setq ventingHeight (/ ventingHeight 1000.0))
  (setq ventingLength (/ ventingLength 1000.0))
  (setq ventingWidth (/ ventingWidth 1000.0))
  (* ventingHeight ventingLength ventingWidth)
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