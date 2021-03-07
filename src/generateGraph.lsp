;��������� 2020-2021 ��
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Steal Gs AutoCAD Modules

(defun GetGsLcModulesPath (/ result)
  (setq result "D:\\dataflowcad\\allBlocks\\GsLcBlocks.dwg")
)

; 2021-03-03
(defun StealAllGsLcBlocks ()
  (Steal (GetGsLcModulesPath) 
    '(
      ("Blocks" ("*"))
    )
  ) 
)

; 2021-03-03
(defun StealAllGsLcLayers ()
  (Steal (GetGsLcModulesPath) 
    '(
      ("Layers" ("*"))
    )
  ) 
)

; 2021-03-03
(defun StealGsLcBlockByNameList (blockNameList /)
  (Steal (GetGsLcModulesPath) 
    (list 
      (list "Blocks" blockNameList)
    )
  ) 
)

; 2021-03-03
(defun StealGsLcLayerByNameList (layerNameList /)
  (Steal (GetGsLcModulesPath) 
    (list 
      (list "Layers" layerNameList)
    )
  ) 
)

; 2021-03-03
(defun VerifyGsLcBlockByName (blockName /) 
  (if (= (tblsearch "BLOCK" blockName) nil) 
    (StealGsLcBlockByNameList (list blockName))
  )
)

; 2021-03-03
(defun VerifyGsLcLayerByName (layerName /) 
  (if (= (tblsearch "LAYER" layerName) nil) 
    (StealGsLcLayerByNameList (list layerName))
  )
)

; 2021-03-05
(defun VerifyGsLcBlockPublicPipe () 
  (VerifyGsLcBlockByName "PublicPipeDownPipeLine")
  (VerifyGsLcBlockByName "PublicPipeDownArrow")
  (VerifyGsLcBlockByName "PublicPipeUpPipeLine")
  (VerifyGsLcBlockByName "PublicPipeUpArrow") 
  (VerifyGsLcLayerByName "DataFlow-PublicPipe")
  (VerifyGsLcLayerByName "DataFlow-PublicPipeLine")
)

; Steal Gs AutoCAD Modules
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GS Entity Object in CAD

(defun GenerateJoinDrawArrowToElement (insPt fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowTo" "DataFlow-JoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue "DataFlow-JoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateJoinDrawArrowFromElement (insPt pipenumValue fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowFrom" "DataFlow-JoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPosition insPt 30 2) "PIPENUM" pipenumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue "DataFlow-JoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownArrow" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -3.5 -10) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt 1.2 -10) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt 7 -10) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpArrow" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -3.5 -11.5) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt 1.2 -11.5) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt 7 -11.5) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpPipeLine" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt -5 -16) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownPipeLine" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt -5 -16) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOneEntityObjectElement (insPt textDataList blockName /) 
  (cond 
    ((= blockName "EquipTagV2") 
      (entmake (list (cons 0 "INSERT") (cons 100 "AcDbEntity") (cons 100 "AcDbBlockReference") 
                    (cons 2 blockName) (cons 10 insPt) 
              )
      )
      (GenerateEquipTagText (MoveInsertPosition insPt 0 1) (nth 0 textDataList))
      (GenerateEquipTagText (MoveInsertPosition insPt 0 -4.5) (nth 1 textDataList))
    )
  )
)

(defun GenerateEntityObjectElement (blockName insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOneEntityObjectElement x y blockName)
          ) 
          insPtList
          dataList
  )
)

(defun c:EquipTag (/ ss equipInfoList insPt insPtList)
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\nѡȡ�豸λ�ŵĲ���㣺"))
  (setq insPtList (GetInsertPtListUtils insPt (GenerateSortedNumByList equipInfoList 0) 30))
  (GenerateEntityObjectElement "EquipTagV2" insPtList equipInfoList)
)

; Unit Test Completed
(defun GenerateSortedNumByList (originList i / resultList)
  (repeat (length originList) 
    (setq resultList (append resultList (list i)))
    (setq i (+ i 1))
  )
  resultList
)

; Unit Test Compeleted
(defun MoveInsertPosition (insPt xOffset yOffset / result)
  (setq result (ReplaceListItemByindexUtils (+ (car insPt) xOffset) 0 insPt))
  (setq result (ReplaceListItemByindexUtils (+ (nth 1 result) yOffset) 1 result))
  result
)

; get the new inserting position
; Unit Test Compeleted
(defun GetInsertPt (insPt i removeDistance /)
  (ReplaceListItemByindexUtils (+ (car insPt) (* i removeDistance)) 0 insPt)
)

; Unit Test Compeleted
(defun GetInsertPtListUtils (insPt SortedNumByList removeDistance / resultList)
  (mapcar '(lambda (x) (GetInsertPt insPt x removeDistance)) 
    SortedNumByList
  )
)

(defun GetEquipTagList (ss / i ent blk entx value equipInfoList equipTag equipName)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (if (/= nil (ssname ss i))
          (progn
              ; get the entity information of the i(th) block
            (setq ent (entget (ssname ss i)))
              ; save the entity name of the i(th) block
            (setq blk (ssname ss i))
              ; get the property information
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (if (= value "TAG")
                    (setq equipTag (append equipTag (list (cdr (assoc 1 entx)))))
              )
              (if (= value "NAME")
                    (setq equipName (append equipName (list (cdr (assoc 1 entx)))))
              )
                ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
      )
    )
  )
  (setq equipInfoList (mapcar '(lambda (x y) (list x y)) equipTag equipName))
)

; Generate Entity Object in CAD
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GsLcBlocks


; logic for generate Instrument
(defun c:InsertBlockInstrumentP (/ ss insPt) 
  (prompt "\nѡȡ�豸����Ǳ��飺")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipment")) 
  (setq insPt (getpoint "\nѡȡ�����Ǳ�����㣺"))
  (InsertGsLcBlockInstrument insPt "InstrumentP" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentP")) 
)

(defun c:InsertBlockInstrumentL (/ ss insPt) 
  (prompt "\nѡȡ�豸����Ǳ��飺")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipment"))  
  (setq insPt (getpoint "\nѡȡ�͵��Ǳ�����㣺"))
  (InsertGsLcBlockInstrument insPt "InstrumentL" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentL")) 
)

(defun c:InsertBlockInstrumentSIS (/ ss insPt) 
  (prompt "\nѡȡ�豸����Ǳ��飺")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipment"))  
  (setq insPt (getpoint "\nѡȡSIS�Ǳ�����㣺"))
  (InsertGsLcBlockInstrument insPt "InstrumentSIS" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentP")) 
)

; 2021-03-07
(defun InsertGsLcBlockInstrument (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcInstrumentLayer)
  (InsertBlockUtils insPt blockName "DataFlow-Instrument" blockPropertyDict)
)

; 2021-03-07
(defun VerifyGsLcInstrumentLayer () 
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
)

; 2021-03-07
(defun GetGsLcBlockInstrumentPropertyDict (ss dataType / propertyIDList sourceData equipmentData instrumentData resultList)
  (setq propertyIDList (GetPropertyIDListStrategy dataType))
  (setq sourceData (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils ss)))
  (setq equipmentData (FilterBlockEquipmentDataUtils sourceData))
  (setq instrumentData (FilterBlockInstrumentDataUtils sourceData))
  (if (/= equipmentData nil) 
      (mapcar '(lambda (x) 
                (setq resultList (append resultList (list (cons (car x) (cdr (assoc (cdr x) (car equipmentData)))))))
              ) 
        propertyIDList
      ) 
  )
  (if (/= instrumentData nil) 
    (setq resultList (ExtendPropertyIDListStrategy dataType resultList instrumentData))
  ) 
  resultList
)

(defun GetPropertyIDListStrategy (dataType /)
  (if (= dataType "InstrumentP") 
    (list (cons 0 "entityhandle") (cons 5 "substance") (cons 6 "temp") (cons 7 "pressure") (cons 10 "material") (cons 12 "tag"))
    (list (cons 0 "entityhandle") (cons 3 "substance") (cons 4 "temp") (cons 5 "pressure") (cons 8 "material") (cons 10 "tag"))
  )
)

(defun ExtendPropertyIDListStrategy (dataType originList instrumentData / resultList)
  (if (= dataType "InstrumentP") 
    (setq resultList (append originList (list 
                                          (cons 1 (cdr (assoc "function" (car instrumentData))))
                                          (cons 3 (cdr (assoc "halarm" (car instrumentData))))
                                          (cons 4 (cdr (assoc "lalarm" (car instrumentData))))
                                        ))) 
    (setq resultList (append originList (list 
                                          (cons 1 (cdr (assoc "function" (car instrumentData))))
                                        )))  
  )
  resultList
)

; logic for generate Pipe
; 2021-03-07
(defun c:InsertBlockPipeArrowLeft (/ ss insPt) 
  (prompt "\nѡȡ�豸��͹ܵ��飺")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe"))
  (setq insPt (getpoint "\nѡȡˮƽ�ܵ�����㣺"))
  (InsertGsLcBlockPipe insPt "PipeArrowLeft" (GetGsLcBlockPipePropertyDict ss))
)

; 2021-03-07
(defun c:InsertBlockPipeArrowUp (/ ss insPt) 
  (prompt "\nѡȡ�豸��͹ܵ��飺")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe")) 
  (setq insPt (getpoint "\nѡȡ��ֱ�ܵ�����㣺"))
  (InsertGsLcBlockPipe insPt "PipeArrowUp" (GetGsLcBlockPipePropertyDict ss))
)

; 2021-03-07
(defun InsertGsLcBlockPipe (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcPipeLayer)
  (InsertBlockUtils insPt blockName "DataFlow-Pipe" blockPropertyDict)
)

; 2021-03-07
(defun GetGsLcBlockPipePropertyDict (ss / propertyIDList sourceData equipmentData pipeData resultList)
  (setq propertyIDList (list (cons 0 "entityhandle") (cons 2 "substance") (cons 3 "temp") (cons 4 "pressure") (cons 6 "tag")))
  (setq sourceData (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils ss)))
  (setq equipmentData (FilterBlockEquipmentDataUtils sourceData))
  (setq pipeData (FilterBlockPipeDataUtils sourceData))
  (if (/= equipmentData nil) 
      (mapcar '(lambda (x) 
                (setq resultList (append resultList (list (cons (car x) (cdr (assoc (cdr x) (car equipmentData)))))))
              ) 
        propertyIDList
      ) 
  )
  (if (/= pipeData nil) 
    (setq resultList (append resultList (list (cons 1 (cdr (assoc "pipenum" (car pipeData)))))))
  ) 
  resultList
)

; 2021-03-07
(defun VerifyGsLcPipeLayer () 
  (VerifyGsLcLayerByName "DataFlow-Pipe")
  (VerifyGsLcLayerByName "DataFlow-PipeComment")
)

; logic for generate EquipTag
; 2021-03-07 refactored
(defun c:InsertBlockGsLcReactor (/ insPt) 
  (setq insPt (getpoint "\nѡȡ��Ӧ��λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Reactor")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Reactor" "DataFlow-EquipTag" (list (cons 1 "R")))
)

; 2021-03-07 refactored
(defun c:InsertBlockGsLcTank (/ insPt) 
  (setq insPt (getpoint "\nѡȡ����λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Tank")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Tank" "DataFlow-EquipTag" (list (cons 1 "V")))
)

; 2021-03-07
(defun c:InsertBlockGsLcPump (/ insPt) 
  (setq insPt (getpoint "\nѡȡ���ͱ�λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Pump")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Pump" "DataFlow-EquipTag" (list (cons 1 "P")))
)

; 2021-03-07
(defun c:InsertBlockGsLcHeater (/ insPt) 
  (setq insPt (getpoint "\nѡȡ������λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Heater")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Heater" "DataFlow-EquipTag" (list (cons 1 "E")))
)

; 2021-03-07
(defun c:InsertBlockGsLcCentrifuge (/ insPt) 
  (setq insPt (getpoint "\nѡȡ���Ļ�λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Centrifuge")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Centrifuge" "DataFlow-EquipTag" (list (cons 1 "M")))
)

; 2021-03-07
(defun c:InsertBlockGsLcVacuum (/ insPt) 
  (setq insPt (getpoint "\nѡȡ��ձ�λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Vacuum")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Vacuum" "DataFlow-EquipTag" (list (cons 1 "P")))
)

; 2021-03-07
(defun c:InsertBlockGsLcCustomEquip (/ insPt) 
  (setq insPt (getpoint "\nѡȡ�Զ����豸λ�Ų���㣺"))
  (VerifyGsLcBlockByName "CustomEquip")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "CustomEquip" "DataFlow-EquipTag" (list (cons 1 "X")))
)

; 2021-03-07
(defun VerifyGsLcEquipTagLayer () 
  (VerifyGsLcLayerByName "DataFlow-EquipTag")
  (VerifyGsLcLayerByName "DataFlow-EquipTagComment")
)



; logic for generate PublicPipe
(defun InsertPublicPipe (dataList pipeSourceDirection / lastEntityName insPt insPtList) 
  (VerifyGsLcBlockPublicPipe)
  (setq lastEntityName (entlast))
  (setq insPt (getpoint "\nѡȡ���������������㣺"))
  (setq dataList (ProcessPublicPipeElementData dataList))
  ; sort data by drawnum
  (setq dataList (vl-sort dataList '(lambda (x y) (< (nth 4 x) (nth 4 y)))))
  (setq insPtList (GetInsertPtListUtils insPt (GenerateSortedNumByList dataList 0) 10))
  (cond 
    ((= pipeSourceDirection "0") (GenerateDownPublicPipe insPtList dataList))
    ((= pipeSourceDirection "1") (GenerateUpPublicPipe insPtList dataList))
  )
)

(defun GenerateUpPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeUpArrow x (nth 2 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeUpPipeLine (MoveInsertPosition x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "DataFlow-PublicPipeLine" 0.6)
          ) 
          insPtList
          dataList
  )
)

(defun GenerateDownPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeDownArrow x (nth 3 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeDownPipeLine (MoveInsertPosition x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "DataFlow-PublicPipeLine" 0.6)
          ) 
          insPtList
          dataList
  )
)

(defun ProcessPublicPipeElementData (dataList /) 
  (mapcar '(lambda (x) 
             ; the property value of drawnum may be null
             (if (< (strlen (nth 4 x)) 3) 
               (ReplaceListItemByindexUtils "XXXXX" 4 x)
               (ReplaceListItemByindexUtils (ExtractDrawNumUtils (nth 4 x)) 4 x)
             )
           ) 
    dataList
  )
)

(defun c:UpdatePublicPipe ()
  (UpdatePublicPipeByDataType "PublicPipeUpArrow")
  (UpdatePublicPipeByDataType "PublicPipeDownArrow")
  (UpdatePublicPipeByDataType "PublicPipeLine")
  (alert "�������")(princ)
)

(defun UpdatePublicPipeByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  )
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; repair bug - relatedid may be not in the allPipeHandleList - 2021-01-30
                        (and (/= (cdr (assoc "relatedid" x)) "") (/= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetBlockAllPropertyDictUtils entityNameList)
    )
  )
  (PrintErrorLogForUpdatePublicPipe dataType entityNameList allPipeHandleList) 
  (UpdatePublicPipeStrategy dataType entityNameList relatedPipeData)
)

(defun PrintErrorLogForUpdatePublicPipe (dataType entityNameList allPipeHandleList /)
  (if (= dataType "PublicPipeLine") 
    (mapcar '(lambda (x) 
              (prompt "\n")
              (prompt (strcat "ԭ�������еĹܵ�" (cdr (assoc "pipenum" x)) "���Կ鱻ͬ����ɾ���ˣ��޷�ͬ�����ݣ�"))
            ) 
      ; refactor at 2021-01-30
      (vl-remove-if-not '(lambda (x) 
                          (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                        ) 
        (GetBlockAllPropertyDictUtils entityNameList)
      )
    ) 
  )
)

(defun UpdatePublicPipeStrategy (dataType entityNameList relatedPipeData /) 
  (cond 
    ((= dataType "PublicPipeLine") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "PIPENUM") 
                  (list (cdr (assoc "pipenum" y)))
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "PublicPipeUpArrow") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "TAG" "DRAWNUM") 
                  (list 
                    (cdr (assoc "from" y)) 
                    (ExtractDrawNumUtils (cdr (assoc "drawnum" y)))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "PublicPipeDownArrow") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "TAG" "DRAWNUM") 
                  (list 
                    (cdr (assoc "to" y)) 
                    (ExtractDrawNumUtils (cdr (assoc "drawnum" y)))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
)

; logic for generate PublicPipe
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
; logic for generate joinDrawArrow

(defun c:UpdateJoinDrawArrow ()
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowTo")
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowFrom")
  (alert "�������")(princ)
)

(defun GetAllPipeHandleListUtils (/ pipeData) 
  (setq pipeData (GetAllPipeDataUtils)) 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    pipeData
  )
)

(defun UpdateJoinDrawArrowByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  )
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; repair bug - JoinDrawArrow's relatedid may be not in the allPipeHandleList - 2020.12.22
                        ; refactor at 2021-01-27
                        (and (/= (cdr (assoc "relatedid" x)) "") (/= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetBlockAllPropertyDictUtils entityNameList)
    )
  )
  (mapcar '(lambda (x) 
             (prompt "\n")
             (prompt (strcat (cdr (assoc "fromto" x)) "��" (cdr (assoc "drawnum" x)) "��" "�����Ĺܵ�����id�ǲ����ڵģ�"))
           ) 
    ; refactor at 2021-01-27
    (vl-remove-if-not '(lambda (x) 
                        (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetBlockAllPropertyDictUtils entityNameList)
    )
  ) 
  (UpdateJoinDrawArrowStrategy dataType entityNameList relatedPipeData)
)

(defun UpdateJoinDrawArrowStrategy (dataType entityNameList relatedPipeData /) 
  (cond 
    ((= dataType "JoinDrawArrowFrom") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "PIPENUM" "FROMTO" "DRAWNUM") 
                  (list 
                    (cdr (assoc "pipenum" y)) 
                    ; add the Equip ChName - 2021-01-27
                    (strcat "��" (cdr (assoc "from" y)) (GetEquipChNameByEquipTag (cdr (assoc "from" y))))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "JoinDrawArrowTo") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "FROMTO" "DRAWNUM") 
                  (list 
                    (strcat "ȥ" (cdr (assoc "to" y)) (GetEquipChNameByEquipTag (cdr (assoc "to" y))))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
)

(defun c:GenerateJoinDrawArrow (/ pipeSS pipeData insPt entityNameList)
  (VerifyGsLcBlockByName "JoinDrawArrowTo")
  (VerifyGsLcBlockByName "JoinDrawArrowFrom")
  (VerifyGsLcLayerByName "DataFlow-JoinDrawArrow")
  (prompt "\nѡ�����ɽ�ͼ��ͷ�ı߽�ܵ���")
  (setq pipeSS (GetPipeSSBySelectUtils))
  (setq pipeData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils pipeSS))))
  (setq insPt (getpoint "\nѡȡ��ͼ��ͷ�Ĳ���㣺"))
  (GenerateJoinDrawArrowToElement insPt
    (strcat "ȥ" (cdr (assoc "to" pipeData))) 
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  )
  (GenerateJoinDrawArrowFromElement (MoveInsertPosition insPt 20 0)
    (cdr (assoc "pipenum" pipeData)) 
    (strcat "��" (cdr (assoc "from" pipeData)))
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  ) 
  (princ)
)

(defun GetRelatedEquipDataByTag (tag / equipData) 
  ; repair bug - the tag may contain space, trim the space frist - 2020.12.21
  (setq tag (StringSubstUtils "" " " tag))
  (setq equipData (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils (GetAllEquipmentSSUtils))))
  (car 
    (vl-remove-if-not '(lambda (x) 
                        (= (cdr (assoc "tag" x)) tag)
                      ) 
      equipData
    ) 
  )
)

(defun GetRelatedEquipDrawNum (equipData / result) 
  (if (/= equipData nil) 
    (setq result (ExtractDrawNumUtils (cdr (assoc "drawnum" equipData))))
    (setq result "�޴��豸")
  )
  result
)

; logic for generate joinDrawArrow
;;;-------------------------------------------------------------------------;;;

; Generate GsLcBlocks
; Generate GS Entity Object in CAD
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
; Generate SS Object in CAD

; refactored at 2021-02-07
(defun GenerateOneFireFightHPipe (insPt pipenum pipeDiameter relatedIDValue textHeight /) 
  (GenerateBlockReference insPt "FireFightHPipe" "DataflowFireFightPipe")
  (GenerateBlockAttribute (MoveInsertPosition insPt 150 60) "PIPENUM" pipenum "0" textHeight)
  (GenerateBlockAttribute (MoveInsertPosition insPt 150 -420) "PIPEDIAMETER" pipeDiameter "0" textHeight)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 150 -720) "RELATEDID" relatedIDValue "DataflowFireFightPipe" 150)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; 2021-02-03
(defun GenerateOneFireFightVPipe (insPt pipenum relatedIDValue /) 
  (GenerateBlockReference insPt "FireFightVPipe" "DataflowFireFightPipe")
  (GenerateVerticallyBlockAttribute (AddPositonOffSetUtils insPt '(-60 150 0)) "PIPENUM" pipenum "0" 350)
  (GenerateBlockHiddenAttribute (AddPositonOffSetUtils insPt '(200 0 0)) "RELATEDID" relatedIDValue "DataflowFireFightPipe" 150)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; 2021-02-07
(defun GenerateOneFireFightElevation (insPt elevation textHeight /) 
  (GenerateBlockReference insPt "FireFightElevation" "DataflowFireFightElevation")
  (GenerateBlockAttribute (AddPositonOffSetUtils insPt '(-950 300 0)) "ELEVATION" elevation "0" textHeight)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; Generate SS Object in CAD
;;;-------------------------------------------------------------------------;;;