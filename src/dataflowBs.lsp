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
; Generate BsGCT

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
(defun InsertBsGCTStrategy (dataType /) 
  (cond 
    ((= dataType "Tank") (InsertBsTankGCT 350 500))
  )
)

; 2021-04-17
(defun InsertBsTankGCT (barrelRadius barrelHalfHeight / insPt tankPressureElementList) 
  (VerifyBsGCTBlockLayerText)
  (setq tankPressureElementList (GetBsGCTTankPressureElementList))
  (setq tankOtherRequestList (GetBsGCTTankOtherRequestList))
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertBsGCTDrawFrame insPt "Tank")
  (InsertBsGCTDataHeader (MoveInsertPositionUtils insPt -900 2870) "Tank")
  (InsertBsGCTDesignParam (MoveInsertPositionUtils insPt -900 2820) "Tank")
  (InsertBsGCTDesignStandard (MoveInsertPositionUtils insPt -450 2820) "Tank")
  (InsertBsGCTRequirement (MoveInsertPositionUtils insPt -450 2620) "Tank")
  (InsertBsGCTPressureElement (MoveInsertPositionUtils insPt -900 1980) "Tank" tankPressureElementList)
  (InsertBsGCTOtherRequest (MoveInsertPositionUtils insPt -900 (- 1900 (* 40 (length tankPressureElementList)))) "Tank" tankOtherRequestList)
  (InsertBsGCTNozzleTable (MoveInsertPositionUtils insPt -1800 2870) "Tank" tankPressureElementList)
  (InsertBsGCTTankGraphy (MoveInsertPositionUtils insPt -2915 1600) barrelRadius barrelHalfHeight 8)
  (princ)
)

; 2021-04-17
(defun InsertBsGCTDrawFrame (insPt dataType /) 
  (InsertBlockByNoPropertyUtils insPt "BsGCTDrawFrame" "0DataFlow-BsFrame")
  (InsertBlockByScaleUtils insPt "title.equip.2017" "0DataFlow-BsFrame" (list (cons 4 "工程图") (cons 15 "设备") (cons 16 "1:5")) 5)
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 230) "revisions.2017" "0DataFlow-BsFrame" (list (cons 2 "1")) 5)
  (InsertBlockByScaleUtils (MoveInsertPositionUtils insPt 0 355) "intercheck.2017" "0DataFlow-BsFrame" (list (cons 2 "1")) 5)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 540) "stamp2.2017" "0DataFlow-BsFrame" 5)
)

; 2021-04-17
(defun InsertBsGCTDataHeader (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTDataHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
)

; 2021-04-17
(defun InsertBsGCTDesignParam (insPt dataType /) 
  (InsertBlockUtils insPt "BsGCTDesignParam" "0DataFlow-BsGCT" (list (cons 0 dataType)))
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
(defun InsertBsGCTNozzleTable (insPt dataType tankPressureElementList / i) 
  (InsertBlockUtils insPt "BsGCTNozzleTableHeader" "0DataFlow-BsGCT" (list (cons 0 dataType)))
  (InsertBsGCTNozzleTableRow (MoveInsertPositionUtils insPt 0 -130) dataType tankPressureElementList)
)

; 2021-04-17
(defun InsertBsGCTNozzleTableRow (insPt dataType tankPressureElementList / i) 
  (setq i 0)
  (repeat (length tankPressureElementList)
    (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (* -40 i)) "BsGCTNozzleTableRow" "0DataFlow-BsGCT" (list (cons 0 dataType)))
    (InsertBsGCTNozzleTableRowText (MoveInsertPositionUtils insPt 0 (* -40 i)) (nth i tankPressureElementList))
    (setq i (1+ i))
  ) 
  (GeneratePolyLineUtils 
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length tankPressureElementList)))) 
    (MoveInsertPositionUtils insPt 900 (- 0 (* 40 (length tankPressureElementList)))) 
    "0DataFlow-BsGCT" 3.6)
  (GeneratePolyLineUtils 
    insPt
    (MoveInsertPositionUtils insPt 0 (- 0 (* 40 (length tankPressureElementList)))) 
    "0DataFlow-BsGCT" 3.6) 
)

; 2021-03-17
(defun InsertBsGCTNozzleTableRowText (insPt textList /) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 38.1 -32) (nth 0 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 126.2 -32) (nth 1 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 326.2 -32) (nth 2 textList) "0DataFlow-BsText" 20 0.6) 
  (GenerateLevelCenterTextUtils (MoveInsertPositionUtils insPt 513.7 -32) (nth 3 textList) "0DataFlow-BsText" 20 0.7) 
  (GenerateLevelLeftTextUtils (MoveInsertPositionUtils insPt 566.2 -32) (nth 4 textList) "0DataFlow-BsText" 20 0.6) 
)

; 2021-04-18
(defun InsertBsGCTTankGraphy (insPt barrelRadius barrelHalfHeight thickNess /) 
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 barrelHalfHeight) barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" 1 thickNess)
  (GenerateDoubleLineBarrelUtils insPt barrelRadius barrelHalfHeight "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" thickNess)
  (GenerateDoubleLineEllipseHeadUtils (MoveInsertPositionUtils insPt 0 (- 0 barrelHalfHeight)) barrelRadius "0DataFlow-BsThickLine" "0DataFlow-BsCenterLine" -1 thickNess)
  (InsertBsGCTSupportLeg (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (- 0 (- barrelHalfHeight 25))) "Tank")
  (princ)
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
(defun InsertBsGCTDimension (firstInsPt secondInsPt textInsPt /)
  (InsertAlignedDimensionUtils firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT")
)

(defun c:foo (/ insPt)
  ; (InsertBsGCTStrategy "Tank")
  ; (GetBsGCTTankOtherRequestList)
  ; (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertBsGCTDimension '(0 0 0) '(1000 0 0) '(500 200 0))
)

; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
