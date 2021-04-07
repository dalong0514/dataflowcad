;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoNS ()
  (alert "暖通设计流最新版本号 V0.1，更新时间：2021-03-22\n数据流内网地址：192.168.1.38")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate NsEquipListTable

; 2021-03-18
(defun c:InsertNsEquipTableByDirection ()
  (InsertNsEquipTableByBox "importNsEquipTableBox")
)

; 2021-03-18
(defun GetInsertDirectionChNameList ()
  '("自上而下" "自左到右")
)

; 2021-03-18
(defun InsertNsEquipTableByBox (tileName / dcl_id status sortedType)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowNs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnModify" "(done_dialog 2)")
    (set_tile "sortedType" "0")
    ; the default value of input box
    (mode_tile "sortedType" 2)
    (action_tile "sortedType" "(setq sortedType $value)")
    (progn
      (start_list "sortedType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetInsertDirectionChNameList))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil sortedType)
      (setq sortedType "0")
    ) 
    (set_tile "sortedType" sortedType)
    ; insert button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (InsertNsEquipListTable sortedType)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-03-17
(defun InsertNsEquipListTable (insertDirection / insPt) 
  (VerifyNsBzTextStyleByName "DataFlow")
  (VerifyNsBzTextStyleByName "TitleText")
  (VerifyNsBzLayerByName "0DataFlow-NsText")
  (VerifyNsBzLayerByName "0DataFlow-NsEquipFrame")
  (VerifyNsBzBlockByName "equiplist.2017") 
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertNsEquipTextList (MoveInsertPositionUtils insPt 3000 25200) (GetNsEquipDictList) insertDirection)
  (DeleteNsEquipNullText)
  (princ)
)

; 2021-03-17
(defun DeleteNsEquipNullText ()
  (DeleteEntityBySSUtils (GetAllNsEquipNullTextSS))
)

; 2021-03-16
(defun GetAllNsEquipNullTextSS ()
  (ssget "X" (list (cons 0 "TEXT") (cons 1 "NsEquipNull")))
)

; refactored at 2021-03-12
(defun InsertNsEquipTextList (insPt equipDictList insertDirection / textInsPt textHeight insPtList totalNum num) 
  (setq textHeight 350)
  (setq totalNum (1+ (/ (length (GetNsEquipDictList)) 29)))
  (setq num 1)
  (mapcar '(lambda (x) 
              (InsertNsEquipFrame (MoveInsertPositionUtils insPt -3000 -25200) totalNum num)
              (setq insPtList (GetInsertPtListByYMoveUtils insPt (GenerateSortedNumByList x 0) -800))
              (mapcar '(lambda (xx yy) 
                        (InsertNsEquipListLeftTextByRow yy xx textHeight)
                      ) 
                x
                insPtList
              ) 
              (setq insPt (GetNextNsEquipFrameInsPtStrategy insPt insertDirection))
              (setq num (1+ num))
           ) 
    (SplitListByNumUtils equipDictList 29)
  ) 
)

; 2021-03-17
(defun GetNextNsEquipFrameInsPtStrategy (insPt insertDirection /)
  (cond 
    ((= insertDirection "0") (MoveInsertPositionUtils insPt 0 -31700)) 
    ((= insertDirection "1") (MoveInsertPositionUtils insPt 44000 0)) 
  ) 
)

; 2021-03-17
(defun InsertNsEquipListLeftTextByRow (insPt rowData textHeight /) 
  (cond 
    ((or (= (length rowData) 7) (= (length rowData) 8)) (InsertFristRowNsEquipList insPt rowData textHeight)) 
    ((= (length rowData) 2) (InsertLastRowNsEquipList insPt rowData textHeight)) 
    ((= (length rowData) 1) (InsertMiddleRowNsEquipList insPt rowData textHeight)) 
    (T (InsertNullRowNsEquipList insPt rowData textHeight)) 
  )
)

; 2021-03-17
;("1" "EH-137-0000-0001" "防爆柜式离心风机箱" "5320" "HTFC-I-12-Ex" "1" "2")
(defun InsertFristRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListCenterText insPt (nth 0 rowData) textHeight)
  (InsertNsEquipListCenterTextByWidth (MoveInsertPositionUtils insPt 1500 0) (nth 1 rowData) textHeight 0.4)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 2700 0) (nth 2 rowData) textHeight)
  ; airVolume
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (RepairNsEquipAirVolume (nth 3 rowData)) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 14700 0) (nth 4 rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 21300 0) "台" textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 22300 0) (nth 5 rowData) textHeight)
  ; weight - refactored at 2021-03-24 remove the unit kg
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 24600 0) (nth 6 rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 30550 0) "订货" textHeight)
  (if (/= (nth 7 rowData) nil) 
    (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) (nth 7 rowData) textHeight)
    (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) "NsEquipNull" textHeight)
  )
)

; 2021-03-17
(defun RepairNsEquipAirVolume (airVolume /)
  (strcat "风量：" airVolume "m3/h")
)

; 2021-03-17
(defun InsertLastRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (nth 0 rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) (nth 1 rowData) textHeight)
)

; 2021-03-17
(defun InsertMiddleRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (nth 0 rowData) textHeight)
)

; 2021-03-17
(defun InsertNullRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) "NsEquipNull" textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) "NsEquipNull" textHeight)
)

; 2021-03-17
(defun GetNsEquipDictList (/ resultList)
  (mapcar '(lambda (x) 
             ; the 1th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("id" "tag" "name" "airVolume" "type" "num" "weight" "explosionProof")))
                              )) 
             ; the 2th row
             (setq resultList (append resultList 
                                (list (RepairFullPressure (GetNsEquipOneRowList x '("fullPressure" "staticPressure" "comment1"))))
                              )) 
             ; the 3th row
             (setq resultList (append resultList 
                                (list (RepairNsEquipPower (GetNsEquipOneRowList x '("power" "voltage" "comment2"))))
                              )) 
             ; the 4th row
             (setq resultList (append resultList 
                                (list (RepairNsEquipRotateSpeed (GetNsEquipOneRowList x '("rotateSpeed" "comment3"))))
                              )) 
             ; the 5th row
             (setq resultList (append resultList 
                                (list (RepairNsEquipNoise (GetNsEquipOneRowList x '("noise" "comment4"))))
                              )) 
             ; the 6th row
             (setq resultList (append resultList 
                                (list (RepairNsEquipEfficiency (GetNsEquipOneRowList x '("efficiency" "comment5"))))
                              )) 
             ; the last row
             (setq resultList (append resultList 
                                (list (list "NsEquipNull" "NsEquipNull"))
                              ))  
           ) 
    (GetOriginNsEquipDictList)
  )
  resultList
)

(defun RepairFullPressure (dataList /)
  (if (/= (car dataList) "") 
    (list (strcat "全压：" (car dataList) "Pa") (caddr dataList))
    (list (strcat "静压：" (cadr dataList) "Pa") (caddr dataList))
  )
)

(defun RepairNsEquipPower (dataList /) 
  (list 
    (strcat "功率：" (car dataList) "kW（" (cadr dataList) "V）")
    (caddr dataList))
)

(defun RepairNsEquipRotateSpeed (dataList /) 
  (list 
    (strcat "转速：" (car dataList) "r/min")
    (cadr dataList))
)

(defun RepairNsEquipNoise (dataList /) 
  (list 
    (strcat "噪声：" (car dataList) "dB（A）")
    (cadr dataList))
)

(defun RepairNsEquipEfficiency (dataList /) 
  (list 
    (strcat "能效等级：" (car dataList) " 级")
    (cadr dataList))
)

; 2021-03-17
(defun GetOriginNsEquipDictList ()
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                (GetNsEquipTablePropertyNameList)
                y
              )
           ) 
    ; sorted by EquipTag - ready for refactor -2021-03-17
    (GetNsEquipImportedList)
  )
)

; 2021-03-17
(defun GetNsEquipOneRowList (dataList propertyNameList / resultList)
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetDottedPairValueUtils x dataList))))
           ) 
    propertyNameList
  )
  resultList
)

(defun GetNsEquipTablePropertyNameList ()
  '("id" "tag" "name" "type" "airVolume" "fullPressure" "staticPressure" "power" "voltage" "rotateSpeed" "noise" "weight" "efficiency" "num" "explosionProof" "comment1" "comment2" "comment3" "comment4" "comment5")
)

(defun GetNsEquipTablePropertyChNameList ()
  '("序号" "设备位号" "设备名称" "设备型号" "风量" "全压" "静压" "功率" "电压" "转速" "噪声" "重量" "能效等级" "数量" "防爆等级" "备注1" "备注2"  "备注3" "备注4" "备注5")
)

; 2021-03-17
(defun ReadNsDataFromCSVStrategy (dataType / fileDir)
  (if (= dataType "NsEquip") 
    (setq fileDir "D:\\dataflowcad\\nsdata\\tempEquip.csv")
  )
  (ReadDataFromCSVUtils fileDir)
)

; 2021-03-17
(defun GetNsEquipImportedList ()
  (StrListToListListUtils (ReadNsDataFromCSVStrategy "NsEquip"))
)

; 2021-03-17
(defun InsertNsEquipFrame (insPt totalNum num /) 
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 0 totalNum) (cons 1 num) (cons 8 "暖通")) 100)
)

; 2021-03-17
(defun InsertNsEquipListCenterText (insPt textContent textHeight /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight 0.7) 
)

; 2021-03-17
(defun InsertNsEquipListCenterTextByWidth (insPt textContent textHeight textWidth /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight textWidth) 
)

; 2021-03-17
(defun InsertNsEquipListLeftText (insPt textContent textHeight /) 
  (GenerateLevelLeftTextUtils insPt textContent "0DataFlow-NsText" textHeight 0.7) 
)