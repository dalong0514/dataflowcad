;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoBS ()
  (alert "设备设计流最新版本号 V0.1，更新时间：2021-05-13\n数据流内网地址：192.168.1.38")(princ)
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
(defun GetBsGCTInspectDictDataStrategy (inspectRate /) 
  (cond 
    ((= inspectRate "20%") 
     (list (cons "INSPECT_RATE" "20%") (cons "INSPECT_GRADE" "AB") (cons "INSPECT_STANDARD" "NB/T47013.2-2015") (cons "INSPECT_QUALIFIED" "RT-Ⅲ")))
    ((= inspectRate "100%") 
     (list (cons "INSPECT_RATE" "100%") (cons "INSPECT_GRADE" "AB") (cons "INSPECT_STANDARD" "NB/T47013.2-2015") (cons "INSPECT_QUALIFIED" "RT-Ⅱ")))
    ((= inspectRate "/") 
     (list (cons "INSPECT_RATE" "/") (cons "INSPECT_GRADE" "/") (cons "INSPECT_STANDARD" "/") (cons "INSPECT_QUALIFIED" "/")))
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
(defun InsertBsGCTDrawFrame (insPt dataType /) 
  (InsertBlockByNoPropertyUtils insPt "BsGCTDrawFrame" "0DataFlow-BsFrame")
  (InsertBlockByScaleUtils insPt "title.equip.2017" "0DataFlow-BsFrame" (list (cons 4 "工程图")) 5)
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "Speci" "Scale" "EquipNAME")
    (list "设备" "1:5" equipTag)
  )  
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 230) "revisions.2017" "0DataFlow-BsFrame" (list (cons 2 "1")) 5)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 355) "intercheck.2017" "0DataFlow-BsFrame" 5)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 540) "stamp2.2017" "0DataFlow-BsFrame" 5)
)

; 2021-04-17
(defun InsertBsGCTDataHeader (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTTableDataHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
)

; 2021-04-17
; refactored at - 2021-04-20
(defun InsertBsGCTDesignParam (insPt dataType designParamDictList blockName /) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (car x)) designParamDictList)
    (mapcar '(lambda (x) (cdr x)) designParamDictList)
  )
)

; refactored at 2021-04-20
; refactored at 2021-05-25
(defun InsertBsGCTDesignStandard (insPt dataType blockName tankStandardList /) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTTankStandardText (MoveInsertPositionUtils insPt 20 -80) tankStandardList dataType)
)

; 2021-04-20
; refactored at 2021-05-18
(defun InsertBsGCTTankStandardText (insPt tankStandardList dataType / i) 
  (setq i 0)
  (repeat (length tankStandardList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankStandardList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; refactored at 2021-04-20
(defun InsertBsGCTRequirement (insPt dataType blockName tankHeadStyleList tankHeadMaterialList /) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTRequirementTextStrategy insPt dataType blockName tankHeadStyleList tankHeadMaterialList)
)

; 2021-05-25
(defun InsertBsGCTRequirementTextStrategy (insPt dataType blockName tankHeadStyleList tankHeadMaterialList /)
  (cond 
    ((= blockName "BsGCTTableRequirement") (InsertBsGCTTankRequirementText insPt dataType tankHeadStyleList tankHeadMaterialList))
    ((= blockName "BsGCTTableRequirement-Heater") (InsertBsGCTHeaterRequirementText insPt dataType tankHeadStyleList tankHeadMaterialList))
  )
)

; 2021-05-25
(defun InsertBsGCTTankRequirementText (insPt dataType tankHeadStyleList tankHeadMaterialList /)
  (InsertBsGCTEquipHeadStyleText (MoveInsertPositionUtils insPt 55 -100) tankHeadStyleList dataType)
  (InsertBsGCTEquipHeadMaterialText (MoveInsertPositionUtils insPt 55 -240) tankHeadMaterialList dataType)
)

; 2021-05-25
(defun InsertBsGCTHeaterRequirementText (insPt dataType tankHeadStyleList tankHeadMaterialList /)
  (InsertBsGCTEquipHeadStyleText (MoveInsertPositionUtils insPt 55 -80) tankHeadStyleList dataType)
  (InsertBsGCTEquipHeadMaterialText (MoveInsertPositionUtils insPt 55 -200) tankHeadMaterialList dataType)
)

; 2021-05-25
(defun InsertBsGCTInspectData (insPt dataType blockName oneEquipData /) 
  (cond 
    ((= blockName "BsGCTTableInspectData-TankA") (InsertBsGCTTankInspectData insPt dataType blockName oneEquipData))
    ((= blockName "BsGCTTableInspectData-Heater") (InsertBsGCTHeaterInspectData insPt dataType blockName oneEquipData))
  )
)

; 2021-05-25
(defun InsertBsGCTHeaterInspectData (insPt dataType blockName oneHeaterData / inspectDictData) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (setq inspectDictData (append 
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "SHELL_INSPECT_RATE" oneHeaterData) "SHELL_BARREL_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneHeaterData) "BARREL_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneHeaterData) "HEAD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneHeaterData) "CD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEATER_INSPECT_RATE" oneHeaterData) "HEATER_")
                        ))
  (ModifyBlockPropertiesByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-07
; refactored at 2021-05-11
(defun InsertBsGCTTankInspectData (insPt dataType blockName oneTankData / inspectDictData) 
  ; BsGCTTableInspectData-TankA or BsGCTTableInspectData-TankB, ready for the whole logic 2021-05-11
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (setq inspectDictData (append 
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneTankData) "BARREL_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneTankData) "HEAD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneTankData) "CD_")
                        ))
  (ModifyBlockPropertiesByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-07
(defun InsertBsGCTTestData (insPt dataType blockName oneEquipData / testDictData) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (setq testDictData (GetBsGCTTestDictData oneEquipData))
  (ModifyBlockPropertiesByDictDataUtils (entlast) testDictData)
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
(defun InsertBsGCTEquipHeadStyleText (insPt tankHeadStyleList dataType / i) 
  (setq i 0)
  (repeat (length tankHeadStyleList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankHeadStyleList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-20
(defun InsertBsGCTEquipHeadMaterialText (insPt tankHeadMaterialList dataType / i) 
  (setq i 0)
  (repeat (length tankHeadMaterialList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankHeadMaterialList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-17
(defun InsertBsGCTPressureElement (insPt dataType tankPressureElementList / i) 
  (InsertBlockUtils insPt "BsGCTTablePressureElement" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTPressureElementRow (MoveInsertPositionUtils insPt 0 -80) dataType tankPressureElementList)
)

; 2021-04-17
(defun InsertBsGCTPressureElementRow (insPt dataType tankPressureElementList / i) 
  (setq i 0)
  (repeat (length tankPressureElementList)
    (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (* -40 i)) "BsGCTTablePressureElementRow" "0DataFlow-BsGCT" (list (cons 0 dataType)))
    (ModifyMultiplePropertyForOneBlockUtils (entlast) 
      (mapcar '(lambda (x) (car x)) (nth i tankPressureElementList))
      (mapcar '(lambda (x) (cdr x)) (nth i tankPressureElementList))
    )
    (setq i (1+ i))
  ) 
  ; bind equipTag to Xdata - 2021-05-13
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length tankPressureElementList)))) 
    "0DataFlow-BsGCT" 3.6) 
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
)

; 2021-04-17
; refactored at 2021-05-18
(defun InsertBsGCTOtherRequest (insPt dataType tankOtherRequestList otherRequestHeght /) 
  (InsertBlockUtils insPt "BsGCTTableOtherRequest" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "TOTALHEIGHT" otherRequestHeght))
  ) 
  (InsertBsGCTTankOtherRequestText (MoveInsertPositionUtils insPt 40 -65) tankOtherRequestList dataType)
)

; 2021-04-17
(defun InsertBsGCTTankOtherRequestText (insPt tankOtherRequestList dataType / i) 
  (setq i 0)
  (repeat (length tankOtherRequestList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankOtherRequestList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-17
(defun InsertBsGCTNozzleTable (insPt dataType oneTankData / oneBsGCTTankNozzleDictData) 
  (setq oneBsGCTTankNozzleDictData (GetOneBsGCTTankNozzleDictData (GetDottedPairValueUtils "TAG" oneTankData)))
  (InsertBlockUtils insPt "BsGCTTableNozzleTableHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (if (/= oneBsGCTTankNozzleDictData nil) 
    (InsertBsGCTNozzleTableRow (MoveInsertPositionUtils insPt 0 -130) dataType oneBsGCTTankNozzleDictData)
  )
)

; 2021-04-17
(defun InsertBsGCTNozzleTableRow (insPt dataType oneBsGCTTankNozzleDictData / i) 
  (setq i 0)
  (repeat (length oneBsGCTTankNozzleDictData)
    (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (* -40 i)) "BsGCTTableNozzleTableRow" "0DataFlow-BsGCT" (list (cons 0 dataType)))
    (ModifyMultiplePropertyForOneBlockUtils (entlast) 
      (mapcar '(lambda (x) (car x)) (nth i oneBsGCTTankNozzleDictData))
      (mapcar '(lambda (x) (cdr x)) (nth i oneBsGCTTankNozzleDictData))
    ) 
    (setq i (1+ i))
  ) 
  ; bind equipTag to Xdata - 2021-05-13
  (GeneratePolyLineUtils 
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    (MoveInsertPositionUtils insPt 900 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" 3.6)
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" 3.6) 
  (BindDataFlowXDataToObjectUtils (entlast) dataType)
)

; 2021-04-18
(defun InsertBsGCTVerticalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight allBsGCTSupportDictData / 
                                      newBarrelHalfHeight nozzleOffset oneBsGCTTankSupportDictData legSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (setq oneBsGCTTankSupportDictData (GetOneBsGCTTankSupportDictData dataType allBsGCTSupportDictData))
  (setq legSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTTankSupportDictData)))
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  (GenerateVerticalDoubleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  ; refactored at 2021-05-27
  (GenerateBsGCTVerticalTankCenterLine insPt newBarrelHalfHeight barrelRadius thickNess)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTLegSupport (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- newBarrelHalfHeight straightEdgeHeight))) dataType legSupportHeight)
  (InsertBsGCTVerticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight)
  (InsertBsGCTVerticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight)
  (princ)
)

; 2021-05-18
(defun InsertBsGCTHorizontalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight allBsGCTSupportDictData / 
                                        newBarrelHalfHeight nozzleOffset oneBsGCTTankSupportDictData saddleSupportOffset saddleSupportHeight) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (setq oneBsGCTTankSupportDictData (GetOneBsGCTTankSupportDictData dataType allBsGCTSupportDictData))
  (setq saddleSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTTankSupportDictData)))
  (setq saddleSupportHeight (atoi (GetDottedPairValueUtils "SUPPORT_HEIGHT" oneBsGCTTankSupportDictData)))
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
    dataType saddleSupportHeight oneBsGCTTankSupportDictData barrelRadius)
  (InsertBsGCTLeftSaddleSupport (MoveInsertPositionUtils insPt (GetNegativeNumberUtils saddleSupportOffset) (GetNegativeNumberUtils (+ barrelRadius thickNess))) 
    dataType saddleSupportHeight oneBsGCTTankSupportDictData barrelRadius)
  (InsertBsGCTHorizonticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight saddleSupportHeight saddleSupportOffset)
  (InsertBsGCTHorizonticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight)
  (princ)
)

; 2021-05-30
(defun InsertBsGCTVerticalHeaterGraphy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess dataType straightEdgeHeight allBsGCTSupportDictData / 
                                      newBarrelHalfHeight nozzleOffset oneBsGCTTankSupportDictData totalFlangeHeight lugSupportOffset lugYPosition) 
  (GenerateBsGCTHeaterTube (MoveInsertPositionUtils insPt -100 0) dataType "0DataFlow-BsDottedLine" 25 (* barrelHalfHeight 2))
  ; different from tank, tube length subtract EXCEED_LENGTH - 2021-5-27 refactored at 2021-05-30
  (setq barrelHalfHeight (- barrelHalfHeight exceedLength))
  (setq nozzleOffset 100)
  (setq oneBsGCTTankSupportDictData (GetOneBsGCTTankSupportDictData dataType allBsGCTSupportDictData))
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
  (setq lugSupportOffset (atoi (GetDottedPairValueUtils "SUPPORT_POSITION" oneBsGCTTankSupportDictData)))
  (setq lugYPosition (- (+ barrelHalfHeight (GetFlangeHeightEnums (* 2 barrelRadius))) lugSupportOffset))
  (InsertBsGCTLugSupport insPt dataType oneBsGCTTankSupportDictData thickNess barrelRadius lugYPosition)
  
  
  ; (InsertBsGCTVerticalTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight)
  ; (InsertBsGCTVerticalTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight)
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
(defun InsertBsGCTVerticalTankAnnotation (insPt dataType barrelRadius headThickNess straightEdgeHeight /) 
  (InsertBsGCTTankDownLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (- 0 barrelHalfHeight straightEdgeHeight 50))
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess)
  (InsertBsGCTTankUpLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (+ barrelHalfHeight straightEdgeHeight 50))
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess) 
)

; 2021-05-19
(defun InsertBsGCTHorizonticalTankAnnotation (insPt dataType barrelRadius headThickNess straightEdgeHeight /) 
  (InsertBsGCTTankUpLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelHalfHeight straightEdgeHeight 50) barrelRadius)
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess)
  (InsertBsGCTTankDownLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight (/ barrelRadius 2) straightEdgeHeight) 0)
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess) 
)

; 2021-04-22
(defun InsertBsGCTTankDownLeftHeadAnnotation (insPt dataType fristText equipType barrelDiameter thickNess /) 
  (InsertBsGCTDownLeftAnnotation insPt dataType fristText (InlineExpandVariableUtils "%equipType% %barrelDiameter%x%thickNess%")) 
)

; 2021-04-22
(defun InsertBsGCTTankUpLeftHeadAnnotation (insPt dataType fristText equipType barrelDiameter thickNess /) 
  (InsertBsGCTUpLeftAnnotation insPt dataType fristText (InlineExpandVariableUtils "%equipType% %barrelDiameter%x%thickNess%")) 
)

; 2021-04-22
(defun InsertBsGCTDownLeftAnnotation (insPt dataType fristText secondText /) 
  (InsertBsGCTAnnotation insPt (MoveInsertPositionUtils insPt -130 -100) (MoveInsertPositionUtils insPt -50 -100) 
    dataType fristText secondText) 
)

; 2021-04-22
(defun InsertBsGCTDownRightAnnotation (insPt dataType fristText secondText /) 
  (InsertBsGCTAnnotation insPt (MoveInsertPositionUtils insPt 130 -100) (MoveInsertPositionUtils insPt 50 -100) 
    dataType fristText secondText) 
)

; 2021-04-22
(defun InsertBsGCTUpLeftAnnotation (insPt dataType fristText secondText /) 
  (InsertBsGCTAnnotation insPt (MoveInsertPositionUtils insPt -130 100) (MoveInsertPositionUtils insPt -50 100) 
    dataType fristText secondText) 
)

; 2021-04-22
(defun InsertBsGCTUpRightAnnotation (insPt dataType fristText secondText /) 
  (InsertBsGCTAnnotation insPt (MoveInsertPositionUtils insPt 130 100) (MoveInsertPositionUtils insPt 50 100) 
    dataType fristText secondText) 
)

; 2021-04-22
(defun InsertBsGCTAnnotation (insPt blockInsPt lineInsPt dataType fristText secondText /) 
  (InsertTwoLinesAnnotationUtils blockInsPt "BsGCTGraphAnnotation" "0DataFlow-BsGCT" 
    dataType fristText secondText)
  (GenerateLineUtils 
    lineInsPt
    insPt
    "0DataFlow-BsGCT"
  )  
)

; 2021-04-22
(defun InsertTwoLinesAnnotationUtils (insPt blockName layerName dataType fristText secondText /) 
  (InsertBlockUtils insPt blockName layerName 
    (list (cons 0 dataType) (cons 1 fristText) (cons 2 secondText)))
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
(defun InsertBsGCTLegSupport (insPt dataType legHeight / groundPlateInsPt) 
  (InsertBlockUtils insPt "BsGCTGraphLegSupport-A2" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LEG_HEIGHT" legHeight))
  ) 
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt 8 (- 150 legHeight)))
  (InsertBsGCTFaceLeftGroundPlate groundPlateInsPt dataType)
  (InsertBsGCTUpLeftGroundPlateAnnotation (MoveInsertPositionUtils groundPlateInsPt -50 15) dataType)
  (InsertBsGCTDimension 
    groundPlateInsPt 
    (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
    (MoveInsertPositionUtils groundPlateInsPt -100 0) 
    "") 
)

; 2021-05-30
(defun InsertBsGCTLugSupport (insPt dataType oneBsGCTTankSupportDictData thickNess barrelRadius lugYPosition / supportType) 
  (setq supportType (GetLugSupportTypeUtils oneBsGCTTankSupportDictData))
  (InsertBsGCTLeftLugSupport (MoveInsertPositionUtils insPt (- 0 thickNess thickNess barrelRadius) lugYPosition) supportType
    dataType oneBsGCTTankSupportDictData thickNess)
  (InsertBsGCRightLugSupport (MoveInsertPositionUtils insPt (+ thickNess thickNess barrelRadius) lugYPosition) supportType 
    dataType oneBsGCTTankSupportDictData thickNess)
  ; (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius)) (- 150 saddleHeight)))
  ; (InsertBsGCTFaceRightGroundPlate groundPlateInsPt dataType)
  ; ; groundPlate Dimension 
  ; (InsertBsGCTDimension 
  ;   groundPlateInsPt 
  ;   (MoveInsertPositionUtils groundPlateInsPt 0 -150) 
  ;   (MoveInsertPositionUtils groundPlateInsPt 100 0) 
  ;   "") 
  ; ; saddle support Dimension 
  ; (InsertBsGCTDimension 
  ;   insPt
  ;   (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils saddleHeight))
  ;   (MoveInsertPositionUtils groundPlateInsPt 140 0) 
  ;   "") 
)

; 2021-05-30
(defun InsertBsGCTLeftLugSupport (insPt supportType dataType oneBsGCTTankSupportDictData thickNess /) 
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; ready to refactor
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "THICKNESS" thickNess))
  ) 
)

; 2021-05-30
(defun InsertBsGCRightLugSupport (insPt supportType dataType oneBsGCTTankSupportDictData thickNess /) 
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
(defun InsertBsGCTRightSaddleSupport (insPt dataType saddleHeight oneBsGCTTankSupportDictData barrelRadius / supportType groundPlateInsPt) 
  (setq supportType (GetSaddleSupportTypeUtils oneBsGCTTankSupportDictData barrelRadius))
  (InsertBlockUtils insPt supportType "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "SADDLE_HEIGHT" saddleHeight))
  ) 
  ; mirror the right saddle support
  (MirrorBlockUtils (entlast))
  (setq groundPlateInsPt (MoveInsertPositionUtils insPt (GetNegativeNumberUtils (GetSaddleSupportDownOffsetEnums (* 2 barrelRadius))) (- 150 saddleHeight)))
  (InsertBsGCTFaceLeftGroundPlate groundPlateInsPt dataType)
  (InsertBsGCTDownRightGroundPlateAnnotation groundPlateInsPt dataType)
  (InsertBsGCTUpRightSaddleSupportAnnotation 
    (MoveInsertPositionUtils insPt 0 (GetSaddleSupportUpOffsetEnums (* 2 barrelRadius)))
    oneBsGCTTankSupportDictData
    barrelRadius
    dataType)
)

; 2021-05-19
(defun InsertBsGCTLeftSaddleSupport (insPt dataType saddleHeight oneBsGCTTankSupportDictData barrelRadius / supportType groundPlateInsPt) 
  (setq supportType (GetSaddleSupportTypeUtils oneBsGCTTankSupportDictData barrelRadius))
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
(defun GetLugSupportTypeUtils (oneBsGCTTankSupportDictData / supportType)
  (setq supportType 
    (strcat 
      "BsGCTGraphLugSupport-SideView-" 
      (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTTankSupportDictData))
  )
  (cond 
    ((member supportType (GetAllBsGCTLugSupportBlockNameList)) supportType)
    (T "BsGCTGraphSaddleSupport-SideView-A2")
  )
)

; 2021-05-19
(defun GetSaddleSupportTypeUtils (oneBsGCTTankSupportDictData barrelRadius / supportType)
  (setq supportType 
    (strcat 
      "BsGCTGraphSaddleSupport-SideView-" 
      (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTTankSupportDictData)
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
(defun InsertBsGCTUpLeftGroundPlateAnnotation (insPt dataType /) 
  (InsertBsGCTUpLeftAnnotation insPt dataType "接地板" "") 
)

; 2021-05-19
(defun InsertBsGCTDownLeftGroundPlateAnnotation (insPt dataType /) 
  (InsertBsGCTDownLeftAnnotation insPt dataType "接地板" "") 
)

; 2021-05-19
(defun InsertBsGCTDownRightGroundPlateAnnotation (insPt dataType /) 
  (InsertBsGCTDownRightAnnotation insPt dataType "接地板" "") 
)

; 2021-05-19
(defun InsertBsGCTUpRightSaddleSupportAnnotation (insPt oneBsGCTTankSupportDictData barrelRadius dataType / firstText secondText) 
  (setq firstText 
         (strcat 
           (GetDottedPairValueUtils "SUPPORT_FORM" oneBsGCTTankSupportDictData) " " 
           (GetDottedPairValueUtils "SUPPORT_STYLE" oneBsGCTTankSupportDictData) " " (rtos (* 2 barrelRadius))))
  (setq secondText (GetDottedPairValueUtils "SUPPORT_STANDARD" oneBsGCTTankSupportDictData))
  (InsertBsGCTUpRightAnnotation insPt dataType firstText secondText) 
)

; 2021-04-19
(defun InsertBsGCTDimension (firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertAlignedDimensionUtils firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent)
)

; 2021-04-19
(defun ReadBsDataFromCSVStrategy (dataType / fileDir)
  (if (= dataType "BsGCT") 
    (setq fileDir "D:\\dataflowcad\\bsdata\\bsGCT.csv")
  )
  (ReadDataFromCSVUtils fileDir)
)

; 2021-04-19
(defun GetBsGCTImportedList ()
  (StrListToListListUtils (ReadBsDataFromCSVStrategy "BsGCT"))
)

; 2021-04-19
(defun GetTankBsGCTDesignData () 
  (mapcar '(lambda (x) 
             (cons (cadr x) (list x))
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank") 
                      ) 
      (GetBsGCTImportedList)
    ) 
  )  
)

; 2021-04-19
(defun GetBsGCTTankData (bsGCTImportedList /) 
  (vl-remove-if-not '(lambda (x) 
                      (= (car x) "Tank") 
                    ) 
    bsGCTImportedList
  ) 
)

; 2021-05-25
(defun GetBsGCTHeaterData (bsGCTImportedList /) 
  (vl-remove-if-not '(lambda (x) 
                      (= (car x) "Heater") 
                    ) 
    bsGCTImportedList
  ) 
)

; 2021-04-19
(defun GetBsGCTTankDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTTankMainKeysData bsGCTImportedList)
                y
              )
           ) 
    (GetBsGCTTankData bsGCTImportedList)
  )
)

; 2021-05-25
(defun GetBsGCTHeaterDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTHeaterMainKeysData bsGCTImportedList)
                y
              )
           ) 
    (GetBsGCTHeaterData bsGCTImportedList)
  )
)

; 2021-04-20
(defun GetBsGCTTankNozzleDictData () 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTNozzleKeysData)
                y
              )
           ) 
    (GetBsGCTNozzleData)
  )
)

; 2021-04-19
(defun GetBsGCTNozzleData () 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Nozzle") 
                      ) 
      (GetBsGCTImportedList)
    )  
  ) 
)

; 2021-04-20
(defun GetOneBsGCTTankNozzleDictData (tankTag /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "TAG" x) tankTag) 
                      ) 
      (GetBsGCTTankNozzleDictData)
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

; 2021-04-23
(defun GetBsGCTNozzleKeysData () 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "NozzleKeys") 
                        ) 
        (GetBsGCTImportedList)
      )  
    ) 
  ) 
)

; 2021-04-20
(defun GetOneBsGCTTankSupportDictData (tankTag allBsGCTSupportDictData /) 
  (car 
    (vl-remove-if-not '(lambda (x) 
                        (= (GetDottedPairValueUtils "TAG" x) tankTag) 
                      ) 
      allBsGCTSupportDictData
    )  
  ) 
)

; 2021-04-20
(defun GetAllBsGCTSupportDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTSupportKeysData bsGCTImportedList)
                y
              )
           ) 
    (GetAllBsGCTSupportData bsGCTImportedList)
  )
)

; 2021-05-18
(defun GetBsGCTSupportKeysData (bsGCTImportedList /) 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "SupportKeys") 
                        ) 
        bsGCTImportedList
      )  
    ) 
  ) 
)

; 2021-04-19
(defun GetAllBsGCTSupportData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cdr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Support") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-17
; refacotred at 2021-05-07
(defun InsertOneBsGCTTank (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList allBsGCTSupportDictData / 
                           equipTag bsGCTType barrelRadius barrelHalfHeight thickNess headThickNess straightEdgeHeight equipType) 
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  ; (setq bsGCTType (strcat (GetDottedPairValueUtils "BSGCT_TYPE" oneTankData) "-" equipTag))
  ; refacotred at 2021-05-07 use equipTag as the label for data
  (setq bsGCTType equipTag)
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelRadius" oneTankData))))
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelHeight" oneTankData))))
  (setq thickNess (atoi (GetDottedPairValueUtils "BARREL_THICKNESS" oneTankData)))
  ; do not convert to int frist 2021-04-23
  (setq headThickNess (GetDottedPairValueUtils "HEAD_THICKNESS" oneTankData))
  (setq straightEdgeHeight 25)
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  (InsertBsGCTDrawFrame insPt equipTag)
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
                           tankHeadMaterialList tankPressureElementList tankOtherRequestList equipType)
  ; thickNess param refactored at 2021-04-21
  (InsertBsGCTTankGraphyStrategy (MoveInsertPositionUtils insPt -2915 1600) 
    barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData)
)

; 2021-05-27
(defun InsertOneBsGCTHeater (insPt oneHeaterData heaterPressureElementList heaterOtherRequestList heaterStandardList heaterHeadStyleList 
                             heaterHeadMaterialList allBsGCTSupportDictData / equipTag bsGCTType barrelRadius barrelHalfHeight exceedLength thickNess 
                             headThickNess straightEdgeHeight equipType) 
  (setq equipTag (GetDottedPairValueUtils "TAG" oneHeaterData))
  ; use equipTag as the label for data
  (setq bsGCTType equipTag)
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelRadius" oneHeaterData))))
  ; refactored at - 2021-05-30 tube length for drawing tube
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "barrelHeight" oneHeaterData))))
  (setq exceedLength (atoi (GetDottedPairValueUtils "EXCEED_LENGTH" oneHeaterData)))
  (setq thickNess (atoi (GetDottedPairValueUtils "BARREL_THICKNESS" oneHeaterData)))
  ; do not convert to int frist 2021-04-23
  (setq headThickNess (GetDottedPairValueUtils "HEAD_THICKNESS" oneHeaterData))
  (setq straightEdgeHeight 25)
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneHeaterData)))
  (InsertBsGCTDrawFrame insPt equipTag)
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneHeaterData heaterStandardList heaterHeadStyleList 
                           heaterHeadMaterialList heaterPressureElementList heaterOtherRequestList equipType)
  (InsertBsGCTHeaterGraphyStrategy (MoveInsertPositionUtils insPt -2915 1600) 
    barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData)
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
                          equipTag bsGCTType equipType) 
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  (setq bsGCTType equipTag)
  ; (setq insPt (GetGCTFramePositionByEquipTag equipTag))
  (setq equipType (GetBsGCTEquipTypeStrategy (GetDottedPairValueUtils "equipType" oneTankData)))
  (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
                           tankHeadMaterialList tankPressureElementList tankOtherRequestList equipType)
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
                                tankPressureElementList tankOtherRequestList / designParamDictList leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts
  (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt -900 2870))
  (setq rightInsPt (MoveInsertPositionUtils insPt -450 2870))
  (InsertBsGCTDataHeader leftInsPt bsGCTType)
  ; the height of BsGCTDataHeader is 50
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -50))
  (InsertBsGCTDesignParam leftInsPt bsGCTType designParamDictList "BsGCTTableDesignParam")
  ; the height of BsGCTTankDesignParam is 840
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -840))
  (InsertBsGCTPressureElement leftInsPt bsGCTType tankPressureElementList)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (- 0 (* 40 (+ (length tankPressureElementList) 2)))))
  (InsertBsGCTOtherRequest leftInsPt bsGCTType tankOtherRequestList 270)
  ; the height of BsGCTOtherRequest is 270
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -270))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -50))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard" tankStandardList)
  ; the height of BsGCTVerticalTankDesignStandard is 200
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -200))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement" tankHeadStyleList tankHeadMaterialList)
  ; the height of BsGCTRequirement is 320
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -320))
  (InsertBsGCTInspectData rightInsPt bsGCTType "BsGCTTableInspectData-TankA" oneTankData)
  ; the height of BsGCTTankInspectData is 160
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -160))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData" oneTankData)
)

; 2021-05-16
; refactored at 2021-05-18
(defun InsertGCTOneBsHorizontalTankTable (insPt bsGCTType oneTankData tankStandardList tankHeadStyleList tankHeadMaterialList 
                                tankPressureElementList tankOtherRequestList / designParamDictList leftInsPt rightInsPt) 
  ; split oneTankData to Two Parts
  (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt -900 2870))
  (setq rightInsPt (MoveInsertPositionUtils insPt -450 2870))
  (InsertBsGCTDataHeader leftInsPt bsGCTType)
  ; the height of BsGCTDataHeader is 50
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -50))
  (InsertBsGCTDesignParam leftInsPt bsGCTType designParamDictList "BsGCTTableHorizontalTankDesignParam")
  ; the height of BsGCTTankDesignParam is 920
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -920))
  (InsertBsGCTPressureElement leftInsPt bsGCTType tankPressureElementList)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (- 0 (* 40 (+ (length tankPressureElementList) 2)))))
  (InsertBsGCTOtherRequest leftInsPt bsGCTType tankOtherRequestList 400)
  ; the height of BsGCTOtherRequest is 400
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -400))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneTankData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -50))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableHorizontalTankDesignStandard" tankStandardList)
  ; the height of BsGCTHorizontalTankDesignStandard is 280
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -280))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement" tankHeadStyleList tankHeadMaterialList)
  ; the height of BsGCTRequirement is 320
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -320))
  (InsertBsGCTInspectData rightInsPt bsGCTType "BsGCTTableInspectData-TankA" oneTankData)
  ; the height of BsGCTTankInspectData is 160
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -160))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData" oneTankData)
)

; 2021-05-25
(defun InsertGCTOneBsHeaterTable (insPt bsGCTType oneHeaterData heaterStandardList heaterHeadStyleList heaterHeadMaterialList 
                                heaterPressureElementList heaterOtherRequestList / designParamDictList leftInsPt rightInsPt) 
  ; split oneHeaterData to Two Parts
  (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneHeaterData)))
  (setq leftInsPt (MoveInsertPositionUtils insPt -900 2870))
  (setq rightInsPt (MoveInsertPositionUtils insPt -450 2870))
  (InsertBsGCTDataHeader leftInsPt bsGCTType)
  ; the height of BsGCTDataHeader is 50
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -50))
  (InsertBsGCTDesignParam leftInsPt bsGCTType designParamDictList "BsGCTTableDesignParam-Heater")
  ; the height of BsGCTTankDesignParam is 960
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -960))
  (InsertBsGCTPressureElement leftInsPt bsGCTType heaterPressureElementList)
  ; the height of BsGCTPressureElement is [length of tankPressureElementList, add 2]
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 (- 0 (* 40 (+ (length heaterPressureElementList) 2)))))
  (InsertBsGCTOtherRequest leftInsPt bsGCTType heaterOtherRequestList 350)
  ; the height of BsGCTOtherRequest is 350
  (setq leftInsPt (MoveInsertPositionUtils leftInsPt 0 -350))
  (InsertBsGCTNozzleTable leftInsPt bsGCTType oneHeaterData)
  ; insert tabe in right position
  ; the height of BsGCTDataHeader is 50
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -50))
  (InsertBsGCTDesignStandard rightInsPt bsGCTType "BsGCTTableDesignStandard-Heater" heaterStandardList)
  ; the height of BsGCTHorizontalTankDesignStandard is 240
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -240))
  (InsertBsGCTRequirement rightInsPt bsGCTType "BsGCTTableRequirement-Heater" heaterHeadStyleList heaterHeadMaterialList)
  ; the height of BsGCTRequirement is 280
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -280))
  (InsertBsGCTInspectData rightInsPt bsGCTType "BsGCTTableInspectData-Heater" oneHeaterData)
  ; the height of BsGCTTankInspectData is 240
  (setq rightInsPt (MoveInsertPositionUtils rightInsPt 0 -240))
  (InsertBsGCTTestData rightInsPt bsGCTType "BsGCTTableTestData-Heater" oneHeaterData)
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
                                equipPressureElementList equipOtherRequestList equipType /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertGCTOneBsVerticalTankTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "verticalTank") 
       (FilterListListByFirstItemUtils equipHeadStyleList "verticalTank") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "verticalTank")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "verticalTank")))
    ((= equipType "horizontalTank") 
     (InsertGCTOneBsHorizontalTankTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "horizontalTank") 
       (FilterListListByFirstItemUtils equipHeadStyleList "horizontalTank") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "horizontalTank")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "horizontalTank")))
    ((or (= equipType "verticalHeater") (= equipType "horizontalHeater")) 
     (InsertGCTOneBsHeaterTable insPt bsGCTType oneEquipData 
       (FilterListListByFirstItemUtils equipStandardList "Heater") 
       (FilterListListByFirstItemUtils equipHeadStyleList "Heater") 
       (FilterListListByFirstItemUtils equipHeadMaterialList "Heater")                    
       equipPressureElementList 
       (FilterListListByFirstItemUtils equipOtherRequestList "Heater")))
  )
)

; 2021-05-25
(defun InsertBsGCTHeaterGraphyStrategy (insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData /)
  (cond 
    ((= equipType "verticalHeater") 
     (InsertBsGCTVerticalHeaterGraphy insPt barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData))
    ((= equipType "horizontalHeater") 
     (InsertBsGCTVerticalHeaterGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight exceedLength thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData))
  )
)

; 2021-05-11
(defun InsertBsGCTTankGraphyStrategy (insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType allBsGCTSupportDictData /)
  (cond 
    ((= equipType "verticalTank") 
     (InsertBsGCTVerticalTankGraphy insPt barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData))
    ((= equipType "horizontalTank") 
     ; refactored at 2021-05-18 move the insPt for HorizontalTankGraphy
     (InsertBsGCTHorizontalTankGraphy (MoveInsertPositionUtils insPt 450 -150) barrelRadius barrelHalfHeight thickNess headThickNess 
       bsGCTType straightEdgeHeight allBsGCTSupportDictData))
  )
)

; 2021-04-17
; refactored at 2021-05-25
(defun InsertAllBsGCTTank (insPt bsGCTImportedList allBsGCTSupportDictData / allBsGCTTankDictData tankPressureElementList 
                           tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList insPtList) 
  (setq allBsGCTTankDictData (GetBsGCTTankDictData bsGCTImportedList))
  (setq tankPressureElementList (GetBsGCTTankPressureElementDictData bsGCTImportedList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestData bsGCTImportedList)) 
  (setq tankStandardList (GetBsGCTTankStandardData bsGCTImportedList)) 
  (setq tankHeadStyleList (GetBsGCTTankHeadStyleData bsGCTImportedList)) 
  (setq tankHeadMaterialList (GetBsGCTTankHeadMaterialData bsGCTImportedList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 5200))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTTank x y tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList allBsGCTSupportDictData) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
)

; 2021-05-25
(defun InsertAllBsGCTHeater (insPt bsGCTImportedList allBsGCTSupportDictData / allBsGCTHeaterDictData heaterPressureElementList 
                           heaterOtherRequestList heaterStandardList heaterHeadStyleList heaterHeadMaterialList insPtList) 
  (setq allBsGCTHeaterDictData (GetBsGCTHeaterDictData bsGCTImportedList))
  (setq heaterPressureElementList (GetBsGCTHeaterPressureElementDictData bsGCTImportedList))
  (setq heaterOtherRequestList (GetBsGCTHeaterOtherRequestData bsGCTImportedList)) 
  (setq heaterStandardList (GetBsGCTHeaterStandardData bsGCTImportedList)) 
  (setq heaterHeadStyleList (GetBsGCTHeaterHeadStyleData bsGCTImportedList)) 
  (setq heaterHeadMaterialList (GetBsGCTHeaterHeadMaterialData bsGCTImportedList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTHeaterDictData 0) 5200))
  (mapcar '(lambda (x y) 
            (InsertOneBsGCTHeater x y heaterPressureElementList heaterOtherRequestList heaterStandardList heaterHeadStyleList heaterHeadMaterialList allBsGCTSupportDictData) 
          ) 
    insPtList
    allBsGCTHeaterDictData 
  ) 
  (princ)
)

; 2021-05-25
(defun InsertAllBsGCTMacro (/ insPt bsGCTImportedList allBsGCTTankDictData tankPressureElementList 
                           tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList allBsGCTSupportDictData insPtList) 
  (VerifyBsGCTBlockLayerText)
  (setq insPt (getpoint "\n拾取工程图插入点："))
  (setq bsGCTImportedList (GetBsGCTImportedList))
  (setq allBsGCTSupportDictData (GetAllBsGCTSupportDictData bsGCTImportedList))
  (InsertAllBsGCTTank insPt bsGCTImportedList allBsGCTSupportDictData)
  (InsertAllBsGCTHeater (MoveInsertPositionUtils insPt 0 -4000) bsGCTImportedList allBsGCTSupportDictData)
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
  (setq allBsGCTTankDictData (GetBsGCTTankDictData bsGCTImportedList))
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
