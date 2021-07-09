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
    ((= dataType "NsEquip") (ReadDataFromCSVTrimFirstRowUtils "D:\\dataflowcad\\nsdata\\tempEquip.csv"))
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
    (SplitProjectInfoToTwoLineUtils (car nsEquipProjectInfoList))
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
  (CSVStrListToListListUtils (ReadNsDataFromFileStrategy "NsEquip"))
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
; refacotred at 2021-06-04
(defun InsertNsACHMacro (/ insPt allNsCleanAirData insPtList) 
  (VerifyAllNsACHSymbol)
  (setq insPt (getpoint "\n拾取PID插入点："))
  (setq allNsCleanAirData (GetAllNsCleanAirData))
  (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList allNsCleanAirData 0) 104100))
  (mapcar '(lambda (x y) 
            (InsertOneNsCAHPID x (cdr y))
          ) 
    insPtList
    allNsCleanAirData
  ) 
)

; 2021-06-04
(defun InserOnetNsACHMacro (/ insPt allNsCleanAirData insPtList) 
  (VerifyAllNsACHSymbol)
  (setq insPt (getpoint "\n拾取PID插入点："))
  (setq allNsCleanAirData (GetAllNsCleanAirData))
  (InsertOneNsCAHPID insPt (cdr (car allNsCleanAirData)))
)

; 2021-05-31
(defun GetAllNsCleanAirData () 
  (ChunkListListByKeyNameUtils 
    (mapcar '(lambda (x) (JsonToListUtils x)) 
      (ReadNsDataFromFileStrategy "nsCleanAir")
    ) 
    "systemNum"
  )
)

; 2021-05-07
; refacotred at 2021-06-03
; refacotred at 2021-06-04
; refacotred at 2021-06-09
(defun InsertOneNsCAHPID (insPt allNsCleanAirData / nsSystemCleanAirData nsSysRefrigeratingData nsRoomCleanAirData nsSysPIDData systemNum) 
  (setq nsSystemCleanAirData (GetSystemCleanAirData allNsCleanAirData))
  (setq nsSysRefrigeratingData (GetSysRefrigeratingData allNsCleanAirData))
  (setq nsRoomCleanAirData (GetRoomCleanAirData allNsCleanAirData))
  (setq nsSysPIDData (GetSysPIDData allNsCleanAirData))
  (setq systemNum (GetListPairValueUtils "systemNum" nsSystemCleanAirData))
  (InsertNSACHDrawFrame insPt)
  (InsertAllNsACHRoomS (MoveInsertPositionUtils insPt -45500 47000) systemNum nsRoomCleanAirData nsSysPIDData)
  (InsertOneNsCAHAirConditionUnit (MoveInsertPositionUtils insPt -78000 32000) systemNum nsSystemCleanAirData nsSysRefrigeratingData nsSysPIDData)
)

; 2021-06-04
(defun GetRoomCleanAirData (allNsCleanAirData /)
  (vl-remove-if-not 
    '(lambda (x) (/= (GetListPairValueUtils "roomSupplyAirRate" x) nil))
    allNsCleanAirData
  )
)

; 2021-06-04
(defun GetSystemCleanAirData (allNsCleanAirData /)
  (car 
    (vl-remove-if-not 
      '(lambda (x) (/= (GetListPairValueUtils "systemSupplyAirRate" x) nil))
      allNsCleanAirData
    )
  )
)

; 2021-06-04
(defun GetSystemCleanAirData (allNsCleanAirData /)
  (car 
    (vl-remove-if-not 
      '(lambda (x) (/= (GetListPairValueUtils "systemSupplyAirRate" x) nil))
      allNsCleanAirData
    )
  )
)

; 2021-06-04
(defun GetSysRefrigeratingData (allNsCleanAirData /)
  (car 
    (vl-remove-if-not 
      '(lambda (x) (/= (GetListPairValueUtils "winterHeatingSteamRate" x) nil))
      allNsCleanAirData
    )
  )
)

; 2021-06-09
(defun GetSysPIDData (allNsCleanAirData /)
  (car 
    (vl-remove-if-not 
      '(lambda (x) (/= (GetListPairValueUtils "supplyAirValveType" x) nil))
      allNsCleanAirData
    )
  )
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

;;;-------------------------------------------------------------------------;;;
; Generate All Room Graph
; 2021-06-01
(defun InsertAllNsACHRoomS (insPt systemNum roomDictList nsSysPIDData / totalNum num insPtList highEfficiencyAirInlet supplyAirValveType returnAirValveType) 
  (setq highEfficiencyAirInlet (GetListPairValueUtils "highEfficiencyAirInlet" nsSysPIDData))
  (setq supplyAirValveType (GetListPairValueUtils "supplyAirValveType" nsSysPIDData))
  (setq returnAirValveType (GetListPairValueUtils "returnAirValveType" nsSysPIDData))
  (setq totalNum (1+ (/ (length roomDictList) 7)))
  (setq num 1)
  (mapcar '(lambda (x) 
              (setq insPtList (GetInsertPtListByXMoveUtils insPt (GenerateSortedNumByList x 0) 6600))
              (GenerateLineUtils (MoveInsertPositionUtils insPt -6100 9500) (MoveInsertPositionUtils insPt 41600 9500) "0DataFlow-NsNT-DUCT-S.A")
              (GenerateLineUtils (MoveInsertPositionUtils insPt -6100 9000) (MoveInsertPositionUtils insPt 43350 9000) "0DataFlow-NsNT-DUCT-R.A")
              (GenerateLineUtils (MoveInsertPositionUtils insPt -6100 8500) (MoveInsertPositionUtils insPt 43350 8500) "0DataFlow-NsNT-DUCT-E.A")
              (mapcar '(lambda (xx yy) 
                         (InsertOneNsACHRoomS yy "NsCAH-Room-S" xx)
                         (InsertNsCAHSupplyAirUnit (MoveInsertPositionUtils yy 2000 6000) xx systemNum highEfficiencyAirInlet supplyAirValveType)
                         (InsertNsCAHInstrument (MoveInsertPositionUtils yy 3600 5600) systemNum)
                         (InsertNsCARoomPositiveAirRate (MoveInsertPositionUtils yy 500 0) systemNum)
                         (InsertNsCAHClipWallStrategy (MoveInsertPositionUtils yy 4250 0) xx systemNum returnAirValveType)
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
(defun InsertOneNsACHRoomS (insPt blockName oneRoomDictList /) 
  (setq oneRoomDictList (UpdateRoomDictList oneRoomDictList))
  (InsertBlockByNoPropertyUtils insPt blockName "0DataFlow-NsNT-ROOM")
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (strcase (car x))) oneRoomDictList)
    (mapcar '(lambda (x) (cadr x)) oneRoomDictList)
  )
)

; 2021-06-10
(defun UpdateRoomDictList (oneRoomDictList /) 
  (setq oneRoomDictList 
    (subst 
      (list "roomPressure" (strcat (GetListPairValueUtils "roomPressure" oneRoomDictList) "Pa") )
      (assoc "roomPressure" oneRoomDictList)
      oneRoomDictList)
  )
  (subst 
    (list "cleanGrade" (strcat (GetListPairValueUtils "cleanGrade" oneRoomDictList) "级") )
    (assoc "cleanGrade" oneRoomDictList)
    oneRoomDictList)
)

; 2021-06-02
(defun InsertNsCAHSupplyAirUnit (insPt oneRoomDictList systemNum highEfficiencyAirInlet supplyAirValveType / nsCAHValveDictList) 
  (InsertNsCAHHEPA insPt systemNum highEfficiencyAirInlet)
  (setq nsCAHValveDictList (GetCAHSupplyAirRateValveDictList oneRoomDictList supplyAirValveType))
  (InsertNsCAHValve (MoveInsertPositionUtils insPt 0 1300) (GetNsCAHAirValveBlockNameEnums supplyAirValveType) nsCAHValveDictList)
  (InsertNsCAHDuctSA (MoveInsertPositionUtils insPt 0 1300) "0DataFlow-NsNT-DUCT-S.A")
)

; 2021-06-02
; 高效送风口
(defun InsertNsCAHHEPA (insPt systemNum highEfficiencyAirInlet /) 
  (InsertBlockUtils insPt "NsCAH-RE-HEPA" "0DataFlow-NsNT-LET-HEPA" (list (cons 1 systemNum) (cons 2 highEfficiencyAirInlet)))
)

; 2021-06-02
(defun InsertNsCAHInstrument (insPt systemNum /) 
  (InsertBlockUtils insPt "NsCAH-InstrumentP" "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "FUNCTION" "NAME")
    (list "PDI" "微差压计")
  ) 
  (GenerateLineByLineScaleUtils (MoveInsertPositionUtils insPt 0 400) (MoveInsertPositionUtils insPt 0 1400) "0DataFlow-NsNT-INSTRUMENT-LINE" 1000)
  (GenerateLineByLineScaleUtils (MoveInsertPositionUtils insPt 0 1400) (MoveInsertPositionUtils insPt 450 1400) "0DataFlow-NsNT-INSTRUMENT-LINE" 1000)
)

; 2021-06-02
(defun InsertNsCARoomPositiveAirRate (insPt systemNum /) 
  (InsertBlockUtils insPt "NsCAH-RE-Room-In" "0DataFlow-NsNT-ROOM" (list (cons 1 systemNum)))
  (InsertBlockUtils (MoveInsertPositionUtils insPt 1000 0) "NsCAH-RE-Room-Out" "0DataFlow-NsNT-ROOM" (list (cons 1 systemNum)))
  (InsertBlockUtils (MoveInsertPositionUtils insPt 2000 0) "NsCAH-RE-Room-PositiveAR" "0DataFlow-NsNT-ROOM" (list (cons 1 systemNum)))
)

; 2021-06-02
(defun InsertNsCAHClipWallStrategy (insPt oneRoomDictList systemNum returnAirValveType /) 
  (cond 
    ((> (GetListPairValueUtils "roomExhaustAirRate" oneRoomDictList) 0) (InsertNsCAHExhaustAirUnit insPt oneRoomDictList systemNum returnAirValveType))
    ((> (GetListPairValueUtils "roomReturnAirRate" oneRoomDictList) 0) (InsertNsCAHReturnAirUnit insPt oneRoomDictList systemNum returnAirValveType))
  )
)

; 2021-06-02
(defun InsertNsCAHExhaustAirUnit (insPt oneRoomDictList systemNum returnAirValveType / nsCAHValveDictList) 
  (InsertNsCAHExhaustClipWall insPt systemNum)
  (setq nsCAHValveDictList (GetCAHExhaustAirRateValveDictList oneRoomDictList returnAirValveType))
  (InsertNsCAHValve (MoveInsertPositionUtils insPt 0 7300) (GetNsCAHAirValveBlockNameEnums returnAirValveType) nsCAHValveDictList)
  (InsertNsCAHDuctEA (MoveInsertPositionUtils insPt 0 7300) "0DataFlow-NsNT-DUCT-E.A")
)

; 2021-06-02
(defun InsertNsCAHReturnAirUnit (insPt oneRoomDictList systemNum returnAirValveType / nsCAHValveDictList) 
  (InsertNsCAHReturnClipWall insPt systemNum)
  (setq nsCAHValveDictList (GetCAHReturnAirRateValveDictList oneRoomDictList returnAirValveType))
  (InsertNsCAHValve (MoveInsertPositionUtils insPt 0 7300) (GetNsCAHAirValveBlockNameEnums returnAirValveType) nsCAHValveDictList)
  (InsertNsCAHDuctRA (MoveInsertPositionUtils insPt 0 7300) "0DataFlow-NsNT-DUCT-R.A")
)

; 2021-06-02
(defun InsertNsCAHReturnClipWall (insPt systemNum /) 
  (InsertBlockUtils insPt "NsCAH-ReturnExhaust-ClipWall" "0DataFlow-NsNT-DUCT-R.A" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "RETURN_EXHAUST" "RETURN_EXHAUST_CLIPWALL")
    (list "R.A" "回风夹墙 Retuin air wall")
  )  
)

; 2021-06-02
(defun InsertNsCAHExhaustClipWall (insPt systemNum /) 
  (InsertBlockUtils insPt "NsCAH-ReturnExhaust-ClipWall" "0DataFlow-NsNT-DUCT-E.A" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "RETURN_EXHAUST" "RETURN_EXHAUST_CLIPWALL")
    (list "E.A" "排风夹墙 Exhaust air wall")
  )  
)

; 2021-06-02
(defun InsertNsCAHDuctSA (insPt layerName /) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 300) (MoveInsertPositionUtils insPt 0 1050) layerName)
  (InsertNsCAHDuctArcLine (MoveInsertPositionUtils insPt 0 1200) layerName 350)
  (InsertNsCAHDuctArcLine (MoveInsertPositionUtils insPt 0 1700) layerName 500)
)

; 2021-06-02
(defun InsertNsCAHDuctRA (insPt layerName /) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 300) (MoveInsertPositionUtils insPt 0 1050) layerName)
  (InsertNsCAHDuctArcLine (MoveInsertPositionUtils insPt 0 1200) layerName 500)
)

; 2021-06-02
(defun InsertNsCAHDuctEA (insPt layerName /) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 300) (MoveInsertPositionUtils insPt 0 1200) layerName)
)

; 2021-06-02
(defun InsertNsCAHDuctArcLine (insPt layerName lineLength /) 
  (InsertNsCAHDuctArc insPt layerName)
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 150) (MoveInsertPositionUtils insPt 0 lineLength) layerName)
)

; 2021-06-02
(defun InsertNsCAHDuctArc (insPt layerName /)
  (GenerateArcUtils insPt layerName 150 (* 1.5 PI) (* 0.5 PI))
)

; 2021-06-02
(defun InsertNsCAHValve (insPt blockName nsCAHValveDictList /) 
  (InsertBlockUtils insPt blockName "0DataFlow-NsNT-VALVE-CAV" (list (cons 1 "")))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (mapcar '(lambda (x) (strcase (car x))) nsCAHValveDictList)
    (mapcar '(lambda (x) (cadr x)) nsCAHValveDictList)
  )
)

; 2021-06-02
(defun GetCAHSupplyAirRateValveDictList (oneRoomDictList supplyAirValveType /)
  (append 
    (list (list "systemNum" (GetListPairValueUtils "systemNum" oneRoomDictList)))
    (list (list "CMH" (vl-princ-to-string (GetListPairValueUtils "roomSupplyAirRate" oneRoomDictList))))
    (list (list "TAG" "CAV0101"))
    (list (list "VALVE_TYPE" supplyAirValveType))
  )
)

; 2021-06-02
(defun GetCAHExhaustAirRateValveDictList (oneRoomDictList returnAirValveType /)
  (append 
    (list (list "systemNum" (GetListPairValueUtils "systemNum" oneRoomDictList)))
    (list (list "CMH" (vl-princ-to-string (GetListPairValueUtils "roomExhaustAirRate" oneRoomDictList))))
    (list (list "TAG" "VAV0101"))
    (list (list "VALVE_TYPE" returnAirValveType))
  )
)

; 2021-06-02
(defun GetCAHReturnAirRateValveDictList (oneRoomDictList returnAirValveType /)
  (append 
    (list (list "systemNum" (GetListPairValueUtils "systemNum" oneRoomDictList)))
    (list (list "CMH" (vl-princ-to-string (GetListPairValueUtils "roomReturnAirRate" oneRoomDictList))))
    (list (list "TAG" "VAV0101"))
    (list (list "VALVE_TYPE" returnAirValveType))
  )
)

;;;-------------------------------------------------------------------------------------------------------------------------------;;;
; Generate Air Condition Unit
; 2021-06-04
; refactored at 2021-06-10
(defun InsertOneNsCAHAirConditionUnit (insPt systemNum nsSystemCleanAirData sysRefrigeratingData nsSysPIDData /  nsCAHUnitFormChName oneNsCAHUnitForm) 
  (InsertNsCAHAHUExhaustAir (MoveInsertPositionUtils insPt 13000 17500) systemNum nsSystemCleanAirData)
  (setq nsCAHUnitFormChName (GetNsCAHUnitFormChNameStrategy (GetListPairValueUtils "systemReturnAirRate" nsSystemCleanAirData)))
  ; sort by numId
  (setq oneNsCAHUnitForm (vl-sort (GetOneNsCAHUnitForm nsSysPIDData nsCAHUnitFormChName) '(lambda (x y) (< (atoi (car x)) (atoi (car y))))))
  (mapcar '(lambda (x) 
             (InsertOneNsCAHnUnitStrategy (cdr x) insPt systemNum nsSystemCleanAirData sysRefrigeratingData nsSysPIDData)
             (setq insPt (MoveInsertPositionUtils insPt (GetNsCAHUnitWidthEnums (cdr x)) 0))
           ) 
    oneNsCAHUnitForm
  )
)

; 2021-06-10
(defun GetNsCAHUnitFormChNameStrategy (nsCAHUnitFormChName /)
  (cond 
    ((= nsCAHUnitFormChName 0) "全新风净化空调机组")
    (T "回风净化空调机组")
  )
)

; 2021-06-10
(defun InsertOneNsCAHnUnitStrategy (unitName insPt systemNum nsSystemCleanAirData sysRefrigeratingData nsSysPIDData /)
  (cond 
    ((= unitName "NsCAH-AHU-OutdoorAir") (InsertNsCAHAHUOutdoorAir insPt systemNum nsSystemCleanAirData))
    ((wcmatch unitName "NsCAH-AHU-*Rough") (InsertNsCAHAHUFilterUnit insPt systemNum unitName nsSysPIDData))
    ((= unitName "NsCAH-AHU-HotWaterHeat") (InsertNsCAHAHUHotWater insPt systemNum sysRefrigeratingData nsSysPIDData))
    ((= unitName "NsCAH-AHU-ReturnAir") (InsertNsCAHAHUReturnAir insPt systemNum nsSystemCleanAirData))
    ((= unitName "NsCAH-AHU-SurfaceCooler") (InsertNsCAHAHUSurfaceCooler insPt systemNum sysRefrigeratingData nsSysPIDData))
    ((= unitName "NsCAH-AHU-SteamPreHeat") (InsertNsCAHAHUSteamPreHeat insPt systemNum sysRefrigeratingData))
    ((= unitName "NsCAH-AHU-SteamHeat") (InsertNsCAHAHUSteamHeat insPt systemNum sysRefrigeratingData))
    ((= unitName "NsCAH-AHU-SteamHumidify") (InsertNsCAHAHUSteamHumidify insPt systemNum sysRefrigeratingData))
    ((= unitName "NsCAH-AHU-FanSection-Level") (InsertNsCAHAHUFanSectionLevel insPt systemNum))
    ((= unitName "NsCAH-AHU-MeanFlowAir") (InsertNsCAHAHUMeanFlowAir insPt systemNum))
    ((wcmatch unitName "NsCAH-AHU-*Efficiency") (InsertNsCAHAHUFilterUnit insPt systemNum unitName nsSysPIDData))
    ((= unitName "NsCAH-AHU-SupplyAir") (InsertNsCAHAHUSupplyAir insPt systemNum nsSystemCleanAirData nsSysPIDData))
  )
)

; 2021-06-10
; ((1 . NsCAH-AHU-OutdoorAir) (2 . NsCAH-AHU-PlateRough) (3 . NsCAH-AHU-ReturnAir) (4 . NsCAH-AHU-MediumEfficiency) (5 . NsCAH-AHU-SurfaceCooler) (6 . NsCAH-AHU-SteamHeat) (7 . NsCAH-AHU-SteamHumidify) (8 . NsCAH-AHU-FanSection-Level) (9 . NsCAH-AHU-MeanFlowAir) (10 . NsCAH-AHU-HighMediumEfficiency) (11 . NsCAH-AHU-SupplyAir))
(defun GetOneNsCAHUnitForm (nsSysPIDData nsCAHUnitFormChName /) 
  (mapcar '(lambda (x) 
             (cons (car x) (NsCAHChUnitNameToUnitNameEnums (cadr x)))
           ) 
    ; ready to refactor 回风净化空调机组 全新风净化空调机组
    (GetListPairValueUtils nsCAHUnitFormChName (GetNsCAHUnitFormsDictList nsSysPIDData))
  )
)

; ((1 新风段) (2 板式粗效段) (3 中效段) (4 蒸汽加热段) (5 热水加热段) (6 蒸汽加热段) (7 蒸汽加湿段) (8 水平风机段) (9 均流段) (10 高中效段) (11 送风段))
; 2021-06-10
(defun GetNsCAHUnitFormsDictList (nsSysPIDData /) 
  (mapcar '(lambda (x) 
             (list 
                (car x) 
                (mapcar '(lambda (xx) 
                          (StrToListUtils xx "-")
                        ) 
                  (cadr x)
                )
             )
           ) 
    (GetNsCAHUnitForms nsSysPIDData)
  )
)

; 2021-06-10
; ready to refactor 机组形式的中文名映射为英文 key
(defun GetNsCAHUnitForms (nsSysPIDData /) 
  (mapcar '(lambda (x) 
             (list (car (GetNsCAHUnitFormsList (cadr x))) (cdr (GetNsCAHUnitFormsList (cadr x))))
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (and (wcmatch (car x) "unit*") (/= (cadr x) "")))      
      nsSysPIDData
    )
  )
)

; 2021-06-10
(defun GetNsCAHUnitFormsList (nsCAHUnitFormsString /) 
  (DeleteLastItemUtils (StrToListUtils nsCAHUnitFormsString "#"))
)

; 2021-06-04
(defun InsertNsCAHAHUSupplyAir (insPt systemNum nsSystemCleanAirData nsSysPIDData / systemSupplyAirRate) 
  (setq systemSupplyAirRate  (GetListPairValueUtils "systemSupplyAirRate" nsSystemCleanAirData))
  (InsertBlockUtils insPt "NsCAH-AHU-SupplyAir" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-SupplyAir") 2) 0))
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 3300) (MoveInsertPositionUtils insPt 0 12350) "0DataFlow-NsNT-DUCT-S.A")
  (InsertNsCAHDuctArcLine (MoveInsertPositionUtils insPt 0 12500) "0DataFlow-NsNT-DUCT-S.A" 500)
  ; the distance 6900 is variable, ready to refactor
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 13000) (MoveInsertPositionUtils insPt 6900 13000) "0DataFlow-NsNT-DUCT-S.A")
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt 1000 12900) "NsCAH-AHU-Arrow" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)) (* PI 0.5))
  (GenerateLevelLeftTextUtils
    (MoveInsertPositionUtils insPt 500 13100)
    (strcat "S.A " (vl-princ-to-string systemSupplyAirRate) " m3/h") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
  (InsertNsCAHUpInstrumentUnit (MoveInsertPositionUtils insPt 3500 13000) "NsCAH-InstrumentP" systemNum "TIMC")
  ; refactored at 2021-06-10
  (InsertNsCAHSupplyAirValve (MoveInsertPositionUtils insPt 4500 13000) systemNum nsSysPIDData)
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt 0 8000) "NsCAH-AHU-Muffler" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)) (* PI 0.5))
  (InsertNsCAHLevelFireDamper (MoveInsertPositionUtils insPt 0 9300) systemNum 70)
)

; 2021-06-10
(defun InsertNsCAHSupplyAirValve (insPt systemNum nsSysPIDData / supplyAirValveType) 
  (setq supplyAirRateControlType (GetListPairValueUtils "supplyAirRateControlType" nsSysPIDData))
  (cond 
    ((wcmatch supplyAirRateControlType "定风量") (InsertNsCAHUpInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "FIC"))
    ((wcmatch supplyAirRateControlType "定静压") (InsertNsCAHUpInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "PIC"))
    ((wcmatch supplyAirRateControlType "定压差") (InsertNsCAHUpInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "PIDC"))
    ((wcmatch supplyAirRateControlType "变静压") (InsertNsCAHUpInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "PIC"))
  )
)

; 2021-06-10
(defun InsertNsCAHAHUMeanFlowAir (insPt systemNum / ) 
  (InsertBlockUtils insPt "NsCAH-AHU-MeanFlowAir" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
)

; 2021-06-04
(defun InsertNsCAHAHUMediumEfficiency (insPt systemNum / ) 
  (InsertBlockUtils insPt "NsCAH-AHU-MediumEfficiency" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (InsertNsCAHAHUBottomPDStrategy insPt systemNum)
)

; 2021-06-04
(defun InsertNsCAHAHUFanSectionLevel (insPt systemNum / ) 
  (InsertBlockUtils insPt "NsCAH-AHU-FanSection-Level" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-FanSection-Level") 2) 0))
  (GenerateLineUtils (MoveInsertPositionUtils insPt -450 -200) (MoveInsertPositionUtils insPt 1750 -200) "0DataFlow-NsNT-INSTRUMENT")
  (GenerateLineUtils (MoveInsertPositionUtils insPt -450 -200) (MoveInsertPositionUtils insPt -450 1200) "0DataFlow-NsNT-INSTRUMENT")
  (GenerateLineUtils (MoveInsertPositionUtils insPt 1750 -200) (MoveInsertPositionUtils insPt 1750 2000) "0DataFlow-NsNT-INSTRUMENT")
  (InsertNsCAHDownInstrumentUnit (MoveInsertPositionUtils insPt 0 -200) "NsCAH-InstrumentP" systemNum "PDIA")
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "HALARM")
    (list "H")
  )  
)

; 2021-06-04
; refactored at 2021-06-10
(defun InsertNsCAHAHUBottomPDStrategy (insPt systemNum filterPdType / ) 
  (GenerateLineUtils (MoveInsertPositionUtils insPt -625 -200) (MoveInsertPositionUtils insPt 625 -200) "0DataFlow-NsNT-INSTRUMENT")
  (GenerateLineUtils (MoveInsertPositionUtils insPt -625 -200) (MoveInsertPositionUtils insPt -625 1200) "0DataFlow-NsNT-INSTRUMENT")
  (GenerateLineUtils (MoveInsertPositionUtils insPt 625 -200) (MoveInsertPositionUtils insPt 625 1200) "0DataFlow-NsNT-INSTRUMENT")
  (cond 
    ((wcmatch filterPdType "集中（有高位报警）") (InsertNsCAHAHUBottomPDIA (MoveInsertPositionUtils insPt 0 -200) systemNum))
    ((wcmatch filterPdType "集中（无高位报警）") (InsertNsCAHAHUBottomPDI (MoveInsertPositionUtils insPt 0 -200) systemNum))
    ((wcmatch filterPdType "就地") (InsertNsCAHAHUBottomPDG (MoveInsertPositionUtils insPt 0 -200) systemNum))
  )
)

; 2021-06-10
(defun InsertNsCAHAHUBottomPDIA (insPt systemNum / ) 
  (InsertNsCAHDownInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "PDIA")
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "HALARM")
    (list "H")
  )  
)

; 2021-06-10
(defun InsertNsCAHAHUBottomPDI (insPt systemNum / ) 
  (InsertNsCAHDownInstrumentUnit insPt "NsCAH-InstrumentP" systemNum "PDI") 
)

; 2021-06-10
(defun InsertNsCAHAHUBottomPDG (insPt systemNum / ) 
  (InsertNsCAHDownInstrumentUnit insPt "NsCAH-InstrumentL" systemNum "PDG") 
)

; 2021-06-04
(defun InsertNsCAHAHUSteamHumidify (insPt systemNum sysRefrigeratingData / systemLSDiameter systemLSFlowRate) 
  (InsertBlockUtils insPt "NsCAH-AHU-SteamHumidify" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-SteamHumidify") 2) 0))
  (setq systemLSDiameter (strcat "LS DN" (vl-princ-to-string (GetListPairValueUtils "winterHumidSteamPipeDiameter" sysRefrigeratingData))))
  (setq systemLSFlowRate (strcat 
                            (GetListPairValueUtils "steamHumidificationPressure" sysRefrigeratingData)
                            "MPa "
                            (vl-princ-to-string (GetListPairValueUtils "winterHumidSteamRate" sysRefrigeratingData))
                            "kg/h"
                          ))
  (InsertBlockUtils (MoveInsertPositionUtils insPt 550 2500) "NsCAH-AHU-Pipe-LS" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "PIPELENGTH" 3100))
  ) 
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "LS" "LS_FLOW")
    (list systemLSDiameter systemLSFlowRate)
  )
  (InsertBlockUtils (MoveInsertPositionUtils insPt 550 500) "NsCAH-AHU-Pipe-SC" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "DIAMETER")
    (list "SC DN20")
  )
)

; 2021-06-04
(defun InsertNsCAHAHUSteamHeat (insPt systemNum sysRefrigeratingData / systemLSDiameter systemLSFlowRate) 
  (InsertBlockUtils insPt "NsCAH-AHU-SteamHeat" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-SteamHeat") 2) 0))
  (setq systemLSDiameter (strcat "LS DN" (vl-princ-to-string (GetListPairValueUtils "winterHeatingSteamPipeDiameter" sysRefrigeratingData))))
  (setq systemLSFlowRate (strcat 
                            (GetListPairValueUtils "steamHeatingPressure" sysRefrigeratingData)
                            "MPa "
                            (vl-princ-to-string (GetListPairValueUtils "winterHeatingSteamRate" sysRefrigeratingData))
                            "kg/h"
                          ))
  (InsertBlockUtils (MoveInsertPositionUtils insPt 250 2500) "NsCAH-AHU-Pipe-LS" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (VlaSetDynamicBlockPropertyValueUtils 
    (GetLastVlaObjectUtils) 
    (list (cons "PIPELENGTH" 1400))
  ) 
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "LS" "LS_FLOW")
    (list systemLSDiameter systemLSFlowRate)
  )
  (InsertNsCAHAHULsInstrumentUnit insPt systemNum nsSysPIDData)
  (InsertBlockUtils (MoveInsertPositionUtils insPt -250 500) "NsCAH-AHU-Pipe-SC" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "DIAMETER")
    (list "SC DN20")
  )
)

; 2021-06-10
(defun InsertNsCAHAHUSteamPreHeat (insPt systemNum sysRefrigeratingData / systemLSDiameter systemLSFlowRate) 
  (InsertBlockUtils insPt "NsCAH-AHU-SteamPreHeat" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-SteamPreHeat") 2) 0))
  (setq systemLSDiameter (strcat "LS DN" (vl-princ-to-string (GetListPairValueUtils "outdoorAirPreheatSteamPipeDiameter" sysRefrigeratingData))))
  (setq systemLSFlowRate (strcat 
                            (GetListPairValueUtils "steamHeatingPressure" sysRefrigeratingData)
                            "MPa "
                            (vl-princ-to-string (GetListPairValueUtils "outdoorAirPreheatSteamRate" sysRefrigeratingData))
                            "kg/h"
                          ))
  (InsertBlockUtils (MoveInsertPositionUtils insPt -250 2500) "NsCAH-AHU-Pipe-LS" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (MirrorBlockUtils (entlast))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "LS" "LS_FLOW")
    (list systemLSDiameter systemLSFlowRate)
  )
  (InsertNsCAHAHUPreHeatLsInstrumentUnit insPt systemNum nsSysPIDData)
  (InsertBlockUtils (MoveInsertPositionUtils insPt 250 500) "NsCAH-AHU-Pipe-SC" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "DIAMETER")
    (list "SC DN20")
  )
)

; 2021-06-04
; refacotred at 2021-06-10
(defun InsertNsCAHAHUSurfaceCooler (insPt systemNum sysRefrigeratingData nsSysPIDData / 
                                    systemLWDiameter systemLWFlowRate systemLWSFlowRate systemLWSDiameter systemLWRFlowRate) 
  (InsertBlockUtils insPt "NsCAH-AHU-SurfaceCooler" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-SurfaceCooler") 2) 0))
  (setq systemLWDiameter (vl-princ-to-string (GetListPairValueUtils "summerRefrigerationCoolHeatPipeDiameter" sysRefrigeratingData)))
  (setq systemLWFlowRate (vl-princ-to-string (GetListPairValueUtils "summerRefrigerationCoolHeatFlowRate" sysRefrigeratingData)))
  (setq systemLWSFlowRate (strcat 
                            (GetListPairValueUtils "coldWaterSupplyMinTemperature" sysRefrigeratingData)
                            "℃ "
                            systemLWFlowRate
                            "m3/h"
                          ))
  (setq systemLWSDiameter (strcat "LWS DN" systemLWDiameter))
  (setq systemLWRFlowRate (strcat 
                            (GetListPairValueUtils "coldWaterReturnMinTemperature" sysRefrigeratingData)
                            "℃ "
                            systemLWFlowRate
                            "m3/h"
                          ))
  (setq systemLWRDiameter (strcat "LWR DN" systemLWDiameter))
  ; refacotred at 2021-06-10
  (InsertNsCAHHWLWUnit (MoveInsertPositionUtils insPt 250 500) "NsCAH-AHU-Pipe-LW" nsSysPIDData systemLWDiameter systemNum)
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "LWS" "LWS_FLOW" "LWR" "LWR_FLOW")
    (list systemLWSDiameter systemLWSFlowRate systemLWRDiameter systemLWRFlowRate)
  )
  (InsertNsCAHAHUHwLwInstrumentUnit insPt systemNum nsSysPIDData)
)

; 2021-06-10
(defun InsertNsCAHHWLWUnit (insPt HWLWStyle nsSysPIDData systemLWDiameter systemNum / pdBalanceValveStatus pipeDivideDiameter) 
  (setq pdBalanceValveStatus (GetListPairValueUtils "pdBalanceValveStatus" nsSysPIDData))
  (setq pipeDivideDiameter (GetListPairValueUtils "pipeDivideDiameter" nsSysPIDData))
  (InsertBlockUtils 
    insPt
    (strcat HWLWStyle (GetNsCAHHWLWBlockNameStrategy systemLWDiameter pipeDivideDiameter pdBalanceValveStatus))
    "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
)

; 2021-06-10
(defun GetNsCAHHWLWBlockNameStrategy (systemLWDiameter pipeDivideDiameter pdBalanceValveStatus /)
  (cond 
    ((and (< (atoi systemLWDiameter) (ExtractIntegerFromStringUtils pipeDivideDiameter)) (= pdBalanceValveStatus "0"))
    "-ShutoffNoPd")
    ((and (>= (atoi systemLWDiameter) (ExtractIntegerFromStringUtils pipeDivideDiameter)) (= pdBalanceValveStatus "0"))
    "-ButterflyNoPd")
    ((and (< (atoi systemLWDiameter) (ExtractIntegerFromStringUtils pipeDivideDiameter)) (= pdBalanceValveStatus "1"))
    "-Shutoff")
    ((and (>= (atoi systemLWDiameter) (ExtractIntegerFromStringUtils pipeDivideDiameter)) (= pdBalanceValveStatus "1"))
    "-Butterfly")
    (T "-Butterfly")
  )
)

; 2021-06-04
; refactored at 2021-06-10
(defun InsertNsCAHAHULsInstrumentUnit (insPt systemNum nsSysPIDData / steamSupplyPressType) 
  (setq steamSupplyPressType (GetListPairValueUtils "steamSupplyPressType" nsSysPIDData))
  (cond 
    ((wcmatch steamSupplyPressType "就地") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 3950) "NsCAH-InstrumentL" systemNum "PG"))
    ((wcmatch steamSupplyPressType "集中") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 3950) "NsCAH-InstrumentP" systemNum "PI"))
  )
  (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 555 6400) "NsCAH-InstrumentP" systemNum "MOV")
)

; 2021-06-10
(defun InsertNsCAHAHUPreHeatLsInstrumentUnit (insPt systemNum nsSysPIDData / steamSupplyPressType) 
  (setq steamSupplyPressType (GetListPairValueUtils "steamSupplyPressType" nsSysPIDData))
  (cond 
    ((wcmatch steamSupplyPressType "就地") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 3950) "NsCAH-InstrumentL" systemNum "PG"))
    ((wcmatch steamSupplyPressType "集中") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 3950) "NsCAH-InstrumentP" systemNum "PI"))
  )
  (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -850 6400) "NsCAH-InstrumentP" systemNum "MOV")
)

; 2021-06-04
; refactored at 2021-06-10
(defun InsertNsCAHAHUHwLwInstrumentUnit (insPt systemNum nsSysPIDData / waterSupplyTempType waterSupplyPressType waterReturnTempType waterReturnPressType) 
  (setq waterSupplyTempType (GetListPairValueUtils "waterSupplyTempType" nsSysPIDData))
  (setq waterSupplyPressType (GetListPairValueUtils "waterSupplyPressType" nsSysPIDData))
  (setq waterReturnTempType (GetListPairValueUtils "waterReturnTempType" nsSysPIDData))
  (setq waterReturnPressType (GetListPairValueUtils "waterReturnPressType" nsSysPIDData))
  (cond 
    ((wcmatch waterSupplyTempType "就地") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 3950) "NsCAH-InstrumentL" systemNum "TG"))
    ((wcmatch waterSupplyTempType "集中") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 3950) "NsCAH-InstrumentP" systemNum "TI"))
  )
  (cond 
    ((wcmatch waterSupplyPressType "就地") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 4850) "NsCAH-InstrumentL" systemNum "PG"))
    ((wcmatch waterSupplyPressType "集中") (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 250 4850) "NsCAH-InstrumentP" systemNum "PI"))
  )
  (cond 
    ((wcmatch waterReturnTempType "就地") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 3950) "NsCAH-InstrumentL" systemNum "TG"))
    ((wcmatch waterReturnTempType "集中") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 3950) "NsCAH-InstrumentP" systemNum "TI"))
  )
  (cond 
    ((wcmatch waterReturnPressType "就地") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 4850) "NsCAH-InstrumentL" systemNum "PG"))
    ((wcmatch waterReturnPressType "集中") (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt -250 4850) "NsCAH-InstrumentP" systemNum "PI"))
  )
  (InsertNsCAHLargeRightInstrumentUnit (MoveInsertPositionUtils insPt -250 7100) "NsCAH-InstrumentP" systemNum "MOV")
)

; 2021-06-04
(defun InsertNsCAHAHUExhaustAir (insPt systemNum nsSystemCleanAirData / systemExhaustAirRate xDistanceOffset) 
  (setq systemExhaustAirRate (GetListPairValueUtils "systemExhaustAirRate" nsSystemCleanAirData))
  (setq xDistanceOffset 2000)
  (InsertBlockUtils insPt "NsCAH-AHU-RoughMediumEfficiencyUnit" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (MirrorBlockUtils (entlast))
  (GenerateLineUtils (MoveInsertPositionUtils insPt -8100 2000) (MoveInsertPositionUtils insPt -6800 2000) "0DataFlow-NsNT-DUCT-E.A")
  (InsertBlockUtils (MoveInsertPositionUtils insPt -8100 2000) "NsCAH-AHU-AirOutlet" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt -7450 2000) "NsCAH-AHU-CheckValve" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)) (* PI 0.5))
  ; refactored at 2021-06-10
  (GenerateLineUtils (MoveInsertPositionUtils insPt 300 1450) (MoveInsertPositionUtils insPt xDistanceOffset 1450) "0DataFlow-NsNT-DUCT-E.A")
  (GenerateLineUtils (MoveInsertPositionUtils insPt xDistanceOffset 1450) (MoveInsertPositionUtils insPt xDistanceOffset -5000) "0DataFlow-NsNT-DUCT-E.A")
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt (- xDistanceOffset 200) -1500) "NsCAH-AHU-Arrow" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)) PI)
  (GenerateVerticalLeftTextUtils 
    (MoveInsertPositionUtils insPt (+ xDistanceOffset 400) -2000) 
    (strcat "E.A " (vl-princ-to-string systemExhaustAirRate) " m3/h") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
  (InsertBlockUtils (MoveInsertPositionUtils insPt xDistanceOffset -3500) "NsCAH-AHU-ButterflyValve" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)))
  (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt (+ xDistanceOffset 500) -3500) "NsCAH-InstrumentP" systemNum "MD")
)

; 2021-06-04
(defun InsertNsCAHAHUReturnAir (insPt systemNum nsSystemCleanAirData / systemReturnAirRate) 
  (setq systemReturnAirRate  (GetListPairValueUtils "systemReturnAirRate" nsSystemCleanAirData))
  (InsertBlockUtils insPt "NsCAH-AHU-ReturnAir" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-ReturnAir") 2) 0))
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 3300) (MoveInsertPositionUtils insPt 0 12500) "0DataFlow-NsNT-DUCT-R.A")
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 12500) (MoveInsertPositionUtils insPt 21400 12500) "0DataFlow-NsNT-DUCT-R.A")
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt 1900 12300) "NsCAH-AHU-Arrow" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)) (* PI -0.5))
  (GenerateLevelLeftTextUtils
    (MoveInsertPositionUtils insPt 600 12600)
    (strcat "R.A " (vl-princ-to-string systemReturnAirRate) " m3/h") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
  (InsertNsCAHUpInstrumentUnit (MoveInsertPositionUtils insPt 4100 12500) "NsCAH-InstrumentP" systemNum "TIMC")
  (InsertNsCAHUpInstrumentUnit (MoveInsertPositionUtils insPt 5600 12500) "NsCAH-InstrumentP" systemNum "FIC")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 7300 12500) "NsCAH-AHU-Muffler" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)))
  (InsertBlockByRotateUtils (MoveInsertPositionUtils insPt 10500 12500) "NsCAH-AHU-ButterflyValve" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)) (* PI 0.5))
  (InsertNsCAHLeftInstrumentUnit (MoveInsertPositionUtils insPt 10500 13000) "NsCAH-InstrumentP" systemNum "MD")
  (InsertNsCAHVerticalFireDamper (MoveInsertPositionUtils insPt 13000 12500) systemNum 70)
)

; 2021-06-04
(defun InsertNsCAHVerticalFireDamper (insPt systemNum fireTemp / ) 
  (InsertBlockByRotateUtils insPt "NsCAH-AHU-FireDamper" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)) (* PI -0.5))
  (GenerateLevelCenterTextUtils
    (MoveInsertPositionUtils insPt 0 -650)
    (strcat (vl-princ-to-string fireTemp) "℃") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
)

; 2021-06-04
(defun InsertNsCAHLevelFireDamper (insPt systemNum fireTemp / ) 
  (InsertBlockUtils insPt "NsCAH-AHU-FireDamper" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)))
  (GenerateLevelCenterTextUtils
    (MoveInsertPositionUtils insPt 450 300)
    (strcat (vl-princ-to-string fireTemp) "℃") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
)

; 2021-06-03
(defun InsertNsCAHAHUHotWater (insPt systemNum sysRefrigeratingData nsSysPIDData / 
                               systemHWDiameter systemHWFlowRate systemHWSFlowRate systemHWSDiameter systemHWRFlowRate systemHWRDiameter) 
  (InsertBlockUtils insPt "NsCAH-AHU-HotWaterHeat" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-HotWaterHeat") 2) 0))
  (setq systemHWDiameter (vl-princ-to-string (GetListPairValueUtils "outdoorAirPreheatCoolHeatPipeDiameter" sysRefrigeratingData)))
  (setq systemHWFlowRate (vl-princ-to-string (GetListPairValueUtils "outdoorAirPreheatCoolHeatFlowRate" sysRefrigeratingData)))
  (setq systemHWSFlowRate (strcat 
                            (GetListPairValueUtils "hotWaterSupplyTemperature" sysRefrigeratingData)
                            "℃ "
                            systemHWFlowRate
                            "m3/h"
                          ))
  (setq systemHWSDiameter (strcat "HWS DN" systemHWDiameter))
  (setq systemHWRFlowRate (strcat 
                            (GetListPairValueUtils "hotWaterReturnTemperature" sysRefrigeratingData)
                            "℃ "
                            systemHWFlowRate
                            "m3/h"
                          ))
  (setq systemHWRDiameter (strcat "HWR DN" systemHWDiameter))
  ; refacotred at 2021-06-10
  (InsertNsCAHHWLWUnit (MoveInsertPositionUtils insPt 250 500) "NsCAH-AHU-Pipe-HW" nsSysPIDData systemHWDiameter systemNum)
  (ModifyMultiplePropertyForOneBlockUtils (entlast) 
    (list "HWS" "HWS_FLOW" "HWR" "HWR_FLOW")
    (list systemHWSDiameter systemHWSFlowRate systemHWRDiameter systemHWRFlowRate)
  ) 
  (InsertNsCAHAHUHwLwInstrumentUnit insPt systemNum nsSysPIDData)
  (InsertNsCAHDownInstrumentLengthUnit (MoveInsertPositionUtils insPt 800 1000) "NsCAH-InstrumentP" systemNum "TMI" 1200)
)

; 2021-06-10
; refacotred at 2021-06-04
(defun InsertNsCAHAHUFilterUnit (insPt systemNum blockName nsSysPIDData / filterPdType) 
  (InsertBlockUtils insPt blockName "0DataFlow-NsNT-AHU" (list (cons 1 systemNum))) 
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums blockName) 2) 0))
  (setq filterPdType (GetListPairValueUtils "filterPdType" nsSysPIDData))
  (InsertNsCAHAHUBottomPDStrategy insPt systemNum filterPdType)
)

; 2021-06-03
(defun InsertNsCAHAHUOutdoorAir (insPt systemNum nsSystemCleanAirData / systemOutdoorAirRate ) 
  (InsertBlockUtils insPt "NsCAH-AHU-OutdoorAir" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (setq insPt (MoveInsertPositionUtils insPt (/ (GetNsCAHUnitWidthEnums "NsCAH-AHU-OutdoorAir") 2) 0))
  (setq systemOutdoorAirRate (GetListPairValueUtils "systemOutdoorAirRate" nsSystemCleanAirData))
  (GenerateLineUtils (MoveInsertPositionUtils insPt 0 3300) (MoveInsertPositionUtils insPt 0 6900) "0DataFlow-NsNT-DUCT-F.A")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 0 3950) "NsCAH-AHU-ElectricDamper" "0DataFlow-NsNT-DUCT-DAMPER" (list (cons 1 systemNum)))
  (GenerateLineUtils (MoveInsertPositionUtils insPt -1000 6900) (MoveInsertPositionUtils insPt 0 6900) "0DataFlow-NsNT-DUCT-F.A")
  (InsertBlockUtils (MoveInsertPositionUtils insPt -1000 6900) "NsCAH-AHU-AirInlet" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (InsertBlockUtils (MoveInsertPositionUtils insPt -200 5700) "NsCAH-AHU-Arrow" "0DataFlow-NsNT-AHU" (list (cons 1 systemNum)))
  (GenerateVerticalLeftTextUtils 
    (MoveInsertPositionUtils insPt 400 4500) 
    (strcat "F.A " (vl-princ-to-string systemOutdoorAirRate) " m3/h") 
    "0DataFlow-NsNT-PIPE-TEXT" 300 0.7)
  (InsertNsCAHUpInstrumentUnit (MoveInsertPositionUtils insPt -500 6900) "NsCAH-InstrumentP" systemNum "TIMC")
  (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 0 5850) "NsCAH-InstrumentP" systemNum "FIC")
  (InsertNsCAHRightInstrumentUnit (MoveInsertPositionUtils insPt 300 3950) "NsCAH-InstrumentP" systemNum "MD")
)

; 2021-06-03
(defun InsertNsCAHUpInstrumentUnit (insPt blockName systemNum functionCode / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt 0 500) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 0 900) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)

; 2021-06-03
(defun InsertNsCAHDownInstrumentUnit (insPt blockName systemNum functionCode / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt 0 -500) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 0 -900) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)

; 2021-06-03
(defun InsertNsCAHDownInstrumentLengthUnit (insPt blockName systemNum functionCode lineLength / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt 0 (GetNegativeNumberUtils lineLength)) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 0 (- 0 lineLength 400)) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)

; 2021-06-03
(defun InsertNsCAHLeftInstrumentUnit (insPt blockName systemNum functionCode / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt -500 0) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt -900 0) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)

; 2021-06-03
(defun InsertNsCAHRightInstrumentUnit (insPt blockName systemNum functionCode / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt 500 0) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 900 0) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)

; 2021-06-03
(defun InsertNsCAHLargeRightInstrumentUnit (insPt blockName systemNum functionCode / ) 
  (GenerateLineUtils insPt (MoveInsertPositionUtils insPt 800 -700) "0DataFlow-NsNT-INSTRUMENT")
  (InsertBlockUtils (MoveInsertPositionUtils insPt 1200 -700) blockName "0DataFlow-NsNT-INSTRUMENT" (list (cons 1 systemNum) (cons 2 functionCode)))
)


;;;-------------------------------------------------------------------------------------------------------------------------------;;;
; Get Room Area

;; 2021-07-07
(defun AutoGenerateNsRoomAreaPL (/ ss pt1 pt2 ptList)
  (setq ss (ssget))
  (setq pt1 (getpoint "\nPick internal point: "))
  (setq pt2 (getpoint "\nPick internal point: "))
  (setq ptList (list pt1 pt2))
  (CADLispBo ss ptList)
)

; 2021-07-06
(defun c:GenerateNsRoomAreaPL () 
  (ExecuteFunctionAfterVerifyDateUtils 'GenerateNsRoomAreaPLMacro '())
)

; 2021-07-06
(defun GenerateNsRoomAreaPLMacro () 
  (VerifyNsBzLayerByName "0DataFlow-NsRoomArea")
  (vl-cmdf "_.pline")
  ; the key code for the function
  (while (= 1 (logand 1 (getvar 'cmdactive)))
      (vl-cmdf "\\")
  )
  (SetGraphLayerUtils (entlast) "0DataFlow-NsRoomArea")
  (princ "\n绘制房间完成！")
)

; 2021-07-06
(defun c:ExtractNsRoomArea () 
  (ExecuteFunctionAfterVerifyDateUtils 'ExtractNsRoomAreaMacro '())
)

; 2021-07-06
(defun ExtractNsRoomAreaMacro (/ roomAreaPLDictList) 
  (setq roomAreaPLDictList (GetMinMaxXYValuesListForAreaPL))
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "ROOM_AREA")
              (list (vl-princ-to-string 
                      (fix (+ 0.5 (GetNsRoomAreaByRoomPolyLine (GetDottedPairValueUtils 10 (entget x)) roomAreaPLDictList)))))
            )
          ) 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "NsCleanAir"))
  ) 
  (alert "提取房间面积完成！")
)

; 2021-07-06
(defun GetNsRoomAreaByRoomPolyLine (blockPoint roomAreaPLDictList / roomPLEntityName result) 
  (setq roomPLEntityName 
    (car 
      (car 
        (vl-remove-if-not '(lambda (x) 
                  (IsPositionInRegionUtils blockPoint (cdr x))
                ) 
          roomAreaPLDictList
        ) 
      )
    )
  )
  (if (/= roomPLEntityName nil) 
    (setq result (/ (VlaGetPolyLineAreaUtils roomPLEntityName) 1000000.0))
    (setq result 0)
  )
)

; 2021-07-06
(defun GetMinMaxXYValuesListForAreaPL () 
  (mapcar '(lambda (x) 
            (cons x (GetMinMaxXYValuesUtils (GetAllPointForPolyLineUtils (entget x))))
          ) 
    (GetEntityNameListBySSUtils (GetAllNSRoomAreaPLSS))
  ) 
)

; 2021-07-06
(defun GetAllNSRoomAreaPLSS () 
  (ssget "X" '((0 . "LWPOLYLINE") (8 . "0DataFlow-NsRoomArea")))
)

; 2021-07-06
(defun GetNSRoomAreaPLSSBySelect () 
  (ssget '((0 . "LWPOLYLINE") (8 . "0DataFlow-NsRoomArea")))
)

;;;-------------------------------------------------------------------------------------------------------------------------------;;;
; Update Ns Data

; 2021-07-06
(defun c:UpdateNsData ()
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateDataStrategyByBoxUtils '("updateDataFlowDataBox" "Ns"))
)

; 2021-03-24
(defun GetNsTempExportedDataTypeChNameList ()
  '("洁净空凋房间")
)

; 2021-03-24
(defun GetNsTempExportedDataTypeByindex (index /)
  (nth (atoi index) '("NsCleanAir"))
)

;;;-------------------------------------------------------------------------------------------------------------------------------;;;
; Set Ns Room SystemNum

; 2021-07-08
(defun c:SetNsRoomSystem ()
  (ExecuteFunctionAfterVerifyDateUtils 'SetNsRoomSystemByBox '("SetNsRoomSystemBox"))
)

; 2021-07-08
(defun SetNsRoomSystemByBox (tileName / dcl_id status roomSysNumColorDictList roomSysNum sysColor msgStatus ss sslen)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowNs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Add the actions to the button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnSelectColor" "(done_dialog 3)") 
    (action_tile "btnExtractSysNum" "(done_dialog 4)") 
    (mode_tile "roomSysNum" 2)
    (action_tile "roomSysNum" "(setq roomSysNum $value)")
    (if (= nil roomSysNum)
      (setq roomSysNum "")
    )
    (if (= nil sysColor)
      (setq sysColor 7)
    )
    (progn
      (start_image "sysColor")
      (fill_image
        0
        0
        (dimx_tile "sysColor")
        (dimy_tile "sysColor")
        sysColor
      )
      (end_image)
    )
    (if (/= sslen nil)
      (set_tile "selectNumMsg" (strcat "选择的数据数量： " (rtos sslen)))
    )
    (set_tile "roomSysNum" roomSysNum)
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq ss (GetBlockSSBySelectByDataTypeUtils "NsCleanAir"))
        (setq sslen (sslength ss)) 
        (SetNsRoomSystemNumAndColor ss sysColor roomSysNum)
      )
    )
    ; color select button
    (if (= 3 status) 
      (setq sysColor (acad_colordlg 0))
    )  
    ; extract sysNum button
    (if (= 4 status) 
      (progn 
        (setq roomSysNumColorDictList (GetNsRoomSystemNumAndColor))
        (setq roomSysNum (GetDottedPairValueUtils "roomSysNum" roomSysNumColorDictList))
        (setq sysColor (GetDottedPairValueUtils "sysColor" roomSysNumColorDictList))
      )
    ) 
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-07-09
(defun GetNsRoomSystemNumAndColor (/ entityName) 
  (setq entityName (car (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "NsCleanAir"))))
  (list 
    (cons "roomSysNum" (VlaGetBlockPropertyValueUtils entityName "SYSTEM_NUM"))
    (cons "sysColor" (GetOneBlockColorUtils entityName))
  )
)

; 2021-07-08
(defun SetNsRoomSystemNumAndColor (ss colorId roomSysNum /) 
  (mapcar '(lambda (x) 
            (ModifyOneBlockColorUtils x colorId)
            (ModifyOnePropertyForOneBlockUtils x "SYSTEM_NUM" roomSysNum)
          ) 
    (GetEntityNameListBySSUtils ss)
  ) 
)

; 2021-07-06
(defun c:InsertAllNsRoomColorBox () 
  (ExecuteFunctionAfterVerifyDateUtils 'InsertAllNsRoomColorBoxMacro '())
)

; 2021-07-09
(defun InsertAllNsRoomColorBoxMacro () 
  (VerifyNsBzLayerByName "0DataFlow-NsRoomSystemBox")
  (mapcar '(lambda (x) 
            (InsertNsRoomColorBox x)
          ) 
    (GetEntityPositionListByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "NsCleanAir")))
  ) 
  (alert "供划分系统用的辅助方框生成完成！")
)

; 2021-07-09
(defun InsertNsRoomColorBox (insPt / ss) 
  (setq ss (ssadd))
  (GenerateTwoPointPolyLineUtils (MoveInsertPositionUtils insPt -400 250) (MoveInsertPositionUtils insPt -400 -250) "0DataFlow-NsRoomSystemBox" 40)
  (setq ss (ssadd (entlast) ss))
  (GenerateTwoPointPolyLineUtils (MoveInsertPositionUtils insPt 400 250) (MoveInsertPositionUtils insPt 400 -250) "0DataFlow-NsRoomSystemBox" 40)
  (setq ss (ssadd (entlast) ss))
  (GenerateTwoPointPolyLineUtils (MoveInsertPositionUtils insPt -400 250) (MoveInsertPositionUtils insPt 400 250) "0DataFlow-NsRoomSystemBox" 40)
  (setq ss (ssadd (entlast) ss))
  (GenerateTwoPointPolyLineUtils (MoveInsertPositionUtils insPt -400 -250) (MoveInsertPositionUtils insPt 400 -250) "0DataFlow-NsRoomSystemBox" 40)
  (setq ss (ssadd (entlast) ss))
  (JoinPolylineUtils ss)
)