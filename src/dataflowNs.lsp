;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate NsEquipListTable

; 2021-03-17
(defun c:InsertNsEquipListTable (/ insPt) 
  (VerifyNsBzTextStyleByName "DataFlow")
  (VerifyNsBzLayerByName "0DataFlow-NsText")
  (VerifyNsBzLayerByName "0DataFlow-NsEquipFrame")
  (VerifyNsBzBlockByName "equiplist.2017") 
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  
  ;(GetNsEquipDictList)
  (InsertNsEquipTextList (MoveInsertPositionUtils insPt 3000 25200) (GetNsEquipDictList))
  ;(InsertNsEquipListLeftText insPt "内容" 350)
  ;(InsertNsEquipFrame insPt)
)

; refactored at 2021-03-12
(defun InsertNsEquipTextList (insPt equipDictList / textHeight insPtList) 
  (setq textHeight 350)
  (setq insPtList (GetInsertPtListByYMoveUtils insPt (GenerateSortedNumByList equipDictList 0) -800))
  (mapcar '(lambda (x y) 
             (InsertNsEquipListLeftTextByRow y x textHeight)
           ) 
    equipDictList
    insPtList
  ) 
)

; 2021-03-17
(defun InsertNsEquipListLeftTextByRow (insPt rowData textHeight /) 
  (cond 
    ((= (length rowData) 7) (InsertFristRowNsEquipList insPt rowData textHeight)) 
    ((= (length rowData) 2) (InsertLastRowNsEquipList insPt rowData textHeight)) 
    (T (InsertNullRowNsEquipList insPt rowData textHeight)) 
  )
)

; 2021-03-17
;("1" "EH-137-0000-0001" "防爆柜式离心风机箱" "5320" "HTFC-I-12-Ex" "1" "2")
(defun InsertFristRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListCenterText insPt (nth 0 rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 1500 0) (nth 1 rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 2700 0) (nth 2 rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (nth 3 rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 14700 0) (nth 4 rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 21300 0) "台" textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 22300 0) (nth 5 rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 30550 0) "订货" textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) (nth 6 rowData) textHeight)
)

; 2021-03-17
(defun InsertLastRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 2700 0) (nth 0 rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) (nth 1 rowData) textHeight)
)

; 2021-03-17
(defun InsertNullRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 2700 0) "NsEquipNull" textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 33600 0) "NsEquipNull" textHeight)
)

; 2021-03-17
(defun GetNsEquipDictList (/ resultList)
  (mapcar '(lambda (x) 
             ; the 1th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("id" "tag" "name" "airVolume" "type" "num" "explosionProof")))
                              )) 
             ; the 2th row
             (setq resultList (append resultList 
                                (list (RemoveNullStringForListUtils (GetNsEquipOneRowList x '("fullPressure" "staticPressure" "comment1"))))
                              )) 
             ; the 3th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("power" "comment2")))
                              )) 
             ; the 4th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("rotateSpeed" "comment3")))
                              )) 
             ; the 5th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("noise" "comment4")))
                              )) 
             ; the 6th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("efficiency" "comment5")))
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
(defun InsertNsEquipFrame (insPt /) 
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 8 "暖通")) 100)
)

; 2021-03-17
(defun InsertNsEquipListCenterText (insPt textContent textHeight /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight) 
)

; 2021-03-17
(defun InsertNsEquipListLeftText (insPt textContent textHeight /) 
  (GenerateLevelLeftTextUtils insPt textContent "0DataFlow-NsText" textHeight) 
)