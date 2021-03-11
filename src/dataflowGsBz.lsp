;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; utils Function for  Equipemnt Layoutt

; 2021-03-11
(defun GetAllGsBzEquipEntityNameList () 
  (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "GsBzEquip"))
)

; utils Function for  Equipemnt Layoutt
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
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
  (generateJSDraw (MoveCopyEntityData))
  (CADLispMove (GetAllMoveDrawLabelSS) '(0 0 0) '(200000 0 0))
  (CADLispCopy (GetAllCopyDrawLabelSS) '(0 0 0) '(200000 0 0)) 
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
  (MoveCopyEntityDataByBasePosition (GetAllCopyEntityData) '(200000 0))
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
               (GetJSDrawPositionRangeUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x)))))
             )
           ) 
    (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

(defun GetJSDrawPositionRangeUtils (position /)
  (list (+ (car position) -126150) (+ (cadr position) 89100))
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

; 2021-02-28
(defun MoveCopyEntityDataByBasePosition (entityData basePosition /)
  (mapcar '(lambda (x) 
             ; ready for refactor
             (if (= (cdr (assoc 0 x)) "INSERT") 
               (MoveBlockDataByBasePosition x basePosition)
               (progn 
                 (if (= (cdr (assoc 0 x)) "LINE") 
                   (MoveLineDataByBasePosition x basePosition)
                   (MovePolyLineDataByBasePosition x basePosition)
                 )
               )
             )  
           ) 
    entityData
  )
)

(defun MoveLineDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10 11)
    (list (MoveInsertPosition (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
          (MoveInsertPosition (cdr (assoc 11 x)) (car basePosition) (cadr basePosition))
    )
  )
)

(defun MoveBlockDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10)
    (list (MoveInsertPosition (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
    )
  )
)

(defun MovePolyLineDataByBasePosition (entityData basePosition / resultList)
  (mapcar '(lambda (x) 
             (if (= (car x) 10) 
               (setq resultList (append resultList (list (cons 10 (MoveInsertPosition (cdr x) (car basePosition) (cadr basePosition))))))
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
               (MoveInsertPosition (cadr y) (- 0 (car (cadr x))) (- 0 (cadr (cadr x))))
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

; 2021-03-098
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

; 2021-03-098
(defun c:migrateGsLcEquipData (/ insPt lcEquipData) 
  (setq insPt (getpoint "\n选取设备模块插入点："))
  (setq lcEquipData (vl-bb-ref 'gsLcEquipData))
  (if (/= lcEquipData nil) 
    (GenerateGsBzEquipTag lcEquipData insPt)
    (alert "请先提取流程设备数据！") 
  )(princ)
)

; refactored at 2021-03-10
(defun GenerateGsBzEquipTag (lcEquipData insPt / itemData equipTagData equipGraphData insPt) 
  (mapcar '(lambda (x) 
             (setq itemData (cdr x))
             ; sorted by EquipName
             (setq itemData (vl-sort itemData '(lambda (x y) (< (cdr (caddr x)) (cdr (caddr y))))))
             (setq insPtList (GetInsertBzEquipinsPtList insPt itemData))
             (setq equipTagData (InsertGsBzEquipTag itemData insPtList (car x))) 
             (setq equipGraphData (InsertGsBzEquipGraph itemData insPtList (car x))) 
             (MigrateGsBzEquipTagPropertyValue equipTagData)
             (MigrateGsBzEquipTagPropertyValue equipGraphData)
             (setq insPt (MoveInsertPosition insPt 0 -15000))
          ) 
    lcEquipData
  )  
)

; 2021-03-10
(defun GetInsertBzEquipinsPtList (insPt equipData / resultList insPt) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list insPt)))
             (setq insPt (MoveInsertPosition insPt 5000 0))
          ) 
    equipData
  ) 
  resultList
)

; 2021-03-09
(defun MigrateGsBzEquipTagPropertyValue (itemData / blockPropertyNameList) 
  (setq blockPropertyNameList 
    (mapcar '(lambda (x) 
              (strcase (car x))
            ) 
      (cdr (car itemData))
    ) 
  ) 
  (mapcar '(lambda (x) 
             (ModifyMultiplePropertyForOneBlockUtils (car x) blockPropertyNameList (GetGsBzEquipBlockPropertyValueList (cdr x)))
          ) 
    itemData
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
(defun InsertGsBzEquipGraph (itemData insPtList dataType /) 
  (mapcar '(lambda (x y) 
             (InsertBlockGsBzEquipGraphStrategy (MoveInsertPosition y 0 3000) "GsBzTank5000LS")
             (cons (entlast) (cdr x))
          ) 
    itemData
    insPtList
  )  
)

;;;-------------------------------------------------------------------------;;;
; Update GsBzEquipGraph

; 2021-03-10
(defun c:UpdateGsBzEquipGraph ()
  (UpdateGsBzEquipGraphByBox "updateGsBzEquipGraphBox")
)

; 2021-03-09
(defun UpdateGsBzEquipGraphByBox (tileName / dcl_id exportDataType viewPropertyName dataType importedDataList status ss entityNameList exportMsgBtnStatus importMsgBtnStatus  modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "modifyBtnMsg" "修改CAD数据状态：已完成")
    )
    ; all select button
    ; export data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq entityNameList (GetAllGsBzEquipEntityNameList))
        (WriteDataToCSVByEntityNameListStrategy entityNameList "GsBzEquip")
        (setq exportMsgBtnStatus 1) 
      )
    )
    ; import data button
    (if (= 3 status) 
      (progn 
        (setq importedDataList (GetImportedGsBzEquipDataList (StrListToListListUtils (ReadDataFromCSVStrategy "GsBzEquip"))))
        (setq importMsgBtnStatus 1)
      )
    )
    ; modify button
    (if (= 4 status) 
      (if (/= importedDataList nil) 
        (progn 
          (princ importedDataList)
          (ModifyPropertyValueByTagUtils importedDataList (GetGsBzEquipPropertyNameList))
          ;(setq modifyMsgBtnStatus 1)
        )
      )
    )
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

; 2021-03-11
(defun GetImportedGsBzEquipDataList (dataList /)
  (mapcar '(lambda (x) 
             (cdr x)
          ) 
    dataList
  )  
)

; 2021-03-11
(defun ModifyPropertyValueByTagUtils (importedDataList propertyNameList / entityNameList propertyValueList)
  (setq importedDataList (FilterListByTestMemberUtils importedDataList data))
  (setq entityNameList (mapcar '(lambda (x) (handent (car x))) 
                            importedDataList
                          )
  )
  (setq propertyValueList (mapcar '(lambda (x) (cdr x)) 
                            importedDataList
                          )
  )
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x propertyNameList y)
          ) 
    entityNameList
    propertyValueList      
  )
)




; Equipemnt Layout
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;