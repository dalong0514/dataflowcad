;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoKS ()
  (alert "仪表设计流最新版本号 V0.1，更新时间：2021-04-05\n数据流内网地址：\\\\192.168.1.38\\dataflow-install")(princ)
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
    (action_tile "textType" "(setq textType $value)")
    (progn
      (start_list "textType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetKsInstallMaterialTextTypeChNameList))
      (end_list) 
    ) 
    ; init the default data of text
    (if (= nil textType)
      (setq textType "1")
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
(defun GetKsTempExportedDataTypeChNameList ()
  '("安装材料")
)

; 2021-03-24
(defun GetKsTempExportedDataTypeByindex (index /)
  (nth (atoi index) '("KsInstallMaterial"))
)

;;;-------------------------------------------------------------------------;;;
; Insert KsInstallMaterial Block

; 2021-07-13
(defun c:InsertBlockKsInstallMaterial ()
  (ExecuteFunctionAfterVerifyDateUtils 'InsertBlockKsInstallMaterialMacro '())
)

; refactored at 2021-07-07
(defun InsertBlockKsInstallMaterialMacro (/ ss insPt) 
  (setq insPt (getpoint "\n统计安装材料块的插入点："))
  (VerifyKsBlockByName "KsInstallMaterial")
  (VerifyKsLayerByName "0DataFlow-KsInstallMaterial")
  (InsertBlockByNoPropertyUtils insPt "KsInstallMaterial" "0DataFlow-KsInstallMaterial")
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Functon in Ks

