;��������� 2020-2021 ��
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
  (VerifyNsBzTextStyleByName "DataFlow")
  (VerifyNsBzLayerByName "0DataFlow-NsText")
  (VerifyNsBzLayerByName "0DataFlow-NsEquipFrame")
  (VerifyNsBzBlockByName "equiplist.2017") 
  (setq insPt (getpoint "\nʰȡ�豸һ�������㣺"))
  (InsertNsEquipFrame insPt)
)

; 2021-03-17
(defun InsertNsEquipFrame (insPt /) 
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 8 "ůͨ")) 100)
)

(defun c:foo (/ insPt) 
  (VerifyNsBzTextStyleByName "DataFlow")
  (VerifyNsBzLayerByName "0DataFlow-NsText")
  (setq insPt (getpoint "\nʰȡ�豸һ�������㣺"))
  (GenerateCenterText insPt "����" "0DataFlow-NsText" 350) 
)