;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoBS ()
  (alert "设备设计流最新版本号 V0.3，更新时间：2021-05-30\n数据流内网地址：192.168.1.38")(princ)
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
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (car x)) bsGCTProjectDictData)
    (mapcar '(lambda (x) (cdr x)) bsGCTProjectDictData)
  )
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
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (car x)) designParamDictList)
    (mapcar '(lambda (x) (cdr x)) designParamDictList)
  )
)

; refactored at 2021-04-20
; refactored at 2021-05-25
; refactored at 2021-06-12 drawFrameScale
(defun InsertBsGCTDesignStandard (insPt dataType blockName tankStandardList drawFrameScale /) 
  (InsertBlockByScaleUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
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
  )
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
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
(defun InsertBsGCTInspectDataStrategy (insPt dataType blockName oneEquipData drawFrameScale /) 
  (cond 
    ((= blockName "Tank") (InsertBsGCTTankInspectData insPt dataType oneEquipData drawFrameScale))
    ((= blockName "Heater") (InsertBsGCTHeaterInspectData insPt dataType oneEquipData drawFrameScale))
  )
)

; 2021-05-25
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-13
(defun InsertBsGCTHeaterInspectData (insPt dataType oneHeaterData drawFrameScale / inspectDictData tubeWeldJoint shellWeldJoint) 
  (setq barrelDiameter (atoi (GetDottedPairValueUtils "barrelDiameter" oneHeaterData)))
  (setq tubeWeldJoint (GetDottedPairValueUtils "TUBE_WELD_JOINT" oneHeaterData))
  (setq shellWeldJoint (GetDottedPairValueUtils "SHELL_WELD_JOINT" oneHeaterData))
  (cond 
    ((<= barrelDiameter 1200) (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-HeaterB" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale))
    (T (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-HeaterA" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale))
  )
  (setq inspectDictData (append 
                          (GetBsGCTHeaterBarrelInspectDictData shellWeldJoint (GetDottedPairValueUtils "SHELL_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTBarrelInspectDictData tubeWeldJoint (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTBarrelInspectDictData tubeWeldJoint (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneHeaterData))
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneHeaterData) "CD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEATER_INSPECT_RATE" oneHeaterData) "HEATER_")
                        ))
  (ModifyBlockPropertiesByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-07
; refactored at 2021-05-11
; refactored at 2021-06-12 drawFrameScale
; refactored at 2021-06-13
(defun InsertBsGCTTankInspectData (insPt dataType oneTankData drawFrameScale / inspectDictData barrelDiameter weldJoint) 
  ; BsGCTTableInspectData-TankA or BsGCTTableInspectData-TankB, ready for the whole logic 2021-05-11
  (setq barrelDiameter (atoi (GetDottedPairValueUtils "barrelDiameter" oneTankData)))
  (setq weldJoint (GetDottedPairValueUtils "WELD_JOINT" oneTankData))
  (cond 
    ((<= barrelDiameter 1200) (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-TankB" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale))
    (T (InsertBlockByScaleUtils insPt "BsGCTTableInspectData-TankA" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale))
  )
  (setq inspectDictData (append 
                          (GetBsGCTBarrelInspectDictData weldJoint (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneTankData))
                          (GetBsGCTHeadInspectDictData weldJoint (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneTankData))
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneTankData) "CD_")
                        ))
  (ModifyBlockPropertiesByDictDataUtils (entlast) inspectDictData)
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
  (ModifyBlockPropertiesByDictDataUtils (entlast) testDictData)
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
(defun GetBsGCTTestDictData (oneEquipData /)
  (vl-remove-if-not '(lambda (x) 
                       (member (car x) 
                               '("TEST_PRESSURE" "AIR_TEST_PRESSURE" "HEAT_TREAT" "SHELL_WATER_TEST_PRESSURE" "TUBE_WATER_TEST_PRESSURE" "SHELL_AIR_TEST_PRESSURE" "TUBE_AIR_TEST_PRESSURE")) 
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
    (ModifyMultiplePropertyForOneBlockUtils (entlast) 
      (mapcar '(lambda (x) (car x)) (nth i tankPressureElementList))
      (mapcar '(lambda (x) (cdr x)) (nth i tankPressureElementList))
    )
    (setq i (1+ i))
  ) 
  ; bind equipTag to Xdata - 2021-05-13
  (GeneratePolyLineUtils 
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
  (SetDynamicBlockPropertyValueUtils 
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
(defun InsertBsGCTNozzleTable (insPt dataType oneTankData drawFrameScale / oneBsGCTTankNozzleDictData) 
  (setq oneBsGCTTankNozzleDictData (GetBsGCTOneEquipNozzleDictData (GetDottedPairValueUtils "TAG" oneTankData)))
  (InsertBlockByScaleUtils insPt "BsGCTTableNozzleTableHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)) drawFrameScale)
  (if (/= oneBsGCTTankNozzleDictData nil) 
    (InsertBsGCTNozzleTableRow (MoveInsertPositionUtils insPt 0 (* drawFrameScale -26)) dataType oneBsGCTTankNozzleDictData drawFrameScale)
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
  (GeneratePolyLineUtils 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    (MoveInsertPositionUtils insPt (* drawFrameScale 180) (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    ; the lineWith is 0.72 for 1:1 scale
    "0DataFlow-BsGCT" (* drawFrameScale 0.72))
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (* (* drawFrameScale 8) (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" (* drawFrameScale 0.72)) 
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
)

; 2021-04-18
(defun InsertBsGCTVerticalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight 
                                      allBsGCTSupportDictData drawFrameScale / 
                                      newBarrelHalfHeight nozzleOffset oneBsGCTEquipSupportDictData legSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq legSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTEquipSupportDictData)))
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  (GenerateVerticalDoubleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTLegSupport 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- newBarrelHalfHeight straightEdgeHeight))) 
    dataType legSupportHeight drawFrameScale)
  (InsertBsGCTVerticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight)
  (InsertBsGCTVerticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale)
  (princ)
)

; 2021-05-18
(defun InsertBsGCTHorizontalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight 
                                        allBsGCTSupportDictData drawFrameScale / 
                                        newBarrelHalfHeight nozzleOffset oneBsGCTEquipSupportDictData saddleSupportOffset saddleSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq saddleSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTEquipSupportDictData)))
  (setq saddleSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTEquipSupportDictData)))
  ; [insPt barrelRadius entityLayer centerLineLayer directionStatus thickNess straightEdgeHeight]
  (GenerateDoubleLineHorizontalEllipseHeadUtils (MoveInsertPositionUtils insPt newBarrelHalfHeight 0) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  ; (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  (GenerateHorizontalDoubleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTHorizontalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateDoubleLineHorizontalEllipseHeadUtils (MoveInsertPositionUtils insPt (- 0 newBarrelHalfHeight) 0) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  ; (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTRightSaddleSupport (MoveInsertPositionUtils insPt saddleSupportOffset (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    dataType saddleSupportHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale)
  (InsertBsGCTLeftSaddleSupport (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    dataType saddleSupportHeight oneBsGCTEquipSupportDictData barrelRadius drawFrameScale)
  (InsertBsGCTHorizonticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight saddleSupportHeight saddleSupportOffset)
  (InsertBsGCTHorizonticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight drawFrameScale)
  (princ)
)

; 2021-05-30
(defun InsertBsGCTVerticalHeaterGraphy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess dataType straightEdgeHeight 
                                        allBsGCTSupportDictData drawFrameScale / 
                                      newBarrelHalfHeight nozzleOffset oneBsGCTEquipSupportDictData totalFlangeHeight) 
  (GenerateBsGCTHeaterTube (MoveInsertPositionUtils insPt -100 0) dataType "0DataFlow-BsDottedLine" 25 (* barrelHalfHeight 2))
  ; different from tank, tube length subtract EXCEED_LENGTH - 2021-5-27 refactored at 2021-05-30
  (setq barrelHalfHeight (- barrelHalfHeight exceedLength))
  (setq nozzleOffset 100)
  (setq oneBsGCTEquipSupportDictData (GetBsGCTOneEquipSupportDictData dataType allBsGCTSupportDictData))
  (setq totalFlangeHeight (GetBsGCTHeaterFlangeTotalHeight barrelRadius))
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight totalFlangeHeight))
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  ; the upper Flange - rotate is PI
  (GenerateBsGCTFlangeUtils (MoveInsertPositionUtils insPt 0 (- newBarrelHalfHeight straightEdgeHeight)) dataType barrelRadius thickNess PI -1)
  (GenerateVerticalDoubleLineBarrelUtils insPt barrelRadius barrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  ; the down Flange - rotate is 0
  (GenerateBsGCTFlangeUtils (MoveInsertPositionUtils insPt 0 (- straightEdgeHeight newBarrelHalfHeight)) dataType barrelRadius thickNess 0 1)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTLugSupport insPt dataType oneBsGCTEquipSupportDictData thickNess barrelRadius barrelHalfHeight drawFrameScale)
  (princ)
)

; 2021-05-30
(defun GenerateBsGCTHeaterTube (insPt dataType blockName tubeDiameter tubeLength /)
  (InsertBlockUtils insPt "BsGCTGraphHeaterTube" blockName (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
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
(defun InsertBsGCTVerticalTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight /) 
  ; Barrel diameter
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelRadius) 0) 
    (MoveInsertPositionUtils insPt barrelRadius 0) 
    (MoveInsertPositionUtils insPt 0 50) 
    "%%c<>")
  ; thickness
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelRadius 0) 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) 0) 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess 50) 50) 
    "") 
  ; vertical barrel
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelRadius barrelHalfHeight) 
    (MoveInsertPositionUtils insPt barrelRadius (GetNegativeNumberUtils barrelHalfHeight))  
    (MoveInsertPositionUtils insPt (+ barrelRadius 200) 0) 
    "") 
  ; vertical head
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt 0 barrelHalfHeight) 
    (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight (/ barrelRadius 2) straightEdgeHeight thickNess))  
    (MoveInsertPositionUtils insPt (+ barrelRadius 200) 0) 
    "") 
  ; vertical up distance for head and barrel
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelRadius barrelHalfHeight) 
    (MoveInsertPositionUtils insPt barrelRadius (+ barrelHalfHeight straightEdgeHeight)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt (- barrelRadius 100) 0) 
    "") 
  ; vertical down distance for head and barrel
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelRadius (GetNegativeNumberUtils barrelHalfHeight)) 
    (MoveInsertPositionUtils insPt barrelRadius (- 0 barrelHalfHeight straightEdgeHeight)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt (- barrelRadius 100) 0) 
    "")   
)

; 2021-05-19
(defun InsertBsGCTHorizonticalTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight saddleSupportHeight saddleSupportOffset /) 
  ; Barrel diameter
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt 0 barrelRadius) 
    (MoveInsertPositionUtils insPt 50 0) 
    "%%c<>")
  ; thickness
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    (MoveInsertPositionUtils insPt 50 (+ barrelRadius thickNess 50)) 
    "") 
  ; horizontial barrel
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelHalfHeight (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils barrelRadius))  
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight 300))) 
    "") 
  ; horizontial head - right
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelHalfHeight 0) 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight (/ barrelRadius 2) straightEdgeHeight thickNess) 0)  
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight 300))) 
    "") 
  ; horizontial head - left
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) 0) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (+ barrelHalfHeight (/ barrelRadius 2) straightEdgeHeight thickNess)) 0)  
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight 300))) 
    "") 
  ; horizontial - straightEdgeHeight - right
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt barrelHalfHeight (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight straightEdgeHeight) (GetNegativeNumberUtils barrelRadius)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (- barrelRadius 100))) 
    "") 
  ; horizontial - straightEdgeHeight - left
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (- 0 barrelHalfHeight straightEdgeHeight) (GetNegativeNumberUtils barrelRadius)) 
    ; the Y position of dimension is option
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (- barrelRadius 100))) 
    "") 
  ; two saddle support
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt saddleSupportOffset (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight))) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight)))  
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight 200))) 
    "") 
  ; ; left saddle support
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils barrelRadius))  
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils (+ barrelRadius saddleSupportHeight 200))) 
    "") 
)

; 2021-04-19
(defun InsertBsGCTTankNozzleDimension (insPt leftNozzleinsPt rightNozzleinsPt /) 
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils leftNozzleinsPt 0 150) 
    (MoveInsertPositionUtils (list (car insPt) (cadr leftNozzleinsPt) 0) 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt leftNozzleinsPt)) 200) 
    "R<>")
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils (list (car insPt) (cadr rightNozzleinsPt) 0) 0 150) 
    (MoveInsertPositionUtils rightNozzleinsPt 0 150) 
    (MoveInsertPositionUtils insPt (- 0 (GetXHalfDistanceForTwoPoint insPt rightNozzleinsPt)) 200) 
    "R<>") 
)

; 2021-04-19
(defun GenerateUpEllipseHeadNozzle (insPt barrelRadius dataType nozzleOffset thickNess / yOffset leftNozzleinsPt rightNozzleinsPt) 
  (setq yOffset (- (GetYByXForEllipseUtils barrelRadius (- barrelRadius nozzleOffset)) (/ barrelRadius 2)))
  (InsertBlockUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (setq leftNozzleinsPt (MoveInsertPositionUtils insPt (- 0 (- barrelRadius nozzleOffset thickNess)) yOffset))
  (setq rightNozzleinsPt (MoveInsertPositionUtils insPt (- barrelRadius nozzleOffset thickNess) yOffset))
  (InsertBlockUtils leftNozzleinsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBlockUtils rightNozzleinsPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBsGCTTankNozzleDimension insPt leftNozzleinsPt rightNozzleinsPt)
)

; 2021-04-19
(defun GenerateDownllipseHeadNozzle (insPt dataType /) 
  (InsertBlockByRotateUtils insPt "BsGCTGraphNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
)

; 2021-04-18
(defun InsertBsGCTLegSupport (insPt dataType legHeight drawFrameScale / groundPlateInsPt) 
  (InsertBlockUtils insPt "BsGCTGraphLegSupport-A2" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LEG_HEIGHT" legHeight))
  ) 
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt 8 (- 150 legHeight)))
  (InsertBsGCTFaceLeftGroundPlate groundPlateInsPt dataType)
  (InsertBsGCTUpLeftGroundPlateAnnotation (MoveInsertPositionUtils groundPlateInsPt -50 15) dataType drawFrameScale)
  (InsertBsGCTDimension 
    groundPlateInsPt 
    (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
    (MoveInsertPositionUtils groundPlateInsPt -100 0) 
    "") 
)

; 2021-05-30
(defun InsertBsGCTLugSupport (insPt dataType oneBsGCTEquipSupportDictData thickNess barrelRadius barrelHalfHeight drawFrameScale / 
                              lugSupportOffset flangeTopOffset lugYPosition supportType leftLugPosition rightLugPosition) 
  (setq lugSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTEquipSupportDictData)))
  (setq flangeTopOffset (+ barrelHalfHeight (GetFlangeHeightEnums (* 2 barrelRadius))))
  (setq lugYPosition (- flangeTopOffset lugSupportOffset))
  (setq supportType (GetLugSupportTypeUtils oneBsGCTEquipSupportDictData))
  (setq leftLugPosition (MoveInsertPositionUtils insPt (- 0 thickNess thickNess barrelRadius) lugYPosition))
  (InsertBsGCTLeftLugSupport leftLugPosition supportType dataType oneBsGCTEquipSupportDictData thickNess)
  (setq rightLugPosition (MoveInsertPositionUtils insPt (+ thickNess thickNess barrelRadius) lugYPosition))
  (InsertBsGCRightLugSupport rightLugPosition supportType dataType oneBsGCTEquipSupportDictData thickNess)
  ; (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius)) (- 150 saddleHeight)))
  ; (InsertBsGCTFaceRightGroundPlate groundPlateInsPt dataType)
  ; ; groundPlate Dimension 
  ; (InsertBsGCTDimension 
  ;   groundPlateInsPt 
  ;   (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
  ;   (MoveInsertPositionUtils groundPlateInsPt 100 0) 
  ;   "") 
  
  ; lug support Dimension 
  ; Y direction
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils insPt (- 0 thickNess thickNess barrelRadius) lugYPosition)
    (MoveInsertPositionUtils insPt (- 0 thickNess thickNess barrelRadius) flangeTopOffset)
    (MoveInsertPositionUtils leftLugPosition -100 0) 
    "") 
  ; X direction
  (InsertBsGCTDimension 
    (MoveInsertPositionUtils leftLugPosition (GetNegativeNumberUtils (GetLugSupportBlotOffsetEnums supportType)) 0) 
    (MoveInsertPositionUtils rightLugPosition (GetLugSupportBlotOffsetEnums supportType) 0) 
    (MoveInsertPositionUtils leftLugPosition 0 -100) 
    "") 
)

; 2021-05-30
(defun InsertBsGCTLeftLugSupport (insPt supportType dataType oneBsGCTEquipSupportDictData thickNess /) 
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; ready to refactor
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "THICKNESS" thickNess))
  ) 
)

; 2021-05-30
(defun InsertBsGCRightLugSupport (insPt supportType dataType oneBsGCTEquipSupportDictData thickNess /) 
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; ready to refactor
  (SetDynamicBlockPropertyValueUtils 
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
  (SetDynamicBlockPropertyValueUtils 
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
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "SADDLE_HEIGHT" saddleHeight))
  ) 
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius)) (- 150 saddleHeight)))
  (InsertBsGCTFaceRightGroundPlate groundPlateInsPt dataType)
  ; groundPlate Dimension 
  (InsertBsGCTDimension 
    groundPlateInsPt 
    (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
    (MoveInsertPositionUtils groundPlateInsPt 100 0) 
    "") 
  ; saddle support Dimension 
  (InsertBsGCTDimension 
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
(defun InsertBsGCTDimension (firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertAlignedDimensionUtils firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent)
)

; 2021-04-19
; refactored at 2021-06-11
(defun GetBsGCTImportedList () 
  (CSVStrListToListListUtils (ReadDataFromCSVUtils "D:\\dataflowcad\\bsdata\\bsGCT.csv"))
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
(defun GetBsGCTOneEquipNozzleDictData (tankTag /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "TAG" x) tankTag) 
                      ) 
      (GetBsGCTAllNozzleDictData)
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
(defun GetBsGCTTankStandardData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-Standard") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterStandardData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Heater-Standard") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
; refactored at 2021-05-18
(defun GetBsGCTTankHeadStyleData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-HeadStyle") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
; refactored at 2021-05-18
(defun GetBsGCTTankHeadMaterialData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-HeadMaterial") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterHeadStyleData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Heater-HeadStyle") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterHeadMaterialData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Heater-HeadMaterial") 
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

; 2021-04-23
(defun GetBsGCTTankMainKeysData (bsGCTImportedList /) 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "Tank-MainKeys") 
                        ) 
        bsGCTImportedList
      )  
    ) 
  )
)

; 2021-05-25
(defun GetBsGCTHeaterMainKeysData (bsGCTImportedList /) 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "Heater-MainKeys") 
                        ) 
        bsGCTImportedList
      )  
    ) 
  )
)

; 2021-04-17
; refacotred at 2021-05-07
(defun InsertOneBsGCTTank (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList 
                           allBsGCTSupportDictData bsGCTProjectDictData / 
                           drawFrameScale equipTag bsGCTType barrelRadius barrelHalfHeight thickNess headThickNess straightEdgeHeight equipType) 
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
  (setq straightEdgeHeight 25)
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  (InsertBsGCTDrawFrame insPt equipTag bsGCTProjectDictData drawFrameScale)
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
                           tankHeadMaterialList tankPressureElementList tankOtherRequestList equipType drawFrameScale)
  ; thickNess param refactored at 2021-04-21 ; Graph insPt updated by drawFrameScale - 2021-06-12
  (InsertBsGCTTankGraphyStrategy (MoveInsertPositionUtils insPt (* drawFrameScale -583) (* drawFrameScale 280)) 
    barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale)
)

; 2021-05-27
(defun InsertOneBsGCTHeater (insPt oneHeaterData heaterPressureElementList heaterOtherRequestList heaterStandardList heaterHeadStyleList 
                             heaterHeadMaterialList allBsGCTSupportDictData bsGCTProjectDictData / 
                             drawFrameScale equipTag bsGCTType barrelRadius barrelHalfHeight exceedLength thickNess headThickNess straightEdgeHeight equipType) 
  ; (setq drawFrameScale 8)
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
  (setq straightEdgeHeight 25)
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneHeaterData)))
  (InsertBsGCTDrawFrame insPt equipTag bsGCTProjectDictData drawFrameScale)
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneHeaterData heaterStandardList heaterHeadStyleList 
                           heaterHeadMaterialList heaterPressureElementList heaterOtherRequestList equipType drawFrameScale)
  ; Graph insPt updated by drawFrameScale - 2021-06-12
  (InsertBsGCTHeaterGraphyStrategy (MoveInsertPositionUtils insPt (* drawFrameScale -583) (* drawFrameScale 280)) 
    barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale)
)

; 2021-05-19
; 标准封头的直边段高度，小于等于 2000 直径的是 25mm，大于 2000 直径的是 40mm
(defun GetBsGCTStraightEdgeHeight (barrelRadius /)
  (cond 
    ((<= barrelRadius 1000) 25)
    ((> barrelRadius 1000) 40)
    (T 25)
  )
)

; 2021-05-13
(defun UpdateOneBsTankGCT (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList / 
                          drawFrameScale equipTag bsGCTType equipType) 
  (setq drawFrameScale 5)
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  (setq bsGCTType equipTag)
  ; (setq insPt (GetGCTFramePositionByEquipTag equipTag))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
                           tankHeadMaterialList tankPressureElementList tankOtherRequestList equipType drawFrameScale)
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
                                tankPressureElementList tankOtherRequestList drawFrameScale / leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts - no need to split 2021-06-11
  ; (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
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
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData drawFrameScale)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" tankStandardList drawFrameScale)
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
                                tankPressureElementList tankOtherRequestList drawFrameScale / leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts
  ; (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
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
  (InsertBsGCTOtherRequest leftInsPt bsGCTType tankOtherRequestList (* drawFrameScale 80) drawFrameScale)
  ; the height of BsGCTOtherRequest is 400 ; height is 80 for 1:1 - refactored at 2021-06-12
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -80)))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData drawFrameScale)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableHorizontalTankDesignStandard" tankStandardList drawFrameScale)
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
                                heaterPressureElementList heaterOtherRequestList drawFrameScale / leftInsPt rightInsPt) 
  ; split oneHeaterData to Two Parts
  ; (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneHeaterData)))
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
  (InsertBsGCTOtherRequest leftInsPt bsGCTType heaterOtherRequestList (* drawFrameScale 70) drawFrameScale)
  ; the height of BsGCTOtherRequest is 350 ; the total height of tankOtherRequestList is 70 for 1:1 scale
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (* drawFrameScale -70)))
  ; Nozzle Table put the left zone - refactored at - 2021-06-12
  (InsertBsGCTNozzleTable leftNozzleInsPt bsGCTType oneHeaterData drawFrameScale)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50 ; height is 10 for 1:1 - refactored at 2021-06-12
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 (* drawFrameScale -10)))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard-Heater" heaterStandardList drawFrameScale)
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

; 2021-05-16
; unit compeleted
(defun GetBsGCTEquipTypeStrategy (equipType /)
  (cond 
    ((RegexpTestUtils equipType "立式双椭.*" nil) "verticalTank")
    ((RegexpTestUtils equipType "卧式双椭.*" nil) "horizontalTank")
    ((RegexpTestUtils equipType "立式换热.*" nil) "verticalHeater")
    ((RegexpTestUtils equipType "卧式换热.*" nil) "horizontalHeater")
  )
)

; 2021-05-11
; refactored at 2021-05-18
; refactored at 2021-05-25
(defun InsertBsGCTEquipTableStrategy (insPt bsGCTType oneEquipData equipStandardList equipHeadStyleList equipHeadMaterialList 
                                equipPressureElementList equipOtherRequestList equipType drawFrameScale /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertGCTOneBsVerticalTankTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "verticalTank") 
       (FilterListListByFirstItemUtils equipHeadStyleList "verticalTank") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "verticalTank")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "verticalTank") 
       drawFrameScale
     ))
    ((= equipType "horizontalTank") 
     (InsertGCTOneBsHorizontalTankTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "horizontalTank") 
       (FilterListListByFirstItemUtils equipHeadStyleList "horizontalTank") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "horizontalTank")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "horizontalTank") 
       drawFrameScale
     ))
    ((or (= equipType "verticalHeater") (= equipType "horizontalHeater")) 
     (InsertGCTOneBsHeaterTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "Heater") 
       (FilterListListByFirstItemUtils equipHeadStyleList "Heater") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "Heater")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "Heater") 
       drawFrameScale
     ))
  )
)

; 2021-05-25
(defun InsertBsGCTHeaterGraphyStrategy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType 
                                        straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale /)
  (cond 
    ((= equipType "verticalHeater") 
     (InsertBsGCTVerticalHeaterGraphy insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale))
    ; ((= equipType "horizontalHeater") 
    ;  (InsertBsGCTVerticalHeaterGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
    ;    bsGCTType straightEdgeHeight allBsGCTSupportDictData))
  )
)

; 2021-05-11
(defun InsertBsGCTTankGraphyStrategy (insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType 
                                      straightEdgeHeight equipType allBsGCTSupportDictData drawFrameScale /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertBsGCTVerticalTankGraphy insPt barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale))
    ((= equipType "horizontalTank") 
     ; refactored at 2021-05-18 move the insPt for HorizontalTankGraphy
     (InsertBsGCTHorizontalTankGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData drawFrameScale))
  )
)

; 2021-04-17
; refactored at 2021-05-25
(defun InsertAllBsGCTTank (insPt bsGCTImportedList allBsGCTSupportDictData bsGCTProjectDictData / allBsGCTTankDictData tankPressureElementList 
                           tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList insPtList) 
  (setq allBsGCTTankDictData (GetBsGCTTankDictData))
  (setq tankPressureElementList (GetBsGCTTankPressureElementDictData bsGCTImportedList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestData bsGCTImportedList)) 
  (setq tankStandardList (GetBsGCTTankStandardData bsGCTImportedList)) 
  (setq tankHeadStyleList (GetBsGCTTankHeadStyleData bsGCTImportedList)) 
  (setq tankHeadMaterialList (GetBsGCTTankHeadMaterialData bsGCTImportedList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTTank x y tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList allBsGCTSupportDictData bsGCTProjectDictData) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
)

; 2021-05-25
(defun InsertAllBsGCTHeater (insPt bsGCTImportedList allBsGCTSupportDictData bsGCTProjectDictData / allBsGCTHeaterDictData heaterPressureElementList 
                           heaterOtherRequestList heaterStandardList heaterHeadStyleList heaterHeadMaterialList insPtList) 
  (setq allBsGCTHeaterDictData (GetBsGCTHeaterDictData))
  (setq heaterPressureElementList (GetBsGCTHeaterPressureElementDictData bsGCTImportedList))
  (setq heaterOtherRequestList (GetBsGCTHeaterOtherRequestData bsGCTImportedList)) 
  (setq heaterStandardList (GetBsGCTHeaterStandardData bsGCTImportedList)) 
  (setq heaterHeadStyleList (GetBsGCTHeaterHeadStyleData bsGCTImportedList)) 
  (setq heaterHeadMaterialList (GetBsGCTHeaterHeadMaterialData bsGCTImportedList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTHeaterDictData 0) 10000))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTHeater x y heaterPressureElementList heaterOtherRequestList heaterStandardList heaterHeadStyleList heaterHeadMaterialList allBsGCTSupportDictData bsGCTProjectDictData) 
          ) 
    insPtList
    allBsGCTHeaterDictData 
  ) 
  (princ)
)

; 2021-05-25
; refactored at 2021-06-11
(defun InsertAllBsGCTMacro (/ insPt bsGCTImportedList allBsGCTSupportDictData bsGCTProjectDictData) 
  (VerifyAllBsGCTSymbol)
  (setq insPt (getpoint "\n拾取工程图插入点："))
  (setq bsGCTImportedList (GetBsGCTImportedList))
  (setq allBsGCTSupportDictData (GetBsGCTAllSupportDictData))
  (setq bsGCTProjectDictData (GetBsGCTProjectDictData))
  (InsertAllBsGCTTank insPt bsGCTImportedList allBsGCTSupportDictData bsGCTProjectDictData)
  (InsertAllBsGCTHeater (MoveInsertPositionUtils insPt 0 -10000) bsGCTImportedList allBsGCTSupportDictData bsGCTProjectDictData)
)

; 2021-04-21
(defun c:InsertAllBsGCT ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertAllBsGCTMacro '())
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
(defun UpdateBsGCTTankByEquipTag (equipTagList equipPositionList / bsGCTImportedList allBsGCTTankDictData tankPressureElementList 
                           tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList insPtList) 
  (VerifyBsGCTBlockLayerText)
  (DeleteBsGCTTableByEquipTagListUtils equipTagList)
  (DeleteBsGCTPolyLineAndTextByEquipTagListUtils equipTagList)
  (setq bsGCTImportedList (GetBsGCTImportedList))
  (setq allBsGCTTankDictData (GetBsGCTTankDictData))
  ; filter the updated data
  (setq allBsGCTTankDictData (FilterUpdatedBsGCTTankDictData allBsGCTTankDictData equipTagList))
  (setq tankPressureElementList (GetBsGCTTankPressureElementDictData bsGCTImportedList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestData bsGCTImportedList)) 
  (setq tankStandardList (GetBsGCTTankStandardData bsGCTImportedList)) 
  (setq tankHeadStyleList (GetBsGCTTankHeadStyleData bsGCTImportedList)) 
  (setq tankHeadMaterialList (GetBsGCTTankHeadMaterialData bsGCTImportedList)) 
  (mapcar '(lambda (x y) 
            (UpdateOneBsTankGCT x y tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList) 
          ) 
    equipPositionList
    allBsGCTTankDictData 
  ) 
  (princ)
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
