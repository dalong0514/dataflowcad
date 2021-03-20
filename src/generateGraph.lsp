;冯大龙编于 2020-2021 年
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

; 2021-03-17
(defun StealNsBzTextStyleByNameList (textStyleNameList /)
  (Steal (GetNsBzModulesPath) 
    (list 
      (list "Text Styles" textStyleNameList)
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

; 2021-03-17
(defun VerifyNsBzTextStyleByName (textStyleName /) 
  (if (= (tblsearch "STYLE" textStyleName) nil) 
    (StealNsBzTextStyleByNameList (list textStyleName))
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

; 2021-03-08
(defun InsertBlockUtils (insPt blockName layerName propertyDictList / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName 1 1 1 0))
  ;(vlax-dump-object blockRefObj T)
  (vlax-put-property blockRefObj 'Layer layerName)
  (setq blockAttributes (vlax-variant-value (vla-GetAttributes blockRefObj)))
  ; another method get the blockAttributes
  ;(setq blockAttributes (vlax-variant-value (vlax-invoke-method blockRefObj 'GetAttributes)))
  ;(vlax-safearray->list blockAttributes)
  ; setting block property value
  (mapcar '(lambda (x) 
            (vla-put-TextString (vlax-safearray-get-element blockAttributes (car x)) (cdr x))
          ) 
    propertyDictList
  ) 
  ;(vla-ZoomAll acadObj) 
  (princ)
)

; 2021-03-17
(defun InsertBlockByScaleUtils (insPt blockName layerName propertyDictList scale / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName scale scale scale 0))
  (vlax-put-property blockRefObj 'Layer layerName)
  (setq blockAttributes (vlax-variant-value (vla-GetAttributes blockRefObj)))
  (mapcar '(lambda (x) 
            (vla-put-TextString (vlax-safearray-get-element blockAttributes (car x)) (cdr x))
          ) 
    propertyDictList
  ) 
  (princ)
)

; 2021-03-11
; Isomerism function for InsertBlockUtils, need no propertyDictList
(defun InsertBlockByNoPropertyUtils (insPt blockName layerName / acadObj curDoc insertionPnt modelSpace blockRefObj)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName 1 1 1 0))
  (vlax-put-property blockRefObj 'Layer layerName)
  (princ)
)

; Unit Test Compeleted
; refactored at 2021-03-12
(defun MoveInsertPositionUtils (insPt xOffset yOffset / result) 
  (list (+ (car insPt) xOffset) (+ (cadr insPt) yOffset) (caddr insPt))
)

; refactored at 2021-03-12
(defun MoveTwoDimPositionUtils (insPt xOffset yOffset / result) 
  (list (+ (car insPt) xOffset) (+ (cadr insPt) yOffset))
)

; Utils Functon in GenerateGraph
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate CAD Graph Utils Function 

; 2021-02-02
(defun GenerateLineByPosition (firstPt secondPt lineLayer /)
  (entmake (list (cons 0 "LINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 lineLayer) (cons 100 "AcDbText") 
                  (cons 10 firstPt) (cons 11 secondPt) (cons 210 '(0.0 0.0 1.0)) 
             )
  )(princ)
)

; 2021-02-02
(defun GenerateVerticallyTextByPositionAndContent (insPt textContent textLayer textHeight /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 textLayer) (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 textHeight) (cons 1 textContent) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

; refactored at 2021-03-17
; directionStatus: dxfcode 50; 0.0 Level - 1.57 Vertical
(defun GenerateLevelLeftTextUtils (insPt textContent textLayer textHeight textWidth /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 textLayer) (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 textHeight) (cons 1 textContent) (cons 50 0.0) (cons 41 textWidth) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

; 2021-03-17
; directionStatus: dxfcode 50; 0.0 Level - 1.57 Vertical
(defun GenerateVerticalLeftTextUtils (insPt textContent textLayer textHeight textWidth /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 textLayer) (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 textHeight) (cons 1 textContent) (cons 50 1.57) (cons 41 textWidth) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

; 2021-03-17
; directionStatus: dxfcode 50; 0.0 Level - 1.57 Vertical
; textWidth: dxfcode 41
(defun GenerateLevelCenterTextUtils (insPt textContent textLayer textHeight textWidth /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 textLayer) (cons 100 "AcDbText") 
                  (cons 10 '(0.0 0.0 0.0)) (cons 11 insPt) (cons 40 textHeight) (cons 1 textContent) (cons 50 0.0) (cons 41 textWidth) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 1) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GenerateEquipTagText (insPt textContent /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "0DataFlow-GsLcEquipTag") (cons 100 "AcDbText") 
                  (cons 10 '(0.0 0.0 0.0)) (cons 11 insPt) (cons 40 3.0) (cons 1 textContent) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 1) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GeneratePublicPipePolyline (insPt /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "PL2") (cons 62 3) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 43 0.6) (cons 38 0.0) (cons 39 0.0) (cons 10 (MoveInsertPositionUtils insPt 0 50)) (cons 40 0.6) 
          (cons 41 0.6) (cons 42 0.0) (cons 91 0) (cons 10 insPt) (cons 40 0.6) (cons 41 0.6) (cons 42 0.0) (cons 91 0) (cons 210 '(0.0 0.0 1.0))
    ))
  (princ)
)

; 2021-03-05
(defun GenerateVerticalPolyline (insPt blockLayer lineWidth /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 62 3) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 43 lineWidth) (cons 38 0.0) (cons 39 0.0) 
          (cons 10 (MoveInsertPositionUtils insPt 0 50)) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 10 insPt) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 210 '(0.0 0.0 1.0))
    ))
  (princ)
)

(defun GenerateBlockReference (insPt blockName blockLayer /) 
  (entmake 
    (list (cons 0 "INSERT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbBlockReference") 
          (cons 66 1) (cons 2 blockName) (cons 10 insPt) (cons 41 1.0) (cons 42 1.0) (cons 43 1.0) (cons 50 0.0) (cons 70 0) (cons 71 0) 
          (cons 44 0.0) (cons 45 0.0) (cons 210 '(0.0 0.0 1.0))
    )
  ) 
  (princ)
)

; directionStatus: dxfcode 50; 0.0 Level - 1.57 Vertical
; hiddenStatus dxfcode 70; 0 可见 - 1 隐藏
; moveStatus: dxfcode 280; 1 固定 - 0 可移动
(defun GenerateCenterBlockAttribute (insPt propertyName propertyValue blockLayer textHeight directionStatus hiddenStatus moveStatus /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 (MoveInsertPositionUtils insPt -5.8 0)) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 directionStatus) 
          (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 1) (cons 11 insPt) (cons 210 '(0.0 0.0 1.0)) 
          (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 hiddenStatus) (cons 73 0) (cons 74 0) (cons 280 moveStatus)
    )
  )
  (princ)
)

(defun GenerateLeftBlockAttribute (insPt propertyName propertyValue blockLayer textHeight directionStatus hiddenStatus moveStatus /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 directionStatus) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 hiddenStatus) 
          (cons 73 0) (cons 74 0) (cons 280 moveStatus)
    )
  )
  (princ)
)

(defun GenerateBlockAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 0) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateVerticallyBlockAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) 
          (cons 70 0) (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateBlockHiddenAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 1) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateVerticallyBlockHiddenAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) 
          (cons 70 1) (cons 70 1) (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

; Generate CAD Graph Utils Function 
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