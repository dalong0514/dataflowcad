;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoBS ()
  (alert "设备设计流最新版本号 V0.5，更新时间：2021-07-18\n数据流内网地址：\\\\192.168.1.38\\dataflow-install")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Constants

; 2021-05-07
(defun GetBsGCTInspectDictData (inspectRate prefixString /) 
  (mapcar '(lambda (x) 
             (cons 
               (strcat prefixString (car x))
               (cdr x)
             )
           ) 
    (GetBsGCTInspectDictDataStrategy inspectRate)
  )
)

; 2021-05-07
; refactored at 2021-06-12
(defun GetBsGCTInspectDictDataStrategy (inspectRate /) 
  (cond 
    ((= inspectRate "20%") 
     (list (cons "INSPECT_RATE" "20%") (cons "INSPECT_GRADE" "AB") (cons "INSPECT_STANDARD" "NB/T47013.2-2015") (cons "INSPECT_QUALIFIED" "RT-Ⅲ")))
    ((= inspectRate "100%") 
     (list (cons "INSPECT_RATE" "100%") (cons "INSPECT_GRADE" "AB") (cons "INSPECT_STANDARD" "NB/T47013.2-2015") (cons "INSPECT_QUALIFIED" "RT-Ⅱ")))
    (T (list (cons "INSPECT_RATE" "/") (cons "INSPECT_GRADE" "/") (cons "INSPECT_STANDARD" "/") (cons "INSPECT_QUALIFIED" "/")))
  )
)

; Constants
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;




;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Bs Utils

(defun GetAllBsGCTTableSSUtils (/ ss)
  (ssget "X" '((0 . "INSERT") (2 . "BsGCTTable*")))
)

; Bs Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate BsGCT - Tank

; 2021-06-11
(defun VerifyAllBsGCTSymbol ()
  (if (= *bsGCTSymbolStatus* nil) 
    (progn 
      (VerifyBsGCTBlockLayerText)
      (setq *bsGCTSymbolStatus* T) 
    )
  )
)

; 2021-04-17
(defun VerifyBsGCTBlockLayerText ()
  (VerifyBsTextStyleByName "DataFlow")
  (VerifyBsTextStyleByName "TitleText")
  (VerifyBsLayerByName "0DataFlow*")
  (VerifyBsDimensionStyleByName "DataFlow*")
  (VerifyBsBlockByName "BsGCT*")
  (VerifyBsBlockByName "*\.2017")
)

; 2021-04-17
; refactored at 2021-06-11
(defun InsertBsGCTDrawFrame (insPt dataType bsGCTProjectDictData drawFrameScale /) 
  (InsertBlockByNoPropertyByScaleUtils insPt "BsGCTDrawFrame" "0DataFlow-BsFrame" drawFrameScale)
  (InsertBlockByScaleUtils insPt "title.equip.2017" "0DataFlow-BsFrame" (list (cons 4 "工程图")) drawFrameScale)
  (setq bsGCTProjectDictData 
         (append bsGCTProjectDictData 
                (mapcar '(lambda (x y) 
                          (cons x y)
                        ) 
                  '("PROJECT2L1" "PROJECT2L2")
                  (SplitProjectInfoToTwoLineUtils (GetDottedPairValueUtils "PROJECT" bsGCTProjectDictData)))
                (list (cons "Speci" "设备") (cons "Scale" (strcat "1:" (vl-princ-to-string drawFrameScale))) 
                      (cons "EquipNAME" dataType) (cons "AuthD" "") (cons "PROJECT1" ""))))
  (ModifyBlockPropertyByDictDataUtils (entlast) bsGCTProjectDictData)
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 (* drawFrameScale 46)) "revisions.2017" "0DataFlow-BsFrame" (list (cons 2 "1")) drawFrameScale)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 (* drawFrameScale 71)) "intercheck.2017" "0DataFlow-BsFrame" drawFrameScale)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 (* drawFrameScale 108)) "stamp2.2017" "0DataFlow-BsFrame" drawFrameScale)
)

; 2021-04-17
(defun InsertBsGCTDataHeader (insPt dataType drawFrameScale /) 
  (InsertBlockByScaleUtils insPt "BsGCTTableDataHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
)

; 2021-04-17
; refactored at - 2021-04-20
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTDesignParam (insPt dataType designParamDictList blockName drawFrameScale /) 
  (InsertBlockByScaleUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (ModifyBlockPropertyByDictDataUtils (entlast) designParamDictList)
)

; refactored at 2021-04-20
; refactored at 2021-05-25
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-13 frameHeight
(defun InsertBsGCTDesignStandard (insPt dataType blockName tankStandardList drawFrameScale frameHeight /) 
  (InsertBlockByScaleUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (VlaSetOneDynamicBlockPropertyValueUtils (GetLastVlaObjectUtils) "HEIGHT" (* drawFrameScale frameHeight))
  (InsertBsGCTTankStandardText (MoveInsertPositionUtils insPt (* drawFrameScale 4) (* drawFrameScale -16)) tankStandardList dataType drawFrameScale)
)

; 2021-04-20
; refactored at 2021-05-18
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTTankStandardText (insPt tankStandardList dataType drawFrameScale / i) 
  (setq i 0)
  (repeat (length tankStandardList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -6) i)) (nth i tankStandardList) "0DataFlow-BsText" (* drawFrameScale 4) 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; refactored at 2021-04-20
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTRequirement (insPt dataType blockName tankHeadStyleList tankHeadMaterialList drawFrameScale /) 
  (InsertBlockByScaleUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (InsertBsGCTRequirementTextStrategy insPt dataType blockName tankHeadStyleList tankHeadMaterialList drawFrameScale)
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTRequirementTextStrategy (insPt dataType blockName tankHeadStyleList tankHeadMaterialList drawFrameScale /)
  (cond 
    ((= blockName "BsGCTTableRequirement") (InsertBsGCTTankRequirementText insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale))
    ((= blockName "BsGCTTableRequirement-Heater") (InsertBsGCTHeaterRequirementText insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale))
    ((= blockName "BsGCTTableRequirement-Reactor") (InsertBsGCTReactorRequirementText insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale))
  )
)

; 2021-06-15
; for tank y position (* drawFrameScale -20) for heater: (* drawFrameScale -16) for reactor: (* drawFrameScale -14)
(defun InsertBsGCTReactorRequirementText (insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale /)
  (InsertBsGCTEquipHeadStyleText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -14)) tankHeadStyleList dataType drawFrameScale)
  (InsertBsGCTEquipHeadMaterialText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -48)) tankHeadMaterialList dataType drawFrameScale)
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
; for tank y position (* drawFrameScale -20) for heater: (* drawFrameScale -16) for reactor: (* drawFrameScale -14)
(defun InsertBsGCTTankRequirementText (insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale /)
  (InsertBsGCTEquipHeadStyleText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -20)) tankHeadStyleList dataType drawFrameScale)
  (InsertBsGCTEquipHeadMaterialText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -48)) tankHeadMaterialList dataType drawFrameScale)
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTHeaterRequirementText (insPt dataType tankHeadStyleList tankHeadMaterialList drawFrameScale /)
  (InsertBsGCTEquipHeadStyleText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -16)) tankHeadStyleList dataType drawFrameScale)
  (InsertBsGCTEquipHeadMaterialText (MoveInsertPositionUtils insPt (* drawFrameScale 11) (* drawFrameScale -40)) tankHeadMaterialList dataType drawFrameScale)
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-15 Reactor
(defun InsertBsGCTInspectDataStrategy (insPt dataType blockName oneEquipData drawFrameScale /) 
  (cond 
    ((= blockName "Tank") (InsertBsGCTTankInspectData insPt dataType oneEquipData drawFrameScale))
    ((= blockName "Heater") (InsertBsGCTHeaterInspectData insPt dataType oneEquipData drawFrameScale))
    ((= blockName "Reactor") (InsertBsGCTReactorInspectData insPt dataType oneEquipData drawFrameScale))
  )
)

; 2021-06-15
(defun InsertBsGCTReactorInspectData (insPt dataType oneHeaterData drawFrameScale / inspectDictData barrelWeldJoint jacketWeldJoint) 
  (setq barrelDiameter (atoi (GetDottedPairValueUtils "barrelDiameter" oneHeaterData)))
  (setq barrelWeldJoint (GetDottedPairValueUtils "BARREL_WELD_JOINT" oneHeaterData))
  (setq jacketWeldJoint (GetDottedPairValueUtils "JACKET_WELD_JOINT" oneHeaterData))
  (if (<= barrelDiameter 1200) 
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-ReactorB" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale) 
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-ReactorA" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  )
  (setq inspectDictData (append 
                          (GetBsGCTReactorJacketInspectDictData jacketWeldJoint (GetDottedPairValueUtils "JACKET_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTBarrelInspectDictData barrelWeldJoint (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTHeadInspectDictData barrelWeldJoint (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneHeaterData) "CD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CLOSED_RING_INSPECT_RATE" oneHeaterData) "CLOSED_RING_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "RIGID_RING_INSPECT_RATE" oneHeaterData) "RIGID_RING_")
                        ))
  (ModifyBlockPropertyByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-13
(defun InsertBsGCTHeaterInspectData (insPt dataType oneHeaterData drawFrameScale / inspectDictData tubeWeldJoint shellWeldJoint) 
  (setq barrelDiameter (atoi (GetDottedPairValueUtils "barrelDiameter" oneHeaterData)))
  (setq tubeWeldJoint (GetDottedPairValueUtils "TUBE_WELD_JOINT" oneHeaterData))
  (setq shellWeldJoint (GetDottedPairValueUtils "SHELL_WELD_JOINT" oneHeaterData))
  (if (<= barrelDiameter 1200) 
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-HeaterB" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-HeaterA" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  )
  (setq inspectDictData (append 
                          (GetBsGCTHeaterBarrelInspectDictData shellWeldJoint (GetDottedPairValueUtils "SHELL_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTBarrelInspectDictData tubeWeldJoint (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTHeadInspectDictData tubeWeldJoint (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneHeaterData) "CD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEATER_INSPECT_RATE" oneHeaterData) "HEATER_")
                        ))
  (ModifyBlockPropertyByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-07
; refactored at 2021-05-11
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-13
(defun InsertBsGCTTankInspectData (insPt dataType oneTankData drawFrameScale / inspectDictData barrelDiameter weldJoint) 
  ; BsGCTTableInspectData-TankA or BsGCTTableInspectData-TankB, ready for the whole logic 2021-05-11
  (setq barrelDiameter (atoi (GetDottedPairValueUtils "barrelDiameter" oneTankData)))
  (setq weldJoint (GetDottedPairValueUtils "WELD_JOINT" oneTankData))
  (if (<= barrelDiameter 1200) 
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-TankB" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
    (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-TankA" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  )
  (setq inspectDictData (append 
                          (GetBsGCTBarrelInspectDictData weldJoint (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneTankData))
                          (GetBsGCTHeadInspectDictData weldJoint (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneTankData))
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneTankData) "CD_")
                        ))
  (ModifyBlockPropertyByDictDataUtils (entlast) inspectDictData)
)

; 2021-06-15
(defun GetBsGCTReactorJacketInspectDictData (weldJoint barrelInspectRate /) 
  (if (/= barrelInspectRate "") 
    (GetBsGCTInspectDictData barrelInspectRate "JACKET_")
    (GetBsGCTInspectDictData (GetBsInspectRateByWeldJointEnums weldJoint) "JACKET_")
  )
)

; 2021-06-13
(defun GetBsGCTHeaterBarrelInspectDictData (shellWeldJoint barrelInspectRate /) 
  (if (/= barrelInspectRate "") 
    (GetBsGCTInspectDictData barrelInspectRate "SHELL_BARREL_")
    (GetBsGCTInspectDictData (GetBsInspectRateByWeldJointEnums shellWeldJoint) "SHELL_BARREL_")
  )
)

; 2021-06-13
(defun GetBsGCTBarrelInspectDictData (weldJoint barrelInspectRate /) 
  (if (/= barrelInspectRate "") 
    (GetBsGCTInspectDictData barrelInspectRate "BARREL_")
    (GetBsGCTInspectDictData (GetBsBarrelInspectRate weldJoint) "BARREL_")
  )
)

; 2021-06-13
(defun GetBsGCTHeadInspectDictData (weldJoint barrelInspectRate /) 
  (if (/= barrelInspectRate "") 
    (GetBsGCTInspectDictData barrelInspectRate "HEAD_")
    (GetBsGCTInspectDictData (GetBsHeadInspectRate weldJoint) "HEAD_")
  )
)

; 2021-06-13
; unit test compeleted
(defun GetBsBarrelInspectRate (weldJoint /)
  (GetBsInspectRateByWeldJointEnums (GetBsBarrelWeldJoint weldJoint))
)

; 2021-06-13
; unit test compeleted
(defun GetBsBarrelWeldJoint (weldJoint /)
  (RegExpReplace weldJoint "(.*)/(.*)" "$1" nil nil)
)

; 2021-06-13
(defun GetBsHeadInspectRate (weldJoint /)
  (GetBsInspectRateByWeldJointEnums (GetBsHeadWeldJoint weldJoint))
)

; 2021-06-13
(defun GetBsHeadWeldJoint (weldJoint /)
  (RegExpReplace weldJoint "(.*)/(.*)" "$2" nil nil)
)

; 2021-05-07
; refactored at 2021-06-12 drawFrameScale and setPrecision
(defun InsertBsGCTTestData (insPt dataType blockName oneEquipData drawFrameScale / testDictData) 
  (InsertBlockByScaleUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (setq testDictData (SetTestDictDataTwoPrecision (GetBsGCTTestDictData oneEquipData)))
  (ModifyBlockPropertyByDictDataUtils (entlast) testDictData)
)

; 2021-06-12
(defun SetTestDictDataTwoPrecision (testDictData /)
  (mapcar '(lambda (x) 
             (if (IsRealStringUtils (cdr x))
               (setq testDictData (subst (cons (car x) (GetTwoPrecisionRealUtils (cdr x))) x testDictData))
             )
           ) 
    testDictData
  )
  testDictData
)

; 2021-05-07
; refacotred at 2021-05-25
; refacotred at 2021-06-15
(defun GetBsGCTTestDictData (oneEquipData /)
  (vl-remove-if-not '(lambda (x) 
                       (member (car x) 
                               '("TEST_PRESSURE" "AIR_TEST_PRESSURE" "HEAT_TREAT" "SHELL_WATER_TEST_PRESSURE" "TUBE_WATER_TEST_PRESSURE" "SHELL_AIR_TEST_PRESSURE" "TUBE_AIR_TEST_PRESSURE" "JACKET_WATER_TEST_PRESSURE" "JACKET_AIR_TEST_PRESSURE" "BARREL_WATER_TEST_PRESSURE" "BARREL_AIR_TEST_PRESSURE")) 
                    ) 
    oneEquipData
  )
)

; 2021-04-20
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTEquipHeadStyleText (insPt tankHeadStyleList dataType drawFrameScale / i) 
  (setq i 0)
  (repeat (length tankHeadStyleList)
    ; textheight is 4 for 1:1 scale
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -6) i)) (nth i tankHeadStyleList) "0DataFlow-BsText" (* drawFrameScale 4) 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-20
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTEquipHeadMaterialText (insPt tankHeadMaterialList dataType drawFrameScale / i) 
  (setq i 0)
  (repeat (length tankHeadMaterialList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -6) i)) (nth i tankHeadMaterialList) "0DataFlow-BsText" (* drawFrameScale 4) 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-17
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTPressureElement (insPt dataType tankPressureElementList drawFrameScale / i) 
  (InsertBlockByScaleUtils insPt "BsGCTTablePressureElement" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (InsertBsGCTPressureElementRow (MoveInsertPositionUtils insPt 0 (* drawFrameScale -16)) dataType tankPressureElementList drawFrameScale)
)

; 2021-04-17
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTPressureElementRow (insPt dataType tankPressureElementList drawFrameScale / i) 
  (setq i 0)
  (repeat (length tankPressureElementList)
    (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -8) i)) "BsGCTTablePressureElementRow" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
    (ModifyBlockPropertyByDictDataUtils (entlast) (nth i tankPressureElementList))
    (setq i (1+ i))
  ) 
  ; bind equipTag to Xdata - 2021-05-13
  (GenerateTwoPointPolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (length tankPressureElementList)))) 
    ; the lineWith is 0.72 for 1:1 scale
    "0DataFlow-BsGCT" (* drawFrameScale 0.72)) 
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
)

; 2021-04-17
; refactored at 2021-05-18
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTOtherRequest (insPt dataType tankOtherRequestList otherRequestHeght drawFrameScale /) 
  (InsertBlockByScaleUtils insPt "BsGCTTableOtherRequest" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "TOTALHEIGHT" otherRequestHeght))
  ) 
  (InsertBsGCTTankOtherRequestText (MoveInsertPositionUtils insPt (* drawFrameScale 8) (* drawFrameScale -13)) tankOtherRequestList dataType drawFrameScale)
)

; 2021-04-17
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTTankOtherRequestText (insPt tankOtherRequestList dataType drawFrameScale / i) 
  (setq i 0)
  (repeat (length tankOtherRequestList)
    ; textheight is 4 for 1:1 scale
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -6) i)) (nth i tankOtherRequestList) "0DataFlow-BsText" (* drawFrameScale 4) 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-17
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTNozzleTable (insPt dataType oneTankData drawFrameScale oneEquipNozzleDictData /) 
  (InsertBlockByScaleUtils insPt "BsGCTTableNozzleTableHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (if (/= oneEquipNozzleDictData nil) 
    (InsertBsGCTNozzleTableRow (MoveInsertPositionUtils insPt 0 (* drawFrameScale -26)) dataType oneEquipNozzleDictData drawFrameScale)
  )
)

; 2021-04-17
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTNozzleTableRow (insPt dataType oneBsGCTTankNozzleDictData drawFrameScale / i) 
  (setq i 0)
  (repeat (length oneBsGCTTankNozzleDictData)
    (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 (* (* drawFrameScale -8) i)) "BsGCTTableNozzleTableRow" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
    (ModifyMultiplePropertyForOneBlockUtils (entlast) 
      (mapcar '(lambda (x) (car x)) (nth i oneBsGCTTankNozzleDictData))
      (mapcar '(lambda (x) (cdr x)) (nth i oneBsGCTTankNozzleDictData))
    ) 
    (setq i (1+ i))
  ) 
  ; bind equipTag to Xdata - 2021-05-13
  (GenerateTwoPointPolyLineUtils 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    (MoveInsertPositionUtils insPt (* drawFrameScale 180) (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    ; the lineWith is 0.72 for 1:1 scale
    "0DataFlow-BsGCT" (* drawFrameScale 0.72))
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
  (GenerateTwoPointPolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" (* drawFrameScale 0.72)) 
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
)

; 2021-07-14
;; refactored at 2021-07-15
;; refactored at 2021-07-17
(defun InsertBsGCTOneEquipNozzle (insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale oneEquipNozzleDictData straightEdgeHeight equipNozzleType / 
                                  upLeftNozzleDictData upRightNozzleDictData downLeftNozzleDictData downRightNozzleDictData sideLeftNozzleDictData sideRightNozzleDictData) 
  (setq upLeftNozzleDictData (GetOneEquipUpLeftHeadNozzleDictData oneEquipNozzleDictData))
  (setq upRightNozzleDictData (GetOneEquipUpRightHeadNozzleDictData oneEquipNozzleDictData))
  (setq downLeftNozzleDictData (GetOneEquipDownLeftHeadNozzleDictData oneEquipNozzleDictData))
  (setq downRightNozzleDictData (GetOneEquipDownRightHeadNozzleDictData oneEquipNozzleDictData))
  (setq sideLeftNozzleDictData (GetOneEquipSideLeftNozzleDictData oneEquipNozzleDictData))
  (setq sideRightNozzleDictData (GetOneEquipSideRightNozzleDictData oneEquipNozzleDictData))
  (setq *GCTTotalHeightInsptList* nil) ;; the key for solve a red hat 2021-07-17
  (setq *GCTSideRightInsptList* nil) ;; the key for solve a red hat 2021-07-17
  (setq *GCTSideLeftInsptList* nil) ;; the key for solve a red hat 2021-07-17
  (setq *GCTTotalLengthInsptList* nil) ;; 2021-07-18
  (setq *GCTSideUpInsptList* nil) ;; 2021-07-18
  (setq *GCTSideDownInsptList* nil) ;; 2021-07-18
  (cond 
    ((= equipNozzleType "vertical") 
      (InsertBsGCTOneVerticalEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale straightEdgeHeight 
        upLeftNozzleDictData upRightNozzleDictData downLeftNozzleDictData downRightNozzleDictData sideLeftNozzleDictData sideRightNozzleDictData)
     )
    ((= equipNozzleType "horizontial") 
      (InsertBsGCTOneHorizonticalEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale straightEdgeHeight 
        upLeftNozzleDictData upRightNozzleDictData downLeftNozzleDictData downRightNozzleDictData sideLeftNozzleDictData sideRightNozzleDictData)
     )
  )
)

; 2021-07-17
(defun InsertBsGCTOneHorizonticalEquipNozzle (insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale straightEdgeHeight upLeftNozzleDictData 
                                             upRightNozzleDictData downLeftNozzleDictData downRightNozzleDictData sideLeftNozzleDictData sideRightNozzleDictData /) 
  (GenerateHorizonticalUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ barrelRadius thickNess)) 
    (+ barrelRadius thickNess) dataType thickNess drawFrameScale upLeftNozzleDictData upRightNozzleDictData)
  (GenerateHorizonticalDownEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    (+ barrelRadius thickNess) dataType thickNess drawFrameScale downLeftNozzleDictData downRightNozzleDictData)
  (GenerateHorizonticalSideLeftNozzle (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) 0) 
    (+ barrelRadius thickNess) dataType sideLeftNozzleDictData drawFrameScale)
  (GenerateHorizonticalSideRightNozzle (MoveInsertPositionUtils insPt (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess) 0) 
    (+ barrelRadius thickNess) dataType sideRightNozzleDictData drawFrameScale)
)

; 2021-07-17
(defun InsertBsGCTOneVerticalEquipNozzle (insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale straightEdgeHeight upLeftNozzleDictData 
                                          upRightNozzleDictData downLeftNozzleDictData downRightNozzleDictData sideLeftNozzleDictData sideRightNozzleDictData /) 
  (GenerateVerticalUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) 
    (+ barrelRadius thickNess) dataType thickNess drawFrameScale upLeftNozzleDictData upRightNozzleDictData)
  (GenerateVerticalDownEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess))) 
    (+ barrelRadius thickNess) dataType thickNess drawFrameScale downLeftNozzleDictData downRightNozzleDictData)
  
  
  
  (GenerateVerticalSideLeftNozzle (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelRadius thickNess)) (- newBarrelHalfHeight straightEdgeHeight)) 
    (+ barrelRadius thickNess) dataType sideLeftNozzleDictData drawFrameScale)
  (GenerateVerticalSideRightNozzle (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- newBarrelHalfHeight straightEdgeHeight)) 
    (+ barrelRadius thickNess) dataType sideRightNozzleDictData drawFrameScale)
)

; 2021-07-14
(defun IsNozzleOffsetAllNull (nozzleDictData /)
  (vl-every '(lambda (x) 
             (= (GetDottedPairValueUtils "POSITION_OFFSET" x) "")
          ) 
    nozzleDictData
  ) 
)

;; 2021-07-18
;; modify the base Inspt for Horizontical
(defun GenerateHorizonticalUpEllipseHeadNozzle (insPt barrelRadius dataType thickNess drawFrameScale upLeftNozzleDictData upRightNozzleDictData /) 
  (if (/= upLeftNozzleDictData nil) 
    (GenerateHorizonticalUpLeftHeadNozzle (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (- newBarrelHalfHeight straightEdgeHeight)) 0) barrelRadius dataType upLeftNozzleDictData drawFrameScale)
  )
  (if (/= upRightNozzleDictData nil) 
    (GenerateHorizonticalUpRightHeadNozzle (MoveInsertPositionUtils insPt (- newBarrelHalfHeight straightEdgeHeight) 0) barrelRadius dataType upRightNozzleDictData drawFrameScale)
  )
)

;; 2021-07-18
;; modify the base Inspt for Horizontical
(defun GenerateHorizonticalDownEllipseHeadNozzle (insPt barrelRadius dataType thickNess drawFrameScale downLeftNozzleDictData downRightNozzleDictData /) 
  (if (/= downLeftNozzleDictData nil) 
    (GenerateHorizonticalDownLeftHeadNozzle (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (- newBarrelHalfHeight straightEdgeHeight)) 0) barrelRadius dataType downLeftNozzleDictData drawFrameScale)
  )
  (if (/= downRightNozzleDictData nil) 
    (GenerateHorizonticalDownRightHeadNozzle (MoveInsertPositionUtils insPt (- newBarrelHalfHeight straightEdgeHeight) 0) barrelRadius dataType downRightNozzleDictData drawFrameScale)
  )
)

; 2021-04-19
; refactored at 2021-07-14
(defun GenerateVerticalUpEllipseHeadNozzle (insPt barrelRadius dataType thickNess drawFrameScale upLeftNozzleDictData upRightNozzleDictData /) 
  (if (/= upLeftNozzleDictData nil) 
    (GenerateVerticalUpLeftHeadNozzle insPt barrelRadius dataType upLeftNozzleDictData drawFrameScale)
  )
  (if (/= upRightNozzleDictData nil) 
    (GenerateVerticalUpRightHeadNozzle insPt barrelRadius dataType upRightNozzleDictData drawFrameScale)
  )
)

; refactored at 2021-07-14
(defun GenerateVerticalDownEllipseHeadNozzle (insPt barrelRadius dataType thickNess drawFrameScale downLeftNozzleDictData downRightNozzleDictData /) 
  (if (/= downLeftNozzleDictData nil) 
    (GenerateVerticalDownLeftHeadNozzle insPt barrelRadius dataType downLeftNozzleDictData drawFrameScale)
  )
  (if (/= downRightNozzleDictData nil) 
    (GenerateVerticalDownRightHeadNozzle insPt barrelRadius dataType downRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-15
;; refactored at 2021-07-18
(defun GenerateVerticalSideRightNozzle (insPt barrelRadius equipTag sideRightNozzleDictData drawFrameScale /) 
  (if (/= sideRightNozzleDictData nil) 
    (if (and (IsNozzleOffsetAllNull sideRightNozzleDictData) (> (length sideRightNozzleDictData) 1)) 
      (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -2))
      (GenerateOneVerticalSideRightNozzle insPt barrelRadius equipTag sideRightNozzleDictData drawFrameScale)
    )
  )
)

; 2021-07-15
;; refactored at 2021-07-18
(defun GenerateVerticalSideLeftNozzle (insPt barrelRadius equipTag sideLeftNozzleDictData drawFrameScale /) 
  (if (/= sideLeftNozzleDictData nil) 
    (if (and (IsNozzleOffsetAllNull sideLeftNozzleDictData) (> (length sideLeftNozzleDictData) 1)) 
      (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 2))
      (GenerateOneVerticalSideLeftNozzle insPt barrelRadius equipTag sideLeftNozzleDictData drawFrameScale)
    )
  )
)

; 2021-07-14
;; refactored at 2021-07-18
(defun GenerateVerticalUpLeftHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull upLeftNozzleDictData) (> (length upLeftNozzleDictData) 1)) 
    (InsertBlockUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
    (GenerateOneVerticalUpLeftHeadNozzle insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale)
  )
)

; 2021-07-14
;; refactored at 2021-07-18
(defun GenerateVerticalUpRightHeadNozzle (insPt barrelRadius equipTag upRightNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull upRightNozzleDictData) (> (length upRightNozzleDictData) 1)) 
    (InsertBlockUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
    (GenerateOneVerticalUpRightHeadNozzle insPt barrelRadius dataType upRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-14
(defun GenerateVerticalDownLeftHeadNozzle (insPt barrelRadius equipTag downLeftNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull downLeftNozzleDictData) (> (length downLeftNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
    (GenerateOneVerticalDownLeftHeadNozzle insPt barrelRadius dataType downLeftNozzleDictData drawFrameScale)
  )
)

; 2021-07-14
(defun GenerateVerticalDownRightHeadNozzle (insPt barrelRadius equipTag downRightNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull downRightNozzleDictData) (> (length downRightNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
    (GenerateOneVerticalDownRightHeadNozzle insPt barrelRadius dataType downRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalUpLeftHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull upLeftNozzleDictData) (> (length upLeftNozzleDictData) 1)) 
    (InsertBlockUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
    (GenerateOneHorizontalUpLeftHeadNozzle insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalUpRightHeadNozzle (insPt barrelRadius equipTag upRightNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull upRightNozzleDictData) (> (length upRightNozzleDictData) 1)) 
    (InsertBlockUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
    (GenerateOneHorizontalUpRightHeadNozzle insPt barrelRadius equipTag upRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalDownLeftHeadNozzle (insPt barrelRadius equipTag downLeftNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull downLeftNozzleDictData) (> (length downLeftNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
    (GenerateOneHorizontalDownLeftHeadNozzle insPt barrelRadius equipTag downLeftNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalDownRightHeadNozzle (insPt barrelRadius equipTag downRightNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull downRightNozzleDictData) (> (length downRightNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
    (GenerateOneHorizontalDownRightHeadNozzle insPt barrelRadius equipTag downRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalSideRightNozzle (insPt barrelRadius equipTag sideRightNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull sideRightNozzleDictData) (> (length sideRightNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -2))
    (GenerateOneHorizontalSideRightNozzle insPt barrelRadius equipTag sideRightNozzleDictData drawFrameScale)
  )
)

; 2021-07-18
(defun GenerateHorizonticalSideLeftNozzle (insPt barrelRadius equipTag sideLeftNozzleDictData drawFrameScale /) 
  (if (and (IsNozzleOffsetAllNull sideLeftNozzleDictData) (> (length sideLeftNozzleDictData) 1)) 
    (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 2))
    (GenerateOneHorizontalSideLeftNozzle insPt barrelRadius equipTag sideLeftNozzleDictData drawFrameScale)
  )
)

; 2021-07-15
(defun GenerateOneVerticalSideRightNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils nozzlePositionRadius)))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideRightInsptList* (append *GCTSideRightInsptList* (list (MoveInsertPositionUtils nozzleInsPt 150 0))))
             ;; add the insertType: Oblique insertion - 2021-07-18 
             (cond 
               ((= (GetDottedPairValueUtils "POSITION_DIRECTION" (car (cdr x))) "斜插") (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -4)))
               (T (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -2)))
             )
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCRightNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-15
(defun GenerateOneVerticalSideLeftNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils nozzlePositionRadius)))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideLeftInsptList* (append *GCTSideLeftInsptList* (list (MoveInsertPositionUtils nozzleInsPt -150 0))))
             ;; add the insertType: Oblique insertion - 2021-07-18 
             (cond 
               ((= (GetDottedPairValueUtils "POSITION_DIRECTION" (car (cdr x))) "斜插") (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 4)))
               (T (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 2)))
             )
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCLeftNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-14
(defun GenerateOneVerticalUpLeftHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils nozzlePositionRadius) yOffset))
             ;; refactored at 2021-07-17
             (setq *GCTTotalHeightInsptList* (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 150))))
             (InsertBlockUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCVerticalUpNozzleTag insPt nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
  ;; fix the red hat - 2021-07-18
  (if (/= nozzleLeftInsPt nil) (InsertBsGCTUpLeftNozzleDimension insPt nozzleLeftInsPt drawFrameScale))
)

; 2021-07-14
(defun GenerateOneVerticalUpRightHeadNozzle (insPt barrelRadius equipTag upRightNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleRightInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt nozzlePositionRadius yOffset))
             ;; refactored at 2021-07-17
             (setq *GCTTotalHeightInsptList* (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 150))))
             (InsertBlockUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
             (if (> nozzlePositionRadius 0) (setq nozzleRightInsPt nozzleInsPt))
             (InsertBsGTCVerticalUpNozzleTag insPt nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upRightNozzleDictData "POSITION_OFFSET")
  )  
  ;; fix the red hat - 2021-07-18
  (if (/= nozzleRightInsPt nil) (InsertBsGCTUpRightNozzleDimension insPt nozzleRightInsPt drawFrameScale))
)

; 2021-07-14
(defun GenerateOneVerticalDownLeftHeadNozzle (insPt barrelRadius equipTag downLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (princ "da")
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils nozzlePositionRadius) (GetNegativeNumberUtils yOffset)))
             ;; refactored at 2021-07-17
             (setq *GCTTotalHeightInsptList* (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 -150)))) ;; the length of nozzle is 150
             (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCDownNozzleTag insPt nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils downLeftNozzleDictData "POSITION_OFFSET")
  ) 
  ;; fix the red hat - 2021-07-18
  (if (/= nozzleLeftInsPt nil) (InsertBsGCTDownLeftNozzleDimension insPt nozzleLeftInsPt drawFrameScale))
)

; 2021-07-14
(defun GenerateOneVerticalDownRightHeadNozzle (insPt barrelRadius equipTag downRightNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleRightInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt nozzlePositionRadius (GetNegativeNumberUtils yOffset)))
             ;; refactored at 2021-07-17
             (setq *GCTTotalHeightInsptList* (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 -150)))) ;; the length of nozzle is 150
             (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
             (if (> nozzlePositionRadius 0) (setq nozzleRightInsPt nozzleInsPt))
             (InsertBsGTCDownNozzleTag insPt nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils downRightNozzleDictData "POSITION_OFFSET")
  )  
  ;; fix the red hat - 2021-07-18
  (if (/= nozzleRightInsPt nil) (InsertBsGCTDownRightNozzleDimension insPt nozzleRightInsPt drawFrameScale))
)

; 2021-07-18
(defun GenerateOneHorizontalUpLeftHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt nozzlePositionRadius 0))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideUpInsptList* (append *GCTSideUpInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 150))))
             (InsertBlockUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCHorizonticalUpNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-18
(defun GenerateOneHorizontalUpRightHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils nozzlePositionRadius) 0))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideUpInsptList* (append *GCTSideUpInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 150))))
             (InsertBlockUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 equipTag)))
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCHorizonticalUpNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-18
(defun GenerateOneHorizontalDownLeftHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt nozzlePositionRadius 0))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideDownInsptList* (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 -150))))
             (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCHorizontalDownNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-18
(defun GenerateOneHorizontalDownRightHeadNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x)))))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils nozzlePositionRadius) 0))
             ;; add the Nozzle Inspt List refactored at 2021-07-16 
             (setq *GCTSideDownInsptList* (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils nozzleInsPt 0 -150))))
             (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCHorizontalDownNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
)

; 2021-07-18
(defun GenerateOneHorizontalSideLeftNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleLeftInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils yOffset) nozzlePositionRadius))
             ;; refactored at 2021-07-17
             (setq *GCTTotalLengthInsptList* (append *GCTTotalLengthInsptList* (list (MoveInsertPositionUtils nozzleInsPt -150 0))))
             ;; add the insertType: Oblique insertion - 2021-07-18 
             (cond 
               ((= (GetDottedPairValueUtils "POSITION_DIRECTION" (car (cdr x))) "斜插") (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 4)))
               (T (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI 2)))
             )
             (if (> nozzlePositionRadius 0) (setq nozzleLeftInsPt nozzleInsPt))
             (InsertBsGTCLeftNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
  (if (/= nozzleLeftInsPt nil) (InsertBsGCTSideLeftNozzleDimension insPt nozzleLeftInsPt drawFrameScale))
)

; 2021-07-18
(defun GenerateOneHorizontalSideRightNozzle (insPt barrelRadius equipTag upLeftNozzleDictData drawFrameScale / nozzlePositionRadius yOffset nozzleInsPt nozzleRightInsPt) 
  (mapcar '(lambda (x) 
             (setq nozzlePositionRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "POSITION_OFFSET" (car (cdr x))))))
             (setq yOffset (- (GetYByXForEllipseUtils barrelRadius nozzlePositionRadius) (/ barrelRadius 2)))
             (setq nozzleInsPt (MoveInsertPositionUtils insPt yOffset nozzlePositionRadius))
             ;; refactored at 2021-07-17
             (setq *GCTTotalLengthInsptList* (append *GCTTotalLengthInsptList* (list (MoveInsertPositionUtils nozzleInsPt 150 0))))
             (cond 
               ((= (GetDottedPairValueUtils "POSITION_DIRECTION" (car (cdr x))) "斜插") (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -4)))
               (T (InsertBlockByRotateUtils nozzleInsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) (/ PI -2)))
             )
             (if (> nozzlePositionRadius 0) (setq nozzleRightInsPt nozzleInsPt))
             (InsertBsGTCRightNozzleTag nozzleInsPt equipTag (cdr x) drawFrameScale)
          ) 
    (ChunkDictListByKeyNameUtils upLeftNozzleDictData "POSITION_OFFSET")
  ) 
  (if (/= nozzleRightInsPt nil) (InsertBsGCTSideRightNozzleDimension insPt nozzleRightInsPt drawFrameScale))
)

; 2021-07-15
(defun InsertBsGTCRightNozzleTag (nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList)
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* 6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt 150 0) (MoveInsertPositionUtils nozzleInsPt (- 500 (* 3 drawFrameScale)) 0) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (+ (car x) 500) (cadr x) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-15
(defun InsertBsGTCLeftNozzleTag (nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList)
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* -6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt -150 0) (MoveInsertPositionUtils nozzleInsPt (+ -450 (* 3 drawFrameScale)) 0) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (- (car x) 450) (cadr x) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-15
(defun InsertBsGTCDownNozzleTag (baseInsPt nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList)
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* 6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt 0 -150) (list (car nozzleInsPt) (- (cadr baseInsPt) (- 300 (* 2.5 drawFrameScale))) 0) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (car x) (- (cadr baseInsPt) 300) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-14
(defun InsertBsGTCVerticalUpNozzleTag (baseInsPt nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList)
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* 6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt 0 150) (list (car nozzleInsPt) (+ (cadr baseInsPt) (- 300 (* 2.5 drawFrameScale))) 0) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (car x) (+ (cadr baseInsPt) 300) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-18
(defun InsertBsGTCHorizonticalUpNozzleTag (nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList) 
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* 6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt 0 150) (MoveInsertPositionUtils nozzleInsPt 0 (- 450 (* 2.5 drawFrameScale))) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (car x) (+ (cadr x) 450) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-18
(defun InsertBsGTCHorizontalDownNozzleTag (nozzleInsPt equipTag nozzleDictData drawFrameScale / insPtList) 
  (setq insPtList (GetInsertPtListByXMoveUtils nozzleInsPt (GenerateSortedNumByList nozzleDictData 0) (* 6 drawFrameScale)))
  (GenerateLineUtils (MoveInsertPositionUtils nozzleInsPt 0 -150) (MoveInsertPositionUtils nozzleInsPt 0 (GetNegativeNumberUtils (- 850 (* 2.5 drawFrameScale)))) "0")
  (mapcar '(lambda (x y) 
             (InsertBlockByScaleUtils 
               ; get the insert point for nozzle
               (list (car x) (+ (cadr x) -850) 0)
               "BsGCTGraphNozzleTag" 
               "0DataFlow-BsText" 
               (list (cons 0 equipTag) (cons 1 (GetDottedPairValueUtils "SYMBOL" y))) drawFrameScale)
          ) 
    insPtList
    nozzleDictData
  ) 
)

; 2021-07-14
(defun GetOneEquipUpLeftHeadNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "顶部" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "左侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-14
(defun GetOneEquipUpRightHeadNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "顶部" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "右侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-14
(defun GetOneEquipDownLeftHeadNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "底部" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "左侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-14
(defun GetOneEquipDownRightHeadNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "底部" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "右侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-14
(defun GetOneEquipSideLeftNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "侧面" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "左侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-14
(defun GetOneEquipSideRightNozzleDictData (oneEquipNozzleDictData /)
  (vl-remove-if-not '(lambda (x) 
                       (and (= (GetDottedPairValueUtils "POSITION" x) "侧面" ) (= (GetDottedPairValueUtils "LEFT_RIGHT" x) "右侧" ))
                    ) 
    oneEquipNozzleDictData
  )
)

; 2021-07-17
(defun InsertBsGCTOneVerticalEquipGlobalDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /)
  (InsertBsGCTOneEquipSideRightDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
  (InsertBsGCTOneEquipSideLeftDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
  (InsertBsGCTOneEquipTotalHeightDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-07-18
(defun InsertBsGCTOneHorizontalEquipGlobalDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /)
  (InsertBsGCTOneEquipSideUpDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
  (InsertBsGCTOneEquipSideDownDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
  (InsertBsGCTOneEquipTotalLengthDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-07-18
(defun InsertBsGCTOneEquipTotalLengthDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale / firstInsPt lastInsPt) 
  (setq *GCTTotalLengthInsptList* 
         (append *GCTTotalLengthInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess)) 0))))
  (setq *GCTTotalLengthInsptList* 
         (append *GCTTotalLengthInsptList* (list (MoveInsertPositionUtils insPt (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess) 0))))
  (setq *GCTTotalLengthInsptList* (vl-sort *GCTTotalLengthInsptList* '(lambda (x y) (< (car x) (car y)))))
  (setq firstInsPt (car *GCTTotalLengthInsptList*))
  (setq lastInsPt (car (reverse *GCTTotalLengthInsptList*)))
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale 
    firstInsPt
    lastInsPt
    (MoveInsertPositionUtils insPt (GetXHalfDistanceForTwoPoint firstInsPt lastInsPt) (GetNegativeNumberUtils (+ barrelRadius thickNess 700))) 
    "")
  (setq *GCTTotalLengthInsptList* nil)
)

; 2021-07-18
(defun InsertBsGCTOneEquipSideDownDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /) 
  (setq *GCTSideDownInsptList* 
    (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess)) 0))))
  (setq *GCTSideDownInsptList* 
    (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess) 0))))
  (setq *GCTSideDownInsptList* 
    (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils (+ barrelRadius thickNess))))))
  (setq *GCTSideDownInsptList* (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt barrelHalfHeight (GetNegativeNumberUtils (+ barrelRadius thickNess))))))
  (setq *GCTSideDownInsptList* (vl-sort *GCTSideDownInsptList* '(lambda (x y) (< (car x) (car y)))))
  (mapcar '(lambda (x y) 
              (InsertBsGCTHorizontalRotatedDimension drawFrameScale 
                x
                y 
                (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (GetXHalfDistanceForTwoPoint x y)) (GetNegativeNumberUtils (+ barrelRadius thickNess 600))) 
                "")
            ) 
    *GCTSideDownInsptList*
    (cdr *GCTSideDownInsptList*)
  )
  (setq *GCTSideDownInsptList* nil)
)

; 2021-07-18
(defun InsertBsGCTOneEquipSideUpDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /) 
  (setq *GCTSideUpInsptList* 
         (append *GCTSideUpInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (+ barrelRadius thickNess)))))
  (setq *GCTSideUpInsptList* (append *GCTSideUpInsptList* (list (MoveInsertPositionUtils insPt barrelHalfHeight (+ barrelRadius thickNess)))))
  (setq *GCTSideUpInsptList* (vl-sort *GCTSideUpInsptList* '(lambda (x y) (< (car x) (car y)))))
  (mapcar '(lambda (x y) 
              (InsertBsGCTHorizontalRotatedDimension drawFrameScale 
                x
                y 
                (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (GetXHalfDistanceForTwoPoint x y)) (+ barrelRadius thickNess 300)) 
                "")
            ) 
    *GCTSideUpInsptList*
    (cdr *GCTSideUpInsptList*)
  )
  (setq *GCTSideUpInsptList* nil)
)

; 2021-07-16
(defun InsertBsGCTOneEquipSideRightDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /) 
  (setq *GCTSideRightInsptList* 
         (append *GCTSideRightInsptList* (list (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess)))))
  (setq *GCTSideRightInsptList* 
         (append *GCTSideRightInsptList* (list (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) barrelHalfHeight))))
  (setq *GCTSideRightInsptList* 
         (append *GCTSideRightInsptList* (list (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (GetNegativeNumberUtils (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess))))))
  (setq *GCTSideRightInsptList* (append *GCTSideRightInsptList* (list (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils barrelHalfHeight)))))
  (setq *GCTSideRightInsptList* (vl-sort *GCTSideRightInsptList* '(lambda (x y) (< (cadr x) (cadr y)))))
  (mapcar '(lambda (x y) 
              (InsertBsGCTVerticalRotatedDimension drawFrameScale 
                x
                y 
                (MoveInsertPositionUtils insPt (+ barrelRadius thickNess 300) (GetNegativeNumberUtils (GetXHalfDistanceForTwoPoint x y))) 
                "")
            ) 
    *GCTSideRightInsptList*
    (cdr *GCTSideRightInsptList*)
  )
  (setq *GCTSideRightInsptList* nil)
)

; 2021-07-16
(defun InsertBsGCTOneEquipSideLeftDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale /) 
  (setq *GCTSideLeftInsptList* 
         (append *GCTSideLeftInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelRadius thickNess)) barrelHalfHeight))))
  (setq *GCTSideLeftInsptList* (vl-sort *GCTSideLeftInsptList* '(lambda (x y) (< (cadr x) (cadr y)))))
  (mapcar '(lambda (x y) 
              (InsertBsGCTVerticalRotatedDimension drawFrameScale 
                x
                y 
                (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelRadius thickNess 300)) (GetNegativeNumberUtils (GetXHalfDistanceForTwoPoint x y))) 
                "")
            ) 
    *GCTSideLeftInsptList*
    (cdr *GCTSideLeftInsptList*)
  )
  (setq *GCTSideLeftInsptList* nil)
)

; 2021-07-16
; refactored at 2021-07-17
(defun InsertBsGCTOneEquipTotalHeightDimension (insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale / firstInsPt lastInsPt) 
  (setq *GCTTotalHeightInsptList* 
         (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess)))))
  (setq *GCTTotalHeightInsptList* 
         (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelHalfHeight straightEdgeHeight (/ barrelRadius 2) thickNess))))))
  (setq *GCTTotalHeightInsptList* (vl-sort *GCTTotalHeightInsptList* '(lambda (x y) (< (cadr x) (cadr y)))))
  (setq firstInsPt (car *GCTTotalHeightInsptList*))
  (setq lastInsPt (car (reverse *GCTTotalHeightInsptList*)))
  (InsertBsGCTVerticalRotatedDimension drawFrameScale 
    firstInsPt
    lastInsPt
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess 400) (GetNegativeNumberUtils (GetXHalfDistanceForTwoPoint firstInsPt lastInsPt))) 
    "")
  (setq *GCTTotalHeightInsptList* nil)
)

; 2021-06-15
; refactored at 2021-07-17
(defun InsertBsGCTReactorGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight 
                                      allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData / newBarrelHalfHeight oneBsGCTEquipSupportDictData) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  ; refactored at 2021-07-14
  (InsertBsGCTOneEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale oneEquipNozzleDictData straightEdgeHeight "vertical")
  (GenerateVerticalSingleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  (InsertBsGCTLugSupport insPt dataType oneBsGCTEquipSupportDictData thickNess barrelRadius barrelHalfHeight drawFrameScale)
  (InsertBsGCTVerticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight drawFrameScale)
  (InsertBsGCTVerticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale)
  ;; refactored at 2021-07-17
  (InsertBsGCTOneVerticalEquipGlobalDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-04-18
; refactored at 2021-07-17
(defun InsertBsGCTVerticalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight 
                                      allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData / 
                                      newBarrelHalfHeight oneBsGCTEquipSupportDictData legSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq legSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTEquipSupportDictData)))
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (InsertBsGCTOneEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale oneEquipNozzleDictData straightEdgeHeight "vertical")
  (GenerateVerticalSingleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  ; (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTLegSupport 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- newBarrelHalfHeight straightEdgeHeight))) 
    dataType legSupportHeight drawFrameScale)
  (InsertBsGCTVerticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight drawFrameScale)
  (InsertBsGCTVerticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale)
  ;; refactored at 2021-07-17
  (setq *GCTTotalHeightInsptList* 
         (append *GCTTotalHeightInsptList* (list (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (GetNegativeNumberUtils (+ barrelHalfHeight legSupportHeight))))))
  (InsertBsGCTOneVerticalEquipGlobalDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-05-18
; refactored at 2021-07-17
(defun InsertBsGCTHorizontalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight 
                                        allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData / 
                                        newBarrelHalfHeight oneBsGCTEquipSupportDictData saddleSupportOffset saddleSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq saddleSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTEquipSupportDictData)))
  (setq saddleSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTEquipSupportDictData)))
  ; [insPt barrelRadius entityLayer centerLineLayer directionStatus thickNess straightEdgeHeight]
  (GenerateSingleLineHorizontalEllipseHeadUtils (MoveInsertPositionUtils insPt newBarrelHalfHeight 0) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (GenerateHorizontalSingleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTHorizontalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateSingleLineHorizontalEllipseHeadUtils (MoveInsertPositionUtils insPt (- 0 newBarrelHalfHeight) 0) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  ; (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTRightSaddleSupport (MoveInsertPositionUtils insPt saddleSupportOffset (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    dataType saddleSupportHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale)
  (InsertBsGCTLeftSaddleSupport (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    dataType saddleSupportHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale)
  ; refactored at 2021-07-17
  (InsertBsGCTOneEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale oneEquipNozzleDictData straightEdgeHeight "horizontial")
  (InsertBsGCTHorizonticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight saddleSupportHeight saddleSupportOffset drawFrameScale)
  (InsertBsGCTHorizonticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale)
  ;; refactored at 2021-07-18
  (setq *GCTSideDownInsptList* 
         (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt saddleSupportOffset (GetNegativeNumberUtils (+ barrelRadius thickNess))))))
  (setq *GCTSideDownInsptList* 
         (append *GCTSideDownInsptList* (list (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils (+ barrelRadius thickNess))))))
  (InsertBsGCTOneHorizontalEquipGlobalDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-05-30
; refactored at 2021-07-17
(defun InsertBsGCTVerticalHeaterGraphy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess dataType straightEdgeHeight 
                                        allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData / newBarrelHalfHeight oneBsGCTEquipSupportDictData totalFlangeHeight) 
  (GenerateBsGCTHeaterTube (MoveInsertPositionUtils insPt -100 0) dataType "0DataFlow-BsDottedLine" 25 (* barrelHalfHeight 2))
  ; different from tank, tube length subtract EXCEED_LENGTH - 2021-5-27 refactored at 2021-05-30
  (setq barrelHalfHeight (- barrelHalfHeight exceedLength))
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq totalFlangeHeight (GetBsGCTHeaterFlangeTotalHeight barrelRadius))
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight totalFlangeHeight))
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (InsertBsGCTOneEquipNozzle insPt barrelRadius newBarrelHalfHeight thickNess dataType drawFrameScale oneEquipNozzleDictData straightEdgeHeight "vertical")
  ; the upper Flange - rotate is PI
  (GenerateBsGCTFlangeUtils (MoveInsertPositionUtils insPt 0 (- newBarrelHalfHeight straightEdgeHeight)) dataType barrelRadius thickNess PI -1)
  (GenerateVerticalSingleLineBarrelUtils insPt barrelRadius barrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  ; the down Flange - rotate is 0
  (GenerateBsGCTFlangeUtils (MoveInsertPositionUtils insPt 0 (- straightEdgeHeight newBarrelHalfHeight)) dataType barrelRadius thickNess 0 1)
  (GenerateSingleLineVerticalEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  ; (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTLugSupport insPt dataType oneBsGCTEquipSupportDictData thickNess barrelRadius barrelHalfHeight drawFrameScale)
  ;; refactored at 2021-07-17
  (InsertBsGCTOneVerticalEquipGlobalDimension insPt barrelHalfHeight straightEdgeHeight barrelRadius thickNess drawFrameScale)
)

; 2021-05-30
(defun GenerateBsGCTHeaterTube (insPt dataType blockName tubeDiameter tubeLength /)
  (InsertBlockUtils insPt "BsGCTGraphHeaterTube" blockName (list (cons 0 dataType)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "TUBE_DIAMETER" tubeDiameter) (cons "TUBE_LENGTH" tubeLength))
  ) 
)

; 2021-04-22
(defun InsertBsGCTVerticalTankAnnotation (insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale /) 
  (InsertBsGCTTankDownLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (- 0 barrelHalfHeight straightEdgeHeight 50))
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess drawFrameScale)
  (InsertBsGCTTankUpLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (+ barrelHalfHeight straightEdgeHeight 50))
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess drawFrameScale) 
)

; 2021-05-19
(defun InsertBsGCTHorizonticalTankAnnotation (insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale /) 
  (InsertBsGCTTankUpLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelHalfHeight straightEdgeHeight 50) barrelRadius)
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess drawFrameScale)
  (InsertBsGCTTankDownLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight (/ barrelRadius 2) straightEdgeHeight) 0)
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess drawFrameScale) 
)

; 2021-04-22
(defun InsertBsGCTTankDownLeftHeadAnnotation (insPt dataType fristText equipType barrelDiameter thickNess drawFrameScale /) 
  (InsertBsGCTDownLeftAnnotation insPt dataType fristText (InlineExpandVariableUtils "%equipType% %barrelDiameter%x%thickNess%") drawFrameScale) 
)

; 2021-04-22
(defun InsertBsGCTTankUpLeftHeadAnnotation (insPt dataType fristText equipType barrelDiameter thickNess drawFrameScale /) 
  (InsertBsGCTUpLeftAnnotation insPt dataType fristText (InlineExpandVariableUtils "%equipType% %barrelDiameter%x%thickNess%") drawFrameScale) 
)

; 2021-04-22
; refactored at 2021-06-12
(defun InsertBsGCTDownLeftAnnotation (insPt dataType fristText secondText drawFrameScale /) 
  (InsertBsGCTAnnotation (MoveInsertPositionUtils insPt (* drawFrameScale -10) (* drawFrameScale -10)) dataType fristText secondText drawFrameScale) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt (* drawFrameScale -10) (* drawFrameScale -10)) "0DataFlow-BsGCT")  
)

; 2021-04-22
; refactored at 2021-06-12
(defun InsertBsGCTDownRightAnnotation (insPt dataType fristText secondText drawFrameScale /) 
  ; ready to refactor
  (InsertBsGCTAnnotation (MoveInsertPositionUtils insPt (* drawFrameScale 42) (* drawFrameScale -10)) dataType fristText secondText drawFrameScale) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt (* drawFrameScale 10) (* drawFrameScale -10)) "0DataFlow-BsGCT")  
)

; 2021-04-22
; refactored at 2021-06-12
(defun InsertBsGCTUpLeftAnnotation (insPt dataType fristText secondText drawFrameScale /) 
  (InsertBsGCTAnnotation (MoveInsertPositionUtils insPt (* drawFrameScale -10) (* drawFrameScale 10)) dataType fristText secondText drawFrameScale) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt (* drawFrameScale -10) (* drawFrameScale 10)) "0DataFlow-BsGCT")   
)

; 2021-04-22
; refactored at 2021-06-12
(defun InsertBsGCTUpRightAnnotation (insPt dataType fristText secondText drawFrameScale /) 
  ; ready to refactor
  (InsertBsGCTAnnotation (MoveInsertPositionUtils insPt (* drawFrameScale 42) (* drawFrameScale 10)) dataType fristText secondText drawFrameScale) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt (* drawFrameScale 10) (* drawFrameScale 10)) "0DataFlow-BsGCT")  
)

; 2021-04-22
; refactored at 2021-06-12
(defun InsertBsGCTAnnotation (insPt dataType fristText secondText drawFrameScale /) 
  (InsertBlockByScaleUtils insPt "BsGCTGraphAnnotation" "0DataFlow-BsGCT" 
    (list (cons 0 dataType) (cons 1 fristText) (cons 2 secondText)) drawFrameScale)
)

; 2021-04-19
; refactored at 2021-04-22
(defun InsertBsGCTVerticalTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight drawFrameScale /) 
  ; Barrel diameter
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelRadius) 0) 
    (MoveInsertPositionUtils insPt barrelRadius 0) 
    (MoveInsertPositionUtils insPt 0 50) 
    "%%c<>")
  ; thickness
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt barrelRadius 0) 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) 0) 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess 50) 50) 
    "") 
  ; vertical up distance for head and barrel
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt barrelRadius barrelHalfHeight) 
    (MoveInsertPositionUtils insPt barrelRadius (+ barrelHalfHeight straightEdgeHeight)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt (- barrelRadius 100) 0) 
    "") 
  ; vertical down distance for head and barrel
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt barrelRadius (GetNegativeNumberUtils barrelHalfHeight)) 
    (MoveInsertPositionUtils insPt barrelRadius (- 0 barrelHalfHeight straightEdgeHeight)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt (- barrelRadius 100) 0) 
    "")   
)

; 2021-05-19
;; refactored at 2021-07-18
(defun InsertBsGCTHorizonticalTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight saddleSupportHeight saddleSupportOffset drawFrameScale /) 
  ; Barrel diameter
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt 0 barrelRadius) 
    (MoveInsertPositionUtils insPt 50 0) 
    "%%c<>")
  ; thickness
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    (MoveInsertPositionUtils insPt 50 (+ barrelRadius thickNess 50)) 
    "") 
  ; horizontial - straightEdgeHeight - right
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt barrelHalfHeight (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight straightEdgeHeight) (GetNegativeNumberUtils barrelRadius)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (- barrelRadius 100))) 
    "") 
  ; horizontial - straightEdgeHeight - left
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (- 0 barrelHalfHeight straightEdgeHeight) (GetNegativeNumberUtils barrelRadius)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (- barrelRadius 100))) 
    "") 
)

; 2021-04-19
(defun InsertBsGCTTankNozzleDimension (insPt leftNozzleinsPt rightNozzleinsPt drawFrameScale /) 
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils leftNozzleinsPt 0 150) 
    (MoveInsertPositionUtils (list (car insPt) (cadr leftNozzleinsPt) 0) 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt)) 200) 
    "R<>")
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils (list (car insPt) (cadr rightNozzleinsPt) 0) 0 150) 
    (MoveInsertPositionUtils rightNozzleinsPt 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt rightNozzleinsPt)) 200) 
    "R<>") 
)

; 2021-07-14
(defun InsertBsGCTUpLeftNozzleDimension (insPt leftNozzleinsPt drawFrameScale /) 
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale 
    ;; the length of nozzle is 150
    (MoveInsertPositionUtils leftNozzleinsPt 0 150) 
    (MoveInsertPositionUtils insPt 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt)) 200) 
    "R<>")
)

; 2021-07-14
(defun InsertBsGCTUpRightNozzleDimension (insPt rightNozzleinsPt drawFrameScale /) 
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt 0 150) 
    (MoveInsertPositionUtils rightNozzleinsPt 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt rightNozzleinsPt)) 200) 
    "R<>") 
)

; 2021-07-14
(defun InsertBsGCTDownLeftNozzleDimension (insPt leftNozzleinsPt drawFrameScale /) 
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils leftNozzleinsPt 0 -150) 
    (MoveInsertPositionUtils insPt 0 -150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt)) -200) 
    "R<>")
)

; 2021-07-14
(defun InsertBsGCTDownRightNozzleDimension (insPt rightNozzleinsPt drawFrameScale /) 
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils insPt 0 -150) 
    (MoveInsertPositionUtils rightNozzleinsPt 0 -150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt rightNozzleinsPt)) -200) 
    "R<>") 
)

; 2021-07-18
(defun InsertBsGCTSideLeftNozzleDimension (insPt leftNozzleinsPt drawFrameScale /) 
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils leftNozzleinsPt -150 0) 
    (MoveInsertPositionUtils insPt -150 0) 
    (MoveInsertPositionUtils insPt -200 (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt))) 
    "R<>")
)

; 2021-07-18
(defun InsertBsGCTSideRightNozzleDimension (insPt leftNozzleinsPt drawFrameScale /) 
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils leftNozzleinsPt 150 0) 
    (MoveInsertPositionUtils insPt 150 0) 
    (MoveInsertPositionUtils insPt 200 (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt))) 
    "R<>")
)

; 2021-06-15
(defun GenerateReactorUpHeadNozzle (insPt barrelRadius dataType nozzleOffset thickNess drawFrameScale / yOffset leftNozzleinsPt rightNozzleinsPt) 
  (setq yOffset (- (GetYByXForEllipseUtils barrelRadius (- barrelRadius nozzleOffset)) (/ barrelRadius 2)))
  (setq leftNozzleinsPt (MoveInsertPositionUtils insPt (- 0 (- barrelRadius nozzleOffset thickNess)) yOffset))
  (setq rightNozzleinsPt (MoveInsertPositionUtils insPt (- barrelRadius nozzleOffset thickNess) yOffset))
  (InsertBlockUtils leftNozzleinsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBlockUtils rightNozzleinsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBsGCTTankNozzleDimension insPt leftNozzleinsPt rightNozzleinsPt drawFrameScale)
)

; 2021-04-19
(defun GenerateDownllipseHeadNozzle (insPt dataType /) 
  (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
)

; 2021-04-18
(defun InsertBsGCTLegSupport (insPt dataType legHeight drawFrameScale / groundPlateInsPt) 
  (InsertBlockUtils insPt "BsGCTGraphLegSupport-A2" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LEG_HEIGHT" legHeight))
  ) 
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt 8 (- 150 legHeight)))
  (InsertBsGCTFaceLeftGroundPlate groundPlateInsPt dataType)
  (InsertBsGCTUpLeftGroundPlateAnnotation (MoveInsertPositionUtils groundPlateInsPt -50 15) dataType drawFrameScale)
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    groundPlateInsPt 
    (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
    (MoveInsertPositionUtils groundPlateInsPt -100 0) 
    "") 
)

; 2021-05-30
;; refactored at 2021-07-17
(defun InsertBsGCTLugSupport (insPt dataType oneBsGCTEquipSupportDictData thickNess barrelRadius barrelHalfHeight drawFrameScale / 
                              lugSupportOffset flangeTopOffset lugYPosition supportType leftLugPosition rightLugPosition) 
  (setq lugSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTEquipSupportDictData)))
  (setq flangeTopOffset (+ barrelHalfHeight (GetFlangeHeightEnums (* 2 barrelRadius))))
  (setq lugYPosition (- barrelHalfHeight lugSupportOffset))
  ; (setq lugYPosition (- flangeTopOffset lugSupportOffset))
  (setq supportType (GetLugSupportTypeUtils oneBsGCTEquipSupportDictData))
  (setq leftLugPosition (MoveInsertPositionUtils insPt (- 0 thickNess thickNess barrelRadius) lugYPosition))
  (InsertBsGCTLeftLugSupport leftLugPosition supportType dataType oneBsGCTEquipSupportDictData thickNess)
  (setq rightLugPosition (MoveInsertPositionUtils insPt (+ thickNess thickNess barrelRadius) lugYPosition))
  (InsertBsGCRightLugSupport rightLugPosition supportType dataType oneBsGCTEquipSupportDictData thickNess)
  ; lug support Dimension 
  ; Y direction ;; refactored at 2021-07-17
  (setq *GCTSideRightInsptList* (append *GCTSideRightInsptList* (list rightLugPosition)))
  ; X direction
  (InsertBsGCTHorizontalRotatedDimension drawFrameScale
    (MoveInsertPositionUtils leftLugPosition (GetNegativeNumberUtils (GetLugSupportBlotOffsetEnums supportType)) 0) 
    (MoveInsertPositionUtils rightLugPosition (GetLugSupportBlotOffsetEnums supportType) 0) 
    (MoveInsertPositionUtils leftLugPosition 0 -100) 
    "") 
)

; 2021-05-30
(defun InsertBsGCTLeftLugSupport (insPt supportType dataType oneBsGCTEquipSupportDictData thickNess /) 
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; ready to refactor
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "THICKNESS" thickNess))
  ) 
)

; 2021-05-30
(defun InsertBsGCRightLugSupport (insPt supportType dataType oneBsGCTEquipSupportDictData thickNess /) 
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; ready to refactor
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "THICKNESS" thickNess))
  ) 
  ; mirror the lug support
  (MirrorBlockUtils (entlast))
)

; 2021-05-18
; refactored at 2021-05-19
(defun InsertBsGCTRightSaddleSupport (insPt dataType saddleHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale / supportType groundPlateInsPt) 
  (setq supportType (GetSaddleSupportTypeUtils oneBsGCTEquipSupportDictData barrelRadius))
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "SADDLE_HEIGHT" saddleHeight))
  ) 
  ; mirror the right saddle support
  (MirrorBlockUtils (entlast))
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius))) (- 150 saddleHeight)))
  (InsertBsGCTFaceLeftGroundPlate groundPlateInsPt dataType)
  (InsertBsGCTDownRightGroundPlateAnnotation groundPlateInsPt dataType drawFrameScale)
  (InsertBsGCTUpRightSaddleSupportAnnotation 
    (MoveInsertPositionUtils insPt 0 (GetSaddleSupportUpOffsetEnums (* 2 barrelRadius)))
    oneBsGCTEquipSupportDictData
    barrelRadius
    dataType
    drawFrameScale
  )
)

; 2021-05-19
(defun InsertBsGCTLeftSaddleSupport (insPt dataType saddleHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale / supportType groundPlateInsPt) 
  (setq supportType (GetSaddleSupportTypeUtils oneBsGCTEquipSupportDictData barrelRadius))
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "SADDLE_HEIGHT" saddleHeight))
  ) 
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius)) (- 150 saddleHeight)))
  (InsertBsGCTFaceRightGroundPlate groundPlateInsPt dataType)
  ; groundPlate Dimension 
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    groundPlateInsPt 
    (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
    (MoveInsertPositionUtils groundPlateInsPt 100 0) 
    "") 
  ; saddle support Dimension 
  (InsertBsGCTVerticalRotatedDimension drawFrameScale
    insPt
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils saddleHeight))
    (MoveInsertPositionUtils groundPlateInsPt 140 0) 
    "") 
)

; 2021-05-19
(defun GetAllBsGCTSaddleSupportBlockNameList () 
  (GetAllBlockNameListByNamePatternUtils "BsGCTGraphSaddleSupport*")
)

; 2021-05-30
(defun GetAllBsGCTLugSupportBlockNameList () 
  (GetAllBlockNameListByNamePatternUtils "BsGCTGraphLugSupport*")
)

; 2021-05-30
(defun GetLugSupportTypeUtils (oneBsGCTEquipSupportDictData / supportType)
  (setq supportType 
    (strcat 
      "BsGCTGraphLugSupport-SideView-" 
      (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTEquipSupportDictData))
  )
  (cond 
    ((member supportType (GetAllBsGCTLugSupportBlockNameList)) supportType)
    (T "BsGCTGraphSaddleSupport-SideView-A2")
  )
)

; 2021-05-19
(defun GetSaddleSupportTypeUtils (oneBsGCTEquipSupportDictData barrelRadius / supportType)
  (setq supportType 
    (strcat 
      "BsGCTGraphSaddleSupport-SideView-" 
      (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTEquipSupportDictData)
      "-"
      (rtos (* 2 barrelRadius)))
  )
  (cond 
    ((member supportType (GetAllBsGCTSaddleSupportBlockNameList)) supportType)
    (T "BsGCTGraphSaddleSupport-SideView-BI-2500")
  )
)

; 2021-05-19
(defun InsertBsGCTFaceLeftGroundPlate (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTGraphGroundPlate" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
)

; 2021-05-19
(defun InsertBsGCTFaceRightGroundPlate (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTGraphGroundPlate" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; mirror the [BsGCTGraphGroundPlate]
  (MirrorBlockUtils (entlast))
)

; 2021-04-22
(defun InsertBsGCTUpLeftGroundPlateAnnotation (insPt dataType drawFrameScale /) 
  (InsertBsGCTUpLeftAnnotation insPt dataType "接地板" "" drawFrameScale) 
)

; 2021-05-19
(defun InsertBsGCTDownLeftGroundPlateAnnotation (insPt dataType drawFrameScale /) 
  (InsertBsGCTDownLeftAnnotation insPt dataType "接地板" "" drawFrameScale) 
)

; 2021-05-19
(defun InsertBsGCTDownRightGroundPlateAnnotation (insPt dataType drawFrameScale /) 
  (InsertBsGCTDownRightAnnotation insPt dataType "接地板" "" drawFrameScale) 
)

; 2021-05-19
(defun InsertBsGCTUpRightSaddleSupportAnnotation (insPt oneBsGCTEquipSupportDictData barrelRadius dataType drawFrameScale / firstText secondText) 
  (setq firstText 
         (strcat 
           (GetDottedPairValueUtils "SUPPORT_FORM" oneBsGCTEquipSupportDictData) " " 
           (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTEquipSupportDictData) " " (rtos (* 2 barrelRadius))))
  (setq secondText (GetDottedPairValueUtils "SUPPORT_STANDARD" oneBsGCTEquipSupportDictData))
  (InsertBsGCTUpRightAnnotation insPt dataType firstText secondText drawFrameScale) 
)

; 2021-04-19
; refactored at 2021-06-16
(defun InsertBsGCTAlignedDimension (scaleFactor firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertAlignedDimensionUtils scaleFactor firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)

; 2021-06-16
(defun InsertBsGCTHorizontalRotatedDimension (scaleFactor firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertHorizontalRotatedDimensionUtils scaleFactor firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)

; 2021-06-16
(defun InsertBsGCTVerticalRotatedDimension (scaleFactor firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertVerticalRotatedDimensionUtils scaleFactor firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)

; refactored at 2021-06-11
(defun GetBsGCTTankDictData ()
  (vl-remove-if-not '(lambda (x) 
                      (= (GetDottedPairValueUtils "updateStatus" x) "是") 
                    ) 
    (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTTankMainData.txt")
  ) 
)

; refactored at 2021-06-11
(defun GetBsGCTHeaterDictData ()
  (vl-remove-if-not '(lambda (x) 
                      (= (GetDottedPairValueUtils "updateStatus" x) "是") 
                    ) 
    (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTHeaterMainData.txt")
  ) 
)

; 2021-06-14
(defun GetBsGCTReactorDictData ()
  (vl-remove-if-not '(lambda (x) 
                      (= (GetDottedPairValueUtils "updateStatus" x) "是") 
                    ) 
    (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTReactorMainData.txt")
  ) 
)

; refactored at 2021-06-11
(defun GetBsGCTProjectDictData ()
  (car (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTProjectData.txt"))
)

; refactored at 2021-06-11
(defun GetBsGCTAllNozzleDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTNozzleData.txt")
)

; refactored at 2021-06-11
(defun GetBsGCTAllSupportDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTSupportData.txt")
)

; 2021-04-20
; rename function at 2021-06-14
; refactored at 2021-07-13
(defun GetBsGCTOneEquipNozzleDictData (tankTag allNozzleDictData /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "TAG" x) tankTag) 
                      ) 
      allNozzleDictData
    )  
  ) 
)

; 2021-04-20
; rename function at 2021-06-14
(defun GetBsGCTOneEquipSupportDictData (tankTag allBsGCTSupportDictData /) 
  (car 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "TAG" x) tankTag) 
                      ) 
      allBsGCTSupportDictData
    )  
  ) 
)

; refactored at 2021-06-15
(defun GetBsGCTAllPressureElementDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTPressureElementData.txt")
)

; refactored at 2021-06-15
(defun GetBsGCTAllStandardDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTStandardData.txt")
)

; refactored at 2021-06-15
(defun GetBsGCTAllRequirementDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTRequirementData.txt")
)

; refactored at 2021-06-15
(defun GetBsGCTAllOtherRequestDictData ()
  (ReadCSVFileToDictDataUtils "D:\\dataflowcad\\bsdata\\bsGCTOtherRequestData.txt")
)

; 2021-04-20
; refactored at 2021-05-18
(defun GetBsGCTTankAssembleData (allAssembleDictData /) 
  (GetBsGCTAssembleDataByChEquipType allAssembleDictData "储罐")
)

; 2021-05-25
; refactored at 2021-05-18
(defun GetBsGCTHeaterAssembleData (allAssembleDictData /) 
  (GetBsGCTAssembleDataByChEquipType allAssembleDictData "换热器")
)

; 2021-05-18
(defun GetBsGCTReactorAssembleData (allAssembleDictData /) 
  (GetBsGCTAssembleDataByChEquipType allAssembleDictData "反应釜")
)

; 2021-05-18
(defun GetBsGCTAssembleDataByChEquipType (allStandardDictData chEquipType /) 
  (vl-remove-if-not '(lambda (x) 
                      (= (GetDottedPairValueUtils "equipType" x) chEquipType) 
                    ) 
    allStandardDictData
  )
)

; 2021-05-06
(defun GetBsGCTTankPressureElementDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTTankPressureElementKeysData bsGCTImportedList)
                y
              )
           ) 
    (GetBsGCTTankPressureElementData bsGCTImportedList)
  )
)

; 2021-05-25
(defun GetBsGCTHeaterPressureElementDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                ; for PressureElementKeysData, tank and heater are the same
                (GetBsGCTTankPressureElementKeysData bsGCTImportedList)
                y
              )
           ) 
    (GetBsGCTHeaterPressureElementData bsGCTImportedList)
  )
)

; 2021-05-06
(defun GetBsGCTTankPressureElementKeysData (bsGCTImportedList /) 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "Tank-PressureElementKeys") 
                        ) 
        bsGCTImportedList
      )  
    ) 
  ) 
)

; 2021-05-06
(defun GetBsGCTTankPressureElementData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-PressureElement") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterPressureElementData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Heater-PressureElement") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
; refactored at 2021-05-18
(defun GetBsGCTTankOtherRequestData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-OtherRequest") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterOtherRequestData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Heater-OtherRequest") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-17
; refacotred at 2021-05-07
(defun InsertOneBsGCTTank (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList 
                           allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData / 
                           drawFrameScale equipTag bsGCTType barrelRadius barrelHalfHeight thickNess headThickNess straightEdgeHeight equipType oneEquipNozzleDictData) 
  ; (setq drawFrameScale 8)
  (setq drawFrameScale (atoi (GetDottedPairValueUtils "drawFrameScale" oneTankData)))
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  ; (setq bsGCTType (strcat (GetDottedPairValueUtils "BSGCT_TYPE" oneTankData) "-" equipTag))
  ; refacotred at 2021-05-07 use equipTag as the label for data
  (setq bsGCTType equipTag)
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelDiameter" oneTankData))))
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelHeight" oneTankData))))
  (setq thickNess (atoi (GetDottedPairValueUtils "BARREL_THICKNESS" oneTankData)))
  ; do not convert to int frist 2021-04-23
  (setq headThickNess (GetDottedPairValueUtils "HEAD_THICKNESS" oneTankData))
  (setq straightEdgeHeight (GetBsGCTStraightEdgeHeightEnums barrelRadius))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  (InsertBsGCTDrawFrame insPt equipTag bsGCTProjectDictData drawFrameScale)
  (setq oneEquipNozzleDictData (GetBsGCTOneEquipNozzleDictData equipTag allNozzleDictData))
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankRequirementList 
    tankPressureElementList tankOtherRequestList equipType drawFrameScale oneEquipNozzleDictData)
  ; thickNess param refactored at 2021-04-21 ; Graph insPt updated by drawFrameScale - 2021-06-12
  (InsertBsGCTTankGraphyStrategy (MoveInsertPositionUtils insPt (* drawFrameScale -583) (* drawFrameScale 280)) 
    barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData)
)

; 2021-05-27
(defun InsertOneBsGCTHeater (insPt oneHeaterData heaterPressureElementList heaterOtherRequestList heaterStandardList heaterRequirementList
                             allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData / 
                             drawFrameScale equipTag bsGCTType barrelRadius barrelHalfHeight exceedLength thickNess headThickNess straightEdgeHeight equipType oneEquipNozzleDictData) 
  (setq drawFrameScale (atoi (GetDottedPairValueUtils "drawFrameScale" oneHeaterData)))
  (setq equipTag (GetDottedPairValueUtils "TAG" oneHeaterData))
  ; use equipTag as the label for data
  (setq bsGCTType equipTag)
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelDiameter" oneHeaterData))))
  ; refactored at - 2021-05-30 tube length for drawing tube
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelHeight" oneHeaterData))))
  (setq exceedLength (atoi (GetDottedPairValueUtils "EXCEED_LENGTH" oneHeaterData)))
  (setq thickNess (atoi (GetDottedPairValueUtils "BARREL_THICKNESS" oneHeaterData)))
  ; do not convert to int frist 2021-04-23
  (setq headThickNess (GetDottedPairValueUtils "HEAD_THICKNESS" oneHeaterData))
  (setq straightEdgeHeight (GetBsGCTStraightEdgeHeightEnums barrelRadius))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneHeaterData)))
  (InsertBsGCTDrawFrame insPt equipTag bsGCTProjectDictData drawFrameScale)
  (setq oneEquipNozzleDictData (GetBsGCTOneEquipNozzleDictData equipTag allNozzleDictData))
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneHeaterData heaterStandardList heaterRequirementList 
                           heaterPressureElementList heaterOtherRequestList equipType drawFrameScale oneEquipNozzleDictData)
  ; Graph insPt updated by drawFrameScale - 2021-06-12
  (InsertBsGCTHeaterGraphyStrategy (MoveInsertPositionUtils insPt (* drawFrameScale -583) (* drawFrameScale 280)) 
    barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData)
)

; 2021-06-15
(defun InsertOneBsGCTReactor (insPt oneReactorData reactorPressureElementList reactorOtherRequestList reactorStandardList reactorRequirementList 
                             allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData / 
                             drawFrameScale equipTag bsGCTType barrelRadius barrelHalfHeight thickNess headThickNess straightEdgeHeight equipType oneEquipNozzleDictData) 
  (setq drawFrameScale (atoi (GetDottedPairValueUtils "drawFrameScale" oneReactorData)))
  (setq equipTag (GetDottedPairValueUtils "TAG" oneReactorData))
  ; use equipTag as the label for data
  (setq bsGCTType equipTag)
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelDiameter" oneReactorData))))
  ; refactored at - 2021-05-30 tube length for drawing tube
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelHeight" oneReactorData))))
  (setq thickNess (atoi (GetDottedPairValueUtils "BARREL_THICKNESS" oneReactorData)))
  ; do not convert to int frist 2021-04-23
  (setq headThickNess (GetDottedPairValueUtils "HEAD_THICKNESS" oneReactorData))
  (setq straightEdgeHeight (GetBsGCTStraightEdgeHeightEnums barrelRadius))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneReactorData)))
  (InsertBsGCTDrawFrame insPt equipTag bsGCTProjectDictData drawFrameScale)
  (setq oneEquipNozzleDictData (GetBsGCTOneEquipNozzleDictData equipTag allNozzleDictData))
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneReactorData reactorStandardList reactorRequirementList 
                          reactorPressureElementList reactorOtherRequestList equipType drawFrameScale oneEquipNozzleDictData)
  ; Graph insPt updated by drawFrameScale - 2021-06-12
  (InsertBsGCTReactorGraphy (MoveInsertPositionUtils insPt (* drawFrameScale -583) (* drawFrameScale 280)) 
    barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData)
)

; 2021-05-13
(defun UpdateOneBsTankGCT (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList allNozzleDictData / 
                          drawFrameScale equipTag bsGCTType equipType oneEquipNozzleDictData) 
  (setq drawFrameScale 5)
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  (setq bsGCTType equipTag)
  ; (setq insPt (GetGCTFramePositionByEquipTag equipTag))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  ;; 2021-07-13
  (setq oneEquipNozzleDictData (GetBsGCTOneEquipNozzleDictData equipTag allNozzleDictData))
  
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankRequirementList 
                          tankPressureElementList tankOtherRequestList equipType drawFrameScale oneEquipNozzleDictData)
  (princ)
)

; 2021-05-13
(defun GetGCTFramePositionByEquipTag (equipTag /)
  (GetEntityPositionByEntityNameUtils (GetGCTFrameEntityNameByEquipTag equipTag))
)

; 2021-05-13
(defun GetGCTFrameEntityNameByEquipTag (equipTag /)
  (handent 
    (GetDottedPairValueUtils "entityhandle" 
      (car 
        (vl-remove-if-not 
          '(lambda (x) 
            (= (GetDottedPairValueUtils "equipname" x) equipTag)
          ) 
          (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
        )
      )
    )
  )
)

; 2021-05-13
; refacotred at 2021-05-07
; refactored at 2021-05-18
(defun InsertGCTOneBsVerticalTankTable (insPt bsGCTType oneTankData tankStandardList tankHeadStyleList tankHeadMaterialList 
                                tankPressureElementList tankOtherRequestList drawFrameScale oneEquipNozzleDictData / leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts - no need to split 2021-06-11
  ; (setq designParamDictList (cadr (SplitDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -180) (* drawFrameScale 574)))
  (setq rightInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -90) (* drawFrameScale 574)))
  (InsertBsGCTDataHeader leftInsPt bsGCTType drawFrameScale)
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignParam leftInsPt bsGCTType oneTankData "BsGCTTableDesignParam" drawFrameScale)
  ; the height of BsGCTTankDesignParam is 840 ; height is 168 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -168)))
  (InsertBsGCTPressureElement leftInsPt bsGCTType tankPressureElementList drawFrameScale)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (+ (length tankPressureElementList) 2)))))
  ; the total height of tankOtherRequestList is 54 for 1:1 scale
  (InsertBsGCTOtherRequest leftInsPt bsGCTType tankOtherRequestList (* drawFrameScale 54) drawFrameScale)
  ; the height of BsGCTOtherRequest is 270 ; height is 168 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -54)))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData drawFrameScale oneEquipNozzleDictData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" tankStandardList drawFrameScale 40)
  ; the height of BsGCTVerticalTankDesignStandard is 200 ; height is 40 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -40)))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement" tankHeadStyleList tankHeadMaterialList drawFrameScale)
  ; the height of BsGCTRequirement is 320 ; height is 64 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -64)))
  (InsertBsGCTInspectDataStrategy rightInsPt bsGCTType "Tank" oneTankData drawFrameScale)
  ; the height of BsGCTTankInspectData is 160 ; height is 32 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -32)))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData" oneTankData drawFrameScale)
)

; 2021-05-16
; refactored at 2021-05-18
(defun InsertGCTOneBsHorizontalTankTable (insPt bsGCTType oneTankData tankStandardList tankHeadStyleList tankHeadMaterialList 
                                tankPressureElementList tankOtherRequestList drawFrameScale oneEquipNozzleDictData / leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts
  ; (setq designParamDictList (cadr (SplitDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -180) (* drawFrameScale 574)))
  (setq rightInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -90) (* drawFrameScale 574)))
  (InsertBsGCTDataHeader leftInsPt bsGCTType drawFrameScale)
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignParam leftInsPt bsGCTType oneTankData "BsGCTTableHorizontalTankDesignParam" drawFrameScale)
  ; the height of BsGCTTankDesignParam is 920 ; height is 184 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -184)))
  (InsertBsGCTPressureElement leftInsPt bsGCTType tankPressureElementList drawFrameScale)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (+ (length tankPressureElementList) 2)))))
  ; the total height of tankOtherRequestList is 80 for 1:1 scale
  ; the height of BsGCTOtherRequest is 400 ; height is 80 for 1:1 - refactored at 2021-06-12
  ; self-calculate the height of BsGCTOtherRequest 2021-06-15
  (InsertBsGCTOtherRequest leftInsPt bsGCTType tankOtherRequestList (* drawFrameScale (+ (* (length tankOtherRequestList) 6) 15)) drawFrameScale)
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale (GetNegativeNumberUtils (+ (* (length tankOtherRequestList) 6) 15)))))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData drawFrameScale oneEquipNozzleDictData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" tankStandardList drawFrameScale 56)
  ; the height of BsGCTHorizontalTankDesignStandard is 280 ; height is 56 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -56)))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement" tankHeadStyleList tankHeadMaterialList drawFrameScale)
  ; the height of BsGCTRequirement is 320 ; height is 64 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -64)))
  (InsertBsGCTInspectDataStrategy rightInsPt bsGCTType "Tank" oneTankData drawFrameScale)
  ; the height of BsGCTTankInspectData is 160 ; height is 32 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -32)))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData" oneTankData drawFrameScale)
)

; 2021-05-25
(defun InsertGCTOneBsHeaterTable (insPt bsGCTType oneHeaterData heaterStandardList heaterHeadStyleList heaterHeadMaterialList 
                                heaterPressureElementList heaterOtherRequestList drawFrameScale oneEquipNozzleDictData / leftInsPt rightInsPt) 
  ; split oneHeaterData to Two Parts
  ; (setq designParamDictList (cadr (SplitDictListByDictKeyUtils "SERVIVE_LIFE" oneHeaterData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -180) (* drawFrameScale 574)))
  (setq rightInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -90) (* drawFrameScale 574)))
  (setq leftNozzleInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -360) (* drawFrameScale 574)))
  (InsertBsGCTDataHeader leftInsPt bsGCTType drawFrameScale)
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignParam leftInsPt bsGCTType oneHeaterData "BsGCTTableDesignParam-Heater" drawFrameScale)
  ; the height of BsGCTTankDesignParam is 960 ; height is 192 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -192)))
  (InsertBsGCTPressureElement leftInsPt bsGCTType heaterPressureElementList drawFrameScale)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (+ (length heaterPressureElementList) 2)))))
  ; the height of BsGCTOtherRequest is 350 ; the total height of tankOtherRequestList is 70 for 1:1 scale
  ; self-calculate the height of BsGCTOtherRequest 2021-06-15
  (InsertBsGCTOtherRequest leftInsPt bsGCTType heaterOtherRequestList (* drawFrameScale (+ (* (length heaterOtherRequestList) 6) 15)) drawFrameScale)
  ; Nozzle Table put the left zone - refactored at - 2021-06-12
  (InsertBsGCTNozzleTable leftNozzleInsPt bsGCTType oneHeaterData drawFrameScale oneEquipNozzleDictData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" heaterStandardList drawFrameScale 48)
  ; the height of BsGCTHorizontalTankDesignStandard is 240 ; height is 48 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -48)))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement-Heater" heaterHeadStyleList heaterHeadMaterialList drawFrameScale)
  ; the height of BsGCTRequirement is 280 ; height is 56 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -56)))
  (InsertBsGCTInspectDataStrategy rightInsPt bsGCTType "Heater" oneHeaterData drawFrameScale)
  ; the height of BsGCTTankInspectData is 240 ; height is 48 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -48)))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData-Heater" oneHeaterData drawFrameScale)
)

; 2021-06-15
(defun InsertGCTOneBsReactorTable (insPt bsGCTType oneReactorData standardList reactorHeadStyleList reactorHeadMaterialList 
                                reactorPressureElementList reactorOtherRequestList drawFrameScale oneEquipNozzleDictData / leftInsPt rightInsPt) 
  ; split oneReactorData to Two Parts
  ; (setq designParamDictList (cadr (SplitDictListByDictKeyUtils "SERVIVE_LIFE" oneReactorData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -180) (* drawFrameScale 574)))
  (setq rightInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -90) (* drawFrameScale 574)))
  (setq leftNozzleInsPt (MoveInsertPositionUtils insPt (* drawFrameScale -360) (* drawFrameScale 574)))
  (InsertBsGCTDataHeader leftInsPt bsGCTType drawFrameScale)
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignParam leftInsPt bsGCTType oneReactorData "BsGCTTableDesignParam-Reactor" drawFrameScale)
  ; the height of BsGCTTankDesignParam is 1040(1:5) ; height is 208 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -208)))
  (InsertBsGCTPressureElement leftInsPt bsGCTType reactorPressureElementList drawFrameScale)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (+ (length reactorPressureElementList) 2)))))
  ; the height of BsGCTOtherRequest is 350 ; the total height of tankOtherRequestList is 70 for 1:1 scale
  ; self-calculate the height of BsGCTOtherRequest 2021-06-15
  (InsertBsGCTOtherRequest leftInsPt bsGCTType reactorOtherRequestList (* drawFrameScale (+ (* (length reactorOtherRequestList) 6) 15)) drawFrameScale)
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -70)))
  ; Nozzle Table put the left zone - refactored at - 2021-06-12
  (InsertBsGCTNozzleTable leftNozzleInsPt bsGCTType oneReactorData drawFrameScale oneEquipNozzleDictData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" standardList drawFrameScale 48)
  ; the height of BsGCTHorizontalTankDesignStandard is 240 ; height is 48 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -48)))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement-Reactor" reactorHeadStyleList reactorHeadMaterialList drawFrameScale)
  ; the height of BsGCTRequirement is 320 ; height is 64 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -64)))
  (InsertBsGCTInspectDataStrategy rightInsPt bsGCTType "Reactor" oneReactorData drawFrameScale)
  ; the height of BsGCTTankInspectData is 280(1:5) ; height is 56 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -56)))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData-Reactor" oneReactorData drawFrameScale)
)

; 2021-05-16
; unit compeleted
(defun GetBsGCTEquipTypeStrategy (equipType /)
  (cond 
    ((RegexpTestUtils equipType "立式双椭.*" nil) "verticalTank")
    ((RegexpTestUtils equipType "卧式双椭.*" nil) "horizontalTank")
    ((RegexpTestUtils equipType "立式换热.*" nil) "verticalHeater")
    ((RegexpTestUtils equipType "卧式换热.*" nil) "horizontalHeater")
    ((RegexpTestUtils equipType ".*反应.*" nil) "reactor")
  )
)

; 2021-05-11
; refactored at 2021-05-18
; refactored at 2021-05-25 equipHeadStyleList equipHeadMaterialList => equipRequirementList
(defun InsertBsGCTEquipTableStrategy (insPt bsGCTType oneEquipData equipStandardList equipRequirementList 
                                      equipPressureElementList equipOtherRequestList equipType drawFrameScale oneEquipNozzleDictData /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertGCTOneBsVerticalTankTable insPt bsGCTType oneEquipData 
      ;  (FilterListListByFirstItemUtils equipStandardList "verticalTank") 
       (FilterBsGCTTextDataByTypeNum equipStandardList (GetDottedPairValueUtils "standardType" oneEquipData))
       ; equipHeadStyleList
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "接头形式") 
       ; equipHeadMaterialList
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "焊接材料") 
       (FilterBsGCTPressureElementByTypeNum equipPressureElementList (GetDottedPairValueUtils "pressureElementType" oneEquipData))
       (FilterBsGCTTextDataByTypeNum equipOtherRequestList (GetDottedPairValueUtils "otherRequestType" oneEquipData))
       drawFrameScale
       oneEquipNozzleDictData
     ))
    ((= equipType "horizontalTank") 
     (InsertGCTOneBsHorizontalTankTable insPt bsGCTType oneEquipData 
       (FilterBsGCTTextDataByTypeNum equipStandardList (GetDottedPairValueUtils "standardType" oneEquipData))
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "接头形式") 
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "焊接材料")              
       (FilterBsGCTPressureElementByTypeNum equipPressureElementList (GetDottedPairValueUtils "pressureElementType" oneEquipData)) 
       (FilterBsGCTTextDataByTypeNum equipOtherRequestList (GetDottedPairValueUtils "otherRequestType" oneEquipData))
       drawFrameScale
       oneEquipNozzleDictData
     ))
    ((or (= equipType "verticalHeater") (= equipType "horizontalHeater")) 
     (InsertGCTOneBsHeaterTable insPt bsGCTType oneEquipData 
       (FilterBsGCTTextDataByTypeNum equipStandardList (GetDottedPairValueUtils "standardType" oneEquipData)) 
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "接头形式") 
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "焊接材料")            
       (FilterBsGCTPressureElementByTypeNum equipPressureElementList (GetDottedPairValueUtils "pressureElementType" oneEquipData)) 
       (FilterBsGCTTextDataByTypeNum equipOtherRequestList (GetDottedPairValueUtils "otherRequestType" oneEquipData))
       drawFrameScale
       oneEquipNozzleDictData
     ))
    ((= equipType "reactor") 
     (InsertGCTOneBsReactorTable insPt bsGCTType oneEquipData 
       (FilterBsGCTTextDataByTypeNum equipStandardList (GetDottedPairValueUtils "standardType" oneEquipData))
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "接头形式") 
       (FilterBsGCTTextDataByTypeNumAndJointWeld equipRequirementList (GetDottedPairValueUtils "requirementType" oneEquipData) "焊接材料") 
       (FilterBsGCTPressureElementByTypeNum equipPressureElementList (GetDottedPairValueUtils "pressureElementType" oneEquipData))
       (FilterBsGCTTextDataByTypeNum equipOtherRequestList (GetDottedPairValueUtils "otherRequestType" oneEquipData))
       drawFrameScale
       oneEquipNozzleDictData
     ))
  )
)

; 2021-06-15
(defun FilterBsGCTPressureElementByTypeNum (assembleData typeNum /) 
  (vl-remove-if-not '(lambda (x) 
                      (= (GetDottedPairValueUtils "typeNum" x) typeNum) 
                    ) 
    assembleData
  ) 
)

; 2021-06-15
(defun FilterBsGCTTextDataByTypeNum (assembleData typeNum /) 
  (mapcar '(lambda (xx)
             (GetDottedPairValueUtils "textContent" xx)
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "typeNum" x) typeNum) 
                      ) 
      assembleData
    )  
  ) 
)

; 2021-06-15
(defun FilterBsGCTTextDataByTypeNumAndJointWeld (assembleData typeNum jointWeld /) 
  (mapcar '(lambda (xx)
             (GetDottedPairValueUtils "textContent" xx)
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (and 
                          (= (GetDottedPairValueUtils "typeNum" x) typeNum) 
                          (= (GetDottedPairValueUtils "jointWeld" x) jointWeld) 
                        )
                      ) 
      assembleData
    )  
  ) 
)

; 2021-05-25
(defun InsertBsGCTHeaterGraphyStrategy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType 
                                        straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData /)
  (cond 
    ((= equipType "verticalHeater") 
     (InsertBsGCTVerticalHeaterGraphy insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData))
    ; ((= equipType "horizontalHeater") 
    ;  (InsertBsGCTVerticalHeaterGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
    ;    bsGCTType straightEdgeHeight allBsGCTSupportDictData))
  )
)

; 2021-05-11
(defun InsertBsGCTTankGraphyStrategy (insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType 
                                      straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertBsGCTVerticalTankGraphy insPt barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData))
    ((= equipType "horizontalTank") 
     ; refactored at 2021-05-18 move the insPt for HorizontalTankGraphy
     (InsertBsGCTHorizontalTankGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale oneEquipNozzleDictData))
  )
)

; 2021-04-17
; refactored at 2021-05-25
; refactored at 2021-06-15
; VerifyBsGCTDataBeforeInsert - refactored at 2021-07-15
(defun InsertAllBsGCTTank (insPt allBsGCTSupportDictData bsGCTProjectDictData allPressureElementDictData 
                           allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTTankDictData / 
                           tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList insPtList) 
  (setq tankStandardList (GetBsGCTTankAssembleData allStandardDictData)) 
  (setq tankRequirementList (GetBsGCTTankAssembleData allRequirementDictData)) 
  (setq tankPressureElementList (GetBsGCTTankAssembleData allPressureElementDictData)) 
  (setq tankOtherRequestList (GetBsGCTTankAssembleData allOtherRequestDictData))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTTank x y tankPressureElementList tankOtherRequestList 
              tankStandardList tankRequirementList allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
)

; 2021-05-25
(defun InsertAllBsGCTHeater (insPt allBsGCTSupportDictData bsGCTProjectDictData allPressureElementDictData 
                             allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTHeaterDictData / 
                             heaterPressureElementList 
                             heaterOtherRequestList heaterStandardList heaterRequirementList insPtList) 
  (setq heaterStandardList (GetBsGCTHeaterAssembleData allStandardDictData)) 
  (setq heaterPressureElementList (GetBsGCTHeaterAssembleData allPressureElementDictData))
  (setq heaterRequirementList (GetBsGCTHeaterAssembleData allRequirementDictData)) 
  (setq heaterOtherRequestList (GetBsGCTHeaterAssembleData allOtherRequestDictData)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTHeaterDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTHeater x y heaterPressureElementList heaterOtherRequestList 
              heaterStandardList heaterRequirementList allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData) 
          ) 
    insPtList
    allBsGCTHeaterDictData 
  ) 
)

; 2021-06-14
(defun InsertAllBsGCTReactor (insPt allBsGCTSupportDictData bsGCTProjectDictData allPressureElementDictData 
                              allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTReactorDictData / 
                              reactorPressureElementList reactorOtherRequestList reactorStandardList reactorRequirementList insPtList) 
  (setq reactorStandardList (GetBsGCTReactorAssembleData allStandardDictData)) 
  (setq reactorRequirementList (GetBsGCTReactorAssembleData allRequirementDictData))
  (setq reactorPressureElementList (GetBsGCTReactorAssembleData allPressureElementDictData))
  (setq reactorOtherRequestList (GetBsGCTReactorAssembleData allOtherRequestDictData)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTReactorDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTReactor x y reactorPressureElementList reactorOtherRequestList 
              reactorStandardList reactorRequirementList allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData) 
          ) 
    insPtList
    allBsGCTReactorDictData 
  ) 
)

; 2021-06-24
(defun InsertAllBsGCTColumn (insPt allBsGCTSupportDictData bsGCTProjectDictData allPressureElementDictData 
                             allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTTankDictData / 
                             tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList insPtList) 
  (setq tankStandardList (GetBsGCTTankAssembleData allStandardDictData)) 
  (setq tankRequirementList (GetBsGCTTankAssembleData allRequirementDictData)) 
  (setq tankPressureElementList (GetBsGCTTankAssembleData allPressureElementDictData)) 
  (setq tankOtherRequestList (GetBsGCTTankAssembleData allOtherRequestDictData))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTTank x y tankPressureElementList tankOtherRequestList 
              tankStandardList tankRequirementList allBsGCTSupportDictData bsGCTProjectDictData allNozzleDictData) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
)

; 2021-05-25
; refactored at 2021-06-11
; refactored at 2021-06-15 Reactor
; refactored at 2021-06-24 Column
; refactored at 2021-07-13 allNozzleDictData
(defun InsertAllBsGCTMacro (/ insPt allBsGCTSupportDictData bsGCTProjectDictData allPressureElementDictData allStandardDictData allRequirementDictData 
                            allOtherRequestDictData allNozzleDictData allBsGCTTankDictData allBsGCTHeaterDictData allBsGCTReactorDictData allBsGCTColumnDictData) 
  (VerifyAllBsGCTSymbol)
  (setq insPt (getpoint "\n拾取工程图插入点："))
  (setq allBsGCTSupportDictData (GetBsGCTAllSupportDictData))
  (setq bsGCTProjectDictData (GetBsGCTProjectDictData))
  (setq allPressureElementDictData (GetBsGCTAllPressureElementDictData))
  (setq allStandardDictData (GetBsGCTAllStandardDictData))
  (setq allRequirementDictData (GetBsGCTAllRequirementDictData))
  (setq allOtherRequestDictData (GetBsGCTAllOtherRequestDictData))
  (setq allNozzleDictData (GetBsGCTAllNozzleDictData))
  (setq allBsGCTTankDictData (GetBsGCTTankDictData))
  (setq allBsGCTHeaterDictData (GetBsGCTHeaterDictData))
  (setq allBsGCTReactorDictData (GetBsGCTReactorDictData))
  ; (setq allBsGCTColumnDictData (GetBsGCTColumnDictData))
  ;; refactored at 2021-07-18
  (VerifyBsGCTDataBeforeInsert allBsGCTTankDictData allBsGCTHeaterDictData allBsGCTReactorDictData allBsGCTColumnDictData allBsGCTSupportDictData)
  (InsertAllBsGCTTank insPt allBsGCTSupportDictData bsGCTProjectDictData 
    allPressureElementDictData allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTTankDictData)
  (InsertAllBsGCTHeater (MoveInsertPositionUtils insPt 0 -10000) allBsGCTSupportDictData bsGCTProjectDictData 
    allPressureElementDictData allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTHeaterDictData)
  (InsertAllBsGCTReactor (MoveInsertPositionUtils insPt 0 -20000) allBsGCTSupportDictData bsGCTProjectDictData 
    allPressureElementDictData allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTReactorDictData)
  ; (InsertAllBsGCTColumn (MoveInsertPositionUtils insPt 0 -30000) allBsGCTSupportDictData bsGCTProjectDictData 
  ;   allPressureElementDictData allStandardDictData allRequirementDictData allOtherRequestDictData allNozzleDictData allBsGCTColumnDictData)
)

; 2021-04-21
(defun c:InsertAllBsGCT ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertAllBsGCTMacro '())
)

;; 2021-07-18
(defun VerifyBsGCTDataBeforeInsert (allBsGCTTankDictData allBsGCTHeaterDictData allBsGCTReactorDictData allBsGCTColumnDictData allBsGCTSupportDictData /) 
  (VerifyBsGCTDataDrawFrameScale allBsGCTTankDictData)
  (VerifyBsGCTDataDrawFrameScale allBsGCTHeaterDictData)
  (VerifyBsGCTDataDrawFrameScale allBsGCTReactorDictData)
  ; (VerifyBsGCTDataDrawFrameScale allBsGCTColumnDictData)
  (VerifyBsGCTDataSupportDictData allBsGCTSupportDictData)
)

;; 2021-07-18
(defun VerifyBsGCTDataSupportDictData (allBsGCTSupportDictData /) 
  (if (= allBsGCTSupportDictData nil) 
    (alert "要生成的工程图其支座数据不能为空！")
  )
)

;; 2021-07-18
(defun VerifyBsGCTDataDrawFrameScale (allBsGCTEquipDictData /) 
  (if (IsAllEquipDrawFrameScaleNull allBsGCTEquipDictData) 
    (alert "要生成的工程图其图框比例不能为空！")
  )
)

;; 2021-07-18
(defun IsAllEquipDrawFrameScaleNull (allBsGCTEquipDictData /) 
  (vl-some '(lambda (x) 
             (= (GetDottedPairValueUtils "drawFrameScale" x) "") 
          ) 
    allBsGCTEquipDictData
  ) 
)

;;;-------------------------------------------------------------------------;;;
; Update BsGCT Table data

; 2021-05-13
(defun c:UpdateBsGCTData ()
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateBsGCTBySelectByBox '("UpdateBsGCTBySelectBox"))
)

; 2021-05-13
(defun UpdateBsGCTBySelectByBox (tileName / dcl_id status sslen equipTagAndPositionList equipTagList equipPositionList modifyStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowBs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAllSelect" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "选择数据的数量： " (rtos sslen)))
    ) 
    (if (= modifyStatus 2)
      (set_tile "equipTagListMsg" (strcat "已选择的设备位号：" (vl-princ-to-string equipTagList)))
    )
    (if (= modifyStatus 1)
      (set_tile "modifyStatusMsg" "修改状态：已完成")
    ) 
    (set_tile "equipTagListMsg" (strcat "已选择的设备位号：" (vl-princ-to-string equipTagList)))
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq ss (GetDrawLabelSSBySelectUtils))
        (setq sslen (sslength ss)) 
        (setq equipTagAndPositionList (vl-sort (GetGCTUpdatedEquipTagAndPositionList ss) '(lambda (x y) (< (car x) (car y)))))
        (setq equipTagList (mapcar '(lambda (x) (car x)) equipTagAndPositionList))
        (setq equipPositionList (mapcar '(lambda (x) (cadr x)) equipTagAndPositionList))
        (setq modifyStatus 2) 
      )
    )
    ; All select button
    (if (= 3 status) 
      (progn 
        (setq ss (GetAllDrawLabelSSUtils))
        (setq sslen (sslength ss)) 
        (setq equipTagAndPositionList (vl-sort (GetGCTUpdatedEquipTagAndPositionList ss) '(lambda (x y) (< (car x) (car y)))))
        (setq equipTagList (mapcar '(lambda (x) (car x)) equipTagAndPositionList))
        (setq equipPositionList (mapcar '(lambda (x) (cadr x)) equipTagAndPositionList))
        (setq modifyStatus 2) 
      )
    ) 
    ; update data button
    (if (= 4 status) 
      (progn 
        (UpdateBsGCTTankByEquipTag equipTagList equipPositionList) 
        (setq modifyStatus 1) 
        (setq sslen nil)
      ) 
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-05-13
(defun GetGCTUpdatedEquipTagAndPositionList (ss /)
  (mapcar '(lambda (x) 
            (list 
              (GetDottedPairValueUtils "equipname" x) 
              (GetEntityPositionByEntityNameUtils (handent (GetDottedPairValueUtils "entityhandle" x))) 
            )
          ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss))
  )
)

; 2021-05-13
; refacotred at 2021-06-15
(defun UpdateBsGCTTankByEquipTag (equipTagList equipPositionList / allBsGCTTankDictData allPressureElementDictData allStandardDictData 
                                  allRequirementDictData allOtherRequestDictData allNozzleDictData tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList) 
  (VerifyBsGCTBlockLayerText)
  (DeleteBsGCTTableByEquipTagListUtils equipTagList)
  (DeleteBsGCTPolyLineAndTextByEquipTagListUtils equipTagList)
  (setq allBsGCTTankDictData (GetBsGCTTankDictData))
  ; filter the updated data
  (setq allBsGCTTankDictData (FilterUpdatedBsGCTTankDictData allBsGCTTankDictData equipTagList))
  ; 2021-6-15
  (setq allPressureElementDictData (GetBsGCTAllPressureElementDictData))
  (setq allStandardDictData (GetBsGCTAllStandardDictData))
  (setq allRequirementDictData (GetBsGCTAllRequirementDictData))
  (setq allOtherRequestDictData (GetBsGCTAllOtherRequestDictData))
  (setq allNozzleDictData (GetBsGCTAllNozzleDictData))
  
  (setq tankPressureElementList (GetBsGCTTankAssembleData allPressureElementDictData))
  (setq tankOtherRequestList (GetBsGCTTankAssembleData allOtherRequestDictData)) 
  (setq tankStandardList (GetBsGCTTankAssembleData allStandardDictData)) 
  (setq tankRequirementList (GetBsGCTTankAssembleData allRequirementDictData)) 
  (mapcar '(lambda (x y) 
            (UpdateOneBsTankGCT x y tankPressureElementList tankOtherRequestList tankStandardList tankRequirementList allNozzleDictData) 
          ) 
    equipPositionList
    allBsGCTTankDictData 
  ) 
)

; 2021-05-13
(defun FilterUpdatedBsGCTTankDictData (allBsGCTTankDictData equipTagList /)
  (vl-remove-if-not '(lambda (x) 
                      (member (GetDottedPairValueUtils "TAG" x) equipTagList) 
                    ) 
    allBsGCTTankDictData
  )
)

; 2021-05-13
(defun FilterBsGCTTableByEquipTagListUtils (propertyName equipTagList /)
  (vl-remove-if-not '(lambda (x) 
                      (member (VlaGetBlockPropertyValueUtils x propertyName) equipTagList) 
                    ) 
    (GetEntityNameListBySSUtils (GetAllBsGCTTableSSUtils))
  ) 
)

; 2021-05-13
(defun DeleteBsGCTTableByEquipTagListUtils (equipTagList /)
  (DeleteEntityByEntityNameListUtils 
    (FilterBsGCTTableByEquipTagListUtils "bsgct_type" equipTagList)
  )
)

; 2021-05-13
(defun DeleteBsGCTPolyLineAndTextByEquipTagListUtils (equipTagList /)
  (DeleteEntityByEntityNameListUtils 
    (FilterBsGCTPolyLineAndTextByEquipTagListUtils "bsgct_type" equipTagList)
  )
)

; 2021-05-13
(defun FilterBsGCTPolyLineAndTextByEquipTagListUtils (propertyName equipTagList /)
  (vl-remove-if-not '(lambda (x) 
                      (member (GetStringXDataByEntityNameUtils x) equipTagList) 
                    ) 
    (GetEntityNameListBySSUtils (GetAllTextAndPloyLineSSUtils))
  ) 
)

; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
