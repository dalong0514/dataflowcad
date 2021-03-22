;��������� 2020-2021 ��
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoKS ()
  (alert "�Ǳ���������°汾�� V0.1������ʱ�䣺2021-04-05\n������������ַ��192.168.1.38")(princ)
)

; 2021-03-22
(defun c:exportKsData (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("KsInstallMaterial"))
  (setq dataTypeChNameList '("��װ����"))
  (ExportTempDataByBox "exportTempDataBox" dataTypeList dataTypeChNameList)
)

(defun ExportTempDataByBox (tileName dataTypeList dataTypeChNameList / dcl_id status fileName exportDataType dataType exportMsgBtnStatus ss sslen dataList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Add the actions to the button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAllSelect" "(done_dialog 3)") 
    (action_tile "btnExportData" "(done_dialog 4)") 
    ; Set the default value
    (set_tile "exportDataType" "0")
    (mode_tile "fileName" 2)
    (mode_tile "exportDataType" 2)
    (action_tile "fileName" "(setq fileName $value)")
    (action_tile "exportDataType" "(setq exportDataType $value)")
    (progn
      (start_list "exportDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                dataTypeChNameList)
      (end_list)
    )
    ; init the default value list box
    (if (= nil exportDataType)
      (setq exportDataType "0")
    )
    (if (= nil fileName)
      (setq fileName "")
    )
    (if (/= exportMsgBtnStatus nil)
      (set_tile "exportDataType" exportDataType)
    )
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "�ļ�������Ϊ�գ�")
    )
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "�������������� " (rtos sslen)))
    )
    ; export data button
    (if (= 2 (setq status (start_dialog))) 
      (if (/= fileName "") 
        (progn 
          (setq dataType (nth (atoi exportDataType) dataTypeList))
          (setq ss (GetKsBlockSSBySelectByDataTypeUtils dataType))
          (setq sslen (sslength ss)) 
          (setq dataList (GetKsDataByDataType ss dataType))
        )
        (setq exportMsgBtnStatus 2)
      )
    )
    ; import data button
    (if (= 3 status) 
      (if (/= fileName "") 
        (progn 
          (setq dataType (nth (atoi exportDataType) dataTypeList))
          (setq ss (GetAllKsBlockSSByDataTypeUtils dataType))
          (setq sslen (sslength ss)) 
          (setq dataList (GetKsDataByDataType ss dataType)) 
        )
        (setq exportMsgBtnStatus 2)
      )
    ) 
    (if (= 4 status) 
      (if (/= fileName "") 
        (progn 
          (ExportKsDataByDataType fileName dataList)
          (setq exportMsgBtnStatus 1)
        )
        (setq exportMsgBtnStatus 2)
      )
    ) 
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-03-22
(defun GetKsDataByDataType (ss dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (ExtractBlockPropertyToJsonListStrategy ss "KsInstallMaterial"))
  ) 
)

; 2021-03-22
(defun ExportKsDataByDataType (fileName dataList /) 
  (cond 
    ((= dataType "KsInstallMaterial") (ExportInstallMaterialData fileName dataList))
  ) 
)

; 2021-03-22
(defun ExportInstallMaterialData (fileName dataList / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir dataList)
)

; 2021-03-22
(defun ExtractBlockPropertyToJsonListStrategy (ss dataType / entityNameList propertyNameList classDict resultList)
  (setq entityNameList (GetEntityNameListBySSUtils ss))
  (setq propertyNameList (GetPropertyNameListStrategy dataType))
  (setq classDict (GetClassDictStrategy dataType))
  (setq resultList 
    (mapcar '(lambda (x) 
              (ExtractBlockPropertyToJsonStringByClassUtils x propertyNameList classDict)
            ) 
      entityNameList
    )
  )
  (setq resultList (ModifyPropertyNameForJsonListStrategy dataType resultList))
)

; 2021-03-22
(defun GetKSInstallMaterialHookDictList () 
  (UpdateKSInstallMaterialHookDictList)
  (FilterKSInstallMaterialHook (GetAllKSInstallMaterialData)) 
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

; 2021-03-22
(defun GetAllKsInstallMaterialTextSSUtils () 
  (ssget "X" '((0 . "TEXT") (1 . "*-*")))
)

; 2021-03-22
(defun UpdateKSInstallMaterialHookDictList (/ KSInstallMaterialTextNumDictList materialNum) 
  (setq KSInstallMaterialTextNumDictList (GetKSInstallMaterialTextNumDictList))
  (mapcar '(lambda (x) 
             (setq materialNum (GetDottedPairValueUtils (car x) KSInstallMaterialTextNumDictList))
             (ModifyMultiplePropertyForOneBlockUtils 
               (handent (GetDottedPairValueUtils "entityhandle" (cdr x)))
               (list "MULTIPLE")
               (list (rtos materialNum))
             )
           ) 
    (FilterKSInstallMaterialHook (GetKSInstallMaterialDictList)) 
  ) 
  (princ)
)

; 2021-03-22
(defun FilterKSInstallMaterialHook (KSInstallMaterialDictList /) 
  (vl-remove-if-not '(lambda (x) 
                      (/= (wcmatch (GetDottedPairValueUtils "standardnum" (cdr x)) "YZ*") nil) 
                    ) 
    KSInstallMaterialDictList
  ) 
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Functon in Ks

; 2021-03-22
(defun GetKsBlockSSBySelectByDataTypeUtils (dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (GetKsInstallMaterialSSBySelectUtils))
  )
)

; 2021-03-22
(defun GetAllKsBlockSSByDataTypeUtils (dataType / ss) 
  (cond 
    ((= dataType "KsInstallMaterial") (GetAllKsInstallMaterialSSUtils))
  ) 
)