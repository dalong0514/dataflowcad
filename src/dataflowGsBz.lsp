;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

; 2021-04-12
(defun c:syncCurrentDrawGsBzEquipBlock (/ item) 
  (foreach item (GetCurrentDrawAllGsBzEquipBlockNameList)
    (command "._attsync" "N" item)
  )
  (princ)
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

; 2021-05-28
(defun VerifyGsBzGraphBlock () 
  (VerifyGsBzBlockByName "GsBzGraph*")
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

; 2021-04-12
(defun GetAllGsBzEquipBlockNameListStrategy (dataType / entityData resultList) 
  (StealAllGsBzEquipBlocks)
  (setq entityData (tblnext "block" T)) 
  (while entityData 
    (if (wcmatch (cdr (assoc 2 entityData)) (GetGsBzEquipBlockNamePattern dataType)) 
      (setq resultList (append resultList (list (cdr (assoc 2 entityData)))))
    )
    (setq entityData (tblnext "block")) 
  ) 
  resultList
)

; 2021-04-12
(defun GetGsBzEquipBlockNamePattern (dataType /) 
  (cond 
    ((= dataType "Reactor") "GsBzReactor*")
    ((= dataType "Tank") "GsBzTank*")
  )
)

; 2021-04-12
(defun GetCurrentDrawAllGsBzEquipBlockNameList (/ entityData resultList) 
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

; 2021-06-25
(defun c:InsertBlockGsBzComfortAir () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsBzComfortAirMacro '())
)

; 2021-06-25
(defun InsertBlockGsBzComfortAirMacro (/ insPt) 
  (setq insPt (getpoint "\n选取房间块插入点："))
  (VerifyGsBzBlockByName "GsComfortAir")
  (VerifyGsBzComfortAirLayer)
  (InsertBlockByNoPropertyUtils insPt "GsComfortAir" "0DataFlow-GsBzComfortAirCondition")
)

; refactored at 2021-04-09
(defun c:InsertBlockGsBzCleanAir () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockGsBzCleanAirMacro '())
)

; refactored at 2021-04-09
(defun InsertBlockGsBzCleanAirMacro (/ insPt) 
  (setq insPt (getpoint "\n选取房间块插入点："))
  (VerifyGsBzBlockByName "GsCleanAir")
  (VerifyGsBzCleanAirLayer)
  (InsertBlockByNoPropertyUtils insPt "GsCleanAir" "0DataFlow-GsBzCleanAirCondition")
)

; 2021-06-25
(defun VerifyGsBzComfortAirLayer () 
  (VerifyGsBzLayerByName "0DataFlow-GsBzComfortAirCondition")
  (VerifyGsBzLayerByName "0DataFlow-GsBzComfortAirConditionComment")
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

; refactored at 2021-04-09
(defun c:numberLayoutData () 
  (ExecuteFunctionAfterVerifyDateUtils 'NumberLayoutDataMacro '())
)

; refactored at 2021-04-09
(defun NumberLayoutDataMacro (/ dataTypeList dataTypeChNameList dataModeChNameList)
  (setq dataTypeList (GetNumberGsBzDataTypeList))
  (setq dataTypeChNameList (GetNumberGsBzDataTypeChNameList))
  (setq dataModeChNameList (GetNumberGsBzDataModeChNameList))
  (enhancedNumberByBox dataTypeList dataTypeChNameList dataModeChNameList "enhancedNumberBox")
)

; refactored at 2021-05-02
(defun GetNumberGsBzDataTypeList ()
  '("GsBzEquip" "GsCleanAir" "GsComfortAir")
  ; '("GsCleanAir" "FireFightHPipe")
)

; refactored at 2021-05-02
(defun GetNumberGsBzDataTypeChNameList ()
  '("布置图设备位号" "洁净空调" "舒适性空调")
  ; '("洁净空调" "给排水消防立管")
)

(defun GetNumberGsBzDataModeChNameList ()
  '("按代号自动编码" "不按代号自动编号")
)

;;;-------------------------------------------------------------------------;;;
; migrate JS Layout Draw

; refactored at 2021-04-09
(defun c:purgeJSDrawData () 
  (ExecuteFunctionAfterVerifyDateUtils 'PurgeJSDrawDataMacro '())
)

; refactored at 2021-04-09
; refactored at 2021-05-11
(defun PurgeJSDrawDataMacro () 
  (DeleteEntityBySSUtils (GetAllJSDrawCopySS))
  (DeleteEntityBySSUtils (GetAllGsBzColumnCenterLineSS))
  (alert "建筑底图清理成功")
)

; refactored at 2021-04-09
(defun c:extractJSDrawData () 
  (ExecuteFunctionAfterVerifyDateUtils 'ExtractJSDrawDataMacro '())
)

; refactored at 2021-04-09
(defun ExtractJSDrawDataMacro () 
  (vl-bb-set 'architectureDraw (list (GetJSDrawBasePositionList) (GetAllStrategyCopyEntityData)))
  (alert "建筑底图提取成功")
)

; refactored at 2021-04-09
(defun c:migrateJSDraw () 
  (ExecuteFunctionAfterVerifyDateUtils 'MigrateJSDrawMacro '())
)

; refactored at 2021-04-09
(defun MigrateJSDrawMacro (/ GSDrawBasePositionList JSDrawBasePositionList newDrawBasePositionList JSDrawData resultList)
  (if (/= (vl-bb-ref 'architectureDraw) nil) 
    (progn 
      (setq GSDrawBasePositionList (GetJSDrawBasePositionList))
      (setq JSDrawBasePositionList (car (vl-bb-ref 'architectureDraw))) 
      (setq newDrawBasePositionList (GetNewDrawBasePositionList GSDrawBasePositionList JSDrawBasePositionList))
      (setq JSDrawData (car (cdr (vl-bb-ref 'architectureDraw)))) ; why have car? - 2021-02-28
      (DeleteEntityBySSUtils (GetAllJSDrawCopySS))
      ; refactored at 2021-05-11
      (DeleteEntityBySSUtils (GetAllGsBzColumnCenterLineSS))
      (GenerateNewJSEntityData newDrawBasePositionList JSDrawData)
      (alert "建筑底图更新成功") 
    )
    (alert "请先提取建筑底图！") 
  )
)

; refactored at 2021-04-09
(defun c:moveJSDraw () 
  (ExecuteFunctionAfterVerifyDateUtils 'MoveJSDrawMacro '())
)

; refactored at 2021-04-09
(defun MoveJSDrawMacro () 
  ; refactored at 2021-07-15
  (CADLispCopyUtils (GetAllJSAxisSS) '(0 0 0) '(400000 0 0)) 
  (CADLispMoveUtils (GetAllMoveDrawLabelSS) '(0 0 0) '(400000 0 0))
  (CADLispCopyUtils (GetAllCopyDrawLabelSS) '(0 0 0) '(400000 0 0)) 
  (generateJSDraw (MoveCopyEntityData))
  ; refactored at 2021-05-11
  (insertAllGsBzColumnCenterLine)
  (alert "移出建筑底图成功！") 
)

; 2021-05-11
(defun insertAllGsBzColumnCenterLine ()
  (VerifyGsBzBlockByName "GsBzColumnCenterLine")
  ; (VerifyGsBzLayerByName "0DataFlow-GsBzCenterLine")
  (mapcar '(lambda (x) 
             (InsertBlockByNoPropertyUtils x "GsBzColumnCenterLine" "COLUMN")
             ; could set the dynamic block property
              ; (VlaSetDynamicBlockPropertyValueUtils 
              ;   (GetLastVlaObjectUtils) 
              ;   (list (cons "XDistance" 800) (cons "YDistance" 800))
              ; )        
           ) 
    (GetAllJSDrawColumnPosition)
  ) 
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

; refactored at 2021-04-09
(defun c:switchLayerLock () 
  (ExecuteFunctionAfterVerifyDateUtils 'SwitchLayerLockMacro '())
)

; refactored at 2021-04-09
(defun SwitchLayerLockMacro (/ acadObj doc lockStatus lockStatusMsg)
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

; refactored at 2021-04-09
(defun c:lockJSDrawLayer () 
  (ExecuteFunctionAfterVerifyDateUtils 'LockJSDrawLayerMacro '())
)

; refactored at 2021-04-09
(defun LockJSDrawLayerMacro (/ acadObj doc lockStatus lockStatusMsg)
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

; refactored at 2021-04-09
(defun c:unlockJSDrawLayer () 
  (ExecuteFunctionAfterVerifyDateUtils 'UnlockJSDrawLayerMacro '())
)

; refactored at 2021-04-09
(defun UnlockJSDrawLayerMacro (/ acadObj doc lockStatus lockStatusMsg)
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
  (ProcessEntityDataForCopyUtils (GetJSDrawCopySS))
)

; 2021-02-28
(defun GetAllCopyEntityData () 
  (ProcessEntityDataForCopyUtils (GetAllJSDrawCopySS))
)

; 2021-03-01
(defun GetJSDrawCopySS () 
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
(defun GetAllJSDrawCopySS () 
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

; 2021-05-11
(defun GetAllGsBzColumnCenterLineSS () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzColumnCenterLine")))
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

; 2021-04-08
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
  (GetStrategyEntityDataByDrawFrame (GetAllCopyEntityData))
)

; 2021-02-28
(defun GetStrategyCopyEntityData () 
  (GetStrategyEntityDataByDrawFrame (GetCopyEntityData))
)

; 2021-02-27
; Draw Frame may not be A0, ready to refactor 2021-06-27
(defun GetStrategyEntityDataByDrawFrame (copyEntityData / resultList) 
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

; refactored at 2021-04-09
(defun c:extractGsLcEquipData () 
  (ExecuteFunctionAfterVerifyDateUtils 'ExtractGsLcEquipDataMacro '())
)

; refactored at 2021-04-09
(defun ExtractGsLcEquipDataMacro (/ lcEquipData) 
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

; refactored at 2021-04-09
(defun c:migrateGsLcEquipData () 
  (ExecuteFunctionAfterVerifyDateUtils 'MigrateGsLcEquipDataMacro '())
)

; refactored at 2021-04-09
(defun MigrateGsLcEquipDataMacro (/ insPt lcEquipData) 
  (setq insPt (getpoint "\n选取设备模块插入点："))
  (setq lcEquipData (vl-bb-ref 'gsLcEquipData))
  (if (/= lcEquipData nil) 
    (GenerateGsBzEquipTag lcEquipData insPt)
    (alert "请先提取流程设备数据！") 
  )
  (CADLispPurgeAllBlockUtils)
  (princ)
)

; refactored at 2021-03-10
(defun GenerateGsBzEquipTag (lcEquipData insPt / itemData equipTagData equipGraphData blockPropertyNameList allGsBzEquipBlockNameList) 
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
    ; refactored at 2021-04-09 [cons 2] is the GSBZTYPE
    (InsertBlockUtils insPt gsBzBlockName "0DataFlow-GsBzEquip" (list (cons 0 (GetGsBzEquipTypeClass gsBzBlockName)) 
                                                                  (cons 2 (GetGsBzEquipType gsBzBlockName))
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
; Generate GsBzEquipTag By GsBzEquipGraph

; 2021-05-14
(defun c:GenerateGsBzEquipTagByGraph ()
  (ExecuteFunctionAfterVerifyDateUtils 'GenerateGsBzEquipTagByGraphMacro '())
)

(defun GenerateGsBzEquipTagByGraphMacro (/)
  (VerifyGsBzEquipTagLayer)
  (if (/= (GetAllGsBzReactorGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Reactor"))
  (if (/= (GetAllGsBzTankGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Tank"))
  (if (/= (GetAllGsBzHeaterGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Heater"))
  (if (/= (GetAllGsBzPumpGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Pump"))
  (if (/= (GetAllGsBzCentrifugeGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Centrifuge"))
  (if (/= (GetAllGsBzVacuumGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "Vacuum"))
  (if (/= (GetAllGsBzCustomEquipGraphySSUtils) nil) (GenerateGsBzReactorTagByGraphStrategy "CustomEquip"))
)

; 2021-05-14
(defun GenerateGsBzReactorTagByGraphStrategy (dataType /)
  (cond 
    ((= dataType "Reactor") (GenerateGsBzEquipTagByGraphImpl "Reactor" (GetAllGsBzReactorGraphyData)))
    ((= dataType "Tank") (GenerateGsBzEquipTagByGraphImpl "Tank" (GetAllGsBzTankGraphyData)))
    ((= dataType "Heater") (GenerateGsBzEquipTagByGraphImpl "Heater" (GetAllGsBzHeaterGraphyData)))
    ((= dataType "Pump") (GenerateGsBzEquipTagByGraphImpl "Pump" (GetAllGsBzPumpGraphyData)))
    ((= dataType "Centrifuge") (GenerateGsBzEquipTagByGraphImpl "Centrifuge" (GetAllGsBzCentrifugeGraphyData)))
    ((= dataType "Vacuum") (GenerateGsBzEquipTagByGraphImpl "Vacuum" (GetAllGsBzVacuumGraphyData)))
    ((= dataType "CustomEquip") (GenerateGsBzEquipTagByGraphImpl "CustomEquip" (GetAllGsBzCustomEquipGraphyData)))
  )
)

; 2021-05-14
(defun GenerateGsBzEquipTagByGraphImpl (dataType gsBzReactorGraphyData /)
  (VerifyGsBzBlockByName dataType)
  (mapcar '(lambda (y) 
             (InsertBlockByNoPropertyUtils 
               (MoveInsertPositionUtils (GetEntityPositionByEntityNameUtils (handent (GetDottedPairValueUtils "entityhandle" y)))  2000 -2000)
               dataType
               "0DataFlow-GsBzEquipTag")
              (ModifyMultiplePropertyForOneBlockUtils (entlast) 
                (mapcar '(lambda (x) (strcase (car x))) y)
                (mapcar '(lambda (x) (cdr x)) y)
              )
          ) 
    gsBzReactorGraphyData
  ) 
)

;;;-------------------------------------------------------------------------;;;
; Generate GsBzEquipData By Import CSV

; refactored at 2021-04-09
(defun c:ImportGsBzEquipData ()
  (ExecuteFunctionAfterVerifyDateUtils 'ImportEquipDataStrategyByBox '("importGsEquipDataBox" "GsBzData"))
  ; refactored at 2021-04-12
  (CADLispPurgeAllBlockUtils)
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
               (CSVStrListToListListUtils (ReadGsDataFromCSVStrategy dataType)))
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
  ; refactored at 2021-04-12
  (cond 
    ((= importDataType "GsBzData") (GenerateGsBzEquipDataByImport insPt dataList dataType sortedTypeResult))
    ((= importDataType "GsLcData") (GenerateGsLcEquipDataByImport insPt dataList dataType sortedTypeResult))
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

; refactored at 2021-04-09
(defun c:UpdateGsBzEquipGraph ()
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateGsBzEquipGraphByBox '("updateGsBzEquipGraphBox"))
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
               (GetImportedGsBzEquipDataList (CSVStrListToListListUtils (ReadGsDataFromCSVStrategy "GsBzEquip"))))
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

; refactored at 2021-04-09
(defun GetGsBzEquipClassAndTypeAndTag (equipTag importedDataList / matchedList) 
  (setq matchedList (GetDottedPairValueUtils equipTag importedDataList))
  ; class is 1th, gsbzType is the 5th, and maybe change
  ; refactored at 2021-04-09 gsbzType is [nth 2 matchedList]
  (list (car matchedList) (nth 2 matchedList) (nth 1 matchedList))
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

; 2021-04-09
(defun c:UpdateGsBzEquipGraphyPostiontData () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateGsBzEquipGraphyPostiontDataMacro '())
  (alert "设备位置更新成功！")
)

; 2021-04-08
(defun GetAllGsBzAxisoDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils "a" (GetAllPropertyDictForOneBlock (GetDottedPairValueUtils -1 (cadr x))))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetStrategyEntityDataByDrawFrame (GetAllJsAxisoData))
  ) 
)

; 2021-04-08
; rename at 2021-06-29
(defun GetAllJsAxisoData () 
  (GetEntityDataBySSUtils (ssget "X" '((0 . "INSERT") (2 . "_AXISO"))))
)

; 2021-06-30
(defun GetAllJsColumnData () 
  (GetEntityDataBySSUtils (ssget "X" '((0 . "INSERT") (8 . "COLUMN"))))
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
                   (strcat (cadr x) "—" (cadr y))
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
                   (strcat (cadr x) "—" (cadr y))
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

; 2021-04-09
(defun GetAllGsBzEquipGraphyData () 
  (GetEntityDataBySSUtils (GetAllGsBzEquipGraphySSUtils))
)

; 2021-05-14
(defun GetAllGsBzEquipGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBz*")))
)

; 2021-05-14
(defun GetAllGsBzReactorGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzReactor*")))
)

; 2021-05-14
(defun GetAllGsBzTankGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzTank*")))
)

; 2021-05-14
(defun GetAllGsBzHeaterGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzHeater*")))
)

; 2021-05-14
(defun GetAllGsBzPumpGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzPump*")))
)

; 2021-05-14
(defun GetAllGsBzCentrifugeGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzCentrifuge*")))
)

; 2021-05-14
(defun GetAllGsBzVacuumGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzRVacuum*")))
)

; 2021-05-14
(defun GetAllGsBzCustomEquipGraphySSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "GsBzCustomEquip*")))
)

; 2021-05-14
(defun GetAllGsBzReactorGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzReactorGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzTankGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzTankGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzHeaterGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzHeaterGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzPumpGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzPumpGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzCentrifugeGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzCentrifugeGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzzVacuumGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzVacuumGraphySSUtils)))
)

; 2021-05-14
(defun GetAllGsBzCustomEquipGraphyData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllGsBzCustomEquipGraphySSUtils)))
)

; 2021-04-09
(defun GetAllGsBzEquipGraphyDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils -1 (cadr x))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetStrategyEntityDataByDrawFrame (GetAllGsBzEquipGraphyData))
  ) 
)

; 2021-04-09
(defun GetAllFloorGsBzEquipGraphyDictListData () 
  (ChunkListByColumnIndexUtils (GetAllGsBzEquipGraphyDictListData) 0) 
)

; 2021-04-09
(defun GetOneFloorGsBzEquipGraphyDictListData () 
  (car 
    (ChunkListByColumnIndexUtils (GetAllGsBzEquipGraphyDictListData) 0) 
  )
)

; 2021-04-09
(defun UpdateGsBzEquipGraphyPostiontDataMacro () 
  (foreach item (GetGsBzEquipGraphyFloorsList) 
    (mapcar '(lambda (x) 
                (UpdateOneFloorGsBzEquipGraphyPostiontData 
                  x
                  (GetDottedPairValueUtils item (GetAllFloorGsBzLevelAxisoTwoPointData))
                  (GetDottedPairValueUtils item (GetAllFloorGsBzVerticalAxisoTwoPointData))
                )
             ) 
      (GetDottedPairValueUtils item (GetAllFloorGsBzEquipGraphyDictListData))
    ) 
  )
)

; 2021-04-09
(defun GetGsBzEquipGraphyFloorsList ()
  (mapcar '(lambda (x) (car x)) 
    (GetAllFloorGsBzEquipGraphyDictListData)
  )   
)

; 2021-04-09
(defun UpdateOneFloorGsBzEquipGraphyPostiontData (equipData oneFloorGsBzLevelAxisoTwoPointData oneFloorGsBzVerticalAxisoTwoPointData /)
  (mapcar '(lambda (x) 
            (mapcar '(lambda (y) 
                        (if (IsPositionInRegionByFourPointUtils (nth 2 equipData) (car (nth 2 x)) (cadr (nth 2 x)) (car (nth 2 y)) (cadr (nth 2 y))) 
                          ; (strcat (nth 1 x) "#" (nth 1 y))
                          ; (cadr equipData)
                          (ModifyMultiplePropertyForOneBlockUtils 
                            (cadr equipData) 
                            (list "FLOORHEIGHT" "XPOSITION" "YPOSITION") 
                            (list (car equipData) (nth 1 x) (nth 1 y)))
                        )
                    ) 
              oneFloorGsBzVerticalAxisoTwoPointData
            ) 
          ) 
    oneFloorGsBzLevelAxisoTwoPointData
  )  
)

;;;-------------------------------------------------------------------------;;;
; Generate GSBz Reactor Graph

; 2021-05-28
(defun GenerateGSBzReactorGraph (insPt reactorRadius jacketRadius nozzleRadius blotRadius nozzleAngle lugAngle /) 
  (GenerateGSBzReactorGraphBarrel insPt reactorRadius jacketRadius nozzleRadius nozzleAngle)
  (GenerateGSBzReactorGraphLugSupport insPt (* 2 jacketRadius) (* 2 blotRadius) lugAngle)
)

; 2021-05-28
(defun GenerateGSBzReactorGraphBarrel (insPt reactorRadius jacketRadius nozzleRadius nozzleAngle /) 
  (InsertBlockUtils insPt "GSBzGraphReactor" "0DataFlow-GsBzEquip" (list (cons 1 "")))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list 
      (cons "DIAMETER" (rtos reactorRadius)) 
      (cons "STATUS" "PersonHole") 
      (cons "JACKET_DIAMETER" (rtos jacketRadius))
      (cons "NOZZLE_DIAMETER" nozzleRadius) 
      (cons "NOZZLE_ANGLE" nozzleAngle) 
    )
  ) 
)

; 2021-05-28
(defun GenerateGSBzReactorGraphLugSupport (insPt reactorDiameter blotDiameter lugAngle /) 
  (InsertBlockByRotateUtils insPt "GSBzGraphLugSupportTopView-A6" "0DataFlow-GsBzEquip" (list (cons 1 "")) lugAngle)
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list 
      (cons "LUG_DIAMETER_X" (rtos reactorDiameter)) 
      (cons "LUG_DIAMETER_Y" (rtos reactorDiameter)) 
      (cons "BLOT_DIAMETER_X" (rtos blotDiameter))
      (cons "BLOT_DIAMETER_Y" (rtos blotDiameter)) 
    )
  ) 
)

; Equipemnt Layout
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;