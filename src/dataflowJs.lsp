; 冯大龙开发于 2020-2021 年
; Dataflow for JS
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoJS ()
  (alert "建筑设计流最新版本号 V0.1，更新时间：2021-07-05\n数据流内网地址：\\\\192.168.1.38\\dataflow-install")(princ)
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
  (CADLispCopyUtils (GetAllMoveDrawLabelSS) '(0 0 0) '(400000 0 0))
  (CADLispCopyUtils (GetAllCopyDrawLabelSS) '(0 0 0) '(400000 0 0)) 
  (CADLispCopyUtils (GetAllJSAxisSS) '(0 0 0) '(400000 0 0)) 
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
; red hat refactored at - 2021-06-30
(defun GetJSDrawFroVentingSS () 
  (ssget "X" '( 
      (-4 . "<OR")
        (-4 . "<AND")
          (0 . "LINE")
          (8 . "WALL-MOVE") 
        (-4 . "AND>") 
        (-4 . "<AND")
          (0 . "INSERT")
          (8 . "WINDOW")
        (-4 . "AND>")     
        (-4 . "<AND")
          (0 . "INSERT")
          (8 . "COLUMN")
        (-4 . "AND>") 
      (-4 . "OR>") 
    )
  )
)
; (defun GetJSDrawFroVentingSSV1 () 
;     (ssget "X" '( 
;         (-4 . "<OR")
;           (0 . "LINE")
;           (0 . "INSERT")
;         (-4 . "OR>") 
;         (-4 . "<OR")
;           (8 . "WINDOW")
;           (8 . "COLUMN")
;           (8 . "WALL-MOVE") 
;           (8 . "STAIR") 
;           (8 . "DOOR_FIRE")
;           (8 . "柱*") 
;         (-4 . "OR>")
;       )
;     )
; )

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
                                  ventingUnderBeamHeight ventingDrawScale ventingSplitPoint splitDistance oneSectionVentingDictList aspectRatio ventingAxisoDictData ventingVertiacalAxisoDictData ventingSpaceDictData ventingRatioStatus twoSectionVentingAspectRatio fristAxis lastAxis ventingEntityData oneSectionActualVentingDictList twoSectionActualVentingDictList actualVentingArea)
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
    (action_tile "btnUpdateCalculateVenting" "(done_dialog 5)")
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
        (set_tile "actualVentingAreaMsg" (strcat "实际泄压面积之和：" (vl-princ-to-string actualVentingArea)))
      )
    ) 
    (if (= ventingRatioStatus 2)
      (progn 
        (set_tile "aspectRatioMsg" (strcat "初始长径比：" (vl-princ-to-string aspectRatio) "  区域：" fristAxis " 轴到 " lastAxis " 轴"))
        (set_tile "aspectRatioOneMsg" 
                  (strcat "分区一长径比：" (vl-princ-to-string (GetDottedPairValueUtils "firstSectionVentingAspectRatio" (cdr twoSectionVentingAspectRatio))) "  区域：" fristAxis " 轴到 " (car twoSectionVentingAspectRatio) " 轴（米）  计算泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "firstSectionVentingArea" (cdr twoSectionVentingAspectRatio))) "  分区一实际泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "firstActualVentingArea" twoSectionActualVentingDictList)) "  分区一实际泄压边长：" (vl-princ-to-string (GetDottedPairValueUtils "firstVentingLength" twoSectionActualVentingDictList))))
        (set_tile "aspectRatioTwoMsg" 
                  (strcat "分区二长径比：" (vl-princ-to-string (GetDottedPairValueUtils "secondSectionVentingAspectRatio" (cdr twoSectionVentingAspectRatio))) "  区域：" (car twoSectionVentingAspectRatio) " 轴（米）到 " lastAxis " 轴  计算泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "secondSectionVentingArea" (cdr twoSectionVentingAspectRatio))) "  分区二实际泄压面积：" (vl-princ-to-string (GetDottedPairValueUtils "secondActualVentingArea" twoSectionActualVentingDictList)) "  分区二实际泄压边长：" (vl-princ-to-string (GetDottedPairValueUtils "secondVentingLength" twoSectionActualVentingDictList))))
        (set_tile "calculateVentingAreaMsg" (strcat "计算泄压面积之和：" (vl-princ-to-string (+ (GetDottedPairValueUtils "firstSectionVentingArea" (cdr twoSectionVentingAspectRatio)) (GetDottedPairValueUtils "secondSectionVentingArea" (cdr twoSectionVentingAspectRatio))))))
        (set_tile "actualVentingAreaMsg" (strcat "实际泄压面积之和：" (vl-princ-to-string actualVentingArea)))
      )
    ) 
    ; ((firstVentingLength . 44355.0) (secondVentingLength . 32400.0) (firstActualVentingArea . 230.646) (secondActualVentingArea . 168.48) (actualVentingArea . 399.126))
    (if (= ventingRatioStatus 3)
      (set_tile "aspectRatioThreeMsg" "两段分区的长径比无法同时小于 3！")
    ) 
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
          (setq splitDistance (* (atof ventingSplitPoint) 1000))
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
          (setq ventingSpaceDictData (GetVentingSpaceDictData xxyyValues))
          (if (< aspectRatio 3) 
            (setq ventingRatioStatus 1)
            (progn 
              (cond 
                ((and (= ventingSplitMethod "0") (= ventingSplitMode "0")) 
                 (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatio ventingAxisoDictData oneSectionVentingDictList ventingRatioValue)))
                ((and (= ventingSplitMethod "1") (= ventingSplitMode "0")) 
                 (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatio ventingSpaceDictData oneSectionVentingDictList ventingRatioValue)))
                ((= ventingSplitMode "1") 
                 (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatioByDistance splitDistance oneSectionVentingDictList ventingRatioValue)))
              )
              (if (/= twoSectionVentingAspectRatio nil) 
                (progn 
                  (setq twoSectionVentingAspectRatio (nth (/ (length twoSectionVentingAspectRatio) 2) twoSectionVentingAspectRatio))
                  (setq twoSectionVentingAspectRatio 
                         (RepairTwoSectionVentingAspectRatio twoSectionVentingAspectRatio entityName xxyyValues (* (atof ventingHeight) 1000) ventingRatioValue))
                  (setq ventingRatioStatus 2)
                )
                (setq ventingRatioStatus 3)
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
          (if (= ventingRatioStatus 1) 
            (progn 
              (setq oneSectionActualVentingDictList (GetJSOneSectionActualVentingArea entityName ventingEntityData ventingUnderBeamHeight))
              (setq actualVentingArea (GetDottedPairValueUtils "actualVentingArea" oneSectionActualVentingDictList))
            )
          )
          (if (= ventingRatioStatus 2) 
            (progn 
              (setq twoSectionActualVentingDictList 
                (GetJSTwoSectionActualVentingArea entityName ventingEntityData ventingUnderBeamHeight twoSectionVentingAspectRatio xxyyValues ventingSplitMethod ventingSplitMode))
              (setq actualVentingArea (GetDottedPairValueUtils "actualVentingArea" twoSectionActualVentingDictList))
            )
          )
        )
      )
    )
    ; insert Venting Draw
    (if (= 4 status) 
      (progn 
        (setq infoDictList 
          (list 
            (cons "aspectRatio" aspectRatio)
            (cons "ventingRatioValue" ventingRatioValue)
            (cons "ventingHeight" (GetDottedPairValueUtils "ventingHeight" oneSectionVentingDictList))
            (cons "ventingLength" (GetDottedPairValueUtils "ventingLength" oneSectionVentingDictList))
            (cons "ventingWidth" (GetDottedPairValueUtils "ventingWidth" oneSectionVentingDictList))
            (cons "ventingArea" (GetDottedPairValueUtils "ventingArea" oneSectionVentingDictList))
            (cons "ventingVolume" (GetDottedPairValueUtils "ventingVolume" oneSectionVentingDictList))
            (cons "twoSectionVentingAspectRatio" (cdr twoSectionVentingAspectRatio))
            (cons "oneSectionActualVentingDictList" oneSectionActualVentingDictList)
            (cons "twoSectionActualVentingDictList" twoSectionActualVentingDictList)
            (cons "actualVentingArea" actualVentingArea)
          )
        )
        (if (= actualVentingArea nil)
          (alert "请先计算实际泄压面积！") 
          (InsertJSVentingRegion entityName xxyyValues (atof ventingDrawScale) ventingAxisoDictData ventingVertiacalAxisoDictData ventingRatioStatus infoDictList)
        )
      )
    )
    ; update calculate venting Area
    (if (= 5 status) 
      (if (/= ventingSplitMode "1") 
        (alert "此功能只针对人工切割！")
        (progn 
          (setq splitDistance (* (atof ventingSplitPoint) 1000))
          (setq oneSectionVentingDictList (GetJSOneSectionVentingDictList entityName ventingRatioValue ventingHeight))
          (setq aspectRatio (GetDottedPairValueUtils "aspectRatio" oneSectionVentingDictList))
          (setq ventingAxisoDictData (ProcessJSHorizontialVentingAxisoDictData entityName))
          (setq ventingVertiacalAxisoDictData (ProcessJSVerticalVentingAxisoDictData entityName))
          (setq fristAxis (car (car ventingAxisoDictData)))
          (setq lastAxis (car (car (reverse ventingAxisoDictData))))
          (setq ventingSpaceDictData (GetVentingSpaceDictData xxyyValues))
          (setq twoSectionVentingAspectRatio (GetTwoSectionVentingAspectRatioByDistance splitDistance oneSectionVentingDictList ventingRatioValue))
          (setq twoSectionVentingAspectRatio (nth (/ (length twoSectionVentingAspectRatio) 2) twoSectionVentingAspectRatio))
          (setq ventingRatioStatus 2)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-06-30
(defun GetVentingSpaceDictData (xxyyValues / i lastPoint resultList)
  (setq i 1)
  (setq lastPoint (- (cadr xxyyValues) (car xxyyValues)))
  (repeat (- (fix (/ lastPoint 500)) 1)
    ; red hat - dict key must be string 2021-06-30
    (setq resultList (append resultList (list (cons (vl-princ-to-string (/ (* 500 i) 1000.0)) (* 500 i)))))
    (setq i (1+ i))
  ) 
  resultList
)

; 2021-06-30
(defun GetJSOneSectionVentingDictList (entityName ventingRatioValue ventingHeight / 
                                       ventingHeightInt ventingRegionLengthWidth ventingLength ventingWidth aspectRatio ventingArea ventingPolyLineArea ventingVolume) 
  (setq ventingHeightInt (* (atof ventingHeight) 1000))
  (setq ventingRegionLengthWidth (GetJSVentingRegionLengthWidth entityName))
  (setq ventingLength (car ventingRegionLengthWidth))
  (setq ventingWidth (cadr ventingRegionLengthWidth))
  (setq aspectRatio (GetVentingAspectRatio ventingHeightInt ventingLength ventingWidth))
  ; refactored at 2021-07-05
  (setq ventingPolyLineArea (GetJSPolyLineAreaUtils entityName))
  (setq ventingArea (GetJSVentingAreaV2 ventingHeightInt ventingPolyLineArea ventingRatioValue))
  (setq ventingVolume (fix (CalculateJSVentingVolumeV2 ventingHeightInt ventingPolyLineArea)))
  (list 
    (cons "ventingLength" ventingLength)
    (cons "ventingWidth" ventingWidth)
    (cons "aspectRatio" aspectRatio)
    (cons "ventingArea" ventingArea)
    (cons "ventingHeight" ventingHeightInt)
    (cons "ventingPolyLineArea" ventingPolyLineArea)
    (cons "ventingVolume" ventingVolume)
  )
)

; 2021-07-05
(defun GetJSPolyLineAreaUtils (entityName /)
  (/ (VlaGetPolyLineAreaUtils entityName) 1000000.0)
)

; 2021-06-30
; refactored at 2021-07-02
(defun InsertJSVentingRegion (entityName xxyyValues scaleFactor ventingAxisoDictData ventingVertiacalAxisoDictData ventingRatioStatus infoDictList / 
                              insPt newEntityData halfColumnLength)
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
  (SetGraphLayerUtils (entlast) "0")
  (if (= ventingRatioStatus 2) 
    (InsertTwoSectionSplitLine insPt infoDictList scaleFactor)
  )
  ; modify the position for column - refactored at 2021-07-02
  (setq halfColumnLength (* (GetJSLeftUpColumnLengthForVenting (car xxyyValues) (cadddr xxyyValues)) scaleFactor))
  (InsertJSHorizontialAxiso (MoveInsertPositionUtils insPt halfColumnLength 0) ventingAxisoDictData scaleFactor)
  (InsertJSVerticalAxiso (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils halfColumnLength)) ventingVertiacalAxisoDictData scaleFactor)
  (cond 
    ((= ventingRatioStatus 1) (InsertOneSectionJSVentingText insPt ventingVertiacalAxisoDictData scaleFactor infoDictList))
    ((= ventingRatioStatus 2) (InsertTwoSectionJSVentingText insPt ventingVertiacalAxisoDictData scaleFactor infoDictList))
  )
)

; 2021-07-02
(defun InsertTwoSectionSplitLine (insPt infoDictList scaleFactor / twoSectionActualVentingDictList splitDistance ventingWidth)
  (setq twoSectionActualVentingDictList (GetDottedPairValueUtils "twoSectionActualVentingDictList" infoDictList))
  (setq splitDistance (GetDottedPairValueUtils "splitDistance" twoSectionActualVentingDictList))
  (setq ventingWidth (GetDottedPairValueUtils "ventingWidth" infoDictList))
  (GenerateLineUtils (MoveInsertPositionUtils insPt splitDistance 0) (MoveInsertPositionUtils insPt splitDistance (GetNegativeNumberUtils ventingWidth)) "0")
  ;; Scale the line
  (vla-ScaleEntity (vlax-ename->vla-object (entlast)) (vlax-3d-point insPt) scaleFactor)
)

; 2021-06-30
; refactored at 2021-07-02
(defun InsertTwoSectionJSVentingText (insPt ventingAxisoDictData scaleFactor infoDictList / 
                                      twoSectionVentingAspectRatio twoSectionActualVentingDictList actualVentingArea 
                                      ventingVolumeOne ventingVolumeTwo ventingAreaOne ventingAreaTwo firstVentingLength secondVentingLength) 
  (setq twoSectionVentingAspectRatio (GetDottedPairValueUtils "twoSectionVentingAspectRatio" infoDictList))
  (setq twoSectionActualVentingDictList (GetDottedPairValueUtils "twoSectionActualVentingDictList" infoDictList))
  (setq actualVentingArea (GetDottedPairValueUtils "actualVentingArea" infoDictList))
  ; refactored at 2021-07-05
  (setq ventingVolumeOne (GetDottedPairValueUtils "ventingVolumeOne" twoSectionVentingAspectRatio))
  (setq ventingVolumeTwo (GetDottedPairValueUtils "ventingVolumeTwo" twoSectionVentingAspectRatio))
  (setq ventingAreaOne (GetDottedPairValueUtils "firstSectionVentingArea" twoSectionVentingAspectRatio))
  (setq ventingAreaTwo (GetDottedPairValueUtils "secondSectionVentingArea" twoSectionVentingAspectRatio))
  ; ((firstVentingLength . 44355.0) (secondVentingLength . 32400.0) (firstActualVentingArea . 230.646) (secondActualVentingArea . 168.48) (actualVentingArea . 399.126))
  (setq firstActualVentingArea (GetDottedPairValueUtils "firstActualVentingArea" twoSectionActualVentingDictList))
  (setq secondActualVentingArea (GetDottedPairValueUtils "secondActualVentingArea" twoSectionActualVentingDictList))
  (setq firstVentingLength (GetDottedPairValueUtils "firstVentingLength" twoSectionActualVentingDictList))
  (setq secondVentingLength (GetDottedPairValueUtils "secondVentingLength" twoSectionActualVentingDictList))
  (setq insPt 
    (MoveInsertPositionUtils insPt 0 (- (* (cdr (car (reverse ventingAxisoDictData))) scaleFactor) 1500)) 
  )
  (GenerateLevelLeftTextUtils insPt
    (strcat "泄压面积一计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolumeOne) "%%1402/3%%141=" (vl-princ-to-string ventingAreaOne) "平方米，实际泄压面积：" (vl-princ-to-string (fix firstActualVentingArea)) "平方米")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -800) 
    (strcat "泄压面积二计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolumeTwo) "%%1402/3%%141=" (vl-princ-to-string ventingAreaTwo) "平方米，实际泄压面积：" (vl-princ-to-string (fix secondActualVentingArea)) "平方米")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -1600) 
    (strcat "计算总泄压面积：" (vl-princ-to-string (+ ventingAreaOne ventingAreaTwo)) "平方米，实际总泄压面积：" (vl-princ-to-string (fix actualVentingArea)) "平方米，满足泄压面积要求")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -2400) 
    (strcat "分区一实际泄压边长：" (vl-princ-to-string (/ firstVentingLength 1000)) "米，分区二实际泄压边长：" (vl-princ-to-string (/ secondVentingLength 1000)) "米")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -3200) 
    (strcat "分区一泄压比：" (vl-princ-to-string (GetDottedPairValueUtils "firstSectionVentingAspectRatio" twoSectionVentingAspectRatio)) "，分区二泄压比：" (vl-princ-to-string (GetDottedPairValueUtils "secondSectionVentingAspectRatio" twoSectionVentingAspectRatio)))
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -4000) 
    (strcat "分割点离左上角定位点水平距离：" (vl-princ-to-string (/ (GetDottedPairValueUtils "splitDistance" twoSectionActualVentingDictList) 1000)) "米")
    "0DataFlow-Text" 
    450 0.7)
)

; 2021-06-30
(defun InsertOneSectionJSVentingText (insPt ventingAxisoDictData scaleFactor infoDictList / oneSectionActualVentingDictList ventingTotalLength ventingVolume) 
  (setq oneSectionActualVentingDictList (GetDottedPairValueUtils "oneSectionActualVentingDictList" infoDictList))
  (setq ventingTotalLength (GetDottedPairValueUtils "ventingTotalLength" oneSectionActualVentingDictList))
  (setq ventingVolume (GetDottedPairValueUtils "ventingVolume" infoDictList))
  (setq insPt 
    (MoveInsertPositionUtils insPt 0 (- (* (cdr (car (reverse ventingAxisoDictData))) scaleFactor) 1500)) 
  )
  (GenerateLevelLeftTextUtils insPt
    (strcat "泄压面积计算：10CV%%1402/3%%141=10x" (vl-princ-to-string (GetDottedPairValueUtils "ventingRatioValue" infoDictList)) "x" (vl-princ-to-string ventingVolume) "%%1402/3%%141=" (vl-princ-to-string (GetDottedPairValueUtils "ventingArea" infoDictList)) "平方米，实际泄压面积：" (vl-princ-to-string (fix (GetDottedPairValueUtils "actualVentingArea" infoDictList))) "平方米，满足泄压面积要求")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -800) 
    (strcat "实际泄压边长：" (vl-princ-to-string (/ ventingTotalLength 1000)) "米")
    "0DataFlow-Text" 
    450 0.7)
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 -1600) 
    (strcat "长径比：" (vl-princ-to-string (GetDottedPairValueUtils "aspectRatio" infoDictList)))
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
; manual split - refactor at 2021-07-02
(defun GetJSTwoSectionActualVentingArea (entityName ventingEntityData ventingHeight twoSectionVentingAspectRatio xxyyValues ventingSplitMethod ventingSplitMode / 
                                         firstSectionSideLength halfColumnLength splitPoint firstVentingLength secondVentingLength 
                                         firstActualVentingArea secondActualVentingArea actualVentingArea) 
  (setq firstSectionSideLength (GetDottedPairValueUtils "firstSectionSideLength" (cdr twoSectionVentingAspectRatio)))
  (setq halfColumnLength (GetJSLeftUpColumnLengthForVenting (car xxyyValues) (cadddr xxyyValues)))
  (cond 
    ((and (= ventingSplitMethod "0") (= ventingSplitMode "0")) 
     (setq splitPoint (+ (car xxyyValues) firstSectionSideLength halfColumnLength)))
    ((and (= ventingSplitMethod "1") (= ventingSplitMode "0")) 
     (setq splitPoint (+ (car xxyyValues) firstSectionSideLength)))
    ((= ventingSplitMode "1") 
     (setq splitPoint (+ (car xxyyValues) firstSectionSideLength)))
  )
  (cond 
    ((and (= ventingSplitMethod "0") (= ventingSplitMode "0")) 
     (setq firstVentingLength (GetJSFirstVentingLength ventingEntityData splitPoint)))
    ((and (= ventingSplitMethod "1") (= ventingSplitMode "0")) 
     (setq firstVentingLength (+ (GetJSFirstVentingLength ventingEntityData splitPoint) (GetCrossSplitPointVentingWalllength ventingEntityData splitPoint 0))))
    ((= ventingSplitMode "1") 
     (setq firstVentingLength (+ (GetJSFirstVentingLength ventingEntityData splitPoint) (GetCrossSplitPointVentingWalllength ventingEntityData splitPoint 0))))
  )
  (cond 
    ((and (= ventingSplitMethod "0") (= ventingSplitMode "0")) 
     (setq secondVentingLength (GetJSSecondVentingLength ventingEntityData splitPoint)))
    ((and (= ventingSplitMethod "1") (= ventingSplitMode "0")) 
     (setq secondVentingLength (+ (GetJSSecondVentingLength ventingEntityData splitPoint) (GetCrossSplitPointVentingWalllength ventingEntityData splitPoint 1))))
    ((= ventingSplitMode "1") 
     (setq secondVentingLength (+ (GetJSSecondVentingLength ventingEntityData splitPoint) (GetCrossSplitPointVentingWalllength ventingEntityData splitPoint 1))))
  )
  (setq firstActualVentingArea (* (atof ventingHeight)  (/ firstVentingLength 1000.0)))
  (setq secondActualVentingArea (* (atof ventingHeight)  (/ secondVentingLength 1000.0)))
  (list 
    (cons "firstVentingLength" firstVentingLength)
    (cons "secondVentingLength" secondVentingLength)
    (cons "firstActualVentingArea" firstActualVentingArea)
    (cons "secondActualVentingArea" secondActualVentingArea)
    (cons "actualVentingArea" (+ firstActualVentingArea secondActualVentingArea))
    (cons "splitDistance" (- splitPoint (car xxyyValues)))
  )
)

; 2021-06-30
(defun GetJSSecondVentingLength (ventingEntityData splitPoint / )
  (+ 
    (GetJSSecondVentingWindowLength ventingEntityData splitPoint) 
    (GetJSSecondVentingWallLength ventingEntityData splitPoint) 
  )
)

; 2021-06-30
(defun GetJSSecondVentingWindowLength (ventingEntityData splitPoint /)
  (apply '+ 
    (mapcar '(lambda (x) 
              (abs (GetDottedPairValueUtils 41 x))
            ) 
      (vl-remove-if-not '(lambda (x) 
                          (and 
                            (= (GetDottedPairValueUtils 0 x) "INSERT")
                            (= (GetDottedPairValueUtils 8 x) "WINDOW")
                            (> (car (GetDottedPairValueUtils 10 x)) splitPoint)
                          ) 
                        ) 
        ventingEntityData
      )
    ) 
  )
)

; 2021-06-30
; refactored at 2021-07-04
(defun GetJSSecondVentingWallLength (ventingEntityData splitPoint /) 
  (- 
    (GetHalfNumberUtils 
      (apply '+ 
        (mapcar '(lambda (x) 
                  (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length)
                ) 
          (GetJSSecondVentingWallData ventingEntityData splitPoint)
        ) 
      )
    )
    (GetRepairJSSecondVentingWallLength ventingEntityData splitPoint)
  )
)

; 2021-06-30
(defun GetJSSecondVentingWallData (ventingEntityData splitPoint /)
  (vl-remove-if-not '(lambda (x) 
                       (and 
                         (= (GetDottedPairValueUtils 0 x) "LINE") 
                         (> (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length) 150)
                         (> (car (GetDottedPairValueUtils 10 x)) splitPoint)
                         (> (car (GetDottedPairValueUtils 11 x)) splitPoint)
                       )
                     ) 
    ventingEntityData
  ) 
)

; 2021-06-30
(defun GetJSFirstVentingLength (ventingEntityData splitPoint / )
  (+ 
    (GetJSFirstVentingWindowLength ventingEntityData splitPoint) 
    (GetJSFirstVentingWallLength ventingEntityData splitPoint) 
  )
)

; 2021-06-30
(defun GetJSFirstVentingWindowLength (ventingEntityData splitPoint /)
  (apply '+ 
    (mapcar '(lambda (x) 
              (abs (GetDottedPairValueUtils 41 x))
            ) 
      (vl-remove-if-not '(lambda (x) 
                          (and 
                            (= (GetDottedPairValueUtils 0 x) "INSERT")
                            (= (GetDottedPairValueUtils 8 x) "WINDOW")
                            (< (car (GetDottedPairValueUtils 10 x)) splitPoint)
                          ) 
                        ) 
        ventingEntityData
      )
    ) 
  )
)

; 2021-06-30
; refactored at 2021-07-04
(defun GetJSFirstVentingWallLength (ventingEntityData splitPoint /) 
  (- 
    (GetHalfNumberUtils 
      (apply '+ 
        (mapcar '(lambda (x) 
                  (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length)
                ) 
          (GetJSFirstVentingWallData ventingEntityData splitPoint)
        ) 
      )
    )
    (GetRepairJSFirstVentingWallLength ventingEntityData splitPoint)
  )
)

; 2021-07-04
(defun GetRepairJSFirstVentingWallLength (ventingEntityData splitPoint /) 
  (apply '+ 
    (mapcar '(lambda (x) 
              (car x)
            ) 
      (GetRepairJSFirstVentingWallData ventingEntityData splitPoint)
    ) 
  )
)

; 2021-07-04
(defun GetRepairJSFirstVentingWallData (ventingEntityData splitPoint /) 
  (vl-remove-if-not '(lambda (x) 
            (< (car (cdr x)) splitPoint)
          ) 
    (GetRepairJSVentingWallData ventingEntityData)
  ) 
)

; 2021-07-04
(defun GetRepairJSSecondVentingWallLength (ventingEntityData splitPoint /) 
  (apply '+ 
    (mapcar '(lambda (x) 
              (car x)
            ) 
      (GetRepairJSSecondVentingWallData ventingEntityData splitPoint)
    ) 
  )
)

; 2021-07-04
(defun GetRepairJSSecondVentingWallData (ventingEntityData splitPoint /) 
  (vl-remove-if-not '(lambda (x) 
            (> (car (cdr x)) splitPoint)
          ) 
    (GetRepairJSVentingWallData ventingEntityData)
  ) 
)

; 2021-07-02
(defun GetCrossSplitPointVentingWalllength (ventingEntityData splitPoint splitMode / filteredVentingWallData result)
  (setq filteredVentingWallData (FilteredCrossSplitVentingWallData ventingEntityData splitPoint))
  (if (/= filteredVentingWallData nil) 
    (setq result 
      (apply '+ 
        (mapcar '(lambda (x) 
                   (cond 
                     ; the key is split Mode
                     ((= splitMode 0) (- splitPoint (car (vl-sort x '<))))
                     ((= splitMode 1) (- (car (vl-sort x '>)) splitPoint))
                   )
                ) 
          filteredVentingWallData
        ) 
      )
    )
    (setq result 0)
  )
  (GetHalfNumberUtils result)
)

; 2021-07-02
(defun FilteredCrossSplitVentingWallData (ventingEntityData splitPoint /) 
  (mapcar '(lambda (x) 
            (list (car (GetDottedPairValueUtils 10 x)) (car (GetDottedPairValueUtils 11 x)))
          ) 
    (vl-remove-if-not '(lambda (x) 
                        (and 
                          (= (GetDottedPairValueUtils 0 x) "LINE") 
                          (> (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length) 150)
                          (or 
                            (and 
                              (< (car (GetDottedPairValueUtils 10 x)) splitPoint)
                              (> (car (GetDottedPairValueUtils 11 x)) splitPoint)
                            )
                            (and 
                              (> (car (GetDottedPairValueUtils 10 x)) splitPoint)
                              (< (car (GetDottedPairValueUtils 11 x)) splitPoint)
                            )
                          )
                        )
                      ) 
      ventingEntityData
    ) 
  )
)

; 2021-06-30
(defun GetJSFirstVentingWallData (ventingEntityData splitPoint /)
  (vl-remove-if-not '(lambda (x) 
                       (and 
                         (= (GetDottedPairValueUtils 0 x) "LINE") 
                         (> (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length) 150)
                         (< (car (GetDottedPairValueUtils 10 x)) splitPoint)
                         (< (car (GetDottedPairValueUtils 11 x)) splitPoint)
                       )
                     ) 
    ventingEntityData
  ) 
)

; 2021-06-30
refacotr at 2021-07-05
(defun GetJSLeftUpColumnLengthForVenting (leftPoint upPoint /)   
  (car 
    (mapcar '(lambda (x) 
              (GetHalfNumberUtils (abs (GetDottedPairValueUtils 41 x)))
            ) 
      (vl-remove-if-not '(lambda (x) 
                          (IsPositionInRegionByFourPointUtils 
                            (GetDottedPairValueUtils 10 x) 
                            ; red hat, refacotr at 2021-07-05
                            (- leftPoint 1000) (+ leftPoint 1000) (- upPoint 1000) (+ upPoint 1000)) 
                        ) 
        (GetAllJsColumnData)
      ) 
    )
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
  (GetEntityDataBySSUtils (GetJScalculateVentingSS))
)

; 2021-06-30
(defun GetJScalculateVentingSS () 
    (ssget '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WALL-MOVE")
          (8 . "WINDOW")
          (8 . "COLUMN")
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
      (FilterJSVentingWindowData ventingEntityData)
    ) 
  )
)

; 2021-06-30
; refactored at 2021-07-04
(defun GetJSVentingWallLength (ventingEntityData /) 
  (- 
    (GetHalfNumberUtils 
      (apply '+ 
        (mapcar '(lambda (x) 
                  (vlax-get-property (vlax-ename->vla-object (GetDottedPairValueUtils -1 x)) 'Length)
                ) 
          (FilterJSVentingWallData ventingEntityData)
        ) 
      )
    )
    (GetRepairJSVentingWallLength ventingEntityData)
  )
)

; 2021-07-04
(defun GetRepairJSVentingWallLength (ventingEntityData /) 
  (apply '+ 
    (mapcar '(lambda (x) 
              (car x)
            ) 
      (GetRepairJSVentingWallData ventingEntityData)
    ) 
  )
)

; 2021-07-04
(defun GetRepairJSVentingWallData (ventingEntityData / resultList) 
  (mapcar '(lambda (x) 
            (mapcar '(lambda (xx) 
                      (if (or 
                            (IsPointOnHorizontialLineUtils (cdr xx) (GetDottedPairValueUtils 10 x) (GetDottedPairValueUtils 11 x)) 
                            (IsPointOnVerticalLineUtils (cdr xx) (GetDottedPairValueUtils 10 x) (GetDottedPairValueUtils 11 x)) 
                          )
                        (if (not (member xx resultList))
                          (setq resultList (append resultList (list xx)))
                        )
                      )
                    ) 
              (GetJSVentingColumnLengthPoistionDict ventingEntityData)
            ) 
          ) 
    (FilterJSVentingWallData ventingEntityData)
  ) 
  resultList
  ; (vl-sort resultList '(lambda (x y) (< (car x) (car y)))) ; sort to deduplicate only valid for list
  ; (apply '+ resultList)
)

; 2021-07-04
(defun RepairJSVentingWallLengthV1 (ventingEntityData / resultList) 
  (mapcar '(lambda (x) 
            (mapcar '(lambda (xx) 
                      (if (IsPositionInRegionUtils (GetDottedPairValueUtils 11 x) xx) 
                        ; the key is 30 redundancy, recover now
                        ; 冗余度导致双线泄压墙只有一根可以落在柱范围内，所以自处捕获的长度无需除以2
                        (setq resultList (append resultList (list (GetHalfNumberUtils (- (cadr xx) (car xx) -60)))))
                      )
                      (if (IsPositionInRegionUtils (GetDottedPairValueUtils 10 x) xx) 
                        (setq resultList (append resultList (list (GetHalfNumberUtils (- (cadr xx) (car xx) -60)))))
                      )
                    ) 
              (GetJSVentingColumnRegionList ventingEntityData)
            ) 
          ) 
    (FilterJSVentingWallData ventingEntityData)
  ) 
  (apply '+ resultList)
)

; 2021-07-04
(defun GetJSVentingColumnRegionList (ventingEntityData / halfColumnLength) 
  (mapcar '(lambda (x) 
             ; the key is 30 redundancy, recover later
            (setq halfColumnLength (- (GetHalfNumberUtils (GetDottedPairValueUtils 41 x)) 30))
            (list 
              (- (car (GetDottedPairValueUtils 10 x)) halfColumnLength)
              (+ (car (GetDottedPairValueUtils 10 x)) halfColumnLength)
              (- (cadr (GetDottedPairValueUtils 10 x)) halfColumnLength)
              (+ (cadr (GetDottedPairValueUtils 10 x)) halfColumnLength)
            )
          ) 
    (FilterJSVentingColumnData ventingEntityData)
  ) 
)

; 2021-07-04
(defun GetJSVentingColumnLengthPoistionDict (ventingEntityData /) 
  (mapcar '(lambda (x) 
            (cons (GetDottedPairValueUtils 41 x) (GetDottedPairValueUtils 10 x))
           )
    (FilterJSVentingColumnData ventingEntityData)
  ) 
)

; 2021-06-30
(defun FilterJSVentingWindowData (ventingEntityData /)
  (vl-remove-if-not '(lambda (x) 
                       (= (GetDottedPairValueUtils 0 x) "INSERT") 
                       (= (GetDottedPairValueUtils 8 x) "WINDOW") 
                     ) 
    ventingEntityData
  ) 
)

; 2021-07-04
(defun FilterJSVentingColumnData (ventingEntityData /)
  (vl-remove-if-not '(lambda (x) 
                       (= (GetDottedPairValueUtils 0 x) "INSERT") 
                       (= (GetDottedPairValueUtils 8 x) "COLUMN") 
                     ) 
    ventingEntityData
  ) 
)

; 2021-06-30
(defun FilterJSVentingWallData (ventingEntityData /)
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
      (FilterJSVentingColumnData antiVentingEntityData)
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
  ; red hat: must delete the last item, because may generate a negative length 2021-06-30
  (setq ventingAxisoDictData (reverse (cdr (reverse ventingAxisoDictData))))
  (vl-remove-if-not '(lambda (x) 
                       (and 
                         (< (GetDottedPairValueUtils "firstSectionVentingAspectRatio" (cdr x)) 3)
                         (< (GetDottedPairValueUtils "secondSectionVentingAspectRatio" (cdr x)) 3)
                       ) 
                     ) 
    (mapcar '(lambda (x) 
              (cons (car x) 
                  (list 
                    (cons "firstSectionVentingAspectRatio" (GetVentingAspectRatio ventingHeight (cdr x) ventingWidth))
                    ; red hat: must delete the last item, because may generate a negative length 2021-06-30
                    (cons "secondSectionVentingAspectRatio" (GetVentingAspectRatio ventingHeight (- ventingLength (cdr x)) ventingWidth))
                    (cons "firstSectionVentingArea" (GetJSVentingArea ventingHeight (cdr x) ventingWidth ventingRatio))
                    (cons "secondSectionVentingArea" (GetJSVentingArea ventingHeight (- ventingLength (cdr x)) ventingWidth ventingRatio))
                    (cons "firstSectionSideLength" (cdr x))
                    (cons "secondSectionSideLength" (- ventingLength (cdr x)))
                  )
              )
            ) 
      ventingAxisoDictData
    )                 
  )
)

; 2021-07-05
(defun RepairTwoSectionVentingAspectRatio (twoSectionVentingAspectRatio entityName xxyyValues ventingHeight ventingRatio / 
                                           axiosKey insPt splitDistance polyLineEntityName lineEntityName twoSectionVentingPolyLineArea firstSectionVentingArea secondSectionVentingArea ventingVolumeOne ventingVolumeTwo)
  (setq axiosKey (car twoSectionVentingAspectRatio))
  (setq twoSectionVentingAspectRatio (cdr twoSectionVentingAspectRatio))
  (setq splitDistance (GetDottedPairValueUtils "firstSectionSideLength" twoSectionVentingAspectRatio))
  (CADLispCopyUtils (GetSSByOneEntityNameUtils entityName) '(0 0 0) '(200000 0 0))
  (setq polyLineEntityName (entlast))
  (setq insPt (MoveInsertPositionUtils (list (car xxyyValues) (cadddr xxyyValues) 0) 200000 0))
  (GenerateLineUtils (MoveInsertPositionUtils insPt splitDistance 0) (MoveInsertPositionUtils insPt splitDistance -40000) "0")
  (setq lineEntityName (entlast))
  (setq twoSectionVentingPolyLineArea (GetTwoSectionVentingPolyLineArea lineEntityName polyLineEntityName))
  (setq firstSectionVentingArea (GetJSVentingAreaV2 ventingHeight (GetDottedPairValueUtils "firstSectionPolyLineArea" twoSectionVentingPolyLineArea) ventingRatio))
  (setq secondSectionVentingArea (GetJSVentingAreaV2 ventingHeight (GetDottedPairValueUtils "secondSectionPolyLineArea" twoSectionVentingPolyLineArea) ventingRatio))
  (setq twoSectionVentingAspectRatio 
    (subst 
      (cons "firstSectionVentingArea" firstSectionVentingArea)
      (assoc "firstSectionVentingArea" twoSectionVentingAspectRatio)
      twoSectionVentingAspectRatio)   
  )
  (setq twoSectionVentingAspectRatio 
    (subst 
      (cons "secondSectionVentingArea" secondSectionVentingArea)
      (assoc "secondSectionVentingArea" twoSectionVentingAspectRatio)
      twoSectionVentingAspectRatio)   
  )
  (setq ventingVolumeOne (fix (CalculateJSVentingVolumeV2 ventingHeight (GetDottedPairValueUtils "firstSectionPolyLineArea" twoSectionVentingPolyLineArea))))
  (setq ventingVolumeTwo (fix (CalculateJSVentingVolumeV2 ventingHeight (GetDottedPairValueUtils "secondSectionPolyLineArea" twoSectionVentingPolyLineArea))))
  (setq twoSectionVentingAspectRatio 
    (append
      twoSectionVentingAspectRatio
      (list 
        (cons "ventingVolumeOne" ventingVolumeOne)
        (cons "ventingVolumeTwo" ventingVolumeTwo)
      )
    )   
  )
  (entdel lineEntityName)
  (entdel polyLineEntityName)
  (cons axiosKey twoSectionVentingAspectRatio)
)

; 2021-07-05
(defun GetTwoSectionVentingPolyLineArea (lineEntityName polyLineEntityName / totalPolyLineArea firstSectionPolyLineArea secondSectionPolyLineArea)
  (setq totalPolyLineArea (GetJSPolyLineAreaUtils polyLineEntityName))
  (TrimJSVentingPolyLine lineEntityName polyLineEntityName)
  (setq secondSectionPolyLineArea (GetJSPolyLineAreaUtils polyLineEntityName))
  (setq firstSectionPolyLineArea (- totalPolyLineArea secondSectionPolyLineArea))
  (list 
    (cons "totalPolyLineArea" totalPolyLineArea) 
    (cons "firstSectionPolyLineArea" firstSectionPolyLineArea) 
    (cons "secondSectionPolyLineArea" secondSectionPolyLineArea)
  )
)

; 2021-07-05
(defun TrimJSVentingPolyLine (lineEntityName polyLineEntityName / lineSS polySS)
  (setq lineSS (GetSSByOneEntityNameUtils lineEntityName))
  (setq polySS (GetSSByOneEntityNameUtils polyLineEntityName))
  (CADLispTrimUtils lineSS polySS)
  
)

; 2021-07-02
(defun GetTwoSectionVentingAspectRatioByDistance (splitDistance oneSectionVentingDictList ventingRatio / ventingHeight ventingLength ventingWidth) 
  (setq ventingHeight (GetDottedPairValueUtils "ventingHeight" oneSectionVentingDictList))
  (setq ventingLength (GetDottedPairValueUtils "ventingLength" oneSectionVentingDictList))
  (setq ventingWidth (GetDottedPairValueUtils "ventingWidth" oneSectionVentingDictList))
  (list 
    (cons (vl-princ-to-string (/ splitDistance 1000) )
        (list 
          (cons "firstSectionVentingAspectRatio" (GetVentingAspectRatio ventingHeight splitDistance ventingWidth))
          (cons "secondSectionVentingAspectRatio" (GetVentingAspectRatio ventingHeight (- ventingLength splitDistance) ventingWidth))
          (cons "firstSectionVentingArea" (GetJSVentingArea ventingHeight splitDistance ventingWidth ventingRatio))
          (cons "secondSectionVentingArea" (GetJSVentingArea ventingHeight (- ventingLength splitDistance) ventingWidth ventingRatio))
          (cons "firstSectionSideLength" splitDistance)
          (cons "secondSectionSideLength" (- ventingLength splitDistance))
        )
    )
  )
)

; 2021-06-28
(defun GetVentingAspectRatio (ventingHeight ventingLength ventingWidth / crossSectionPerimeter) 
  (setq crossSectionPerimeter (* (+ ventingHeight ventingWidth) 2))
  (/ (* ventingLength crossSectionPerimeter) (* ventingHeight ventingWidth 4))
)

; 2021-06-29
; unit test completed
(defun GetJSVentingArea (ventingHeight ventingLength ventingWidth ventingRatio /) 
  (fix (* 10 ventingRatio (expt (CalculateJSVentingVolume ventingHeight ventingLength ventingWidth) (/ 2.0 3))))
)

; 2021-07-05
(defun GetJSVentingAreaV2 (ventingHeight ventingPolyLineArea ventingRatio /) 
  (fix (* 10 ventingRatio (expt (CalculateJSVentingVolumeV2 ventingHeight ventingPolyLineArea) (/ 2.0 3))))
)

; 2021-07-05
; return m3
(defun CalculateJSVentingVolumeV2 (ventingHeight ventingPolyLineArea /)
  (setq ventingHeight (/ ventingHeight 1000.0))
  (* ventingHeight ventingPolyLineArea)
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
; the Region is PL or columnZone, ready to comfirm 2021-07-02
(defun GetJSVentingRegionLengthWidth (entityName / xxyyValues) 
  ; (setq xxyyValues (GetMinMaxXYValuesUtils (GetJSColumnPositionForVenting entityName)))
  (setq xxyyValues (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget entityName))))
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
                       (IsPositionInRegionByFourPointUtils x (car filterRegion) (cadr filterRegion) (caddr filterRegion) (cadddr filterRegion)) 
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
                       (IsPositionInRegionByFourPointUtils 
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
                        (IsPositionInRegionByFourPointUtils 
                          (GetDottedPairValueUtils 10 x) 
                          (- (car filterRegion) 30000) (car filterRegion) (caddr filterRegion) (cadddr filterRegion)) 
                      ) 
      allJsAxisoData
    ) 
  )
  (if (= resultList nil) 
    (setq resultList 
      (vl-remove-if-not '(lambda (x) 
                          (IsPositionInRegionByFourPointUtils 
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