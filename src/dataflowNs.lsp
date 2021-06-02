;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoNS ()
  (alert "暖通设计流最新版本号 V0.2，更新时间：2021-04-26\n数据流内网地址：192.168.1.38")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate NsEquipListTable

; refactored at 2021-04-09
(defun c:InsertNsEquipTableByDirection ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertNsEquipTableByBox '("importNsEquipTableBox"))
)

; 2021-03-18
(defun GetInsertDirectionChNameList ()
  '("自上而下" "自左到右")
)

; 2021-03-18
(defun InsertNsEquipTableByBox (tileName / dcl_id status sortedType)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowNs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnModify" "(done_dialog 2)")
    (set_tile "sortedType" "0")
    ; the default value of input box
    (mode_tile "sortedType" 2)
    (action_tile "sortedType" "(setq sortedType $value)")
    (progn
      (start_list "sortedType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetInsertDirectionChNameList))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil sortedType)
      (setq sortedType "0")
    ) 
    (set_tile "sortedType" sortedType)
    ; insert button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (InsertNsEquipListTable sortedType)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-04-25
(defun InsertNsEquipListTable (insertDirection / insPt nsEquipImportedList nsEquipProjectInfoList) 
  (VerifyNsBzTextStyleByName "DataFlow")
  (VerifyNsBzTextStyleByName "TitleText")
  (VerifyNsBzLayerByName "0DataFlow-NsText")
  (VerifyNsBzLayerByName "0DataFlow-NsEquipFrame")
  (VerifyNsBzBlockByName "equiplist.2017") 
  (setq nsEquipImportedList (GetNsEquipImportedList))
  (setq nsEquipProjectInfoList (GetNsEquipProjectInfoList nsEquipImportedList))
  (setq insPt (getpoint "\n拾取设备一览表插入点："))
  (InsertNsEquipTextList 
    (MoveInsertPositionUtils insPt 3000 25200) 
    (GetNsEquipRowDictList (ProcessOriginNsEquipDictList nsEquipImportedList)) 
    insertDirection 
    nsEquipProjectInfoList
  )
  (DeleteNsEquipNullText)
  (princ)
)

; refactored at 2021-04-25
(defun InsertNsEquipTextList (insPt equipDictList insertDirection nsEquipProjectInfoList / textHeight totalNum num insPtList) 
  (setq textHeight 350)
  (setq totalNum (1+ (/ (length equipDictList) 29)))
  (setq num 1)
  (mapcar '(lambda (x) 
              (InsertNsEquipFrame (MoveInsertPositionUtils insPt -3000 -25200) totalNum num nsEquipProjectInfoList)
              (setq insPtList (GetInsertPtListByYMoveUtils insPt (GenerateSortedNumByList x 0) -800))
              (mapcar '(lambda (xx yy) 
                        (InsertNsEquipListLeftTextByRow yy xx textHeight)
                      ) 
                x
                insPtList
              ) 
              (setq insPt (GetNextNsEquipFrameInsPtStrategy insPt insertDirection))
              (setq num (1+ num))
           ) 
    (SplitListByNumUtils equipDictList 29)
  ) 
)

; 2021-03-17
(defun DeleteNsEquipNullText ()
  (DeleteEntityBySSUtils (GetAllNsEquipNullTextSS))
)

; 2021-03-16
(defun GetAllNsEquipNullTextSS ()
  (ssget "X" (list (cons 0 "TEXT") (cons 1 "NsEquipNull")))
)

; 2021-03-17
(defun GetNextNsEquipFrameInsPtStrategy (insPt insertDirection /)
  (cond 
    ((= insertDirection "0") (MoveInsertPositionUtils insPt 0 -31700)) 
    ((= insertDirection "1") (MoveInsertPositionUtils insPt 44000 0)) 
  ) 
)

; 2021-03-17
(defun RepairNsEquipAirVolume (airVolume /)
  (strcat "风量：" airVolume "m3/h")
)

; 2021-03-17
; refactored at 2021-05-19
(defun ReadNsDataFromFileStrategy (dataType /)
  (cond 
    ((= dataType "NsEquip") (ReadDataFromCSVUtils "D:\\dataflowcad\\nsdata\\tempEquip.csv"))
    ((= dataType "nsCleanAir") (ReadDataFromFileByEncodeUtils "D:\\dataflowcad\\tempdata\\nsCleanAir.json"))
  )
)

; refactored at 2021-04-26
(defun InsertNsEquipFrame (insPt totalNum num nsEquipProjectInfoList /) 
  (InsertBlockByScaleUtils insPt "equiplist.2017" "0DataFlow-NsEquipFrame" (list (cons 0 totalNum) (cons 1 num)) 100)
  (ModifyNsEquipFrameProjectInfo (entlast) nsEquipProjectInfoList)  
)

; 2021-04-26
(defun ModifyNsEquipFrameProjectInfo (entityName nsEquipProjectInfoList /)
  (if (> (strlen (car nsEquipProjectInfoList)) 42) 
    (ModifyMultiplePropertyForOneBlockUtils entityName
      (list "PROJECT2L1" "PROJECT2L2" "UNITNAME" "DwgNo" "SPECI" "VER")
      (RepairNsEquipProjectInfoList nsEquipProjectInfoList)
    ) 
    (ModifyMultiplePropertyForOneBlockUtils entityName
      (list "PROJECT1" "UNITNAME" "DwgNo" "SPECI" "VER")
      nsEquipProjectInfoList
    ) 
  )
)

; 2021-04-26
(defun RepairNsEquipProjectInfoList (nsEquipProjectInfoList /) 
  (append 
    (SplitStrToListByIndexUtils (car nsEquipProjectInfoList) 42)
    (cdr nsEquipProjectInfoList)
  )
)

; 2021-03-17
(defun InsertNsEquipListCenterText (insPt textContent textHeight /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight 0.7) 
)

; 2021-03-17
(defun InsertNsEquipListCenterTextByWidth (insPt textContent textHeight textWidth /) 
  (GenerateLevelCenterTextUtils insPt textContent "0DataFlow-NsText" textHeight textWidth) 
)

; 2021-03-17
(defun InsertNsEquipListLeftText (insPt textContent textHeight /) 
  (GenerateLevelLeftTextUtils insPt textContent "0DataFlow-NsText" textHeight 0.7) 
)

; refacotered at 2021-04-25
(defun GetNsEquipImportedList ()
  (StrListToListListUtils (ReadNsDataFromFileStrategy "NsEquip"))
)

; 2021-04-25
; refactored at 2021-04-26
(defun GetOriginNsEquipDictList (nsEquipImportedList / propertyNameList) 
  (setq propertyNameList (cadr nsEquipImportedList))
  (mapcar '(lambda (y) 
              (mapcar '(lambda (xx yy) 
                         (cons xx yy)
                      ) 
                propertyNameList
                y
              )
           ) 
    (cdr (cdr nsEquipImportedList))
  )
)

; 2021-04-26
(defun GetNsEquipProjectInfoList (nsEquipImportedList /) 
  (vl-remove-if-not '(lambda (x) 
                      (/= x "") 
                    ) 
    (car nsEquipImportedList)
  )
)

; 2021-04-25
(defun ProcessOriginNsEquipDictList (nsEquipImportedList / rowId)
  (setq rowId 0)
  (mapcar '(lambda (x) 
             (setq rowId (1+ rowId))
             (append 
                (list 
                  ; id must convert to string 
                  (cons "id" (rtos rowId))
                )
                (list 
                  (cons "tag" (strcat (GetDottedPairValueUtils "tag1" x) "-" (GetDottedPairValueUtils "tag2" x) "-" (GetDottedPairValueUtils "tag3" x))) 
                )
                x
                (list 
                  (cons "comment" (RepairNsEquipSpecComment (GetDottedPairValueUtils "comment1" x) (GetDottedPairValueUtils "comment2" x))) 
                ) 
             )
           ) 
    (GetOriginNsEquipDictList nsEquipImportedList)
  )
)

; 2021-04-26
(defun RepairNsEquipSpecComment (fristComment secondComment /) 
  (if (/= fristComment "") 
    (strcat "服务区域：" fristComment "；" secondComment)
    (strcat "" secondComment)
  )
)

; 2021-04-25
(defun GetNsEquipRowDictListList (originNsEquipDictList / firstRowNameList specificationRowNameList) 
  (setq firstRowNameList 
    '("id" "tag" "name" "airVolume" "type" "unit" "num" "weight" "comment" "source"))
  (setq specificationRowNameList 
    '("runMode" "rotateSpeed" "fullPressure" "staticPressure" "residualPressure" "power" "voltage" "transferMode" "fanEfficiency" "unitPower" "efficiency" "noise" "size" "ioPosition" "ioSize" "explosionProof")) 
  ; the key logic
  (mapcar '(lambda (x) 
             (append 
               (list 
                  (vl-remove-if-not '(lambda (xx) 
                                      (/= (member (car xx) firstRowNameList) nil) 
                                    ) 
                    x
                  )  
               )
                (vl-remove-if-not '(lambda (xx) 
                                    (and 
                                      (/= (member (car xx) specificationRowNameList) nil) 
                                      (/= (cdr xx) "") 
                                    )
                                  ) 
                  x
                ) 
               (list (cons "NsEquipNull" "NsEquipNull"))
             )
           ) 
    originNsEquipDictList
  ) 
)

; 2021-04-25
(defun GetNsEquipRowDictList (originNsEquipDictList / resultList) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList x))
           ) 
    (GetNsEquipRowDictListList originNsEquipDictList)
  ) 
  resultList
)

; 2021-04-25
(defun InsertNsEquipListLeftTextByRow (insPt rowData textHeight /) 
  (if (IsListDataTypeUtils (car rowData))
    (InsertFristRowNsEquipList insPt rowData textHeight) 
    (InsertMiddleRowNsEquipList insPt rowData textHeight)
  )
)

; 2021-04-25
; ("id" "tag" "name" "airVolume" "type" "unit" "num" "weight" "comment" "source")
(defun InsertFristRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListCenterText insPt (GetDottedPairValueUtils "id" rowData) textHeight)
  (InsertNsEquipListCenterTextByWidth (MoveInsertPositionUtils insPt 1500 0) (GetDottedPairValueUtils "tag" rowData) textHeight 0.5)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 2700 0) (GetDottedPairValueUtils "name" rowData) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (RepairNsEquipAirVolume (GetDottedPairValueUtils "airVolume" rowData)) textHeight)
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 14700 0) (GetDottedPairValueUtils "type" rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 21300 0) (GetDottedPairValueUtils "unit" rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 22300 0) (GetDottedPairValueUtils "num" rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 24600 0) (GetDottedPairValueUtils "weight" rowData) textHeight)
  (InsertNsEquipListCenterText (MoveInsertPositionUtils insPt 30550 0) (GetDottedPairValueUtils "source" rowData) textHeight)
  (InsertNsEquipComments (MoveInsertPositionUtils insPt 33600 0) (GetDottedPairValueUtils "comment" rowData) textHeight)
)

; 2021-04-25
(defun InsertNsEquipComments (insPt commentData textHeight / commentList i)
  (setq i 0)
  (setq commentList (StrToListUtils commentData "；"))
  (mapcar '(lambda (x) 
             (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 0 (- 0 (* i 800))) x textHeight)
             (setq i (1+ i))
           ) 
    commentList
  ) 
)

; 2021-04-25
(defun InsertMiddleRowNsEquipList (insPt rowData textHeight /) 
  (InsertNsEquipListLeftText (MoveInsertPositionUtils insPt 6700 0) (RepairNsEquipSpecificationStrategy rowData) textHeight)
)

; 2021-04-25
; ("runMode" "rotateSpeed" "fullPressure" "staticPressure" "residualPressure" "power" "voltage" "transferMode" "fanEfficiency" "unitPower" "efficiency" "noise" "size" "ioPosition" "ioSize" "explosionProof")
(defun RepairNsEquipSpecificationStrategy (rowData /)
  (cond 
    ((= (car rowData) "runMode") (RepairNsEquipSpecRunMode rowData))
    ((= (car rowData) "rotateSpeed") (RepairNsEquipSpecRotateSpeed rowData))
    ((= (car rowData) "fullPressure") (RepairNsEquipSpecFullPressure rowData))
    ((= (car rowData) "staticPressure") (RepairNsEquipSpecStaticPressure rowData))
    ((= (car rowData) "residualPressure") (RepairNsEquipSpecResidualPressure rowData))
    ((= (car rowData) "power") (RepairNsEquipSpecPower rowData))
    ((= (car rowData) "voltage") (RepairNsEquipSpecVoltage rowData))
    ((= (car rowData) "transferMode") (RepairNsEquipSpecTransferMode rowData))
    ((= (car rowData) "fanEfficiency") (RepairNsEquipSpecFanEfficiency rowData))
    ((= (car rowData) "unitPower") (RepairNsEquipSpecUnitPower rowData))
    ((= (car rowData) "efficiency") (RepairNsEquipSpecEfficiency rowData))
    ((= (car rowData) "noise") (RepairNsEquipSpecNoise rowData))
    ((= (car rowData) "size") (RepairNsEquipSpecSize rowData))
    ((= (car rowData) "ioPosition") (RepairNsEquipSpecIOPosition rowData))
    ((= (car rowData) "ioSize") (RepairNsEquipSpecIOSize rowData))
    ((= (car rowData) "explosionProof") (RepairNsEquipSpecExplosionProof rowData))
    (T (cdr rowData))
  )
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecRunMode (dataList /) 
  (strcat "运行方式：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecRotateSpeed (dataList /) 
  (strcat "转速：" (cdr dataList) "r/min")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecFullPressure (dataList /) 
  (strcat "全压：" (cdr dataList) "Pa")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecStaticPressure (dataList /) 
  (strcat "静压：" (cdr dataList) "Pa")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecResidualPressure (dataList /) 
  (strcat "机外余压：" (cdr dataList) "Pa")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecPower (dataList /) 
  (strcat "功率：" (cdr dataList) "kW")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecVoltage (dataList /) 
  (strcat "电压：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecTransferMode (dataList /) 
  (strcat "传动方式：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecFanEfficiency (dataList /) 
  (strcat "风机效率：" 
    (rtos (fix (* 100 (atof (cdr dataList)))))
    "%"
  )
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecUnitPower (dataList /) 
  (strcat "单位风量耗功率：" 
    (vl-princ-to-string (/ (atoi (cdr dataList)) 100.00))
  )
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecEfficiency (dataList /) 
  (strcat "能效等级：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecNoise (dataList /) 
  (strcat "噪声：" (cdr dataList) "dB（A）")
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecSize (dataList /) 
  (strcat "外形尺寸：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecIOPosition (dataList /) 
  (strcat "进/出口方位角：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecIOSize (dataList /) 
  (strcat "进/出口尺寸：" (cdr dataList))
)

; refactored at 2021-04-25
(defun RepairNsEquipSpecExplosionProof (dataList /) 
  (strcat "防爆等级：" (cdr dataList))
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; NS Clean Air

; 2021-06-01
(defun VerifyNsACHBlockLayerText ()
  (VerifyNsCAHTextStyleByName "DataFlow")
  (VerifyNsCAHTextStyleByName "TitleText")
  (VerifyNsCAHLayerByName "0DataFlow*")
  (VerifyNsCAHBlockByName "NsCAH*")
  (VerifyNsCAHBlockByName "*\.2017")
)

; 2021-06-01
(defun VerifyAllNsACHSymbol ()
  (if (= *nsACHSymbolStatus* nil) 
    (progn 
      (VerifyNsACHBlockLayerText)
      (setq *nsACHSymbolStatus* T) 
    )
  )
)

; 2021-06-01
(defun c:InsertNsACH ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertNsACHMacro '())
)

; 2021-06-01
(defun InsertNsACHMacro (/ insPt allNsCleanAirData) 
  (VerifyAllNsACHSymbol)
  (setq insPt (getpoint "\n拾取PID插入点："))
  (setq allNsCleanAirData (GetAllNsCleanAirData))
  (InsertOneNsACHPID insPt allNsCleanAirData)
)

; 2021-05-31
(defun GetAllNsCleanAirData ()
  (mapcar '(lambda (x) (JsonToListUtils x)) 
    (ReadNsDataFromFileStrategy "nsCleanAir")
  ) 
)

; refacotred at 2021-05-07
(defun InsertOneNsACHPID (insPt allNsCleanAirData / equipType) 
  ; (setq equipTag (GetDottedPairValueUtils "TAG" oneTankData))
  (InsertNSACHDrawFrame insPt)
  (InsertAllNsACHRoomS (MoveInsertPositionUtils insPt -45500 47000) "2B" allNsCleanAirData)
  ; (InsertBsGCTEquipTableStrategy insPt bsGCTType oneTankData tankStandardList tankHeadStyleList 
  ;                          tankHeadMaterialList tankPressureElementList tankOtherRequestList equipType)
)

; 2021-06-01
(defun InsertNSACHDrawFrame (insPt /) 
  (InsertBlockByNoPropertyUtils insPt "NsCAH-DrawFrame" "0DataFlow-NsTitanTitle")
  (InsertBlockByNoPropertyByScaleUtils insPt "title.2017" "0DataFlow-NsTitanTitle" 100)
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "Stage" "Scale")
    (list "施工图" "1:100")
  )  
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt 0 4600) "revisions.2017" "0DataFlow-NsTitanTitle" 100)
  (InsertBlockByNoPropertyByScaleUtils (MoveInsertPositionUtils insPt -18000 0) "intercheck.2017" "0DataFlow-NsTitanTitle" 100)
)

; 2021-06-01
(defun InsertAllNsACHRoomS (insPt systemNum roomDictList / totalNum num insPtList) 
  (setq totalNum (1+ (/ (length roomDictList) 7)))
  (setq num 1)
  (mapcar '(lambda (x) 
              (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList x 0) 6600))
              (mapcar '(lambda (xx yy) 
                         (InsertOneNsACHRoomS yy "NsCAH-Room-S" systemNum xx)
                         (InsertNsCAHHEPA (MoveInsertPositionUtils yy 2000 6000) "NsCAH-RE-HEPA" systemNum)
                      ) 
                x
                insPtList
              ) 
              (setq insPt (MoveInsertPositionUtils insPt 0 -11500))
              (setq num (1+ num))
           ) 
    (SplitListByNumUtils roomDictList 7)
  ) 
)

; 2021-06-01
(defun InsertOneNsACHRoomS (insPt blockName systemNum oneRoomDictList /) 
  (InsertBlockUtils insPt blockName "0DataFlow-NsCAH" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (strcase (car x))) oneRoomDictList)
    (mapcar '(lambda (x) (cadr x)) oneRoomDictList)
  )
)

; 2021-06-02
; 高效送风口
(defun InsertNsCAHHEPA (insPt blockName systemNum /) 
  (InsertBlockUtils insPt blockName "0DataFlow-NsCAH" (list (cons 1 systemNum) (cons 2 "H13")))
)


(defun c:foo ()
  (GetAllNsCleanAirData)
)