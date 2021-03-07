;冯大龙编于 2020-2021 年
(vl-load-com)


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
  (setq insPt (getpoint "\n选取设备位号的插入点："))
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
(defun c:InsertBlockInstrumentP (/ insPt) 
  (setq insPt (getpoint "\n选取集中仪表插入点："))
  (VerifyGsLcBlockByName "InstrumentP")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentP")
)

(defun c:InsertBlockInstrumentL (/ insPt) 
  (setq insPt (getpoint "\n选取就地仪表插入点："))
  (VerifyGsLcBlockByName "InstrumentL")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentL")
)

(defun c:InsertBlockInstrumentSIS (/ insPt) 
  (setq insPt (getpoint "\n选取SIS仪表插入点："))
  (VerifyGsLcBlockByName "InstrumentSIS")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentSIS")
)

(defun GenerateBlockInstrumentP (insPt blockName /) 
  (GenerateBlockReference insPt blockName "DataFlow-Instrument") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 4) "VERSION" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 0.5) "FUNCTION" "xxxx" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -3.5) "TAG" "xxxx" "0" 3 0 0 1)
  (if (/= blockName "InstrumentL") 
    (progn 
      (GenerateLeftBlockAttribute (MoveInsertPosition insPt 6.5 2.4) "HALARM" "" "0" 3 0 0 0)
      (GenerateLeftBlockAttribute (MoveInsertPosition insPt 6.5 -5) "LALARM" "" "0" 3 0 0 0) 
    )
  )
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 2) "SUBSTANCE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 0) "TEMP" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -2) "PRESSURE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -6) "SORT" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -12) "PHASE" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -14) "MATERIAL" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -16) "NAME" "" "DataFlow-InstrumentComment" 1.5 0 1 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -4) "LOCATION" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -18) "MIN" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -20) "MAX" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -22) "NOMAL" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -24) "DRAWNUM" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -26) "INSTALLSIZE" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -28) "COMMENT" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -30) "DIRECTION" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -8) "PIPECLASSCHANGE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -10) "REDUCERINFO" "" "DataFlow-InstrumentComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; logic for generate Pipe
(defun c:InsertBlockPipeArrowLeft (/ insPt) 
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (VerifyGsLcBlockByName "PipeArrowLeft")
  (VerifyGsLcLayerByName "DataFlow-Pipe")
  (VerifyGsLcLayerByName "DataFlow-PipeComment")
  (GenerateBlockPipeArrowLeft insPt)
)

(defun c:InsertBlockPipeArrowUp (/ insPt) 
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (VerifyGsLcBlockByName "PipeArrowUp")
  (VerifyGsLcLayerByName "DataFlow-Pipe")
  (VerifyGsLcLayerByName "DataFlow-PipeComment")
  (GenerateBlockPipeArrowUp insPt)
)

(defun GenerateBlockPipeArrowLeft (insPt /) 
  (GenerateBlockReference insPt "PipeArrowLeft" "DataFlow-Pipe") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -1) "VERSION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 2) "PIPENUM" "xxxx" "0" 3 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 6) "SUBSTANCE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -10 6) "TEMP" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -6.5 6) "PRESSURE" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -5) "PHASE" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -1 6) "FROM" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8 6) "TO" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -9) "DRAWNUM" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -7) "INSULATION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -3) "PIPECLASSCHANGE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -12 -3) "REDUCERINFO" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateBlockPipeArrowUp (insPt /) 
  (GenerateBlockReference insPt "PipeArrowUp" "DataFlow-Pipe") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 4) "VERSION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -2 -20) "PIPENUM" "xxxx" "0" 3 1.57 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 2) "SUBSTANCE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 0) "TEMP" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -2) "PRESSURE" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -12) "PHASE" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -4) "FROM" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -6) "TO" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -14) "DRAWNUM" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -16) "INSULATION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -8) "PIPECLASSCHANGE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -10) "REDUCERINFO" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)


; logic for generate EquipTag
; 2021-03-07 refactored
(defun c:InsertBlockGsLcReactor (/ insPt) 
  (setq insPt (getpoint "\n选取反应釜位号插入点："))
  (VerifyGsLcBlockByName "Reactor")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Reactor" "DataFlow-EquipTag" (list (cons 1 "R")))
)

; 2021-03-07 refactored
(defun c:InsertBlockGsLcTank (/ insPt) 
  (setq insPt (getpoint "\n选取储罐位号插入点："))
  (VerifyGsLcBlockByName "Tank")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Tank" "DataFlow-EquipTag" (list (cons 1 "V")))
)

; 2021-03-07
(defun c:InsertBlockGsLcPump (/ insPt) 
  (setq insPt (getpoint "\n选取输送泵位号插入点："))
  (VerifyGsLcBlockByName "Pump")
  (VerifyGsLcEquipTagLayer)
  (InsertBlockUtils insPt "Pump" "DataFlow-EquipTag" (list (cons 1 "P")))
)

; 2021-03-07
(defun VerifyGsLcEquipTagLayer () 
  (VerifyGsLcLayerByName "DataFlow-EquipTag")
  (VerifyGsLcLayerByName "DataFlow-EquipTagComment")
)

; the function is abandoned - 2021-03-07
(defun GenerateBlockGsLcReactor (insPt /) 
  (GenerateBlockReference insPt "Reactor" "DataFlow-EquipTag") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 0 5) "VERSION" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 1) "TAG" "R" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -4.5) "NAME" "xxxx" "DataFlow-EquipTagComment" 3 0 0 1)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -7.5) "SPECIES" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -9.5) "VOLUME" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -13.5) "SUBSTANCE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -15.5) "TEMP" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -17.5) "PRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -11.5) "POWER" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -21.5) "ANTIEXPLOSIVE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -23.5) "MOTORSERIES" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -25.5) "SPEED" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -19.5) "SIZE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -27.5) "MATERIAL" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -29.5) "WEIGHT" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -31.5) "TYPE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -33.5) "INSULATIONTHICK" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -35.5) "NUMBER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -37.5) "DRAWNUM" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -39.5) "EXTEMP" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -41.5) "EXPRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; the function is abandoned - 2021-03-07
(defun GenerateBlockGsLcTank (insPt /) 
  (GenerateBlockReference insPt "Tank" "DataFlow-EquipTag") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 0 5) "VERSION" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 1) "TAG" "V" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -4.5) "NAME" "xxxx" "DataFlow-EquipTagComment" 3 0 0 1)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -7.5) "SPECIES" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -9.5) "VOLUME" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -11.5) "SUBSTANCE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -13.5) "TEMP" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -15.5) "PRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -19.5) "POWER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -21.5) "ANTIEXPLOSIVE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -23.5) "MOTORSERIES" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -17.5) "SIZE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -25.5) "MATERIAL" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -27.5) "WEIGHT" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -29.5) "TYPE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -31.5) "INSULATIONTHICK" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -33.5) "NUMBER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -35.5) "DRAWNUM" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -37.5) "EXTEMP" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -39.5) "EXPRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)



; logic for generate PublicPipe
(defun InsertPublicPipe (dataList pipeSourceDirection / lastEntityName insPt insPtList) 
  (VerifyGsLcBlockPublicPipe)
  (setq lastEntityName (entlast))
  (setq insPt (getpoint "\n选取辅助流程组件插入点："))
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
      (GetAllPropertyValueListByEntityNameList entityNameList)
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
        (GetAllPropertyValueListByEntityNameList entityNameList)
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
      (GetAllPropertyValueListByEntityNameList entityNameList)
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
      (GetAllPropertyValueListByEntityNameList entityNameList)
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
  (VerifyGsLcLayerByName "DataFlow-JoinDrawArrow")
  (prompt "\n选择生成接图箭头的边界管道：")
  (setq pipeSS (GetPipeSSBySelectUtils))
  (setq pipeData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils pipeSS))))
  (setq insPt (getpoint "\n选取接图箭头的插入点："))
  (GenerateJoinDrawArrowToElement insPt
    (strcat "去" (cdr (assoc "to" pipeData))) 
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  )
  (GenerateJoinDrawArrowFromElement (MoveInsertPosition insPt 20 0)
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
  (setq equipData (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllEquipmentSSUtils))))
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