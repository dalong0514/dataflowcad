;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoBS ()
  (alert "设备设计流最新版本号 V0.2，更新时间：2021-05-10\n数据流内网地址：192.168.1.38")(princ)
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
(defun InsertBsGCTTankDesignParam (insPt dataType designParamDictList blockName /) 
  (InsertBlockUtils insPt blockName "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (car x)) designParamDictList)
    (mapcar '(lambda (x) (cdr x)) designParamDictList)
  )
)

; refactored at 2021-04-20
(defun InsertBsGCTDesignStandard (insPt dataType tankStandardList /) 
  (InsertBlockUtils insPt "BsGCTTableDesignStandard" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTTankStandardText (MoveInsertPositionUtils insPt 20 -90) tankStandardList dataType)
)

; 2021-04-20
(defun InsertBsGCTTankStandardText (insPt tankStandardList dataType / i) 
  (setq i 0)
  (repeat (length tankStandardList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -35 i)) (nth i tankStandardList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; refactored at 2021-04-20
(defun InsertBsGCTRequirement (insPt dataType tankHeadStyleList tankHeadMaterialList /) 
  (InsertBlockUtils insPt "BsGCTTableRequirement" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTTankHeadStyleText (MoveInsertPositionUtils insPt 55 -100) tankHeadStyleList dataType)
  (InsertBsGCTTankHeadMaterialText (MoveInsertPositionUtils insPt 55 -240) tankHeadMaterialList dataType)
)

; 2021-05-07
; refactored at 2021-05-11
(defun InsertBsGCTTankInspectData (insPt dataType oneTankData / inspectDictData) 
  ; BsGCTTableInspectData-TankA or BsGCTTableInspectData-TankB, ready for the whole logic 2021-05-11
  (InsertBlockUtils insPt "BsGCTTableInspectData-TankA" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (setq inspectDictData (append 
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "BARREL_INSPECT_RATE" oneTankData) "BARREL_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "HEAD_INSPECT_RATE" oneTankData) "HEAD_")
                          (GetBsGCTInspectDictData (GetDottedPairValueUtils "CD_INSPECT_RATE" oneTankData) "CD_")
                        ))
  (ModifyBlockPropertiesByDictDataUtils (entlast) inspectDictData)
)

; 2021-05-07
(defun InsertBsGCTTestData (insPt dataType oneTankData / testDictData) 
  (InsertBlockUtils insPt "BsGCTTableTestData" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (setq testDictData (GetBsGCTTestDictData oneTankData))
  (ModifyBlockPropertiesByDictDataUtils (entlast) testDictData)
)

; 2021-05-07
(defun GetBsGCTTestDictData (oneTankData /)
  (vl-remove-if-not '(lambda (x) 
                       (member (car x) '("TEST_PRESSURE" "AIR_TEST_PRESSURE" "HEAT_TREAT")) 
                    ) 
    oneTankData
  )
)

; 2021-04-20
(defun InsertBsGCTTankHeadStyleText (insPt tankHeadStyleList dataType / i) 
  (setq i 0)
  (repeat (length tankHeadStyleList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankHeadStyleList) "0DataFlow-BsText" 20 0.7) 
    ; bind equipTag to Xdata - 2021-05-13
    (BindDataFlowXDataToObjectUtils (entlast) dataType)
    (setq i (1+ i))
  ) 
)

; 2021-04-20
(defun InsertBsGCTTankHeadMaterialText (insPt tankHeadMaterialList dataType / i) 
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
(defun InsertBsGCTOtherRequest (insPt dataType tankOtherRequestList / i) 
  (InsertBlockUtils insPt "BsGCTTableOtherRequest" "0DataFlow-BsGCT" (list (cons 0 dataType)))
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
(defun InsertBsGCTVerticalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight / newBarrelHalfHeight nozzleOffset) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  (GenerateDoubleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess straightEdgeHeight)
  (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTSupportLeg (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- newBarrelHalfHeight straightEdgeHeight))) dataType 800)
  (InsertBsGCTTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight)
  (InsertBsGCTTankAnnotation insPt dataType barrelRadius headThickNess straightEdgeHeight)
  (princ)
)

; 2021-05-11
(defun InsertBsGCTHorizontalTankGraphy (insPt barrelRadius barrelHalfHeight thickNess headThickNess dataType straightEdgeHeight / newBarrelHalfHeight nozzleOffset) 
  ; refactored at 2021-05-06 straightEdgeHeight is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight straightEdgeHeight)) 
  (setq nozzleOffset 100)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) 
    barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess straightEdgeHeight)
  (princ)
)

; 2021-04-22
(defun InsertBsGCTTankAnnotation (insPt dataType barrelRadius headThickNess straightEdgeHeight /) 
  (InsertBsGCTTankDownLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (- 0 barrelHalfHeight straightEdgeHeight 50))
    dataType 
    "椭圆封头" "EHA" (* 2 barrelRadius) headThickNess)
  (InsertBsGCTTankUpLeftHeadAnnotation 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (+ barrelHalfHeight straightEdgeHeight 50))
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
(defun InsertBsGCTUpRightAnnotation (insPt dataType fristText equipType barrelDiameter thickNess /) 
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
(defun InsertBsGCTTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess straightEdgeHeight /) 
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
(defun InsertBsGCTSupportLeg (insPt dataType legHeight /) 
  (InsertBlockUtils insPt "BsGCTGraphSupportLeg-A2" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LEG_HEIGHT" legHeight))
  ) 
  (InsertBsGCTGroundPlate (MoveInsertPositionUtils insPt 8 (- 150 legHeight)) dataType)
)

; 2021-04-22
(defun InsertBsGCTGroundPlate (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTGraphGroundPlate" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBsGCTGroundPlateAnnotation (MoveInsertPositionUtils insPt -50 15) dataType)
)

; 2021-04-22
(defun InsertBsGCTGroundPlateAnnotation (insPt dataType /) 
  (InsertBsGCTUpLeftAnnotation insPt dataType "接地板" "") 
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

; 2021-04-19
(defun GetBsGCTTankDictData (bsGCTImportedList /) 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetBsGCTTankMainKeysData)
                y
              )
           ) 
    (GetBsGCTTankData bsGCTImportedList)
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

; 2021-04-20
(defun GetBsGCTTankStandardData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cadr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-Standard") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
(defun GetBsGCTTankHeadStyleData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cadr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-HeadStyle") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
(defun GetBsGCTTankHeadMaterialData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cadr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-HeadMaterial") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-20
(defun GetBsGCTTankOtherRequestData (bsGCTImportedList /) 
  (mapcar '(lambda (x) (cadr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) "Tank-OtherRequest") 
                      ) 
      bsGCTImportedList
    )  
  ) 
)

; 2021-04-23
(defun GetBsGCTTankMainKeysData () 
  (cdr 
    (car 
      (vl-remove-if-not '(lambda (x) 
                          (= (car x) "Tank-MainKeys") 
                        ) 
        (GetBsGCTImportedList)
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

; 2021-04-17
; (defun InsertBsGCTStrategy (dataType designData /) 
;   (cond 
;     ((= dataType "Tank") (InsertOneBsTankGCT designData))
;   )
; )

; 2021-04-17
; refacotred at 2021-05-07
(defun InsertOneBsTankGCT (insPt oneTankData tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList / 
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
  (setq equipType (GetDottedPairValueUtils "equipType" oneTankData))
  (InsertBsGCTDrawFrame insPt equipTag)
  (InsertGCTOneBsTankTable insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
                           tankHeadMaterialList tankPressureElementList tankOtherRequestList)
  ; thickNess param refactored at 2021-04-21
  (InsertBsGCTTankGraphyStrategy (MoveInsertPositionUtils insPt -2915 1600) barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType)
  (princ)
)

; 2021-05-13
; refacotred at 2021-05-07
(defun InsertGCTOneBsTankTable (insPt bsGCTType oneTankData tankStandardList tankHeadStyleList tankHeadMaterialList 
                                tankPressureElementList tankOtherRequestList / designParamDictList) 
  ; split oneTankData to Two Parts
  (setq designParamDictList (cadr (SplitLDictListByDictKeyUtils "SERVIVE_LIFE" oneTankData)))
  (InsertBsGCTDataHeader (MoveInsertPositionUtils insPt -900 2870) bsGCTType)
  (InsertBsGCTTankDesignParam (MoveInsertPositionUtils insPt -900 2820) bsGCTType designParamDictList "BsGCTTableDesignParam")
  (InsertBsGCTDesignStandard (MoveInsertPositionUtils insPt -450 2820) bsGCTType tankStandardList)
  (InsertBsGCTRequirement (MoveInsertPositionUtils insPt -450 2620) bsGCTType tankHeadStyleList tankHeadMaterialList)
  (InsertBsGCTTankInspectData (MoveInsertPositionUtils insPt -450 2300) bsGCTType oneTankData)
  (InsertBsGCTTestData (MoveInsertPositionUtils insPt -450 2140) bsGCTType oneTankData)
  (InsertBsGCTPressureElement (MoveInsertPositionUtils insPt -900 1980) bsGCTType tankPressureElementList)
  (InsertBsGCTOtherRequest (MoveInsertPositionUtils insPt -900 (- 1900 (* 40 (length tankPressureElementList)))) bsGCTType tankOtherRequestList)
  (InsertBsGCTNozzleTable (MoveInsertPositionUtils insPt -1800 2870) bsGCTType oneTankData)
)

; 2021-05-11
(defun InsertBsGCTTankGraphyStrategy (insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight equipType /)
  (cond 
    ((RegexpTestUtils equipType "立式双椭.*" nil) 
     (InsertBsGCTVerticalTankGraphy insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight))
    ((RegexpTestUtils equipType "卧式双椭.*" nil) 
     (InsertBsGCTHorizontalTankGraphy insPt barrelRadius barrelHalfHeight thickNess headThickNess bsGCTType straightEdgeHeight))
  )
)

; 2021-04-17
(defun InsertAllBsGCTTank (/ insPt bsGCTImportedList allBsGCTTankDictData tankPressureElementList 
                           tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList insPtList) 
  (VerifyBsGCTBlockLayerText)
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (setq bsGCTImportedList (GetBsGCTImportedList))
  (setq allBsGCTTankDictData (GetBsGCTTankDictData bsGCTImportedList))
  (setq tankPressureElementList (GetBsGCTTankPressureElementDictData bsGCTImportedList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestData bsGCTImportedList)) 
  (setq tankStandardList (GetBsGCTTankStandardData bsGCTImportedList)) 
  (setq tankHeadStyleList (GetBsGCTTankHeadStyleData bsGCTImportedList)) 
  (setq tankHeadMaterialList (GetBsGCTTankHeadMaterialData bsGCTImportedList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 5200))
  (mapcar '(lambda (x y) 
            (InsertOneBsTankGCT x y tankPressureElementList tankOtherRequestList tankStandardList tankHeadStyleList tankHeadMaterialList) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
  (princ)
)

; 2021-04-21
(defun c:InsertAllBsGCT ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertAllBsGCTTank '())
)


;;;-------------------------------------------------------------------------;;;
; Update BsGCT Table data

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

(defun c:foo ()
  (DeleteBsGCTTableByEquipTagListUtils '("V1101" "V1102"))
  (DeleteBsGCTPolyLineAndTextByEquipTagListUtils '("V1101" "V1102"))
  ; (BindDataFlowXDataToObjectUtils (car (GetEntityNameListBySSUtils (ssget))) "V1101")
  ; (GetStringXDataByEntityNameUtils (car (GetEntityNameListBySSUtils (ssget))))
  ; (DeleteEntityBySSUtils (GetAllTextAndPloyLineSSUtils))
)

; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
