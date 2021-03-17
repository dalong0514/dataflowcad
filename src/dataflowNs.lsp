;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun ReadNsDataFromCSVStrategy (dataType / fileDir)
  (if (= dataType "NsEquip") 
    (setq fileDir "D:\\dataflowcad\\nsdata\\tempEquip.csv")
  )
  (ReadDataFromCSVUtils fileDir)
)

(defun GetNsEquipImportedList ()
  (StrListToListListUtils (ReadNsDataFromCSVStrategy "NsEquip"))
)

; 2021-03-17
(defun c:InsertNsEquipListTable (/ insPt) 
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertNsEquipFrame insPt)
)

; 2021-03-17
(defun InsertNsEquipFrame (insPt /) 
  (VerifyNsBzLayerByName "0DataFlow-NsEquipFrame")
  (VerifyNsBzBlockByName "equiplist.2017")
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 8 "暖通")) 100)
)