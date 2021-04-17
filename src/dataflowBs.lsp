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
(defun VerifyBsBlockLayerText ()
  (VerifyBsTextStyleByName "DataFlow")
  (VerifyBsTextStyleByName "TitleText")
  (VerifyBsLayerByName "0DataFlow-BsText")
  (VerifyBsLayerByName "0DataFlow-BsGCT")
  (VerifyBsLayerByName "0DataFlow-BsFrame")
  (VerifyBsBlockByName "BsGCT*")
  (VerifyBsBlockByName "*\.2017")
)

; 2021-04-17
(defun InsertBsGCTStrategy (dataType /) 
  (cond 
    ((= dataType "Tank") (InsertBsTankGCT))
  )
)

; 2021-04-17
(defun InsertBsTankGCT (/ insPt) 
  (VerifyBsBlockLayerText)
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertBsGCTDrawFrame insPt "Tank")
  (InsertBsGCTDataHeader (MoveInsertPositionUtils insPt -900 2870) "Tank")
  (InsertBsGCTDesignParam (MoveInsertPositionUtils insPt -900 2820) "Tank")
  (InsertBsGCTDesignStandard (MoveInsertPositionUtils insPt -450 2820) "Tank")
  (InsertBsGCTRequirement (MoveInsertPositionUtils insPt -450 2620) "Tank")
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

(defun c:foo ()
  ; (InsertBsGCTStrategy "Tank")
  (GetBsGCTTankPressureElementDictList)
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
(defun GetBsImportedListFromCSVStrategy (dataType / fileDir)
  (cond 
    ((= dataType "BsGCTTankPressureElement") (setq fileDir "D:\\dataflowcad\\bsdata\\tankPressureElement.csv"))
  ) 
  (StrListToListListUtils (ReadFullDataFromCSVUtils fileDir))
)

; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
