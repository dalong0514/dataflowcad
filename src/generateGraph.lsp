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
; refactored at 2021-04-22
(defun GetGsLcModulesPath (/ result)
  ; (setq result "D:\\dataflowcad\\allBlocks\\GsLcBlocks.dwg")
  (setq result "\\\\192.168.1.38\\dataflow\\allBlocks\\GsLcBlocks.dwg")
)

; 2021-03-09
; refactored at 2021-04-22
(defun GetGsBzModulesPath (/ result)
  ; (setq result "D:\\dataflowcad\\allBlocks\\GsBzBlocks.dwg")
  (setq result "\\\\192.168.1.38\\dataflow\\allBlocks\\GsBzBlocks.dwg")
)

; 2021-03-17
; refactored at 2021-04-22
(defun GetNsBzModulesPath (/ result)
  ; (setq result "D:\\dataflowcad\\allBlocks\\NsBzBlocks.dwg")
  (setq result "\\\\192.168.1.38\\dataflow\\allBlocks\\NsBzBlocks.dwg")
)

; 2021-03-17
; refactored at 2021-04-22
(defun GetBsModulesPath (/ result)
  ; (setq result "D:\\dataflowcad\\allBlocks\\BsGCTBlocks.dwg")
  (setq result "\\\\192.168.1.38\\dataflow\\allBlocks\\BsGCTBlocks.dwg")
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

; 2021-04-27
(defun StealGsLcTextStyleByNameList (textStyleNameList /)
  (Steal (GetGsLcModulesPath) 
    (list 
      (list "Text Styles" textStyleNameList)
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

; 2021-04-27
(defun StealGsBzTextStyleByNameList (textStyleNameList /)
  (Steal (GetGsBzModulesPath) 
    (list 
      (list "Text Styles" textStyleNameList)
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

; 2021-04-17
(defun StealBsBlockByNameList (blockNameList /)
  (Steal (GetBsModulesPath) 
    (list 
      (list "Blocks" blockNameList)
    )
  ) 
)

; 2021-04-17
(defun StealBsLayerByNameList (layerNameList /)
  (Steal (GetBsModulesPath) 
    (list 
      (list "Layers" layerNameList)
    )
  ) 
)

; 2021-04-17
(defun StealBsTextStyleByNameList (textStyleNameList /)
  (Steal (GetBsModulesPath) 
    (list 
      (list "Text Styles" textStyleNameList)
    )
  ) 
)

; 2021-04-17
(defun StealBsDimensionStyleByNameList (dimensionStyleNameList /)
  (Steal (GetBsModulesPath) 
    (list 
      (list "Dimension Styles" dimensionStyleNameList)
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

; 2021-04-27
(defun VerifyGsLcTextStyleByName (textStyleName /) 
  (if (= (tblsearch "STYLE" textStyleName) nil) 
    (StealGsLcTextStyleByNameList (list textStyleName))
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

; 2021-04-27
(defun VerifyGsBzTextStyleByName (textStyleName /) 
  (if (= (tblsearch "STYLE" textStyleName) nil) 
    (StealGsBzTextStyleByNameList (list textStyleName))
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

; 2021-03-17
(defun VerifyBsBlockByName (blockName /) 
  (if (= (tblsearch "BLOCK" blockName) nil) 
    (StealBsBlockByNameList (list blockName))
  )
)

; 2021-04-17
(defun VerifyBsLayerByName (layerName /) 
  (if (= (tblsearch "LAYER" layerName) nil) 
    (StealBsLayerByNameList (list layerName))
  )
)

; 2021-04-17
(defun VerifyBsTextStyleByName (textStyleName /) 
  (if (= (tblsearch "STYLE" textStyleName) nil) 
    (StealBsTextStyleByNameList (list textStyleName))
  )
)

; 2021-04-19
(defun VerifyBsDimensionStyleByName (dimensionStyleName /) 
  (if (= (tblsearch "DIMSTYLE" dimensionStyleName) nil) 
    (StealBsDimensionStyleByNameList (list dimensionStyleName))
  )
)

; 2021-04-05
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

; 2021-04-05
; level is 0, vertical is 1.57[PI/2]
(defun InsertBlockByRotateUtils (insPt blockName layerName propertyDictList rotate / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName 1 1 1 rotate))
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

; 2021-04-17
(defun InsertBlockByNoPropertyByScaleUtils (insPt blockName layerName scale / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName scale scale scale 0))
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

; 2021-04-19
(defun InsertAlignedDimensionUtils (firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent / 
                                    acadObj curDoc first3DInsPt second3DInsPt text3DInsPt modelSpace dimObj)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq first3DInsPt (vlax-3d-point firstInsPt) 
        second3DInsPt (vlax-3d-point secondInsPt)
        text3DInsPt (vlax-3d-point textInsPt)
  )
  (setq modelSpace (vla-get-ModelSpace curDoc))
  ;; Create an aligned dimension object in model space
  (setq dimObj (vla-AddDimAligned modelSpace first3DInsPt second3DInsPt text3DInsPt))
  (vlax-put-property dimObj 'Layer layerName)
  (vlax-put-property dimObj 'StyleName dimensionStyleName)
  (vlax-put-property dimObj 'TextOverride textOverrideContent)
  ; (GetVlaObjectPropertyAndMethodUtils dimObj)
  (princ)
)

; Utils Functon in GenerateGraph
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate CAD Graph Utils Function 

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

; refactored 2021-04-18
(defun GenerateLineUtils (firstPt secondPt entityLayer /)
  (entmake (list (cons 0 "LINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 8 entityLayer) (cons 100 "AcDbText") 
                  (cons 10 firstPt) (cons 11 secondPt) (cons 210 '(0.0 0.0 1.0)) 
             )
  )(princ)
)

; 2021-04-18
(defun GenerateLineByLineScaleUtils (firstPt secondPt entityLayer lineScale /)
  (entmake (list (cons 0 "LINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 8 entityLayer) (cons 48 lineScale) 
                 (cons 100 "AcDbText") (cons 10 firstPt) (cons 11 secondPt) (cons 210 '(0.0 0.0 1.0)) 
             )
  )(princ)
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

; 2021-04-18
; dxf color (cons 62 3) - green
(defun GeneratePolyLineUtils (firstPt secondPt entityLayer lineWidth /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 8 entityLayer) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 43 lineWidth) (cons 38 0.0) (cons 39 0.0) 
          (cons 10 firstPt) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 10 secondPt) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 210 '(0.0 0.0 1.0))
    ))
  (princ)
)

; 2021-04-18
; directionStatus: dxfcode 210: 1 up, -1 down
; ratio dxf 40: Ratio of minor axis to major axis
(defun GenerateEllipseUtils (insPt entityLayer ellipseDiameter directionStatus ratio /)
  (entmake 
    (list (cons 0 "ELLIPSE") (cons 100 "AcDbEntity") (cons 67 0) (cons 8 entityLayer) (cons 100 "AcDbEllipse") 
          (cons 10 insPt) (cons 11 (list ellipseDiameter 0 0)) (cons 210 (list 0 0 directionStatus)) (cons 40 ratio) (cons 41 0.0) (cons 42 3.14159) 
    )
  )
  (princ)
)

; 2021-05-18
; directionStatus: dxfcode 210: 1 up, -1 down
; ratio dxf 40: Ratio of minor axis to major axis
(defun GenerateHorizontalEllipseUtils (insPt entityLayer ellipseDiameter directionStatus ratio /)
  (entmake 
    (list (cons 0 "ELLIPSE") (cons 100 "AcDbEntity") (cons 67 0) (cons 8 entityLayer) (cons 100 "AcDbEllipse") 
          (cons 10 insPt) (cons 11 (list 0 (- 0 ellipseDiameter) 0)) (cons 210 (list 0 0 directionStatus)) (cons 40 ratio) (cons 41 0.0) (cons 42 3.14159) 
    )
  )
  (princ)
)

; 2021-04-18
; directionStatus: dxfcode 210: 1 up, -1 down
(defun GenerateSingleLineEllipseHeadUtils (insPt barrelRadius entityLayer centerLineLayer directionStatus straightEdgeHeight /)
  (GenerateEllipseUtils insPt entityLayer barrelRadius directionStatus 0.5)
  (GenerateEllipseHeadVerticalLineUtils insPt barrelRadius entityLayer directionStatus)
  (GenerateVerticalEllipseHeadCenterLineUtils insPt barrelRadius entityLayer centerLineLayer directionStatus straightEdgeHeight)
  (princ)
)

; 2021-04-18
; directionStatus: dxfcode 210: 1 up, -1 down
(defun GenerateDoubleLineEllipseHeadUtils (insPt barrelRadius entityLayer centerLineLayer directionStatus thickNess straightEdgeHeight /)
  (GenerateEllipseUtils insPt entityLayer barrelRadius directionStatus 0.5)
  ; ratio dxf 40: Ratio of minor axis to major axis
  (GenerateEllipseUtils insPt entityLayer (+ barrelRadius thickNess) directionStatus (/ (float (+ (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess)))
  (GenerateEllipseHeadVerticalLineUtils insPt barrelRadius entityLayer directionStatus)
  (GenerateEllipseHeadVerticalLineUtils insPt (+ barrelRadius thickNess) entityLayer directionStatus)
  (GenerateVerticalEllipseHeadCenterLineUtils insPt (+ barrelRadius thickNess) entityLayer centerLineLayer directionStatus straightEdgeHeight)
  (princ)
)

; 2021-05-18
; directionStatus: dxfcode 210: 1 up, -1 down
(defun GenerateDoubleLineHorizontalEllipseHeadUtils (insPt barrelRadius entityLayer centerLineLayer directionStatus thickNess straightEdgeHeight /)
  (GenerateHorizontalEllipseUtils insPt entityLayer barrelRadius directionStatus 0.5)
  ; ratio dxf 40: Ratio of minor axis to major axis
  (GenerateHorizontalEllipseUtils insPt entityLayer (+ barrelRadius thickNess) directionStatus (/ (float (+ (/ barrelRadius 2) thickNess)) (+ barrelRadius thickNess)))
  (GenerateEllipseHeadHorizontalLineUtils insPt barrelRadius entityLayer directionStatus)
  (GenerateEllipseHeadHorizontalLineUtils insPt (+ barrelRadius thickNess) entityLayer directionStatus)
  (GenerateHorizontalEllipseHeadCenterLineUtils insPt (+ barrelRadius thickNess) entityLayer centerLineLayer directionStatus straightEdgeHeight)
  (princ)
)

; 2021-04-18
(defun GenerateVerticalEllipseHeadCenterLineUtils (insPt barrelRadius entityLayer centerLineLayer directionStatus straightEdgeHeight /)
  (GenerateLineByLineScaleUtils 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) 0) 
    (MoveInsertPositionUtils insPt (+ 0 barrelRadius) 0)
    centerLineLayer
    6
  )
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus)) 
    (MoveInsertPositionUtils insPt (+ 0 barrelRadius) (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus))
    entityLayer
  ) 
  (princ)
)

; 2021-05-18
(defun GenerateHorizontalEllipseHeadCenterLineUtils (insPt barrelRadius entityLayer centerLineLayer directionStatus straightEdgeHeight /)
  (GenerateLineByLineScaleUtils 
    (MoveInsertPositionUtils insPt 0 (- 0 barrelRadius)) 
    (MoveInsertPositionUtils insPt 0 (+ 0 barrelRadius))
    centerLineLayer
    6
  )
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus) (- 0 barrelRadius)) 
    (MoveInsertPositionUtils insPt (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus) (+ 0 barrelRadius))
    entityLayer
  ) 
  (princ)
)

; 2021-04-18
(defun GenerateEllipseHeadVerticalLineUtils (insPt barrelRadius entityLayer directionStatus /)
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) 0) 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus))
    entityLayer
  )
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (+ 0 barrelRadius) 0) 
    (MoveInsertPositionUtils insPt (+ 0 barrelRadius) (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus))
    entityLayer
  ) 
  (princ)
)

; 2021-05-18
(defun GenerateEllipseHeadHorizontalLineUtils (insPt barrelRadius entityLayer directionStatus /)
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt 0 (- 0 barrelRadius)) 
    (MoveInsertPositionUtils insPt (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus) (- 0 barrelRadius))
    entityLayer
  )
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt 0 (+ 0 barrelRadius)) 
    (MoveInsertPositionUtils insPt (* (GetNegativeNumberUtils straightEdgeHeight) directionStatus) (+ 0 barrelRadius))
    entityLayer
  ) 
  (princ)
)

; 2021-04-18
(defun GenerateSingleLineBarrelUtils (insPt barrelRadius barrelHalfHeight entityLayer centerLineLayer /)
  (GenerateLineByLineScaleUtils 
    (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight (/ barrelRadius 2))) 
    (MoveInsertPositionUtils insPt 0 (- 0 barrelHalfHeight (/ barrelRadius 2)))
    centerLineLayer
    6
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) barrelHalfHeight) 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius) (- 0 barrelHalfHeight))
    entityLayer
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelRadius barrelHalfHeight) 
    (MoveInsertPositionUtils insPt barrelRadius (- 0 barrelHalfHeight))
    entityLayer
  ) 
  (princ)
)

; 2021-04-18
(defun GenerateVerticalDoubleLineBarrelUtils (insPt barrelRadius barrelHalfHeight entityLayer centerLineLayer thickNess /) 
  ; left two lines
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelRadius) barrelHalfHeight) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelRadius) (GetNegativeNumberUtils barrelHalfHeight))
    entityLayer
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelRadius barrelHalfHeight) 
    (MoveInsertPositionUtils insPt barrelRadius (GetNegativeNumberUtils barrelHalfHeight))
    entityLayer
  ) 
  ; right two lines
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius thickNess) barrelHalfHeight) 
    (MoveInsertPositionUtils insPt (- 0 barrelRadius thickNess) (GetNegativeNumberUtils barrelHalfHeight))
    entityLayer
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) barrelHalfHeight) 
    (MoveInsertPositionUtils insPt (+ barrelRadius thickNess) (GetNegativeNumberUtils barrelHalfHeight))
    entityLayer
  )  
  (princ)
)

; 2021-05-18
(defun GenerateHorizontalDoubleLineBarrelUtils (insPt barrelRadius barrelHalfHeight entityLayer centerLineLayer thickNess /) 
  ; left two lines
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelHalfHeight (GetNegativeNumberUtils barrelRadius)) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (GetNegativeNumberUtils barrelRadius))
    entityLayer
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelHalfHeight barrelRadius) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) barrelRadius)
    entityLayer
  ) 
  ; right two lines
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelHalfHeight (- 0 barrelRadius thickNess)) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (- 0 barrelRadius thickNess))
    entityLayer
  ) 
  (GenerateLineUtils 
    (MoveInsertPositionUtils insPt barrelHalfHeight (+ barrelRadius thickNess)) 
    (MoveInsertPositionUtils insPt (GetNegativeNumberUtils barrelHalfHeight) (+ barrelRadius thickNess))
    entityLayer
  )  
  (princ)
)

; 2021-05-27
(defun GenerateBsGCTVerticalTankCenterLine (insPt barrelHalfHeight barrelRadius thickNess /)
  (GenerateLineByLineScaleUtils 
    (MoveInsertPositionUtils insPt 0 (+ barrelHalfHeight (/ barrelRadius 2) thickNess)) 
    (MoveInsertPositionUtils insPt 0 (- 0 barrelHalfHeight (/ barrelRadius 2) thickNess))
    "0DataFlow-BsCenterLine"
    6
  ) 
)

; 2021-05-27
(defun GenerateBsGCTHorizontalTankCenterLine (insPt barrelHalfHeight barrelRadius thickNess /)
  (GenerateLineByLineScaleUtils 
    (MoveInsertPositionUtils insPt (+ barrelHalfHeight (/ barrelRadius 2) thickNess) 0) 
    (MoveInsertPositionUtils insPt (- 0 barrelHalfHeight (/ barrelRadius 2) thickNess) 0)
    "0DataFlow-BsCenterLine"
    6
  ) 
)

; 2021-05-26
(defun GenerateBsGCTFlangeUtils (insPt dataType barrelRadius thickNess rotate / outerDiameter flangeBarrelHeight flangeNeckHeight flangeHeight totalFlangeHeight) 
  (setq outerDiameter (* (+ barrelRadius thickNess) 2))
  (setq flangeBarrelHeight (GetFlangeBarrelHeightEnums (* 2 barrelRadius)))
  (GenerateBsGCTFlangeUpBarrel insPt dataType "BsGCTGraphRectangleBottomBase" outerDiameter flangeBarrelHeight rotate)
  (setq flangeNeckHeight (GetFlangeNeckHeightEnums (* 2 barrelRadius)))
  (GenerateBsGCTFlangeNeck 
    (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils flangeBarrelHeight)) dataType "BsGCTGraphFlangeNeck-RF" outerDiameter flangeNeckHeight rotate)
  (setq flangeHeight (GetFlangeHeightEnums (* 2 barrelRadius)))
  (GenerateBsGCTNeckFlange 
    (MoveInsertPositionUtils insPt 0 (- 0 flangeBarrelHeight flangeNeckHeight)) dataType "BsGCTGraphFlange-RF" outerDiameter flangeHeight rotate)
  (GenerateBsGCTFlangeDoubleRaised 
    (MoveInsertPositionUtils insPt 0 (- 0 flangeBarrelHeight flangeNeckHeight flangeHeight)) dataType "BsGCTGraphRectangleBottomBase" (* barrelRadius 2) rotate)
  ; the height of two raised is 6
  (GenerateBsGCTNeckFlange 
    (MoveInsertPositionUtils insPt 0 (- 0 flangeBarrelHeight flangeNeckHeight flangeHeight 6)) dataType "BsGCTGraphFlange-RF" outerDiameter flangeHeight rotate)
  (setq totalFlangeHeight (+ flangeBarrelHeight flangeNeckHeight flangeHeight 6 flangeHeight))
)

; 2021-05-27
(defun GenerateBsGCTFlangeUpBarrel (insPt dataType blockName outerDiameter flangeBarrelHeight rotate /)
  (InsertBlockByRotateUtils insPt "BsGCTGraphRectangleBottomBase" "0DataFlow-BsThickLine" (list (cons 0 dataType)) rotate)
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LENGTH" outerDiameter) (cons "WIDTH" flangeBarrelHeight))
  ) 
)

; 2021-05-27
(defun GenerateBsGCTFlangeDoubleRaised (insPt dataType blockName barrelDiameter rotate /)
  (InsertBlockByRotateUtils insPt "BsGCTGraphRectangleBottomBase" "0DataFlow-BsThickLine" (list (cons 0 dataType)) rotate)
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LENGTH" (+ barrelDiameter 55)) (cons "WIDTH" 3))
  ) 
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt 0 -3) "BsGCTGraphRectangleBottomBase" "0DataFlow-BsThickLine" (list (cons 0 dataType)) rotate)
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "LENGTH" (+ barrelDiameter 55)) (cons "WIDTH" 3))
  )
)

; 2021-05-26
(defun GenerateBsGCTFlangeNeck (insPt dataType blockName outerDiameter flangeNeckHeight rotate /)
  (InsertBlockByRotateUtils insPt blockName "0DataFlow-BsThickLine" (list (cons 0 dataType)) rotate)
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "DIAMETER" outerDiameter) (cons "HEIGHT" flangeNeckHeight))
  ) 
)

; 2021-05-26
(defun GenerateBsGCTNeckFlange (insPt dataType blockName outerDiameter flangeHeight rotate /)
  (InsertBlockByRotateUtils insPt blockName "0DataFlow-BsThickLine" (list (cons 0 dataType)) rotate)
  (SetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list 
      (cons "DIAMETER" outerDiameter) 
      (cons "BLOT_DIAMETER" 700)
      (cons "FLANGE_DIAMETER" 740)
      (cons "HEIGHT" flangeHeight))
  ) 
)

; 2021-05-19
; the DXFCode of 41 is -1 for mirroring the block
(defun MirrorBlockUtils (entityName /)
  (SetDXFValueUtils entityName 41 -1)
)

; Generate CAD Graph Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Calculate CAD Graph Utils Function 

; 2021-04-19
(defun GetYByXForEllipseUtils (lengthRadius xValue /) 
  (/ (sqrt (- (expt lengthRadius 2) (expt xValue 2))) 2)
)

; 2021-04-19
(defun GetXDistanceForTwoPoint (firstInsPt secondInsPt /) 
  (abs (- (car firstInsPt) (car firstInsPt)))
)

; 2021-04-19
(defun GetXHalfDistanceForTwoPoint (firstInsPt secondInsPt /) 
  (/ (GetXDistanceForTwoPoint firstInsPt secondInsPt))
)

; 2021-04-19
(defun GetYDistanceForTwoPoint (firstInsPt secondInsPt /) 
  (abs (- (cadr firstInsPt) (cadr firstInsPt)))
)

; 2021-04-19
(defun GetYHalfDistanceForTwoPoint (firstInsPt secondInsPt /) 
  (/ (GetYDistanceForTwoPoint firstInsPt secondInsPt))
)

; Calculate CAD Graph Utils Function 
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