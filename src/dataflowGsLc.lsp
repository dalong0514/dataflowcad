;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
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

(defun c:EquipTag (/ ss equipInfoList insPt insPtList)
  (VerifyGsLcBlockByName "EquipTagV2")
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\n选取设备位号的插入点："))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList equipInfoList 0) 30))
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
(defun c:InsertBlockInstrumentP (/ ss insPt) 
  (prompt "\n选取设备块和仪表块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe")) 
  (setq insPt (getpoint "\n选取集中仪表插入点："))
  (InsertGsLcBlockInstrument insPt "InstrumentP" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentP")) 
)

(defun c:InsertBlockInstrumentL (/ ss insPt) 
  (prompt "\n选取设备块和仪表块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe"))  
  (setq insPt (getpoint "\n选取就地仪表插入点："))
  (InsertGsLcBlockInstrument insPt "InstrumentL" (GetGsLcBlockInstrumentPropertyDict ss "InstrumentL")) 
)

(defun c:InsertBlockInstrumentSIS (/ ss insPt) 
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

(defun GetInstrumentPropertyIDListStrategy (dataType /)
  (cond 
    ((= dataType "InstrumentP") 
     (list (cons 0 "entityhandle") (cons 5 "substance") (cons 6 "temp") (cons 7 "pressure") (cons 12 "tag")))
    ((= dataType "InstrumentL") 
     (list (cons 0 "entityhandle") (cons 3 "substance") (cons 4 "temp") (cons 5 "pressure") (cons 10 "tag")))
  ) 
)
  
(defun GetPipePropertyIDListStrategy (dataType /)
  (cond 
    ((= dataType "InstrumentP") 
     (list (cons 0 "entityhandle") (cons 5 "substance") (cons 6 "temp") (cons 7 "pressure") (cons 12 "pipenum")))
    ((= dataType "InstrumentL") 
     (list (cons 0 "entityhandle") (cons 3 "substance") (cons 4 "temp") (cons 5 "pressure") (cons 10 "pipenum")))
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


; logic for generate Pipe
; refactored at 2021-03-11
(defun c:InsertBlockPipeArrowLeft (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe"))
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowLeft")
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    '("PIPENUM" "VERSION" "SUBSTANCE" "TEMP" "PRESSURE" "FROM")  
    (GetGsLcBlockPipePropertyValueList ss)) 
  ;(princ)
)

; 2021-03-07
; refactored at 2021-03-11
(defun c:InsertBlockPipeArrowUp (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe")) 
  (setq insPt (getpoint "\n选取垂直管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowUp")
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    '("PIPENUM" "VERSION" "SUBSTANCE" "TEMP" "PRESSURE" "FROM")  
    (GetGsLcBlockPipePropertyValueList ss)) 
)

; 2021-03-07
; refactored at 2021-03-11
(defun InsertGsLcBlockPipe (insPt blockName /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcPipeLayer)
  (InsertBlockByNoPropertyUtils insPt blockName "0DataFlow-GsLcPipe")
)

; 2021-03-11
(defun GetGsLcBlockPipePropertyValueList (ss / sourceData equipmentData pipeData resultList)
  (setq sourceData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (setq equipmentData (FilterBlockEquipmentDataUtils sourceData))
  (setq pipeData (FilterBlockPipeDataUtils sourceData))
  (if (/= equipmentData nil) 
      (mapcar '(lambda (x) 
                (setq resultList (append resultList (list (cdr (assoc x (car equipmentData))))))
              ) 
        '("entityhandle" "substance" "temp" "pressure" "tag")
      ) 
  )
  (if (/= pipeData nil) 
    (setq resultList (cons (cdr (assoc "pipenum" (car pipeData))) resultList))
  ) 
  resultList
)

; 2021-03-07
(defun VerifyGsLcPipeLayer () 
  (VerifyGsLcLayerByName "0DataFlow-GsLcPipe")
  (VerifyGsLcLayerByName "0DataFlow-GsLcPipeComment")
)

; logic for generate OuterPipeRight
; 2021-03-08
(defun c:InsertBlockOuterPipeRight (/ ss insPt) 
  (prompt "\n选取管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取外管块的插入点："))
  (InsertGsLcBlockOuterPipe insPt "OuterPipeRight" (GetGsLcBlockOuterPipePropertyDict ss))
)

; 2021-03-08
(defun c:InsertBlockOuterPipeLeft (/ ss insPt) 
  (prompt "\n选取管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "Pipe"))
  (setq insPt (getpoint "\n选取外管块的插入点："))
  (InsertGsLcBlockOuterPipe insPt "OuterPipeLeft" (GetGsLcBlockOuterPipePropertyDict ss))
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
; 2021-03-08
(defun c:InsertBlockPipeClassChange (/ ss insPt) 
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

; logic for generate Reducer
; 2021-03-08
(defun c:InsertBlockReducer (/ ss insPt) 
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
; 2021-03-07 refactored
(defun c:InsertBlockGsLcReactor (/ insPt) 
  (setq insPt (getpoint "\n选取反应釜位号插入点："))
  (VerifyGsLcBlockByName "Reactor")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Reactor" "0DataFlow-GsLcEquipTag" (list (cons 1 "R")))
)

; 2021-03-07 refactored
(defun c:InsertBlockGsLcTank (/ insPt) 
  (setq insPt (getpoint "\n选取储罐位号插入点："))
  (VerifyGsLcBlockByName "Tank")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Tank" "0DataFlow-GsLcEquipTag" (list (cons 1 "V")))
)

; 2021-03-07
(defun c:InsertBlockGsLcPump (/ insPt) 
  (setq insPt (getpoint "\n选取输送泵位号插入点："))
  (VerifyGsLcBlockByName "Pump")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Pump" "0DataFlow-GsLcEquipTag" (list (cons 1 "P")))
)

; 2021-03-07
(defun c:InsertBlockGsLcHeater (/ insPt) 
  (setq insPt (getpoint "\n选取换热器位号插入点："))
  (VerifyGsLcBlockByName "Heater")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Heater" "0DataFlow-GsLcEquipTag" (list (cons 1 "E")))
)

; 2021-03-07
(defun c:InsertBlockGsLcCentrifuge (/ insPt) 
  (setq insPt (getpoint "\n选取离心机位号插入点："))
  (VerifyGsLcBlockByName "Centrifuge")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Centrifuge" "0DataFlow-GsLcEquipTag" (list (cons 1 "M")))
)

; 2021-03-07
(defun c:InsertBlockGsLcVacuum (/ insPt) 
  (setq insPt (getpoint "\n选取真空泵位号插入点："))
  (VerifyGsLcBlockByName "Vacuum")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Vacuum" "0DataFlow-GsLcEquipTag" (list (cons 1 "P")))
)

; 2021-03-07
(defun c:InsertBlockGsLcCustomEquip (/ insPt) 
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

(defun c:UpdatePublicPipe ()
  (UpdatePublicPipeByDataType "PublicPipeUpArrow")
  (UpdatePublicPipeByDataType "PublicPipeDownArrow")
  (UpdatePublicPipeByDataType "PublicPipeLine")
  (alert "更新完成")(princ)
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
      (GetBlockAllPropertyDictListUtils entityNameList)
    )
  )
  (PrintErrorLogForUpdatePublicPipe dataType entityNameList allPipeHandleList) 
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

(defun c:UpdateJoinDrawArrow ()
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowTo")
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowFrom")
  (alert "更新完成")(princ)
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
      (GetBlockAllPropertyDictListUtils entityNameList)
    )
  )
  (mapcar '(lambda (x) 
             (prompt "\n")
             (prompt (strcat (cdr (assoc "fromto" x)) "（" (cdr (assoc "drawnum" x)) "）" "关联的管道数据id是不存在的！"))
           ) 
    ; refactor at 2021-01-27
    (vl-remove-if-not '(lambda (x) 
                        (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetBlockAllPropertyDictListUtils entityNameList)
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

(defun c:GenerateJoinDrawArrow (/ pipeSS pipeData insPt entityNameList)
  (VerifyGsLcBlockByName "JoinDrawArrowTo")
  (VerifyGsLcBlockByName "JoinDrawArrowFrom")
  (VerifyGsLcLayerByName "0DataFlow-GsLcJoinDrawArrow")
  (prompt "\n选择生成接图箭头的边界管道：")
  (setq pipeSS (GetPipeSSBySelectUtils))
  (setq pipeData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils pipeSS))))
  (setq insPt (getpoint "\n选取接图箭头的插入点："))
  (GenerateJoinDrawArrowToElement insPt
    (strcat "去" (cdr (assoc "to" pipeData))) 
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  )
  (GenerateJoinDrawArrowFromElement (MoveInsertPositionUtils insPt 20 0)
    (cdr (assoc "pipenum" pipeData)) 
    (strcat "自" (cdr (assoc "from" pipeData)))
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
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

; 2021-03-18
(defun c:ImportGsLcEquipData ()
  (ImportEquipDataStrategyByBox "importGsEquipDataBox" "GsLcData")
)


; Generate GsLcEquipData By Import CSV
;;;-------------------------------------------------------------------------;;;