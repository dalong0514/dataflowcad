;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoNS ()
  (alert "设备设计流最新版本号 V0.1，更新时间：2021-03-22\n数据流内网地址：192.168.1.38")(princ)
)

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
  (InsertBlockUtils insPt "BsGCTDataHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
)

; 2021-04-17
; refactored at - 2021-04-20
(defun InsertBsGCTDesignParam (insPt dataType designParamDictList /) 
  (InsertBlockUtils insPt "BsGCTDesignParam" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (car x)) designParamDictList)
    (mapcar '(lambda (x) (cdr x)) designParamDictList)
  )
)

; 2021-04-17
(defun InsertBsGCTDesignStandard (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTDesignStandard" "0DataFlow-BsGCT" (list (cons 0 dataType)))
)

; 2021-04-17
(defun InsertBsGCTRequirement (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTRequirement" "0DataFlow-BsGCT" (list (cons 0 dataType)))
)

; 2021-04-17
(defun InsertBsGCTPressureElement (insPt dataType tankPressureElementList / i) 
  (InsertBlockUtils insPt "BsGCTPressureElement" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTPressureElementRow (MoveInsertPositionUtils insPt 0 -80) dataType tankPressureElementList)
)

; 2021-04-17
(defun InsertBsGCTPressureElementRow (insPt dataType tankPressureElementList / i) 
  (setq i 0)
  (repeat (length tankPressureElementList)
    (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (* -40 i)) "BsGCTPressureElementRow" "0DataFlow-BsGCT" (list (cons 0 dataType)))
    (InsertBsGCTPressureElementRowText (MoveInsertPositionUtils insPt 0 (* -40 i)) (nth i tankPressureElementList))
    (setq i (1+ i))
  ) 
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length tankPressureElementList)))) 
    "0DataFlow-BsGCT" 3.6)  
)

; 2021-03-17
(defun InsertBsGCTPressureElementRowText (insPt textList /) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 62.5 -32) (nth 0 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 175 -32) (nth 1 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 337.5 -32) (nth 2 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 575 -32) (nth 3 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 800 -32) (nth 4 textList) "0DataFlow-BsText" 20 0.7) 
)

; 2021-04-17
(defun InsertBsGCTOtherRequest (insPt dataType tankOtherRequestList / i) 
  (InsertBlockUtils insPt "BsGCTOtherRequest" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTTankOtherRequestText (MoveInsertPositionUtils insPt 40 -65) dataType tankOtherRequestList)
)

; 2021-04-17
(defun InsertBsGCTTankOtherRequestText (insPt dataType tankOtherRequestList / i) 
  (setq i 0)
  (repeat (length tankOtherRequestList)
    (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 0 (* -30 i)) (nth i tankOtherRequestList) "0DataFlow-BsText" 20 0.7) 
    (setq i (1+ i))
  ) 
)

; 2021-04-17
(defun InsertBsGCTNozzleTable (insPt dataType oneTankData / oneBsGCTTankNozzleDictData) 
  (setq oneBsGCTTankNozzleDictData (GetOneBsGCTTankNozzleDictData (GetDottedPairValueUtils "TAG" oneTankData)))
  (InsertBlockUtils insPt "BsGCTNozzleTableHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (if (/= oneBsGCTTankNozzleDictData nil) 
    (InsertBsGCTNozzleTableRow (MoveInsertPositionUtils insPt 0 -130) dataType oneBsGCTTankNozzleDictData)
  )
)

; 2021-04-17
(defun InsertBsGCTNozzleTableRow (insPt dataType oneBsGCTTankNozzleDictData / i) 
  (setq i 0)
  (repeat (length oneBsGCTTankNozzleDictData)
    (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (* -40 i)) "BsGCTNozzleTableRow" "0DataFlow-BsGCT" (list (cons 0 dataType)))
    (ModifyMultiplePropertyForOneBlockUtils (entlast) 
      (mapcar '(lambda (x) (car x)) (nth i oneBsGCTTankNozzleDictData))
      (mapcar '(lambda (x) (cdr x)) (nth i oneBsGCTTankNozzleDictData))
    ) 
    (setq i (1+ i))
  ) 
  (GeneratePolyLineUtils 
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    (MoveInsertPositionUtils insPt 900 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" 3.6)
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length oneBsGCTTankNozzleDictData)))) 
    "0DataFlow-BsGCT" 3.6) 
)

; 2021-04-18
(defun InsertBsGCTTankGraphy (insPt barrelRadius barrelHalfHeight thickNess dataType / newBarrelHalfHeight nozzleOffset) 
  ; the head height is 25
  (setq newBarrelHalfHeight (+ barrelHalfHeight 25)) 
  (setq nozzleOffset 100)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 newBarrelHalfHeight) barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess)
  (GenerateUpEllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (+ newBarrelHalfHeight (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess) dataType nozzleOffset thickNess)
  (GenerateDoubleLineBarrelUtils insPt barrelRadius newBarrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight)) barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess)
  (GenerateDownllipseHeadNozzle (MoveInsertPositionUtils insPt 0 (- 0 newBarrelHalfHeight (/ barrelRadius 2) thickNess)) dataType)
  (InsertBsGCTSupportLeg (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- newBarrelHalfHeight 25))) dataType)
  (InsertBsGCTTankBarrelDimension insPt barrelRadius barrelHalfHeight thickNess)
  (princ)
)

; 2021-04-19
(defun InsertBsGCTTankBarrelDimension (insPt barrelRadius barrelHalfHeight thickNess /) 
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
    (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight (/ barrelRadius 2) 25 thickNess))  
    (MoveInsertPositionUtils insPt (+ barrelRadius 200) 0) 
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
  (InsertBlockUtils insPt "BsGCTNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (setq leftNozzleinsPt (MoveInsertPositionUtils insPt (- 0 (- barrelRadius nozzleOffset thickNess)) yOffset))
  (setq rightNozzleinsPt (MoveInsertPositionUtils insPt (- barrelRadius nozzleOffset thickNess) yOffset))
  (InsertBlockUtils leftNozzleinsPt "BsGCTNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBlockUtils rightNozzleinsPt "BsGCTNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  (InsertBsGCTTankNozzleDimension insPt leftNozzleinsPt rightNozzleinsPt)
)

; 2021-04-19
(defun GenerateDownllipseHeadNozzle (insPt dataType /) 
  (InsertBlockByRotateUtils insPt "BsGCTNozzle" "0DataFlow-BsThickLine" (list (cons 0 dataType)) PI)
)

; 2021-04-18
(defun InsertBsGCTSupportLeg (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTSupportLeg-A2" "0DataFlow-BsThickLine" (list (cons 0 dataType)))
  ; (SetDynamicBlockPropertyValueUtils 
  ;   (GetLastVlaObjectUtils) 
  ;   (list (cons "LEG_HEIGHT" "1000"))
  ; ) 
)

; 2021-04-17
(defun GetBsGCTTankPressureElementDictList ()
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (car (GetBsImportedListFromCSVStrategy "BsGCTTankPressureElement"))
                y
              )
           ) 
    (cdr (GetBsImportedListFromCSVStrategy "BsGCTTankPressureElement"))
  ) 
)

; 2021-04-17
(defun GetBsGCTTankPressureElementList ()
  (cdr (GetBsImportedListFromCSVStrategy "BsGCTTankPressureElement"))
)

; 2021-04-17
(defun GetBsGCTTankOtherRequestList ()
  (mapcar '(lambda (x) (car x)) 
    (cdr (GetBsImportedListFromCSVStrategy "BsGCTTankOtherRequest"))
  )
)

; 2021-04-17
(defun GetBsImportedListFromCSVStrategy (dataType / fileDir)
  (cond 
    ((= dataType "BsGCTTankPressureElement") (setq fileDir "D:\\dataflowcad\\bsdata\\tankPressureElement.csv"))
    ((= dataType "BsGCTTankOtherRequest") (setq fileDir "D:\\dataflowcad\\bsdata\\tankOtherRequest.csv"))
  ) 
  (StrListToListListUtils (ReadFullDataFromCSVUtils fileDir))
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

; 2021-04-20
(defun GetTankBsGCTMainPropertyNameList ()
  '("BSGCT_TYPE" "TAG" "BarrelRadius" "BarrelHeight")
)

; 2021-04-20
(defun GetTankBsGCTDesignParamPropertyNameList ()
  '("SERVIVE_LIFE" "PRESSURE" "DESIGN_PRESSURE" "TEMP" "DESIGN_TEMP" "SUBSTANCE" "SUBSTANCE_PROPERTY" "SUBSTANCE_DENSITY" "CORROSION_ALLOWANCE" "WELD_JOINT" "FULL_VOLUME" "LOAD_FACTOR" "SV_SET_PRESSURE" "SV_MAX_PRESSURE" "INSULATION_THICKNESS" "NET_WEIGHT" "SS_WEIGHT" "OPERATION_WEIGHT" "TOTAL_WEIGHT")
)

; 2021-04-20
(defun GetBsGCTNozzleTableRowPropertyNameList ()
  '("SYMBOL" "MATERIAL" "STANDARD" "CONNECTION" "NAME" "LENGTH")
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
(defun GetBsGCTTankData () 
  (vl-remove-if-not '(lambda (x) 
                      (= (car x) "Tank") 
                    ) 
    (GetBsGCTImportedList)
  ) 
)

; 2021-04-19
(defun GetBsGCTTankDictData () 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (append (GetTankBsGCTMainPropertyNameList) (GetTankBsGCTDesignParamPropertyNameList))
                y
              )
           ) 
    (GetBsGCTTankData)
  )
)

; 2021-04-20
(defun GetBsGCTTankNozzleDictData () 
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (append (list "TAG") (GetBsGCTNozzleTableRowPropertyNameList))
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
                        (= (car x) "nozzle") 
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

; 2021-04-17
; (defun InsertBsGCTStrategy (dataType designData /) 
;   (cond 
;     ((= dataType "Tank") (InsertOneBsTankGCT designData))
;   )
; )

; 2021-04-17
(defun InsertOneBsTankGCT (insPt oneTankData tankPressureElementList tankOtherRequestList / equipTag bsGCTType barrelRadius barrelHalfHeight designParamDictList) 
  (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  (setq bsGCTType (strcat (GetDottedPairValueUtils "BSGCT_TYPE" oneTankData) "-" equipTag))
  (setq barrelRadius (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "BarrelRadius" oneTankData))))
  (setq barrelHalfHeight (GetHalfNumberUtils (atoi (GetDottedPairValueUtils "BarrelHeight" oneTankData))))
  (setq designParamDictList (cadr (SplitListListByIndexUtils 4 oneTankData)))
  (InsertBsGCTDrawFrame insPt equipTag)
  (InsertBsGCTDataHeader (MoveInsertPositionUtils insPt -900 2870) bsGCTType)
  (InsertBsGCTDesignParam (MoveInsertPositionUtils insPt -900 2820) bsGCTType designParamDictList)
  (InsertBsGCTDesignStandard (MoveInsertPositionUtils insPt -450 2820) bsGCTType)
  (InsertBsGCTRequirement (MoveInsertPositionUtils insPt -450 2620) bsGCTType)
  (InsertBsGCTPressureElement (MoveInsertPositionUtils insPt -900 1980) bsGCTType tankPressureElementList)
  (InsertBsGCTOtherRequest (MoveInsertPositionUtils insPt -900 (- 1900 (* 40 (length tankPressureElementList)))) bsGCTType tankOtherRequestList)
  (InsertBsGCTNozzleTable (MoveInsertPositionUtils insPt -1800 2870) bsGCTType oneTankData)
  (InsertBsGCTTankGraphy (MoveInsertPositionUtils insPt -2915 1600) barrelRadius barrelHalfHeight 8 bsGCTType)
  (princ)
)

; 2021-04-17
(defun InsertAllBsGCTTank (/ insPt allBsGCTTankDictData tankPressureElementList tankOtherRequestList totalNum insPtList) 
  (VerifyBsGCTBlockLayerText)
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (setq allBsGCTTankDictData (GetBsGCTTankDictData))
  (setq tankPressureElementList (GetBsGCTTankPressureElementList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestList)) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allBsGCTTankDictData 0) 5200))
  (mapcar '(lambda (x y) 
            (InsertOneBsTankGCT x y tankPressureElementList tankOtherRequestList) 
          ) 
    insPtList
    allBsGCTTankDictData 
  ) 
  (princ)
)

(defun c:foo (/ insPt)
  (InsertAllBsGCTTank)
  ; (GetBsGCTTankNozzleDictData)
  ; (GetOneBsGCTTankNozzleDictData "V5501")
)

; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
