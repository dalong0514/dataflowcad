;·ë´óÁú±àÓÚ 2020-2021 Äê
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Steal Gs AutoCAD Modules

; 2021-03-03
(defun GetGsLcModulesPath (/ result)
  (setq result "D:\\dataflowcad\\allBlocks\\GsLcBlocks.dwg")
)

; 2021-03-09
(defun GetGsBzModulesPath (/ result)
  (setq result "D:\\dataflowcad\\allBlocks\\GsBzBlocks.dwg")
)

; 2021-03-17
(defun GetNsBzModulesPath (/ result)
  (setq result "D:\\dataflowcad\\allBlocks\\NsBzBlocks.dwg")
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
(defun StealAllGsBzEquipBlocks ()
  (Steal (GetGsBzModulesPath) 
    '(
      ("Blocks" ("GsBz*"))
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

; 2021-03-09
(defun StealGsBzBlockByNameList (blockNameList /)
  (Steal (GetGsBzModulesPath) 
    (list 
      (list "Blocks" blockNameList)
    )
  ) 
)

; 2021-03-09
(defun StealGsBzLayerByNameList (layerNameList /)
  (Steal (GetGsBzModulesPath) 
    (list 
      (list "Layers" layerNameList)
    )
  ) 
)

; 2021-03-17
(defun StealNsBzBlockByNameList (blockNameList /)
  (Steal (GetNsBzModulesPath) 
    (list 
      (list "Blocks" blockNameList)
    )
  ) 
)

; 2021-03-17
(defun StealNsBzLayerByNameList (layerNameList /)
  (Steal (GetNsBzModulesPath) 
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

; 2021-03-09
(defun VerifyGsBzBlockByName (blockName /) 
  (if (= (tblsearch "BLOCK" blockName) nil) 
    (StealGsBzBlockByNameList (list blockName))
  )
)

; 2021-03-09
(defun VerifyGsBzLayerByName (layerName /) 
  (if (= (tblsearch "LAYER" layerName) nil) 
    (StealGsBzLayerByNameList (list layerName))
  )
)

; 2021-03-17
(defun VerifyNsBzBlockByName (blockName /) 
  (if (= (tblsearch "BLOCK" blockName) nil) 
    (StealNsBzBlockByNameList (list blockName))
  )
)

; 2021-03-17
(defun VerifyNsBzLayerByName (layerName /) 
  (if (= (tblsearch "LAYER" layerName) nil) 
    (StealNsBzLayerByNameList (list layerName))
  )
)

; 2021-03-05
(defun VerifyGsLcBlockPublicPipe () 
  (VerifyGsLcBlockByName "PublicPipe*") ; refactored at 2021-03-09
  (VerifyGsLcLayerByName "0DataFlow-GsLcPublicPipe")
  (VerifyGsLcLayerByName "0DataFlow-GsLcPublicPipeLine")
)

; Steal Gs AutoCAD Modules
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Functon in GenerateGraph

; Unit Test Compeleted
; refactored at 2021-03-12
(defun MoveInsertPositionUtils (insPt xOffset yOffset / result) 
  (list (+ (car insPt) xOffset) (+ (cadr insPt) yOffset) (caddr insPt))
)

; Utils Functon in GenerateGraph
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
; Generate SS Object in CAD

; refactored at 2021-02-07
(defun GenerateOneFireFightHPipe (insPt pipenum pipeDiameter relatedIDValue textHeight /) 
  (GenerateBlockReference insPt "FireFightHPipe" "DataflowFireFightPipe")
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 150 60) "PIPENUM" pipenum "0" textHeight)
  (GenerateBlockAttribute (MoveInsertPositionUtils insPt 150 -420) "PIPEDIAMETER" pipeDiameter "0" textHeight)
  (GenerateBlockHiddenAttribute (MoveInsertPositionUtils insPt 150 -720) "RELATEDID" relatedIDValue "DataflowFireFightPipe" 150)
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