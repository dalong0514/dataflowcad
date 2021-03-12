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

