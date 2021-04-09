;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; utils Function for  Equipemnt Layout

; 2021-03-11
(defun GetAllGsBzEquipEntityNameList () 
  (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "GsBzEquip"))
)

; 2021-03-11
(defun GetAllGsBzEquipTagList () 
  (mapcar '(lambda (x) 
             (cadr x)
          ) 
    (GetPropertyValueListByEntityNameList (GetAllGsBzEquipEntityNameList) '("TAG"))
  )   
)

; 2021-03-09
(defun VerifyGsBzEquipTagLayer () 
  (VerifyGsBzLayerByName "0DataFlow-GsBzEquipTag")
  (VerifyGsBzLayerByName "0DataFlow-GsBzEquipTagComment")
)

; 2021-03-09
(defun VerifyGsBzEquipLayer () 
  (VerifyGsBzLayerByName "0DataFlow-GsBzEquip")
  (VerifyGsBzLayerByName "0DataFlow-GsBzEquipComment")
)

; 2021-03-12
(defun GetAllGsBzEquipBlockNameList (/ entityData resultList) 
  (StealAllGsBzEquipBlocks)
  (setq entityData (tblnext "block" T)) 
  (while entityData 
    (if (wcmatch (cdr (assoc 2 entityData)) "GsBz*") 
      (setq resultList (append resultList (list (cdr (assoc 2 entityData)))))
    )
    (setq entityData (tblnext "block")) 
  ) 
  resultList
)

; utils Function for  Equipemnt Layout
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GsBzBlocks

; 2021-03-09
(defun c:InsertBlockGsBzCleanAir (/ insPt) 
  (setq insPt (getpoint "\n选取房间块插入点："))
  (VerifyGsBzBlockByName "GsCleanAir")
  (VerifyGsBzCleanAirLayer)
  (InsertBlockUtils insPt "GsCleanAir" "0DataFlow-GsBzCleanAirCondition" (list (cons 2 "C01")))
)

; 2021-03-09
(defun VerifyGsBzCleanAirLayer () 
  (VerifyGsBzLayerByName "0DataFlow-GsBzCleanAirCondition")
  (VerifyGsBzLayerByName "0DataFlow-GsBzCleanAirConditionComment")
)

; 2021-03-11
(defun InsertBlockGsBzEquipDefault (insPt propertyDictList /) 
  (VerifyGsBzBlockByName "GsBzEquipDefault")
  (VerifyGsBzLayerByName "0DataFlow-GsBzEquipDefault")
  (InsertBlockUtils insPt "GsBzEquipDefault" "0DataFlow-GsBzEquipDefault" propertyDictList)
)

; 2021-03-10
(defun InsertBlockGsBzEquipTagStrategy (insPt dataType /) 
  (VerifyGsBzBlockByName dataType)
  (InsertBlockByNoPropertyUtils insPt dataType "0DataFlow-GsBzEquipTag")
)

; Generate GsBzBlocks
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Equipemnt Layout

(defun c:numberLayoutData (/ dataTypeList)
  (setq dataTypeList (GetNumberLayoutDataTypeList))
  (numberLayoutDataByBox dataTypeList "enhancedNumberBox")
)

(defun GetNumberLayoutDataTypeList ()
  '("GsCleanAir" "FireFightHPipe")
)

(defun GetNumberLayoutDataTypeChNameList ()
  '("洁净空调" "给排水消防立管")
)

(defun GetNumberLayoutDataModeChNameList ()
  '("按代号自动编码" "不按代号自动编号")
)

(defun numberLayoutDataByBox (dataTypeList tileName / dcl_id dataType numberMode status selectedPropertyName 
                            selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList 
                            modifyMessageStatus numberedDataList numberedList codeNameList startNumberString)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnPreviewNumber" "(done_dialog 3)")
    (action_tile "btnComfirmNumber" "(done_dialog 4)")
    (mode_tile "dataType" 2)
    (mode_tile "numberMode" 2)
    (action_tile "dataType" "(setq dataType $value)")
    (action_tile "numberMode" "(setq numberMode $value)")
    (action_tile "startNumberString" "(setq startNumberString $value)")
    ; init the default data of text
    (progn 
      (start_list "dataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberLayoutDataTypeChNameList)
      )
      (end_list)
      (start_list "numberMode" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberLayoutDataModeChNameList)
      )
      (end_list)
    )  
    (if (= nil dataType)
      (setq dataType "0")
    )
    (if (= nil numberMode)
      (setq numberMode "0")
    )
    (if (= nil startNumberString)
      (setq startNumberString "")
    ) 
    ; setting for saving the existed value of a box
    (set_tile "dataType" dataType)
    (set_tile "numberMode" numberMode)
    (set_tile "startNumberString" startNumberString)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= modifyMessageStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "modifyBtnMsg" "请先预览修改")
    )
    (if (/= selectedDataType nil)
      (set_tile "dataType" dataType)
    )
    (if (/= matchedList nil)
      (progn
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        ;(add_list matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq selectedDataType (nth (atoi dataType) dataTypeList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        (setq ss (SortSelectionSetByXYZ ss))  ; sort by x cordinate
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType "Instrument"))
        (setq sslen (length matchedList))
      )
    )
    ; confirm button
    (if (= 3 status)
      (progn 
        (setq codeNameList (GetCodeNameListStrategy propertyValueDictList selectedDataType))
        (setq numberedDataList (GetNumberedDataListStrategy propertyValueDictList selectedDataType codeNameList numberMode startNumberString))
        (setq matchedList (GetNumberedListStrategy numberedDataList selectedDataType))
        (setq confirmList matchedList)
      )
    )
    ; modify button
    (if (= 4 status)
      (progn 
        (if (/= confirmList nil) 
          (progn 
            (UpdateNumberedData numberedDataList selectedDataType)
            (setq modifyMessageStatus 1)
          )
          (setq modifyMessageStatus 0)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)


;;;-------------------------------------------------------------------------;;;
; migrate JS Layout Draw

; 2021-03-05
(defun c:purgeJSDrawData () 
  (DeleteEntityBySSUtils (GetAllCopySS))
  (alert "建筑底图清理成功")
)

; 2021-02-28
(defun c:extractJSDrawData () 
  (vl-bb-set 'architectureDraw (list (GetJSDrawBasePositionList) (GetAllStrategyCopyEntityData)))
  (alert "建筑底图提取成功")
)

; 2021-02-28
(defun c:migrateJSDraw (/ GSDrawBasePositionList JSDrawBasePositionList newDrawBasePositionList JSDrawData resultList)
  (if (/= (vl-bb-ref 'architectureDraw) nil) 
    (progn 
      (setq GSDrawBasePositionList (GetJSDrawBasePositionList))
      (setq JSDrawBasePositionList (car (vl-bb-ref 'architectureDraw))) 
      (setq newDrawBasePositionList (GetNewDrawBasePositionList GSDrawBasePositionList JSDrawBasePositionList))
      (setq JSDrawData (car (cdr (vl-bb-ref 'architectureDraw)))) ; why have car? - 2021-02-28
      (DeleteEntityBySSUtils (GetAllCopySS))
      (GenerateNewJSEntityData newDrawBasePositionList JSDrawData)
      (alert "建筑底图更新成功") 
    )
    (alert "请先提取建筑底图！") 
  )
)

; 2021-02-26
(defun c:moveJSDraw () 
  (CADLispMove (GetAllMoveDrawLabelSS) '(0 0 0) '(400000 0 0))
  (CADLispCopy (GetAllCopyDrawLabelSS) '(0 0 0) '(400000 0 0)) 
  (CADLispCopy (GetAllJSAxisSS) '(0 0 0) '(400000 0 0)) 
  (generateJSDraw (MoveCopyEntityData))
  (alert "移出建筑底图成功！") 
)

; 2021-03-02
(defun GetAllMoveDrawLabelSS () 
    (ssget "X" '( (0 . "INSERT")
        (-4 . "<OR")
          (8 . "titan-title")
          (8 . "titan-title2")
        (-4 . "OR>")
      )
    )
)

; 2021-03-02
(defun GetAllCopyDrawLabelSS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "LWPOLYLINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "titan-title")
          (8 . "titan-title2")
        (-4 . "OR>")
      )
    )
)

; 2021-03-01
(defun c:switchLayerLock(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Toggle the status of the Lock property for the layer
              (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  (setq lockStatus 0)
                  (setq lockStatus 1)
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (setq lockStatusMsg '("建筑底图锁定" "建筑底图解锁"))
  (alert (nth lockStatus lockStatusMsg))
)

; 2021-03-01
(defun c:lockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (/= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "建筑底图锁定")
)

; 2021-03-01
(defun c:unlockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "建筑底图解锁")
)

; 2021-02-26
(defun generateJSDraw (JSEntityData /)
  (mapcar '(lambda (x) 
              (entmake x)
             ; for block - AcDbBlockReference
              (entmake 
                (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
              ) 
           ) 
    JSEntityData
  )
  (princ)
)

; 2021-02-28
(defun MoveCopyEntityData () 
  (MoveCopyEntityDataByBasePosition (GetAllCopyEntityData) '(400000 0))
)

; 2021-02-26
(defun GetCopyEntityData () 
  (GetJSEntityData (GetCopySS))
)

; 2021-02-28
(defun GetAllCopyEntityData () 
  (GetJSEntityData (GetAllCopySS))
)

; 2021-02-28
(defun GetJSEntityData (ss /) 
  (mapcar '(lambda (x) 
              (vl-remove-if-not '(lambda (y) 
                                  (and (/= (car y) -1)  (/= (car y) 330) (/= (car y) 5))
                                ) 
                x
              ) 
           ) 
    (GetSelectedEntityDataUtils ss) 
  )
)

; 2021-03-01
(defun GetCopySS () 
    (ssget '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
          (0 . "LWPOLYLINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WINDOW")
          (8 . "WALL")
          (8 . "COLUMN")
          (8 . "WALL-MOVE") 
          (8 . "STAIR") 
          (8 . "EVTR") 
          (8 . "DOOR_FIRE")
        (-4 . "OR>")
      )
    )
)

; 2021-03-01
(defun GetAllCopySS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
          (0 . "LWPOLYLINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WINDOW")
          (8 . "WALL")
          (8 . "COLUMN")
          (8 . "WALL-MOVE") 
          (8 . "STAIR") 
          (8 . "EVTR") 
          (8 . "DOOR_FIRE")
          (8 . "柱*") 
        (-4 . "OR>")
      )
    )
)

; 2021-02-26
(defun GetJSDrawColumnSS () 
  (ssget '((0 . "INSERT") (8 . "COLUMN")))
)

; 2021-02-27
(defun GetAllJSDrawColumnSS () 
  (ssget "X" '((0 . "INSERT") (8 . "COLUMN")))
)

; 2021-03-31
(defun GetAllJSAxisSS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "DIMENSION")
          (0 . "INSERT")
          (0 . "LINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "AXIS")
        (-4 . "OR>")
      )
    )
)

; 2021-02-27
(defun GetAllJSDrawColumnPosition () 
  (mapcar '(lambda (x) 
             (GetEntityPositionByEntityNameUtils x)
           ) 
    (GetEntityNameListBySSUtils (GetAllJSDrawColumnSS))
  ) 
)

; 2021-02-27
(defun GetStrategyJSDrawColumnPositionData (/ allJSDrawColumnPosition resultList) 
  ; set a temp variable first, ss in the foreach
  (setq allJSDrawColumnPosition (GetAllJSDrawColumnPosition))
    (foreach item (FilterJSDrawLabelData) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (car x) (car (cadr item))) 
                    (< (car x) (+ (car (cadr item)) 126150)) 
                    (< (cadr x) (cadr (cadr item)))
                    (> (cadr x) (- (cadr (cadr item)) 89100))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      allJSDrawColumnPosition
    ) 
  ) 
  resultList
)

(defun GetJSDrawBasePositionList (/ allJSDrawColumnPositionData tempPositionList resultList)
  ; set a temp variable first, ss in the foreach
  (setq allJSDrawColumnPositionData (GetStrategyJSDrawColumnPositionData))
  (foreach item (FilterJSDrawLabelData) 
    (setq tempPositionList (SortPositionListByMinxMinyUtils 
                              (mapcar '(lambda (x) (cadr x)) 
                                (vl-remove-if-not '(lambda (x) 
                                                    (= (car x) (car item)) 
                                                  ) 
                                  allJSDrawColumnPositionData
                                ) 
                              )  
                       )
    )
    (setq resultList (append resultList (list (list (car item) (car tempPositionList)))))
  ) 
  (setq resultList (vl-sort resultList '(lambda (x y) (< (atof (car x)) (atof (car y))))))
)

; 2021-02-26
(defun GetAllJSDrawLabelData () 
  (mapcar '(lambda (x) 
             (list 
               (StringSubstUtils "" "%%p" (strcat (cdr (assoc "dwgname1" x)) (cdr (assoc "dwgname2l1" x)) (cdr (assoc "dwgname2l2" x))))
               (Get15A1DrawPositionRangeUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x)))))
             )
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

(defun Get15A1DrawPositionRangeUtils (position /)
  (list (+ (car position) -126150) (+ (cadr position) 89100))
)

; 2021-04-08
(defun GetA1DrawPositionRangeUtils (position /)
  (list (+ (car position) -84100) (+ (cadr position) 59400))
)

; 2021-02-27
(defun FilterJSDrawLabelData ()
  (mapcar '(lambda (x) 
             (list 
               (RegExpReplace (car x) "([^0-9]*)(\\d+\\.\\d).*" "$2" nil T)
               (cadr x)
             )
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (/= (wcmatch (car x) "*`.*") nil) 
                      ) 
      (GetAllJSDrawLabelData)
    ) 
  ) 
)

; 2021-02-28
(defun GetAllStrategyCopyEntityData () 
  (GetStrategyEntityData (GetAllCopyEntityData))
)

; 2021-02-28
(defun GetStrategyCopyEntityData () 
  (GetStrategyEntityData (GetCopyEntityData))
)

; 2021-02-27
(defun GetStrategyEntityData (copyEntityData / resultList) 
    (foreach item (FilterJSDrawLabelData) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (cadr (assoc 10 x)) (car (cadr item))) 
                    (< (cadr (assoc 10 x)) (+ (car (cadr item)) 126150)) 
                    (< (caddr (assoc 10 x)) (cadr (cadr item)))
                    (> (caddr (assoc 10 x)) (- (cadr (cadr item)) 89100))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      copyEntityData
    ) 
  ) 
  resultList
)

; refactored at 2021-02-28
(defun MoveCopyEntityDataByBasePosition (entityData basePosition /)
  (mapcar '(lambda (x) 
             ; ready for refactor 
            (cond 
              ((= (cdr (assoc 0 x)) "INSERT") (MoveBlockDataByBasePosition x basePosition))
              ((= (cdr (assoc 0 x)) "LINE") (MoveLineDataByBasePosition x basePosition))
              ((= (cdr (assoc 0 x)) "LWPOLYLINE") (MovePolyLineDataByBasePosition x basePosition)) 
            )  
           ) 
    entityData
  )
)

(defun MoveLineDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10 11)
    (list (MoveInsertPositionUtils (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
          (MoveInsertPositionUtils (cdr (assoc 11 x)) (car basePosition) (cadr basePosition))
    )
  )
)

(defun MoveBlockDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10)
    (list (MoveInsertPositionUtils (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
    )
  )
)

; refactored at - 2021-03-20
; (10 597934.0 177705.0) (40 . 0.0) (41 . 0.0) (42 . 0.0) (91 . 0) (10 595834.0 177705.0)
; 多段线的 dxf 10 后面的数据是个 2 维数组，不能用 3 维的偏移函数来调
(defun MovePolyLineDataByBasePosition (entityData basePosition / resultList)
  (mapcar '(lambda (x) 
             (if (= (car x) 10) 
               (setq resultList (append resultList (list (cons 10 (MoveTwoDimPositionUtils (cdr x) (car basePosition) (cadr basePosition))))))
               (setq resultList (append resultList (list x)))
             ) 
             
           ) 
    entityData
  )
  resultList
)

; 2021-02-28
(defun MoveJSEntityDataToBasePosition (drawBasePositionList / strategyCopyEntityData tempDataList resultList)
  ; set a temp variable first, ss in the foreach
  (setq strategyCopyEntityData (GetStrategyCopyEntityData))
    (foreach item drawBasePositionList
    (setq tempDataList (MoveCopyEntityDataByBasePosition 
                              (mapcar '(lambda (x) (cadr x)) 
                                (vl-remove-if-not '(lambda (x) 
                                                    (= (car x) (car item)) 
                                                  ) 
                                  strategyCopyEntityData
                                ) 
                              ) 
                              (list (- 0 (car (cadr item))) (- 0 (cadr (cadr item))))
                           )
    )
    (setq resultList (append resultList (list (list (car item) tempDataList))))
  ) 
  resultList
)

; 2021-02-28
(defun GenerateNewJSEntityData (drawBasePositionList strategyCopyEntityData /)
  ; set a temp variable first, ss in the foreach
    (foreach item drawBasePositionList
    (generateJSDraw (MoveCopyEntityDataByBasePosition 
                      (mapcar '(lambda (x) (cadr x)) 
                        (vl-remove-if-not '(lambda (x) 
                                            (= (car x) (car item)) 
                                          ) 
                          strategyCopyEntityData
                        ) 
                      ) 
                      (list (- 0 (car (cadr item))) (- 0 (cadr (cadr item))))
                    )
    )
  ) 
)

(defun GetNewDrawBasePositionList (GSDrawBasePositionList JSDrawBasePositionList /)
  (mapcar '(lambda (x y) 
             (list 
               (car x) 
               (MoveInsertPositionUtils (cadr y) (- 0 (car (cadr x))) (- 0 (cadr (cadr x))))
             )
           ) 
    GSDrawBasePositionList
    JSDrawBasePositionList
  )  
)

; Migrate JS Layout Draw
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
; Migrate Lc Data to Bz Layout

; 2021-03-08



; Migrate Lc Data to Bz Layout
;;;-------------------------------------------------------------------------;;;

; 2021-03-09
(defun c:extractGsLcEquipData (/ lcEquipData) 
  (setq lcEquipData (GetAllMarkedEquipDataListByTypeListUtils))
  (if (not (IsGetNullGsLcEquipData lcEquipData)) 
    (progn 
      (vl-bb-set 'gsLcEquipData lcEquipData)
      (alert "工艺流程设备数据提取成功！")
    )
    (alert "工艺流程中无设备数据！")
  )
  (princ)
)

; 2021-03-09
(defun IsGetNullGsLcEquipData (lcEquipData /)
  (vl-every '(lambda (x) 
               (= (cdr x) nil)
             ) 
    lcEquipData
  )
)

; 2021-03-09
(defun c:migrateGsLcEquipData (/ insPt lcEquipData) 
  (setq insPt (getpoint "\n选取设备模块插入点："))
  (setq lcEquipData (vl-bb-ref 'gsLcEquipData))
  (if (/= lcEquipData nil) 
    (GenerateGsBzEquipTag lcEquipData insPt)
    (alert "请先提取流程设备数据！") 
  )
  (PurgeAllUtils)
  (princ)
)

; refactored at 2021-03-10
(defun GenerateGsBzEquipTag (lcEquipData insPt / itemData equipTagData equipGraphData blockPropertyNameList insPt allGsBzEquipBlockNameList) 
  (setq allGsBzEquipBlockNameList (GetAllGsBzEquipBlockNameList))
  (VerifyGsBzEquipLayer)
  (VerifyGsBzEquipTagLayer)
  (mapcar '(lambda (x) 
             (setq itemData (cdr x))
             ; sorted by EquipName
             (setq itemData (vl-sort itemData '(lambda (x y) (< (cdr (caddr x)) (cdr (caddr y))))))
             (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList itemData 0) 3500))
             (setq equipTagData (InsertGsBzEquipTag itemData insPtList (car x)))
             (setq equipGraphData (InsertGsBzEquipGraph itemData insPtList (car x) allGsBzEquipBlockNameList))
             (setq blockPropertyNameList (GetGsBzEquipTagPropertyNameList itemData)) 
             (MigrateGsBzEquipTagPropertyValue equipTagData blockPropertyNameList)
             (MigrateGsBzEquipTagPropertyValue equipGraphData blockPropertyNameList)
             (setq insPt (MoveInsertPositionUtils insPt 0 -10000))
          ) 
    lcEquipData
  )  
)

; refactored at 2021-03-14
; do not migrate [version] property
(defun MigrateGsBzEquipTagPropertyValue (itemData blockPropertyNameList /) 
  (mapcar '(lambda (x) 
             (ModifyMultiplePropertyForOneBlockUtils (car x) 
               (cdr blockPropertyNameList) 
               (cdr (GetGsBzEquipBlockPropertyValueList (cdr x))))
          ) 
    itemData
  )
)

; 2021-03-09
(defun GetGsBzEquipTagPropertyNameList (itemData /) 
  (mapcar '(lambda (x) 
            (strcase (car x))
          ) 
    (cdr (car itemData))
  ) 
)

; 2021-03-09
(defun GetGsBzEquipBlockPropertyValueList (blockData /) 
  (mapcar '(lambda (x) 
             (cdr x)
          ) 
    blockData
  )  
)

; 2021-03-09
(defun InsertGsBzEquipTag (itemData insPtList dataType /) 
  (mapcar '(lambda (x y) 
             (InsertBlockGsBzEquipTagStrategy y dataType)
             (cons (entlast) (cdr x))
          ) 
    itemData
    insPtList
  )  
)

; 2021-03-10
(defun InsertGsBzEquipGraph (itemData insPtList dataType allGsBzEquipBlockNameList / gsBzEquipBlockName) 
  (mapcar '(lambda (x y) 
             (setq gsBzEquipBlockName (GetGsBzEquipBlockNameStrategy dataType (cdr x)))
             (InsertBlockGsBzEquipGraphStrategy (MoveInsertPositionUtils y 0 2500) gsBzEquipBlockName allGsBzEquipBlockNameList)
             (cons (entlast) (cdr x))
          ) 
    itemData
    insPtList
  )  
)

; red hat - 2021-03-16
(defun InsertBlockGsBzEquipGraphStrategy (insPt gsBzBlockName allGsBzEquipBlockNameList /) 
  (if (member gsBzBlockName allGsBzEquipBlockNameList) 
    (InsertBlockUtils insPt gsBzBlockName "0DataFlow-GsBzEquip" (list (cons 0 (GetGsBzEquipTypeClass gsBzBlockName)) 
                                                                  (cons 4 (GetGsBzEquipType gsBzBlockName))
                                                                ))
    ; if has no layer [0DataFlow-GsBzEquipDefault], do not generate graph, bug record - 2021-03-16
    (InsertBlockGsBzEquipDefault insPt (list (cons 0 (GetGsBzEquipTypeClass gsBzBlockName)) ))
  )
)

; 2021-03-13
; unit test completed
(defun GetGsBzEquipType (gsBzBlockName /)
  (RegExpReplace gsBzBlockName ".*-(.*)" "$1" nil nil)
)

; 2021-03-14
(defun GetGsBzEquipTypeClass (gsBzBlockName /)
  (RegExpReplace gsBzBlockName "(.*)-(.*)" "$1" nil nil)
)

; refactored at 2021-03-12
; ready for refactor to strategy - completed
(defun GetGsBzEquipTankBlockName (dataType propertyDictList / equipVolume equipDiameter) 
  (setq equipVolume (GetGsBzEquipVolume propertyDictList))
  (setq equipDiameter (GetGsBzEquipDiameter propertyDictList)) 
  (strcat "GsBz" dataType "-V" equipVolume "D" equipDiameter "LS")
)

(defun GetGsBzEquipReactorBlockName (dataType propertyDictList / equipVolume equipDiameter) 
  (setq equipVolume (GetGsBzEquipVolume propertyDictList))
  (setq equipDiameter (GetGsBzEquipDiameter propertyDictList)) 
  (strcat "GsBz" dataType "-V" equipVolume "D" equipDiameter "KSB")
)

; 2021-03-16
(defun GetGsBzEquipVolume (propertyDictList /)
  (ExtractEquipVolumeStringUtils (ProcessNullStringUtils 
                                   (GetDottedPairValueUtils "volume" propertyDictList)))
)

; 2021-03-16
(defun GetGsBzEquipDiameter (propertyDictList /)
  (ExtractEquipDiameterStringUtils (ProcessNullStringUtils 
                                   (GetDottedPairValueUtils "size" propertyDictList)))
)

; 2021-03-16
(defun GetGsBzEquipBlockNameStrategy (dataType propertyDictList /)
  (cond 
    ((= dataType "Tank") (GetGsBzEquipTankBlockName dataType propertyDictList)) 
    ((= dataType "Reactor") (GetGsBzEquipReactorBlockName dataType propertyDictList)) 
    (T (strcat "GsBz" dataType)) 
  )
)

;;;-------------------------------------------------------------------------;;;
; Generate GsBzEquipData By Import CSV

; 2021-03-11
(defun c:ImportGsBzEquipData ()
  (ImportEquipDataStrategyByBox "importGsEquipDataBox" "GsBzData")
)

; 2021-03-11
(defun GetImportedEquipDataTypeChNameList ()
  '("反应釜" "输送泵" "储罐" "换热器" "离心机" "真空泵" "自定义设备")
)

; 2021-03-11
(defun GetImportedDataTypeByindex (index /)
  (nth (atoi index) '("Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip"))
)

; 2021-03-11
(defun GetsortedTypeChNameList ()
  '("按设备位号" "按体积")
)

; 2021-03-11
(defun GetsortedTypeByindex (index /)
  (nth (atoi index) '("equipTag" "equipVolume"))
)

; 2021-03-11
(defun ImportEquipDataStrategyByBox (tileName importDataType / dcl_id dataType importedDataList status exportDataType sortedType sortedTypeResult importMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowGs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnImportData" "(done_dialog 2)")
    (action_tile "btnModify" "(done_dialog 3)")
    (set_tile "exportDataType" "0")
    (set_tile "sortedType" "0")
    ; the default value of input box
    (mode_tile "exportDataType" 2)
    (mode_tile "sortedType" 2)
    (action_tile "exportDataType" "(setq exportDataType $value)")
    (action_tile "sortedType" "(setq sortedType $value)")
    (progn
      (start_list "exportDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetImportedEquipDataTypeChNameList))
      (end_list)
      (start_list "sortedType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetsortedTypeChNameList))
      (end_list) 
    ) 
    (if (= importDataType "GsBzData")
      (set_tile "importDataTypeMsg" "布置图：导入的设备位号及设备图形")
      (set_tile "importDataTypeMsg" "流程图：导入的设备位号及设备图形")
    ) 
    ; init the default data of text
    (if (= nil exportDataType)
      (setq exportDataType "0")
    ) 
    (if (= nil sortedType)
      (setq sortedType "0")
    )  
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "导入数据状态：请先导入数据")
    ) 
    (set_tile "exportDataType" exportDataType)
    (set_tile "sortedType" sortedType)
    ; import data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq dataType (GetImportedDataTypeByindex exportDataType))
        (setq sortedTypeResult (GetsortedTypeByindex sortedType))
        (princ dataType)
        (setq importedDataList 
               (StrListToListListUtils (ReadGsDataFromCSVStrategy dataType)))
        (setq importMsgBtnStatus 1)
      )
    )
    ; insert button
    (if (= 3 status) 
      (if (/= importedDataList nil) 
        (progn 
          (setq dataType (GetImportedDataTypeByindex exportDataType))
          (setq sortedTypeResult (GetsortedTypeByindex sortedType))
          (GenerateGsEquipDataStrategy importedDataList dataType sortedTypeResult importDataType)
          (setq modifyMsgBtnStatus 1)
          (setq importMsgBtnStatus nil)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; refactored at 2021-03-18
(defun GenerateGsEquipDataStrategy (importedDataList dataType sortedTypeResult importDataType / insPt dataList) 
  (setq insPt (getpoint "\n选取设备位号插入点："))
  ; sorted by EquipTag or Volume
  (setq dataList (SortEquipDataStrategy importedDataList sortedTypeResult))
  (if (= importDataType "GsBzData") 
    (GenerateGsBzEquipDataByImport insPt dataList dataType sortedTypeResult)
    (GenerateGsLcEquipDataByImport insPt dataList dataType sortedTypeResult)
  )
)

; refactored at 2021-03-18
(defun GenerateGsBzEquipDataByImport (insPt dataList dataType sortedTypeResult / allGsBzEquipBlockNameList insPtList equipTagData equipPropertyTagDictList) 
  (VerifyGsBzEquipLayer)
  (VerifyGsBzEquipTagLayer)
  (setq allGsBzEquipBlockNameList (GetAllGsBzEquipBlockNameList))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList dataList 0) 3500))
  (setq equipTagData (InsertGsBzEquipTag dataList insPtList dataType))
  (UpdateGsEquipTagPropertyValue equipTagData (GetPropertyNameListStrategy dataType))
  (setq equipPropertyTagDictList (GetGsBzEquipPropertyTagDictListStrategy dataType dataList))
  (setq equipGraphData (InsertGsBzEquipGraph equipPropertyTagDictList insPtList dataType allGsBzEquipBlockNameList))
  (MigrateGsBzEquipTagPropertyValueFromCSV equipGraphData (GetPropertyNameListStrategy dataType))
)

; ready for refactoring 2021-03-18
(defun GenerateGsLcEquipDataByImport (insPt dataList dataType sortedTypeResult / allGsBzEquipBlockNameList insPtList equipTagData equipPropertyTagDictList) 
  (VerifyGsLcEquipTagLayer)
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList dataList 0) 35))
  (setq equipTagData (InsertGsLcEquipTag dataList insPtList dataType))
  (UpdateGsEquipTagPropertyValue equipTagData (GetPropertyNameListStrategy dataType))
  ;(setq allGsBzEquipBlockNameList (GetAllGsBzEquipBlockNameList))
  ;(setq equipPropertyTagDictList (GetGsBzEquipPropertyTagDictListStrategy dataType dataList))
  ;(setq equipGraphData (InsertGsBzEquipGraph equipPropertyTagDictList insPtList dataType allGsBzEquipBlockNameList))
  ;(MigrateGsBzEquipTagPropertyValueFromCSV equipGraphData (GetPropertyNameListStrategy dataType))
)

; refactored at 2021-03-15
; red hat - fixed bug - csv data has no property [version], so need not to remove the first item
(defun MigrateGsBzEquipTagPropertyValueFromCSV (itemData blockPropertyNameList /) 
  (mapcar '(lambda (x) 
             (ModifyMultiplePropertyForOneBlockUtils (car x) 
               blockPropertyNameList
               (GetGsBzEquipBlockPropertyValueList (cdr x)))
          ) 
    itemData
  )
)

; 2021-03-12
(defun GetGsBzEquipPropertyTagDictListStrategy (dataType dataList / resultList)
  (setq resultList 
    (mapcar '(lambda (x) 
                (mapcar '(lambda (xx yy) 
                          (cons (strcase xx T) yy)
                        ) 
                  (GetPropertyNameListStrategy dataType)
                  (cdr x)
                ) 
            ) 
      dataList
    )  
  )
  (mapcar '(lambda (x) 
             ; simulate the frist item
             (cons (cons 0 "entity") x)
          ) 
    resultList
  ) 
)

(defun SortEquipDataStrategy (dataList sortedType /)
  (cond 
    ((= sortedType "equipTag") 
     (vl-sort importedDataList '(lambda (x y) (< (cadr x) (cadr y)))))
    ((= sortedType "equipVolume") 
     (vl-sort importedDataList '(lambda (x y) (< (ExtractEquipVolumeNumUtils (nth 4 x)) (ExtractEquipVolumeNumUtils (nth 4 y))))))
  )
)

; 2021-03-11
(defun UpdateGsEquipTagPropertyValue (itemData blockPropertyNameList /) 
  (mapcar '(lambda (x) 
             (ModifyMultiplePropertyForOneBlockUtils (car x) blockPropertyNameList (cdr x))
          ) 
    itemData
  )
)

; Generate GsBzEquipTag By Import CSV
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
; Update GsBzEquipGraph

; 2021-03-10
(defun c:UpdateGsBzEquipGraph ()
  (UpdateGsBzEquipGraphByBox "updateGsBzEquipGraphBox")
)

; 2021-03-09
(defun UpdateGsBzEquipGraphByBox (tileName / dcl_id status importedDataList exportMsgBtnStatus importMsgBtnStatus  modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowGs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    (action_tile "btnImportData" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    ; init the default data of text
    ; Display the number of selected pipes
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "导入数据状态：请先导入数据")
    ) 
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "设备图形更新状态：已完成")
    )
    ; all select button
    ; export data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (WriteGsBzDataToCSV)
        (setq exportMsgBtnStatus 1) 
      )
    )
    ; import data button
    (if (= 3 status) 
      (progn 
        (setq importedDataList 
               (GetImportedGsBzEquipDataList (StrListToListListUtils (ReadGsDataFromCSVStrategy "GsBzEquip"))))
        (setq importMsgBtnStatus 1)
      )
    )
    ; modify button
    (if (= 4 status) 
      (if (/= importedDataList nil) 
        (progn 
          (UpdateGsBzEquipData importedDataList)
          (setq modifyMsgBtnStatus 1)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-03-15
(defun WriteGsBzDataToCSV (/ entityNameList)
  (setq entityNameList (GetAllGsBzEquipEntityNameList))
  (WriteDataToCSVByEntityNameListStrategy entityNameList "GsBzEquip") 
)

; 2021-03-11
(defun GetImportedGsBzEquipDataList (dataList /)
  (mapcar '(lambda (x) 
             ; set equipTag as the key of List - 2021-03-15
             ; (F23101 GsBzCustomEquip F23101  800  1-2/A-B commentMsg)
             (cons (nth 2 x) (cdr x))
          ) 
    dataList
  )  
)

; 2021-03-15
; importedDataList: (V23104 GsBzTank V23104 立式双椭圆封头 500L V500D700LS 1-2/A-B 备注信息)
(defun UpdateGsBzEquipData (importedDataList / entityNameList)
  ; filter so slow, do not filter now. ready for refactor - 2021-03-15
  ;(setq importedDataList (FilterListByTestMemberUtils importedDataList (GetAllGsBzEquipTagList)))
  (setq entityNameList (GetAllGsBzEquipEntityNameList))
  (ReplaceAllGsBzEquipGraph importedDataList entityNameList)
  (ModifyPropertyValueByTagUtils importedDataList)
)

; refactored at 2021-03-15
(defun ModifyPropertyValueByTagUtils (importedDataList / entityNameList) 
  ; graph entity has been updated
  (setq entityNameList (GetAllGsBzEquipEntityNameList))
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (GetGsBzEquipPropertyNameList)
              (GetimportedPropertyValueListByEquipTag (GetGsBzEquipTagByEntityName x) importedDataList))
          ) 
    (FilterEntityNameListByImportedData entityNameList importedDataList)    
  )
)

; 2021-03-15
(defun ReplaceAllGsBzEquipGraph (importedDataList entityNameList / allGsBzEquipBlockNameList gsBzEquipClassAndTypeAndTag insPt)
  (setq allGsBzEquipBlockNameList (GetAllGsBzEquipBlockNameList))
  (mapcar '(lambda (x) 
             (setq gsBzEquipClassAndTypeAndTag (GetGsBzEquipClassAndTypeAndTag (GetGsBzEquipTagByEntityName x) importedDataList))
             (if (/= (cadr gsBzEquipClassAndTypeAndTag) (GetGsBzEquipTypeByEntityName x)) 
               (progn 
                 (setq insPt (GetEntityPositionByEntityNameUtils x))
                 (entdel x)
                 (ReGenerateBlockGsBzEquipGraph insPt 
                   (GetGsBzEquipBlockNameByCSV gsBzEquipClassAndTypeAndTag) 
                   (caddr gsBzEquipClassAndTypeAndTag)
                   allGsBzEquipBlockNameList)
               )
             )
          ) 
    (FilterEntityNameListByImportedData entityNameList importedDataList)     
  )
)

; 2021-03-15
(defun FilterEntityNameListByImportedData (entityNameList importedDataList / importedGsBzEquipTagList)
  (setq importedGsBzEquipTagList (GetImportedGsBzEquipTagList importedDataList))
  (vl-remove-if-not '(lambda (x) 
                      (member (GetGsBzEquipTagByEntityName x) importedGsBzEquipTagList)
                    ) 
    entityNameList
  )  
)

; 2021-03-15
(defun GetGsBzEquipBlockNameByCSV (gsBzEquipClassAndTypeAndTag /)
  (strcat (car gsBzEquipClassAndTypeAndTag) "-" (cadr gsBzEquipClassAndTypeAndTag))
)

; 2021-03-15
(defun ReGenerateBlockGsBzEquipGraph (insPt gsBzBlockName equipTag allGsBzEquipBlockNameList /) 
  (if (member gsBzBlockName allGsBzEquipBlockNameList) 
    (InsertBlockUtils insPt gsBzBlockName "0DataFlow-GsBzEquip" (list (cons 0 (GetGsBzEquipTypeClass gsBzBlockName)) 
                                                                      (cons 1 equipTag)
                                                                      (cons 4 (GetGsBzEquipType gsBzBlockName))
                                                                ))
    (InsertBlockGsBzEquipDefault insPt (list (cons 0 (GetGsBzEquipTypeClass gsBzBlockName)) 
                                             (cons 1 equipTag)
                                       ))
  )
)

; 2021-03-15
(defun GetImportedGsBzEquipTagList (importedDataList /) 
  (mapcar '(lambda (x) 
             ; have not call function GetDottedPairValueUtils, so 2th not 1th
             (nth 2 x)
          ) 
    importedDataList
  )  
)

; 2021-03-15
(defun GetGsBzEquipClassAndTypeAndTag (equipTag importedDataList / matchedList) 
  (setq matchedList (GetDottedPairValueUtils equipTag importedDataList))
  ; class is 1th, gsbzType is the 5th, and maybe change
  (list (car matchedList) (nth 4 matchedList) (nth 1 matchedList))
)

; 2021-03-15
(defun GetimportedPropertyValueListByEquipTag (equipTag importedDataList /)
  (GetDottedPairValueUtils equipTag importedDataList)
)

; 2021-03-15
(defun GetGsBzEquipTagByEntityName (entityName /) 
  ; the frist item is entityhandle, so tag is the 3th - 2021-03-15
  ;(cdr (nth 2 (GetAllPropertyDictForOneBlock entityName)))
  (GetDottedPairValueUtils "tag" (GetAllPropertyDictForOneBlock entityName))
)

; 2021-03-15
(defun GetGsBzEquipTypeByEntityName (entityName /) 
  (GetDottedPairValueUtils "gsbztype" (GetAllPropertyDictForOneBlock entityName))
)

; 2021-03-11
; too slow, do not apply now
(defun VerifyGsBzEquipData (importedDataList /)
  (vl-remove-if-not '(lambda (x) 
                      (member (car x) (GetAllGsBzEquipTagList))
                    ) 
    importedDataList
  ) 
)

;;;-------------------------------------------------------------------------;;;
; Set Location Data to GsBzGraphy

; 2021-04-08
(defun GetAllGsBzAxisoDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils "a" (GetAllPropertyDictForOneBlock (GetDottedPairValueUtils -1 (cadr x))))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetStrategyEntityData (GetAllGsBzAxisoData))
  ) 
)

; 2021-04-08
(defun GetAllGsBzAxisoData () 
  (GetSelectedEntityDataUtils (ssget "X" '((0 . "INSERT") (2 . "_AXISO"))))
)

; 2021-04-08
(defun GetAllGsBzLevelAxisoData () 
  ; sort from min to max
  (reverse 
    (vl-remove-if-not '(lambda (x) 
                        (RegexpTestUtils (cadr x) "[0-9]+$" nil)
                      ) 
      (GetAllGsBzAxisoDictListData)
    )  
  )
)

; 2021-04-08
(defun GetAllGsBzVerticalAxisoData () 
  ; sort from min to max
  (reverse 
    (vl-remove-if-not '(lambda (x) 
                        (RegexpTestUtils (cadr x) ".*[A-Z]$" nil)
                      ) 
      (GetAllGsBzAxisoDictListData)
    )  
  )
)

; 2021-04-08
(defun GetOneFloorGsBzLevelAxisoTwoPointData (dataList /) 
  (mapcar '(lambda (x y) 
             (list (car y) 
                   (strcat (cadr x) "-" (cadr y))
                   (list (car (caddr x)) (car (caddr y)))
             )
           ) 
    dataList
    (cdr dataList)
  ) 
)

; 2021-04-08
(defun GetOneFloorGsBzVerticalAxisoTwoPointData (dataList /) 
  (mapcar '(lambda (x y) 
             (list (car y) 
                   (strcat (cadr x) "-" (cadr y))
                   (list (cadr (caddr x)) (cadr (caddr y)))
             )
           ) 
    dataList
    (cdr dataList)
  ) 
)

; 2021-04-08
(defun GetAllFloorGsBzLevelAxisoTwoPointData () 
  (mapcar '(lambda (x) 
             (cons (car x) (GetOneFloorGsBzLevelAxisoTwoPointData (cdr x)))
           ) 
    (ChunkListByColumnIndexUtils (GetAllGsBzLevelAxisoData) 0)
  ) 
)

; 2021-04-08
(defun GetAllFloorGsBzVerticalAxisoTwoPointData () 
  (mapcar '(lambda (x) 
             (cons (car x) (GetOneFloorGsBzVerticalAxisoTwoPointData (cdr x)))
           ) 
    (ChunkListByColumnIndexUtils (GetAllGsBzVerticalAxisoData) 0)
  ) 
)

(defun c:foo ()
  (ExecuteFunctionAfterVerifyDateUtils 'GetAllFloorGsBzLevelAxisoTwoPointData)
)

; Equipemnt Layout
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;