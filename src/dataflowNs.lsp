;��������� 2020-2021 ��
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
  (setq insPt (getpoint "\nʰȡ�豸һ�������㣺"))
  ;(InsertNsEquipTextList (MoveInsertPositionUtils insPt 3000 25200) (GetNsEquipDictList))
  (GetNsEquipDictList)
  ;(InsertNsEquipListLeftText insPt "����" 350)
  ;(InsertNsEquipFrame insPt)
)

; refactored at 2021-03-12
(defun InsertNsEquipTextList (insPt equipDictList / insPtList equipTagData equipPropertyTagDictList) 
  (setq insPtList (GetInsertPtListByYMoveUtils insPt (GenerateSortedNumByList equipDictList 0) -800))
  (mapcar '(lambda (x y) 
             (InsertNsEquipListLeftText y (car x) 350)
           ) 
    equipDictList
    insPtList
  ) 
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
                                (list (GetNsEquipOneRowList x '("fullPressure" "comment1")))
                              )) 
             ; the 3th row
             (setq resultList (append resultList 
                                (list (GetNsEquipOneRowList x '("power" "comment2")))
                              ))  
             ; the last row
             (setq resultList (append resultList 
                                (list (list "NsEquipNull"))
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
  '("���" "�豸λ��" "�豸����" "�豸�ͺ�" "����" "ȫѹ" "��ѹ" "����" "��ѹ" "ת��" "����" "����" "��Ч�ȼ�" "����" "�����ȼ�" "��ע1" "��ע2"  "��ע3" "��ע4" "��ע5")
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
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 8 "ůͨ")) 100)
)

; 2021-03-17
(defun InsertNsEquipListCenterText (insPt textContent textHeight /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight) 
)

; 2021-03-17
(defun InsertNsEquipListLeftText (insPt textContent textHeight /) 
  (GenerateLevelLeftTextUtils insPt textContent "0DataFlow-NsText" textHeight) 
)