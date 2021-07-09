;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; utils Function for  LC

; 2021-03-09
(defun VerifyGsLcEquipTagLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcEquipTag")
  (VerifyGsLcLayerByName "0DataFlow-GsLcEquipTagComment")
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GS Entity Object in CAD

(defun GenerateJoinDrawArrowToElement (insPt fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowTo" "0DataFlow-GsLcJoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 1 4) "FROMTO" fromtoValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 1 -1.5) "DRAWNUM" drawnumValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPositionUtils insPt 1 -7) "RELATEDID" relatedIDValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateJoinDrawArrowFromElement (insPt pipenumValue fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowFrom" "0DataFlow-GsLcJoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 30 2) "PIPENUM" pipenumValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 1 4) "FROMTO" fromtoValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 1 -1.5) "DRAWNUM" drawnumValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPositionUtils insPt 1 -7) "RELATEDID" relatedIDValue "0DataFlow-GsLcJoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownArrow" "0DataFlow-GsLcPublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt -3.5 -10) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt 1.2 -10) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPositionUtils insPt 7 -10) "RELATEDID" relatedIDValue "0DataFlow-GsLcPublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpArrow" "0DataFlow-GsLcPublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt -3.5 -11.5) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt 1.2 -11.5) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPositionUtils insPt 7 -11.5) "RELATEDID" relatedIDValue "0DataFlow-GsLcPublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpPipeLine" "0DataFlow-GsLcPublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPositionUtils insPt -5 -16) "RELATEDID" relatedIDValue "0DataFlow-GsLcPublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownPipeLine" "0DataFlow-GsLcPublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPositionUtils insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPositionUtils insPt -5 -16) "RELATEDID" relatedIDValue "0DataFlow-GsLcPublicPipe" 3)
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
      (GenerateEquipTagText (MoveInsertPositionUtils insPt 0 1) (nth 0 textDataList))
      (GenerateEquipTagText (MoveInsertPositionUtils insPt 0 -4.5) (nth 1 textDataList))
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

; refactored at 2021-04-09
(defun c:EquipTag () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertEquipTagMacro '())
)

; refactored at 2021-04-09
(defun InsertEquipTagMacro (/ ss equipInfoList insPt insPtList)
  (VerifyGsLcTextStyleByName "DataFlow")
  (VerifyGsLcBlockByName "EquipTagV2")
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\n选取设备位号的插入点："))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList equipInfoList 0) 30))
  (GenerateEntityObjectElement "EquipTagV2" insPtList equipInfoList)
)

; 2021-04-29
(defun c:UpdateGsLcEquipTag () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateGsLcEquipTagMacro '())
)

; 2021-04-29
(defun UpdateGsLcEquipTagMacro (/ entityNameList allEquipHandleList relatedPipeData) 
  (setq allEquipHandleList (GetAllEquipHandleListUtils))
  ; must filter first
  (setq entityNameList 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; relatedid may be not in the allHandleList
                        (and (/= (cdr (assoc "relatedid" (GetAllPropertyDictForOneBlock x))) "") 
                             (/= (member (cdr (assoc "relatedid" (GetAllPropertyDictForOneBlock x))) allEquipHandleList) nil)) 
                      ) 
      (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "EquipTag"))
    )
  ) 
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    (GetBlockAllPropertyDictListUtils entityNameList)
  ) 
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "TAG" "NAME") 
              (list 
                (GetDottedPairValueUtils "tag" y)
                (GetDottedPairValueUtils "name" y)
              )
            )
          ) 
    entityNameList
    relatedPipeData 
  ) 
  (alert "更新完成")(princ)
)

; 2021-04-29
(defun c:InsertAllGsLcEquipTag () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertAllGsLcEquipTagMacro '())
)

; 2021-04-29
(defun c:InsertGsLcEquipTag () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertGsLcEquipTagMacro '())
)

; 2021-04-29
(defun InsertGsLcEquipTagMacro ( / insPt equipData) 
  (princ "\n框选设备数据：")
  (setq equipData (GetEquipDictDataBySelectUtils))
  ; sorted by equipTag
  (setq equipData (vl-sort equipData '(lambda (x y) (< (GetDottedPairValueUtils "tag" x) (GetDottedPairValueUtils "tag" y)))))
  (setq insPt (getpoint "\n选取设备位号的插入点："))
  (InsertOneDrawEquipTag insPt equipData)
)

; 2021-04-29
(defun InsertAllGsLcEquipTagMacro ( / allDrawEquipData allGsLcDrawLabelPositionDictData oneDrawEquipData drawPosition) 
  (setq allDrawEquipData (GetAllGsLcEquipDrawNumDictListData))
  (setq allGsLcDrawLabelPositionDictData (GetAllGsLcDrawLabelPositionDictDataUtils))
  (foreach item (mapcar '(lambda (x) (car x)) allDrawEquipData) 
    (setq oneDrawEquipData (GetOneDrawEquipDictData (GetDottedPairValueUtils item allDrawEquipData)))
    ; sorted by equipTag
    (setq oneDrawEquipData (vl-sort oneDrawEquipData '(lambda (x y) (< (GetDottedPairValueUtils "tag" x) (GetDottedPairValueUtils "tag" y)))))
    (setq drawPosition (GetDottedPairValueUtils item allGsLcDrawLabelPositionDictData))
    (InsertOneDrawEquipTag (MoveInsertPositionUtils drawPosition -770 40) oneDrawEquipData)
  )
)

; 2021-04-29
(defun GetAllGsLcEquipDrawNumDictListData () 
  (ChunkListByColumnIndexUtils (GetGsLcAllEquipDictListData) 0) 
)

; 2021-04-15
(defun GetGsLcAllEquipDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils -1 (cadr x))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetGsLcStrategyEntityData (GetEntityDataBySSUtils (GetAllEquipmentSSUtils)))
  ) 
)

; 2021-04-29
(defun InsertOneDrawEquipTag (insPt equipData /) 
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList equipData 0) 30))
  (mapcar '(lambda (x y) 
              (InsertOneGsLcEquipTag x y)
            ) 
    insPtList
    equipData
  ) 
)

; 2021-04-29
(defun InsertOneGsLcEquipTag (insPt dataList /)
  (VerifyGsLcBlockByName "EquipTag")
  (VerifyGsLcLayerByName "0DataFlow-GsLcEquipTag")
  (InsertBlockUtils insPt "EquipTag" "0DataFlow-GsLcEquipTag" 
    (list 
      (cons 1 (GetDottedPairValueUtils "tag" dataList))
      (cons 2 (GetDottedPairValueUtils "name" dataList))
      (cons 3 (GetDottedPairValueUtils "entityhandle" dataList))
    )
  )
)

; 2021-04-29
(defun GetOneDrawEquipDictData (oneDrawEquipData /) 
  (mapcar '(lambda (x) 
             (GetAllPropertyDictForOneBlock (cadr x))
            ) 
    oneDrawEquipData
  ) 
)

; Unit Test Completed
(defun GenerateSortedNumByList (originList i / resultList)
  (repeat (length originList) 
    (setq resultList (append resultList (list i)))
    (setq i (+ i 1))
  )
  resultList
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

; Generate SS Entity Object in CAD
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GsLcBlocks

; logic for generate Instrument
; refactored at 2021-04-09
(defun c:InsertBlockInstrumentP () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockInstrumentPMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockInstrumentPMacro (/ ss insPt) 
  (prompt "\n选取设备块和仪表块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe")) 
  (setq insPt (getpoint "\n选取集中仪表插入点："))
  (InsertGsLcBlockInstrument insPt "InstrumentP" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentP")) 
)

; refactored at 2021-04-09
(defun c:InsertBlockInstrumentL () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockInstrumentLMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockInstrumentLMacro (/ ss insPt) 
  (prompt "\n选取设备块和仪表块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe"))  
  (setq insPt (getpoint "\n选取就地仪表插入点："))
  (InsertGsLcBlockInstrument insPt "InstrumentL" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentL")) 
)

; refactored at 2021-04-09
(defun c:InsertBlockInstrumentSIS () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockInstrumentSISMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockInstrumentSISMacro (/ ss insPt) 
  (prompt "\n选取设备块和仪表块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe"))  
  (setq insPt (getpoint "\n选取SIS仪表插入点："))
  (InsertGsLcBlockInstrument insPt "InstrumentSIS" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentP")) 
)

; 2021-03-07
(defun InsertGsLcBlockInstrument (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcInstrumentLayer)
  (InsertBlockUtils insPt blockName "0DataFlow-GsLcInstrument" blockPropertyDict)
)

; 2021-03-07
(defun VerifyGsLcInstrumentLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcInstrument")
  (VerifyGsLcLayerByName "0DataFlow-GsLcInstrumentComment")
)

; 2021-03-07
(defun GetGsLcBlockInstrumentPropertyDict (ss dataType / propertyIDList sourceData equipmentData instrumentData pipeData resultList)
  (setq propertyIDList (GetInstrumentPropertyIDListStrategy dataType))
  (setq sourceData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (setq equipmentData (FilterBlockEquipmentDataUtils sourceData))
  (setq instrumentData (FilterBlockInstrumentDataUtils sourceData))
  (setq pipeData (FilterBlockPipeDataUtils sourceData))
  (if (/= equipmentData nil) 
      (mapcar '(lambda (x) 
                (setq resultList (append resultList (list (cons (car x) (cdr (assoc (cdr x) (car equipmentData)))))))
              ) 
        propertyIDList
      ) 
  )
  (if (and (= equipmentData nil) (/= pipeData nil)) 
      (mapcar '(lambda (x) 
                (setq resultList (append resultList (list (cons (car x) (cdr (assoc (cdr x) (car pipeData)))))))
              ) 
        (GetPipePropertyIDListStrategy dataType)
      ) 
  ) 
  (if (/= instrumentData nil) 
    (setq resultList (ExtendInstrumentPropertyIDListStrategy dataType resultList instrumentData))
  ) 
  resultList
)

; refactored at 2021-04-14
(defun GetInstrumentPropertyIDListStrategy (dataType /)
  (cond 
    ((= dataType "InstrumentP") 
     (list (cons 0 "entityhandle") (cons 12 "tag")))
    ;  (list (cons 0 "entityhandle") (cons 5 "substance") (cons 6 "temp") (cons 7 "pressure") (cons 12 "tag")))
    ((= dataType "InstrumentL") 
     (list (cons 0 "entityhandle") (cons 10 "tag")))
    ; (list (cons 0 "entityhandle") (cons 3 "substance") (cons 4 "temp") (cons 5 "pressure") (cons 10 "tag")))
  ) 
)

; refactored at 2021-04-14
(defun GetPipePropertyIDListStrategy (dataType /)
  (cond 
    ((= dataType "InstrumentP") 
     (list (cons 0 "entityhandle") (cons 12 "pipenum")))
    ; (list (cons 0 "entityhandle") (cons 5 "substance") (cons 6 "temp") (cons 7 "pressure") (cons 12 "pipenum")))
    ((= dataType "InstrumentL") 
     (list (cons 0 "entityhandle") (cons 10 "pipenum")))
    ; (list (cons 0 "entityhandle") (cons 3 "substance") (cons 4 "temp") (cons 5 "pressure") (cons 10 "pipenum")))
  ) 
)

(defun ExtendInstrumentPropertyIDListStrategy (dataType originList instrumentData / resultList)
  (if (= dataType "InstrumentP") 
    (setq resultList (append originList (list 
                                          (cons 1 (cdr (assoc "function" (car instrumentData))))
                                          (cons 2 "xxxx")
                                          (cons 3 (cdr (assoc "halarm" (car instrumentData))))
                                          (cons 4 (cdr (assoc "lalarm" (car instrumentData))))
                                        ))) 
    (setq resultList (append originList (list 
                                          (cons 1 (cdr (assoc "function" (car instrumentData))))
                                          (cons 2 "xxxx")
                                        )))  
  )
  resultList
)

; logic for UpdateInstrumentLocation 
; 2021-04-22
(defun c:UpdatePipeDataFromEquip () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdatePipeDataFromEquipMacro '())
)

; 2021-04-22
(defun UpdatePipeDataFromEquipMacro (/ allEquipTagDataList allEquipDataList allPipeDataList entityNameList matchedList) 
  (setq allEquipTagDataList 
    (mapcar '(lambda (x) 
               (GetDottedPairValueUtils "tag" x)
            ) 
      (GetAllEquipDataUtils)
    ) 
  ) 
  (setq allEquipDataList 
    (mapcar '(lambda (x) 
               (cons 
                 (GetDottedPairValueUtils "tag" x)
                 x
               )
            ) 
      (GetAllEquipDataUtils)
    ) 
  ) 
  ; must filter first
  (setq allPipeDataList 
    ; relatedid value maybe null
    ; refactored at 2021-04-25 update only for two end is equipment
    (vl-remove-if-not '(lambda (x) 
                        (and (IsKsLocationOnEquip (GetDottedPairValueUtils "from" x))
                             (IsKsLocationOnEquip (GetDottedPairValueUtils "to" x))
                             (/= (member (GetDottedPairValueUtils "from" x) allEquipTagDataList) nil))  
                      ) 
      (GetAllPipeDataUtils)
    )
  ) 
  (setq entityNameList 
    (mapcar '(lambda (x) 
               (cons 
                 (handent (GetDottedPairValueUtils "entityhandle" x))
                 (GetDottedPairValueUtils "from" x)
               )
            ) 
      allPipeDataList
    ) 
  ) 
  (mapcar '(lambda (x) 
            (setq matchedList (GetDottedPairValueUtils (cdr x) allEquipDataList))
            (ModifyMultiplePropertyForOneBlockUtils (car x) 
              (list "SUBSTANCE" "TEMP" "PRESSURE") 
              (list 
                (GetDottedPairValueUtils "substance" matchedList)
                (GetDottedPairValueUtils "temp" matchedList)
                (GetDottedPairValueUtils "pressure" matchedList)
              )  
            )
          ) 
    entityNameList
  ) 
  (alert "更新完成")(princ)
)

; logic for UpdateInstrumentLocation 
; 2021-04-14
(defun c:UpdateInstrumentLocation () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateInstrumentLocationMacro '())
)

; 2021-04-14
(defun UpdateInstrumentLocationMacro (/ entityNameList allPipeAndEquipHandleList relatedPipeData) 
  (setq allPipeAndEquipHandleList (GetAllPipeAndEquipHandleListUtils))
  ; must filter first
  (setq entityNameList 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; relatedid may be not in the allHandleList
                        (and (/= (cdr (assoc "version" (GetAllPropertyDictForOneBlock x))) "") 
                             (/= (member (cdr (assoc "version" (GetAllPropertyDictForOneBlock x))) allPipeAndEquipHandleList) nil)) 
                      ) 
      (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Instrument"))
    )
  ) 
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "version" x)))))
                                   ))
           ) 
    (GetBlockAllPropertyDictListUtils entityNameList)
  ) 
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "LOCATION") 
              (list 
                (if (assoc "tag" y) 
                  (GetDottedPairValueUtils "tag" y)
                  (GetDottedPairValueUtils "pipenum" y)
                ) 
              )
            )
          ) 
    entityNameList
    relatedPipeData 
  ) 
  (alert "更新完成")(princ)
)

; logic for generate Pipe
; refactored at 2021-04-09
(defun c:InsertBlockPipeArrowLeft () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockPipeArrowLeftMacro '())
)

; refactored at 2021-04-09
; refactored at 2021-07-07
(defun InsertBlockPipeArrowLeftMacro (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe"))
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowLeft")
  (ModifyBlockPropertyByDictDataUtils (entlast) (GetGsLcBlockPipePropertyDictList ss)) 
)

; refactored at 2021-04-09
(defun c:InsertBlockPipeArrowUp () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockPipeArrowUpMacro '())
)

; refactored at 2021-04-09
; refactored at 2021-07-07
(defun InsertBlockPipeArrowUpMacro (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe")) 
  (setq insPt (getpoint "\n选取垂直管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowUp")
  (ModifyBlockPropertyByDictDataUtils (entlast) (GetGsLcBlockPipePropertyDictList ss)) 
)

; 2021-03-11
; refactored at 2021-07-07
(defun GetGsLcBlockPipePropertyDictList (ss / sourceData equipmentData pipeData resultList)
  (setq sourceData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (setq equipmentData (car (FilterBlockEquipmentDataUtils sourceData)))
  (setq pipeData (car (FilterBlockPipeDataUtils sourceData)))
  (if (and (/= equipmentData nil)  (/= pipeData nil))
    (setq resultList 
      (list 
        (cons "VERSION" (GetDottedPairValueUtils "entityhandle" equipmentData))
        (cons "PIPENUM" (GetDottedPairValueUtils "pipenum" pipeData))
        (cons "SUBSTANCE" (GetDottedPairValueUtils "substance" equipmentData))
        (cons "TEMP" (GetDottedPairValueUtils "temp" equipmentData))
        (cons "PRESSURE" (GetDottedPairValueUtils "pressure" equipmentData))
        (cons "FROM" (GetDottedPairValueUtils "tag" equipmentData))
      )
    ) 
    (alert "必须选择一个设备和一个管道数据！")
  )
  resultList
)

; refactored at 2021-03-11
(defun InsertGsLcBlockPipe (insPt blockName /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcPipeLayer)
  (InsertBlockByNoPropertyUtils insPt blockName "0DataFlow-GsLcPipe")
)

; 2021-03-07
(defun VerifyGsLcPipeLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcPipe")
  (VerifyGsLcLayerByName "0DataFlow-GsLcPipeComment")
)

; logic for generate OuterPipeRight
; refactored at 2021-04-09
(defun c:InsertBlockOuterPipeRight () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockOuterPipeRightMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockOuterPipeRightMacro (/ ss insPt) 
  (prompt "\n选取管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取外管块的插入点："))
  (InsertGsLcBlockOuterPipe insPt "OuterPipeRight" (GetGsLcBlockOuterPipePropertyDict ss))
)

; refactored at 2021-04-09
(defun c:InsertBlockOuterPipeLeft () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockOuterPipeLeftMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockOuterPipeLeftMacro (/ ss insPt) 
  (prompt "\n选取管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取外管块的插入点："))
  (InsertGsLcBlockOuterPipe insPt "OuterPipeLeft" (GetGsLcBlockOuterPipePropertyDict ss))
)

; 2021-05-20
(defun c:InsertBlockOuterPipeDoubleArrow() 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockOuterPipeDoubleArrowMacro '())
)

; 2021-05-20
(defun InsertBlockOuterPipeDoubleArrowMacro (/ ss insPt) 
  (prompt "\n选取管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取外管块的插入点："))
  (InsertGsLcBlockOuterPipe insPt "OuterPipeDoubleArrow" (GetGsLcBlockOuterPipePropertyDict ss))
)

; 2021-03-08
(defun InsertGsLcBlockOuterPipe (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcOuterPipeLayer)
  (InsertBlockUtils insPt blockName "0DataFlow-GsLcOuterPipe" blockPropertyDict)
)

; 2021-03-07
(defun VerifyGsLcOuterPipeLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcOuterPipe")
  (VerifyGsLcLayerByName "0DataFlow-GsLcOuterPipeComment")
)

; 2021-03-08
(defun GetGsLcBlockOuterPipePropertyDict (ss / pipeData resultList)
  (setq pipeData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (if (/= pipeData nil) 
    (setq resultList (append resultList (list (cons 1 (cdr (assoc "pipenum" (car pipeData)))))))
  ) 
  resultList
)

; logic for generate PipeClassChange
; refactored at 2021-04-09
(defun c:InsertBlockPipeClassChange (/ ss insPt) 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockPipeClassChangeMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockPipeClassChangeMacro (/ ss insPt) 
  (prompt "\n选取包含等级号信息的 2 个管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取变等级块的插入点："))
  (InsertGsLcBlockPipeClassChange insPt "PipeClassChange" (GetGsLcBlockPipeClassChangePropertyDict ss))
)

; 2021-03-08
(defun InsertGsLcBlockPipeClassChange (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcValveLayer)
  (InsertBlockUtils insPt blockName "0DataFlow-GsLcValve" blockPropertyDict)
)

; 2021-03-07
(defun VerifyGsLcValveLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcValve")
  (VerifyGsLcLayerByName "0DataFlow-GsLcValveComment")
)

; 2021-03-08
(defun GetGsLcBlockPipeClassChangePropertyDict (ss / pipeData resultList)
  (setq pipeData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (if (/= pipeData nil) 
    (setq resultList (list (cons 1 (ExtractGsPipeClassUtils (GetDottedPairValueUtils "pipenum" (car pipeData)))) 
                       (cons 2 (ExtractGsPipeClassUtils (GetDottedPairValueUtils "pipenum" (cadr pipeData))))
                     ))
  ) 
  resultList
)

; logic for generate Ball Valve
; refactored at 2021-04-09
(defun c:InsertBlockLevelBallValve () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockLevelBallValveMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockLevelBallValveMacro (/ ss insPt) 
  (prompt "\n选取 1 个管道块")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取阀门插入点："))
  (InsertGsLcBlockBallValve insPt "BallValve" (GetGsLcBlockValvePropertyDict ss) 0)
)

; refactored at 2021-04-09
(defun c:InsertBlockVerticalBallValve () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockVerticalBallValveMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockVerticalBallValveMacro (/ ss insPt) 
  (prompt "\n选取 1 个管道块")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取阀门插入点："))
  (InsertGsLcBlockBallValve insPt "BallValve" (GetGsLcBlockValvePropertyDict ss) 1.57)
)

; 2021-04-05
(defun InsertGsLcBlockBallValve (insPt blockName blockPropertyDict rotate /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcValveLayer)
  (InsertBlockByRotateUtils insPt blockName "0DataFlow-GsLcValve" blockPropertyDict rotate)
)

; 2021-04-05
(defun GetGsLcBlockValvePropertyDict (ss / pipeData resultList)
  (setq pipeData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (if (/= pipeData nil) 
    (setq resultList (list (cons 1 (GetDottedPairValueUtils "pipenum" (car pipeData)))
                     ))
  ) 
  resultList
)

; logic for generate Reducer
; refactored at 2021-04-09
(defun c:InsertBlockReducer () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockReducerMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockReducerMacro (/ ss insPt) 
  (prompt "\n选取包含管径信息的 2 个管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取异径管块的插入点："))
  (InsertGsLcBlockReducer insPt "Reducer" (GetGsLcBlockReducerPropertyDict ss))
)

; 2021-03-08
(defun InsertGsLcBlockReducer (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcValveLayer)
  (InsertBlockUtils insPt blockName "0DataFlow-GsLcValve" blockPropertyDict)
)

; 2021-03-08
(defun GetGsLcBlockReducerPropertyDict (ss / pipeData resultList)
  (setq pipeData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (if (/= pipeData nil) 
    (setq resultList (list (cons 1 
                              (strcat (ExtractGsPipeDiameterUtils (GetDottedPairValueUtils "pipenum" (car pipeData))) 
                                      "x"
                                      (ExtractGsPipeDiameterUtils (GetDottedPairValueUtils "pipenum" (cadr pipeData))))
                           )
                     ))
  ) 
  resultList
)

; logic for generate EquipTag
; refactored at 2021-04-09
(defun c:InsertBlockGsLcReactor () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcReactorMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcReactorMacro (/ insPt) 
  (setq insPt (getpoint "\n选取反应釜位号插入点："))
  (VerifyGsLcBlockByName "Reactor")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Reactor" "0DataFlow-GsLcEquipTag" (list (cons 1 "R")))
)


; refactored at 2021-04-09
(defun c:InsertBlockGsLcTank () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcTankMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcTankMacro (/ insPt) 
  (setq insPt (getpoint "\n选取储罐位号插入点："))
  (VerifyGsLcBlockByName "Tank")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Tank" "0DataFlow-GsLcEquipTag" (list (cons 1 "V")))
)

; refactored at 2021-04-09
(defun c:InsertBlockGsLcPump () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcPumpMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcPumpMacro (/ insPt) 
  (setq insPt (getpoint "\n选取输送泵位号插入点："))
  (VerifyGsLcBlockByName "Pump")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Pump" "0DataFlow-GsLcEquipTag" (list (cons 1 "P")))
)

; refactored at 2021-04-09
(defun c:InsertBlockGsLcHeater () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcHeaterMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcHeaterMacro (/ insPt) 
  (setq insPt (getpoint "\n选取换热器位号插入点："))
  (VerifyGsLcBlockByName "Heater")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Heater" "0DataFlow-GsLcEquipTag" (list (cons 1 "E")))
)

; refactored at 2021-04-09
(defun c:InsertBlockGsLcCentrifuge () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcCentrifugeMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcCentrifugeMacro (/ insPt) 
  (setq insPt (getpoint "\n选取离心机位号插入点："))
  (VerifyGsLcBlockByName "Centrifuge")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Centrifuge" "0DataFlow-GsLcEquipTag" (list (cons 1 "M")))
)

; refactored at 2021-04-09
(defun c:InsertBlockGsLcVacuum () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcVacuumMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcVacuumMacro (/ insPt) 
  (setq insPt (getpoint "\n选取真空泵位号插入点："))
  (VerifyGsLcBlockByName "Vacuum")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Vacuum" "0DataFlow-GsLcEquipTag" (list (cons 1 "P")))
)

; refactored at 2021-04-09
(defun c:InsertBlockGsLcCustomEquip () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsLcCustomEquipMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsLcCustomEquipMacro (/ insPt) 
  (setq insPt (getpoint "\n选取自定义设备位号插入点："))
  (VerifyGsLcBlockByName "CustomEquip")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "CustomEquip" "0DataFlow-GsLcEquipTag" (list (cons 1 "X")))
)

; 2021-03-07
(defun VerifyGsLcEquipTagLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcEquipTag")
  (VerifyGsLcLayerByName "0DataFlow-GsLcEquipTagComment")
)

; logic for generate PublicPipe
(defun InsertPublicPipe (dataList pipeSourceDirection / lastEntityName insPt insPtList) 
  (VerifyGsLcBlockPublicPipe)
  (setq lastEntityName (entlast))
  (setq insPt (getpoint "\n选取辅助流程组件插入点："))
  (setq dataList (ProcessPublicPipeElementData dataList))
  ; sort data by drawnum
  (setq dataList (vl-sort dataList '(lambda (x y) (< (nth 4 x) (nth 4 y)))))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList dataList 0) 10))
  (cond 
    ((= pipeSourceDirection "0") (GenerateDownPublicPipe insPtList dataList))
    ((= pipeSourceDirection "1") (GenerateUpPublicPipe insPtList dataList))
  )
)

(defun GenerateUpPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeUpArrow x (nth 2 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeUpPipeLine (MoveInsertPositionUtils x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "0DataFlow-GsLcPublicPipeLine" 0.6)
          ) 
          insPtList
          dataList
  )
)

(defun GenerateDownPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeDownArrow x (nth 3 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeDownPipeLine (MoveInsertPositionUtils x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "0DataFlow-GsLcPublicPipeLine" 0.6)
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

; refactored at 2021-04-09
(defun c:UpdatePublicPipe () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdatePublicPipeMacro '())
)

; refactored at 2021-04-09
(defun UpdatePublicPipeMacro ()
  (UpdatePublicPipeByDataType "PublicPipeUpArrow")
  (UpdatePublicPipeByDataType "PublicPipeDownArrow")
  (UpdatePublicPipeByDataType "PublicPipeLine")
  (alert "更新完成")(princ)
)

; 2021-04-14
(defun FilterEntityNameListForUpdate (dataType relatedIDProperty allHandleList /)
  (vl-remove-if-not '(lambda (x) 
                      (and (/= (GetDottedPairValueUtils relatedIDProperty (GetAllPropertyDictForOneBlock x)) "") 
                            (/= (member (GetDottedPairValueUtils relatedIDProperty (GetAllPropertyDictForOneBlock x)) allHandleList) nil)) 
                    ) 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  ) 
)

; refactor at 2021-04-14
(defun UpdatePublicPipeByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  ; must filter first
  (setq entityNameList 
    ; relatedid value maybe null
    ; repair bug - JoinDrawArrow's relatedid may be not in the allPipeHandleList - 2020.12.22
    ; refactor at 2021-01-27 
    (FilterEntityNameListForUpdate dataType "relatedid" allPipeHandleList)
  )  
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    (GetBlockAllPropertyDictListUtils entityNameList)
  )
  ; (PrintErrorLogForUpdatePublicPipe dataType (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType)) allPipeHandleList) 
  (UpdatePublicPipeStrategy dataType entityNameList relatedPipeData)
)

(defun PrintErrorLogForUpdatePublicPipe (dataType entityNameList allPipeHandleList /)
  (if (= dataType "PublicPipeLine") 
    (mapcar '(lambda (x) 
              (prompt "\n")
              (prompt (strcat "原主流程中的管道" (cdr (assoc "pipenum" x)) "属性块被同步或被删除了，无法同步数据！"))
            ) 
      ; refactor at 2021-01-30
      (vl-remove-if-not '(lambda (x) 
                          (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                        ) 
        (GetBlockAllPropertyDictListUtils entityNameList)
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

; refactored at 2021-04-09
(defun c:UpdateJoinDrawArrow () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateJoinDrawArrowMacro '())
)

; refactored at 2021-04-09
(defun UpdateJoinDrawArrowMacro ()
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowTo")
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowFrom")
  (alert "更新完成")(princ)
)

; refactor at 2021-04-14
(defun UpdateJoinDrawArrowByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  ; must filter first
  (setq entityNameList 
    ; relatedid value maybe null
    ; repair bug - JoinDrawArrow's relatedid may be not in the allPipeHandleList - 2020.12.22
    ; refactor at 2021-01-27 
    (FilterEntityNameListForUpdate dataType "relatedid" allPipeHandleList)
  )  
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    (GetBlockAllPropertyDictListUtils entityNameList)
  )
  ; (mapcar '(lambda (x) 
  ;            (prompt "\n")
  ;            (prompt (strcat (cdr (assoc "fromto" x)) "（" (cdr (assoc "drawnum" x)) "）" "关联的管道数据id是不存在的！"))
  ;          ) 
  ;   ; refactor at 2021-01-27
  ;   (vl-remove-if-not '(lambda (x) 
  ;                       (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
  ;                     ) 
  ;     (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType)))
  ;   )
  ; ) 
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
                    (strcat "自" (cdr (assoc "from" y)) (GetEquipChNameByEquipTag (cdr (assoc "from" y))))
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
                    (strcat "去" (cdr (assoc "to" y)) (GetEquipChNameByEquipTag (cdr (assoc "to" y))))
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

; refactored at 2021-04-09
(defun c:GenerateJoinDrawArrow () 
  (ExecuteFunctionAfterVerifyDateUtils 'GenerateJoinDrawArrowMacro '())
)

; refactored at 2021-04-09
; refactored at 2021-07-07
(defun GenerateJoinDrawArrowMacro (/ pipeEntityNameList insPt insPtList pipeData)
  (VerifyGsLcBlockByName "JoinDrawArrowTo")
  (VerifyGsLcBlockByName "JoinDrawArrowFrom")
  (VerifyGsLcLayerByName "0DataFlow-GsLcJoinDrawArrow")
  (prompt "\n选择生成接图箭头的边界管道：")
  (setq pipeEntityNameList (GetEntityNameListBySSUtils (GetPipeSSBySelectUtils)))
  (setq insPt (getpoint "\n选取接图箭头的插入点："))
  (setq insPtList (GetInsertPtListByYMoveUtils insPt (GenerateSortedNumByList pipeEntityNameList 0) -11))
  (mapcar '(lambda (x y) 
             (setq pipeData (GetAllPropertyDictForOneBlock x))
              (GenerateJoinDrawArrowToElement y 
                ; add the Equip ChName - 2021-03-30
                (strcat "去" (cdr (assoc "to" pipeData)) (GetEquipChNameByEquipTag (cdr (assoc "to" pipeData)))) 
                (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
                (cdr (assoc "entityhandle" pipeData)) 
              )
              (GenerateJoinDrawArrowFromElement (MoveInsertPositionUtils y 20 0)
                (cdr (assoc "pipenum" pipeData)) 
                ; add the Equip ChName - 2021-03-30
                (strcat "自" (cdr (assoc "from" pipeData)) (GetEquipChNameByEquipTag (cdr (assoc "from" pipeData))))
                (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" pipeData))))
                (cdr (assoc "entityhandle" pipeData)) 
              )
          ) 
    pipeEntityNameList
    insPtList
  ) 
  (princ)
)

(defun GetRelatedEquipDataByTag (tag / equipData) 
  ; repair bug - the tag may contain space, trim the space frist - 2020.12.21
  (setq tag (StringSubstUtils "" " " tag))
  (setq equipData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllEquipmentSSUtils))))
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
    (setq result "无此设备")
  )
  result
)

; Generate GsLcBlocks
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
; Generate GsLcEquipData By Import CSV

; refactored at 2021-04-09
(defun c:ImportGsLcEquipData ()
  (ExecuteFunctionAfterVerifyDateUtils 'ImportEquipDataStrategyByBox '("importGsEquipDataBox" "GsLcData"))
  ; refactored at 2021-04-12
  (PurgeAllUtils)
)

; 2021-03-09
(defun InsertGsLcEquipTag (itemData insPtList dataType /) 
  (mapcar '(lambda (x y) 
             (InsertBlockLcBzEquipTagStrategy y dataType)
             (cons (entlast) (cdr x))
          ) 
    itemData
    insPtList
  )  
)

; 2021-03-18
(defun InsertBlockLcBzEquipTagStrategy (insPt dataType /) 
  (VerifyGsLcBlockByName dataType)
  (InsertBlockByNoPropertyUtils insPt dataType "0DataFlow-GsLcEquipTag")
)

; Generate GsLcEquipData By Import CSV
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Test Zoom

; 2021-03-25
(defun InsertDynamicBlock (/ insPt) 
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (InsertTestDynamicBlock insPt "HGCAD动态块#管法兰.PL.PN16")
)

; 2021-03-25
(defun InsertTestDynamicBlock (insPt blockName /) 
  ;(VerifyGsLcBlockByName blockName)
  (VerifyGsLcPipeLayer)
  (InsertBlockByNoPropertyUtils insPt blockName "0DataFlow-GsLcPipe")
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "DN" "PN16 DN40") (cons "_H" "L=100"))
  )
)

; Test Zoom
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;