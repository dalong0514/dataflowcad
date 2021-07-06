;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoKS ()
  (alert "仪表设计流最新版本号 V0.1，更新时间：2021-04-05\n数据流内网地址：192.168.1.38")(princ)
)

; refactored at 2021-04-09
(defun c:updateKsInstallMaterialMultiple ()
  (ExecuteFunctionAfterVerifyDateUtils 'updateKsInstallMaterialByBox '("updateKsInstallMaterialBox"))
)

; 2021-04-02
(defun GetKsInstallMaterialTextTypeChNameList ()
  '("单行文字" "多行文字")
)

; 2021-04-02
(defun updateKsInstallMaterialByBox (tileName / dcl_id status textType updateMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowKs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnModify" "(done_dialog 2)")
    (set_tile "textType" "0")
    ; the default value of input box
    (mode_tile "textType" 2)
    (action_tile "textType" "(setq textType $value)")
    (progn
      (start_list "textType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetKsInstallMaterialTextTypeChNameList))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil textType)
      (setq textType "0")
    ) 
    (if (= updateMsgBtnStatus 1)
      (set_tile "updateBtnMsg" "更新数据状态：已完成")
    ) 
    (set_tile "textType" textType)
    ; insert button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (UpdateKSInstallMaterialMultipleDataStrategy textType)
        (setq updateMsgBtnStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

; refactored at 2021-04-09
(defun c:exportKsData () 
  (ExecuteFunctionAfterVerifyDateUtils 'ExportKsDataMacro '())
)

; refactored at 2021-04-09
(defun ExportKsDataMacroV1 (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("KsInstallMaterial"))
  (setq dataTypeChNameList '("安装材料"))
  (ExportTempDataByBox "exportTempDataBox" dataTypeList dataTypeChNameList "Ks")
)

; 2021-04-11
(defun ExportKsDataMacro (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("KsInstallMaterial"))
  (setq dataTypeChNameList '("安装材料"))
  (ExportCADDataByBox "exportCADDataBox" dataTypeList dataTypeChNameList "Ks")
)

; 2021-03-22
(defun GetKsBlockSSBySelectByDataTypeUtils (dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (GetKsInstallMaterialSSBySelectUtils))
  )
)

; 2021-03-22
(defun GetAllKsBlockSSByDataTypeUtils (dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (GetAllKsInstallMaterialSSUtils))
  ) 
)

; 2021-03-22
(defun GetAllNsBlockSSByDataTypeUtils (dataType /) 
  (cond 
    ((= dataType "NsCleanAir") (GetAllBlockSSByDataTypeUtils "NsCleanAir"))
  ) 
)

; 2021-03-22
(defun GetKsJsonListDataByDataType (ss dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (ExtractBlockPropertyToJsonListStrategy ss dataType))
  ) 
)

; 2021-03-22
(defun GetKSInstallMaterialDrawPositionList () 
  (GetAllDrawLabelPositionListUtils)
)

; 2021-03-22
(defun GetKSInstallMaterialData () 
  (mapcar '(lambda (x) 
             (cons (cons "position" (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x))))) 
               x
             )
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllKsInstallMaterialSSUtils)))
  )  
)

; 2021-03-22
(defun GetAllKSInstallMaterialData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllKsInstallMaterialSSUtils)))
)

; 2021-03-22
(defun GetKSInstallMaterialDictList (/ materialPosition resultList) 
  (foreach item (GetKSInstallMaterialDrawPositionList) 
    (mapcar '(lambda (x) 
              (setq materialPosition (GetDottedPairValueUtils "position" x))
              (if (IsInKSInstallMaterialDrawRegion materialPosition item)
                (setq resultList (append resultList (list (cons (GetKSInstallMaterialKey item) x))))
              )
            ) 
      (GetKSInstallMaterialData)
    ) 
  ) 
  resultList
)

; 2021-03-22
(defun IsInKSInstallMaterialDrawRegion (materialPosition drawPosition /)
  (and 
    (< (car materialPosition) (car drawPosition)) 
    (> (car materialPosition) (- (car drawPosition) 180)) 
    (> (cadr materialPosition) (cadr drawPosition))
    (< (cadr materialPosition) (+ (cadr drawPosition) 297))
  )
)

; 2021-03-22
(defun GetKSInstallMaterialTextNumDictList (/ i materialPosition resultList) 
  (setq i 0)
  (foreach item (GetKSInstallMaterialDrawPositionList) 
    (mapcar '(lambda (x) 
              (setq materialPosition (GetDottedPairValueUtils "position" x))
              (if (IsInKSInstallMaterialDrawRegion materialPosition item)
                (setq i (1+ i))
              )
            ) 
      (GetKSInstallMaterialTextData)
    ) 
    (setq resultList (append resultList (list (cons (GetKSInstallMaterialKey item) i))))
    (setq i 0)
  ) 
  resultList
)

; 2021-04-02
(defun GetKSInstallMaterialMultiTextNumDictList (/ num materialPosition resultList) 
  (foreach item (GetKSInstallMaterialDrawPositionList) 
    (mapcar '(lambda (x) 
              (setq materialPosition (GetDottedPairValueUtils "position" x))
              (if (IsInKSInstallMaterialDrawRegion materialPosition item)
                (setq num (GetKSInstallMaterialMultiTextNum (GetDottedPairValueUtils "entityname" x)))
              )
            ) 
      (GetKSInstallMaterialMultiTextData)
    ) 
    (setq resultList (append resultList (list (cons (GetKSInstallMaterialKey item) num))))
  ) 
  resultList
)

; 2021-04-02
(defun GetKSInstallMaterialMultiTextNum (entityName / stringData result) 
  (setq stringData (GetKSInstallMaterialMultiTextString entityName))
  (length (FilterKSInstallMaterialMultiText (StrToListUtils stringData "\\")))
)

; 2021-04-02
(defun FilterKSInstallMaterialMultiText (dataList /)
  (vl-remove-if-not '(lambda (x) 
                       (/= (wcmatch x "*-*") nil) 
                    ) 
    dataList
  ) 
)

; 2021-04-02
(defun GetKSInstallMaterialMultiTextString (entityName / result) 
  (setq result "")
  (mapcar '(lambda (x) 
              (if (or (= (car x) 1) (= (car x) 3))
                (setq result (strcat result (cdr x)))
              ) 
           ) 
    (entget entityName)
  ) 
  result
)

; 2021-03-22
(defun GetKSInstallMaterialKey (position /)
  (fix (+ (car position) (cadr position)))
)

; 2021-03-22
(defun GetKSInstallMaterialTextData () 
  (mapcar '(lambda (x) 
             (cons (cons "position" (GetEntityPositionByEntityNameUtils x)) 
               (list (cons "entityname" x))
             )
           ) 
    (GetEntityNameListBySSUtils (GetAllKsInstallMaterialTextSSUtils))
  )  
)

; 2021-04-02
(defun GetKSInstallMaterialMultiTextData () 
  (mapcar '(lambda (x) 
             (cons (cons "position" (GetEntityPositionByEntityNameUtils x)) 
               (list (cons "entityname" x))
             )
           ) 
    (GetEntityNameListBySSUtils (GetAllMultiTextSSUtils))
  )  
)

; 2021-03-22
(defun GetAllKsInstallMaterialTextSSUtils () 
  (ssget "X" '((0 . "TEXT") (1 . "*-*")))
)

; 2021-04-02
(defun GetAllMultiTextSSUtils () 
  (ssget "X" '((0 . "MTEXT")))
)

; 2021-04-02
(defun UpdateKSInstallMaterialMultipleDataStrategy (textType / KSInstallMaterialTextNumDictList materialNum) 
  (cond 
    ((= textType "0") (UpdateKSInstallMaterialTextNumData))
    ((= textType "1") (UpdateKSInstallMaterialMultiTextNumData))
  )
)

; refactored at 2021-03-23
(defun UpdateKSInstallMaterialTextNumData (/ KSInstallMaterialTextNumDictList materialNum) 
  (setq KSInstallMaterialTextNumDictList (GetKSInstallMaterialTextNumDictList))
  (mapcar '(lambda (x) 
             (setq materialNum (GetDottedPairValueUtils (car x) KSInstallMaterialTextNumDictList))
             (ModifyMultiplePropertyForOneBlockUtils 
               (handent (GetDottedPairValueUtils "entityhandle" (cdr x)))
               (list "MULTIPLE")
               (list (rtos materialNum))
             )
           ) 
    ; do not need filter
    ; (FilterKSInstallMaterialHook (GetKSInstallMaterialDictList)) 
    (GetKSInstallMaterialDictList)
  ) 
)

; 2021-04-02
(defun UpdateKSInstallMaterialMultiTextNumData (/ KSInstallMaterialTextNumDictList materialNum) 
  (setq KSInstallMaterialTextNumDictList (GetKSInstallMaterialMultiTextNumDictList))
  (mapcar '(lambda (x) 
             (setq materialNum (GetDottedPairValueUtils (car x) KSInstallMaterialTextNumDictList))
             (ModifyMultiplePropertyForOneBlockUtils 
               (handent (GetDottedPairValueUtils "entityhandle" (cdr x)))
               (list "MULTIPLE")
               (list (rtos materialNum))
             )
           ) 
    (GetKSInstallMaterialDictList)
  ) 
)

; 2021-03-22
(defun FilterKSInstallMaterialHook (KSInstallMaterialDictList /) 
  (vl-remove-if-not '(lambda (x) 
                      (/= (wcmatch (GetDottedPairValueUtils "standardnum" (cdr x)) "YZ*") nil) 
                    ) 
    KSInstallMaterialDictList
  ) 
)


; 2021-03-24
(defun c:autoNumerKsInstall ()
  (alert "该功能待开发！")
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Update Data By temp CSV

; refactored at 2021-04-09
(defun c:UpdateKsData ()
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateDataStrategyByBoxUtils '("updateDataFlowDataBox" "Ks"))
)

; 2021-03-24
(defun GetTempExportedDataTypeChNameListStrategy (dataClass /) 
  (cond 
    ((= dataClass "Ks") (GetKsTempExportedDataTypeChNameList))
    ((= dataClass "Ns") (GetNsTempExportedDataTypeChNameList))
  )
)

; 2021-03-24
(defun GetTempExportedDataTypeByindexStrategy (dataClass index /) 
  (cond 
    ((= dataClass "Ks") (GetKsTempExportedDataTypeByindex index))
    ((= dataClass "Ns") (GetNsTempExportedDataTypeByindex index))
  ) 
)

; 2021-03-24
(defun GetKsTempExportedDataTypeChNameList ()
  '("安装材料")
)

; 2021-03-24
(defun GetKsTempExportedDataTypeByindex (index /)
  (nth (atoi index) '("KsInstallMaterial"))
)

(defun UpdateDataStrategyByBoxUtils (tileName dataClass / dcl_id exportDataType dataType importedDataList selectedName propertyNameList status ss confirmList entityNameList exportMsgBtnStatus importMsgBtnStatus comfirmMsgBtnStatus modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    (action_tile "btnImportData" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    ; optional setting for the popup_list tile
    (set_tile "exportDataType" "0")
    ; the default value of input box
    (mode_tile "exportDataType" 2)
    (action_tile "exportDataType" "(setq exportDataType $value)")
    ; init the value of listbox
    (progn
      (start_list "exportDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetTempExportedDataTypeChNameListStrategy dataClass))
      (end_list)
    )
    ; init the default data of text
    (if (= nil exportDataType)
      (setq exportDataType "0")
    )
    ; Display the number of selected pipes
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "导入数据状态：不能所有设备一起导入")
    ) 
    (if (= importMsgBtnStatus 3)
      (set_tile "importBtnMsg" "请先导入数据！")
    ) 
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "修改CAD数据状态：已完成")
    ) 
    (set_tile "exportDataType" exportDataType)
    ; all select button
    ; export data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        ; refactored at 2021-07-06
        (setq dataType (GetTempExportedDataTypeByindexStrategy dataClass exportDataType))
        ; (setq dataType (GetTempExportedDataTypeByindexStrategy "Ks" exportDataType))
        (setq ss (GetAllBlockSSByDataTypeStrategyUtils dataClass dataType))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (WriteDataFlowToCSVStrategy dataClass entityNameList dataType)
        (setq exportMsgBtnStatus 1) 
      )
    )
    ; import data button
    (if (= 3 status) 
      (progn 
        (setq dataType (GetTempExportedDataTypeByindexStrategy dataClass exportDataType))
        (setq importedDataList (CSVStrListToListListUtils (ReadDataFlowDataFromCSVStrategy dataClass dataType)))
        (setq importMsgBtnStatus 1) 
      )
    )
    ; modify button
    (if (= 4 status) 
      (progn 
        (if (/= importedDataList nil) 
          (progn 
            (ModifyPropertyValueByEntityHandleUtils importedDataList (GetPropertyNameListStrategy dataType))
            (setq modifyMsgBtnStatus 1)
          )
          (setq importMsgBtnStatus 3)
        )
      ) 
    )
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Functon in Ks

