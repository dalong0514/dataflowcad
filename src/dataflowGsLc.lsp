;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

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
  (setq sourceData (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils ss)))
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
; 2021-03-07
(defun c:InsertBlockPipeArrowLeft (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe"))
  (setq insPt (getpoint "\n选取水平管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowLeft" (GetGsLcBlockPipePropertyDict ss))
)

; 2021-03-07
(defun c:InsertBlockPipeArrowUp (/ ss insPt) 
  (prompt "\n选取设备块和管道块：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "EquipmentAndPipe")) 
  (setq insPt (getpoint "\n选取垂直管道插入点："))
  (InsertGsLcBlockPipe insPt "PipeArrowUp" (GetGsLcBlockPipePropertyDict ss))
)

; 2021-03-07
(defun InsertGsLcBlockPipe (insPt blockName blockPropertyDict /) 
  (VerifyGsLcBlockByName blockName)
  (VerifyGsLcPipeLayer)
  (InsertBlockUtils insPt blockName "0DataFlow-GsLcPipe" blockPropertyDict)
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
  (setq pipeData (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils ss)))
  (if (/= pipeData nil) 
    (setq resultList (append resultList (list (cons 1 (cdr (assoc "pipenum" (car pipeData)))))))
  ) 
  resultList
)





