;冯大龙编于 2020 年
(princ "\n数据流一体化开发者：冯大龙、谢雨东、华雷、曾涵卫、靳淳、陈杰，版本号V-1.2")
(vl-load-com)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo (/ versionInfo)
  (setq versionInfo "最新版本号 V1.2，更新时间：2020-11-23")
  (alert versionInfo)(princ)
)

; basic Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Unit Test

(defun c:RunTest ()
  (StringSubstUtilsTest)
  (numberedStringSubstUtilTest)
  (GetIndexforSearchMemberInListUtilsTest)
  (GenerateSortedNumByListTest)
  (GetInsertPtTest)
  (ExtractDrawNumTest)
  (ReplaceListItemByindexUtilsTest)
  (AddItemToListStartUtilsTest)
  (GetInsertPtListTest)
  (MoveInsertPositionTest)
  (SpliceElementInTwoListUtilsTest)
  (GetNumberedListByStartAndLengthUtilsTest)
  (GetIncreasedNumberListUtilsTest)
  (GetIncreasedNumberStringListUtilsTest)
  (RemoveLastNumCharForStringUtilsTest)
  (ReplaceNumberOfListByNumberedListUtilsTest)
  (DL:PrintTestResults (DL:CountBooleans *testList*))
)

(defun RemoveLastNumCharForStringUtilsTest ()
  (AssertEqual 'RemoveLastNumCharForStringUtils (list "dalong" 1) "dalon")
  (AssertEqual 'RemoveLastNumCharForStringUtils (list "dalong" 2) "dalo")
)

(defun SpliceElementInTwoListUtilsTest ()
  (AssertEqual 'SpliceElementInTwoListUtils 
    (list '("PL" "YC" "EC") '("1101" "1102" "1103")) 
    '("PL1101" "YC1102" "EC1103")
  )
)

(defun GetIncreasedNumberStringListUtilsTest ()
  (AssertEqual 'GetIncreasedNumberStringListUtils
    (list 7 5)
    '("07" "08" "09" "10" "11")
  )
  (AssertEqual 'GetIncreasedNumberStringListUtils
    (list 1 5)
    '("01" "02" "03" "04" "05")
  )
  (AssertEqual 'GetIncreasedNumberStringListUtils
    (list 12 5)
    '("12" "13" "14" "15" "16")
  )
)

(defun GetIncreasedNumberListUtilsTest ()
  (AssertEqual 'GetIncreasedNumberListUtils 
    (list 2 5)
    '(2 3 4 5 6)
  )
)

(defun GetNumberedListByStartAndLengthUtilsTest ()
  (AssertEqual 'GetNumberedListByStartAndLengthUtils 
    (list "PL" "2" 4) 
    (list "PL02" "PL03" "PL04" "PL05")
  )
  (AssertEqual 'GetNumberedListByStartAndLengthUtils 
    (list "PL" "1101" 4) 
    (list "PL1101" "PL1102" "PL1103" "PL1104")
  )
)

(defun MoveInsertPositionTest ()
  (AssertEqual 'MoveInsertPosition (list '(1 1 0) 10 20) '(11 21 0))
  (AssertEqual 'MoveInsertPosition (list '(10 10 0) -15 -20) '(-5 -10 0))
  (AssertEqual 'MoveInsertPosition (list '(1.5 3.6 0) -5 -2) '(-3.5 1.6 0))
)

(defun GetInsertPtListTest ()
  (AssertEqual 'GetInsertPtList (list '(1 1 1) '(0 1 2 3 4) 10) 
    (list '(1 1 1) '(11 1 1) '(21 1 1) '(31 1 1) '(41 1 1))
  )
)

(defun AddItemToListStartUtilsTest ()
  (AssertEqual 'AddItemToListStartUtils (list (list 0 1 2) (list (list "PL01" "PL02") (list "PL01" "PL02") (list "PL05" "PL06"))) 
    (list (list 0 "PL01" "PL02") (list 1 "PL01" "PL02") (list 2 "PL05" "PL06"))
  )
  (AssertEqual 'AddItemToListStartUtils (list (list '(1 1 1) '(2 2 2) '(3 3 3)) (list (list "PL01" "PL02") (list "PL01" "PL02") (list "PL05" "PL06"))) 
    (list (list '(1 1 1) "PL01" "PL02") (list '(2 2 2) "PL01" "PL02") (list '(3 3 3) "PL05" "PL06"))
  )
)

(defun ReplaceListItemByindexUtilsTest ()
  (AssertEqual 'ReplaceListItemByindexUtils 
    (list "PL1101" 1 '("PL1201" "PL1202" "PL1203" "PL1203")) 
    '("PL1201" "PL1101" "PL1203" "PL1203")
  )
)

(defun ExtractDrawNumTest ()
  (AssertEqual 'ExtractDrawNum '("S20101GS-101-04-04") "04-04")
  (AssertEqual 'ExtractDrawNum '("") "无图号")
)

(defun GetInsertPtTest () 
  (AssertEqual 'GetInsertPt (list '(100 100 0) 1 10) '(110 100 0))
)

(defun GenerateSortedNumByListTest ()
  (AssertEqual 'GenerateSortedNumByList (list '("13" "134" "456")) '(0 1 2))
)

(defun GetIndexforSearchMemberInListUtilsTest ()
  (AssertEqual 'GetIndexforSearchMemberInListUtils (list "PL1101" (list "PL1101" "PL1102" "PL1103")) 0)
  (AssertEqual 'GetIndexforSearchMemberInListUtils (list "PL1102" (list "PL1101" "PL1102" "PL1103")) 1)
)

(defun numberedStringSubstUtilTest ()
  (AssertEqual 'numberedStringSubstUtil '("PL1201" "PL1301-50-2J1") "PL1201-50-2J1")
  (AssertEqual 'numberedStringSubstUtil '("YC1101" "PL-50-2J1") "YC1101-50-2J1")
)

(defun StringSubstUtilsTest ()
  (AssertEqual 'StringSubstUtils '("fengda" "da" "dalong") "fengdalong")
  (AssertEqual 'StringSubstUtils '("-80-" "-50-" "PL1201-50-2J1") "PL1201-80-2J1")
  (AssertEqual 'StringSubstUtils '("YC" "PL" "PL1201-50-2J1") "YC1201-50-2J1")
  (AssertEqual 'StringSubstUtils '("" "-2J1" "PL1201-50-2J1") "PL1201-50")
)

; Unit Test
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Unit Test Source Code

(defun AssertEqual (functionName argumentList expectedReturn / actualReturn passed)
	(if (not (= (type argumentList) 'LIST))
		(setq argumentList (list argumentList))
  )
	(cond
		((equal (setq actualReturn (vl-catch-all-apply functionName argumentList))
			  expectedReturn)
			(princ "passed...(")
			(setq passed T)
			(setq actualReturn nil)
    )
		(T
			(princ "failed...(")
			(setq passed nil)
			(setq actualReturn 
				(strcat (vl-princ-to-string actualReturn) " instead of ")
      )
    )
  )
	
	;; continue printing result...
	(princ (strcase (vl-symbol-name functionName) T))
	(princ " ")
	(princ 
		(DL:ReplaceAllSubst 
			"'"
			"(QUOTE " 
			(vl-prin1-to-string argumentList))
  )
	(princ ") returned ")
	(if actualReturn (princ actualReturn))
	(princ expectedReturn)
	(princ "\n")
	(setq *testList* (append *testList* (list passed)))

  (if (/= passed T) 
    (setq *failedTestList* (append *failedTestList* (list (strcat 
                                                            (strcase (vl-symbol-name functionName) T) 
                                                            " "
                                                            (vl-prin1-to-string argumentList) 
                                                            " returned "
                                                            actualReturn
                                                            expectedReturn
                                                          ))))
  )
	passed
)

; Changes all "pattern"s to "newSubst". Like vl-string-subst, but replaces
;    ALL instances of pattern instead of just the first one.
; Argument: String to alter.
; Return: Altered string.
(defun DL:ReplaceAllSubst (newSubst pattern string / pattern)
	(while (vl-string-search pattern string)
		(setq
			string
			(vl-string-subst newSubst pattern string)))
	string
)

; Counts boolean values
; Input: simple list of boolean values - (T T T T T T T T T T)
; Output: none
; Return: assoc. list of the qty of T's and F's - (("T" . 10) ("F" . 0))
(defun DL:CountBooleans ( booleanList / countList totalTList totalFList)
	(foreach listItem booleanList
		(if (= listItem T)
			(setq totalTList (append totalTList (list listItem)))
			(setq totalFList (append totalFList (list listItem))))
  )
  (setq countList (list 
                    (cons "T" (length totalTList)) 
                    (cons "F" (length totalFList))))
  countList
)

; Prints test results
; Input: assoc list of T's and F's - (("T" . 10) ("F" . 0))
; Output: simple description of the results -
;			Results:
;			----------------
;			 10 tests passed
;			  0 tests failed
; Note: there are always four characters before each "tests"
(defun DL:PrintTestResults ( testResults / trues falses)
	(setq trues (cdr (assoc "T" testResults)))
	(setq falses (cdr (assoc "F" testResults)))
	
	(if (= trues nil)
		(setq trues 0))
	(if (= falses nil)
		(setq falses 0))
	
	(princ "\nResults:")
	(if (= falses 0)
		(princ " ALL PASS"))
	(princ "\n-----------------")
	
	
	; add code to count digits in numbers and add correct space before.
	; also, choose between "test" and "tests" correctly?
	
	(princ "\n  ")(princ trues)(princ " tests passed")
	(princ "\n  ")(princ falses)(princ " tests failed")
  (setq *testList* nil)
  ; print message of failed Tests
  (princ "\n-----------------\n  ")
  (foreach item *failedTestList* 
    (princ "failed...")(princ item)(princ "\n  ")
  )
  (setq *failedTestList* nil)
	(princ)
)

; Unit Test Source Code
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Get Constant Data

(defun GetDataTypeMsgStrategy (dataType / dataTypeMsg)
  (if (= dataType "Pipe") 
    (setq dataTypeMsg "批量修改管道数据")
  )
  (if (= dataType "Instrument") 
    (setq dataTypeMsg "批量修改仪表数据")
  )
  (if (= dataType "Reactor") 
    (setq dataTypeMsg "批量修改反应釜数据")
  )
  (if (= dataType "Tank") 
    (setq dataTypeMsg "批量修改储罐数据")
  )
  (if (= dataType "Heater") 
    (setq dataTypeMsg "批量修改换热器数据")
  )
  (if (= dataType "Pump") 
    (setq dataTypeMsg "批量修改输送泵数据")
  )
  (if (= dataType "Vacuum") 
    (setq dataTypeMsg "批量修改真空泵数据")
  )
  (if (= dataType "Centrifuge") 
    (setq dataTypeMsg "批量修改离心机数据")
  )
  (if (= dataType "CustomEquip") 
    (setq dataTypeMsg "批量修改自定义设备数据")
  )
  ; must give the return
  dataTypeMsg
)

(defun GetPropertyNameListStrategy (dataType / propertyNameList)
  (if (= dataType "Pipe") 
    (setq propertyNameList (GetPipePropertyNameList))
  )
  (if (= dataType "OuterPipe") 
    (setq propertyNameList (GetOuterPipePropertyNameList))
  )
  (if (= dataType "PublicPipe") 
    (setq propertyNameList (GetPublicPipePropertyNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
  )
  (if (= dataType "InstrumentL") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
  )
  (if (= dataType "InstrumentP") 
    (setq propertyNameList (GetInstrumentPPropertyNameList))
  )
  (if (= dataType "InstrumentSIS") 
    (setq propertyNameList (GetInstrumentPPropertyNameList))
  )
  (if (= dataType "Reactor") 
    (setq propertyNameList (GetReactorPropertyNameList))
  )
  (if (= dataType "Tank") 
    (setq propertyNameList (GetTankPropertyNameList))
  )
  (if (= dataType "Heater") 
    (setq propertyNameList (GetHeaterPropertyNameList))
  )
  (if (= dataType "Pump") 
    (setq propertyNameList (GetPumpPropertyNameList))
  )
  (if (= dataType "Vacuum") 
    (setq propertyNameList (GetVacuumPropertyNameList))
  )
  (if (= dataType "Centrifuge") 
    (setq propertyNameList (GetCentrifugePropertyNameList))
  )
  (if (= dataType "CustomEquip") 
    (setq propertyNameList (GetCustomEquipPropertyNameList))
  )
  ; must give the return
  propertyNameList
)

(defun GetPropertyChNameListStrategy (dataType / propertyChNameList)
  (if (= dataType "Pipe") 
    (setq propertyChNameList (GetPipePropertyChNameList))
  )
  (if (= dataType "PublicPipe") 
    (setq propertyChNameList (GetPublicPipePropertyChNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyChNameList (GetInstrumentPropertyChNameList))
  )
  (if (= dataType "Reactor") 
    (setq propertyChNameList (GetReactorPropertyChNameList))
  )
  (if (= dataType "Tank") 
    (setq propertyChNameList (GetTankPropertyChNameList))
  )
  (if (= dataType "Heater") 
    (setq propertyChNameList (GetHeaterPropertyChNameList))
  )
  (if (= dataType "Pump") 
    (setq propertyChNameList (GetPumpPropertyChNameList))
  )
  (if (= dataType "Vacuum") 
    (setq propertyChNameList (GetVacuumPropertyChNameList))
  )
  (if (= dataType "Centrifuge") 
    (setq propertyChNameList (GetCentrifugePropertyChNameList))
  )
  (if (= dataType "CustomEquip") 
    (setq propertyChNameList (GetCustomEquipPropertyChNameList))
  )
  ; must give the return
  propertyChNameList
)

(defun GetPipePropertyNameList ()
  '("PIPENUM" "SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "FROM" "TO" "DRAWNUM" "INSULATION")
)

(defun GetPipePropertyChNameList ()
  '("管道编号" "工作介质" "工作温度" "工作压力" "相态" "管道起点" "管道终点" "流程图号" "保温材料")
)

(defun GetOuterPipePropertyNameList ()
  '("PIPENUM" "FROMTO" "DRAWNUM" "DESIGNFLOW" "OPERATESPEC" "INSULATION" "PROTECTION")
)

(defun GetPublicPipePropertyNameList ()
  '("PIPENUM" "FROM" "TO" "DRAWNUM")
)

(defun GetPublicPipePropertyChNameList ()
  '("管道编号" "管道起点" "管道终点" "流程图号")
)

(defun GetInstrumentPropertyNameList ()
  '("FUNCTION" "TAG" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION")
)

(defun GetInstrumentPPropertyNameList ()
  '("FUNCTION" "TAG" "HALARM" "LALARM" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION")
)

(defun GetInstrumentPropertyChNameList ()
  '("仪表功能代号" "仪表位号" "工作介质" "工作温度" "工作压力" "仪表类型" "相态" "所在位置材质" "控制点名称" "所在管道或设备" "最小值" "最大值" "正常值" "流程图号" "所在位置尺寸" "备注" "安装方向")
)

(defun GetReactorPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SPEED" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "EXTEMP" "EXPRESSURE")
)

(defun GetReactorPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "设备体积" "工作介质" "工作温度" "工作压力" "电机功率" "电机是否防爆" "电机级数" "反应釜转数" "设备尺寸" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "极限温度" "极限压力")
)

(defun GetTankPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "EXTEMP" "EXPRESSURE")
)

(defun GetTankPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "设备体积" "工作介质" "工作温度" "工作压力" "电机功率" "电机是否防爆" "电机级数" "设备尺寸" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "极限温度" "极限压力")
)

(defun GetHeaterPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "AREA" "SIZE" "ELEMENT" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER")
)

(defun GetHeaterPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "换热面积" "设备尺寸" "换热元件规格" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量")
)

(defun GetPumpPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "FLOW" "HEAD" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "NUMBER" "TYPE")
)

(defun GetPumpPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "流量" "扬程" "电机功率" "电机是否防爆" "电机级数" "设备材质" "设备重量" "设备数量" "设备型号")
)

(defun GetVacuumPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "CAPACITY" "EXPRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "NUMBER")
)

(defun GetVacuumPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "抽气量" "极限压力" "电机功率" "电机是否防爆" "电机级数" "设备尺寸" "设备材质" "设备重量" "设备型号" "设备数量")
)

(defun GetCentrifugePropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "VOLUME" "CAPACITY" "DIAMETER" "SPEED" "FACTOR" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "TYPE" "NUMBER")
)

(defun GetCentrifugePropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "设备体积" "装料限重" "转鼓直径" "转鼓转速" "最大分离因素" "设备尺寸" "电机功率" "电机是否防爆" "电机级数" "设备材质" "设备重量" "设备型号" "设备数量")
)

(defun GetCustomEquipPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "PARAM1" "PARAM2" "PARAM3" "PARAM4" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER")
)

(defun GetCustomEquipPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "设备尺寸" "电机功率" "电机是否防爆" "电机级数" "关键参数1" "关键参数2" "关键参数3" "关键参数4" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量")
)

(defun GetJoinDrawArrowPropertyNameList ()
  '("FROMTO" "DRAWNUM" "RELATEDID")
)

; Get Constant Data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Function 

; tansfor gb2312 to utf8
(defun FileEncodeTransUtils (file charset1 charset2 / obj encode)
  (setq obj (vlax-create-object "ADODB.Stream"))
  (vlax-put-property obj 'type 2);1-reading binary, 2-reading text
  (vlax-put-property obj 'mode 3);1-read, 2-write, 3-read and write
  (vlax-invoke obj 'open)
  (vlax-put-property obj "charset" charset1);;unicode;utf-8;ascii;gb2312;big5;gbk
  (vlax-invoke-method obj 'loadfromfile file)
  (setq encode (vlax-invoke obj 'readtext))
  (vlax-invoke obj 'close)
  (vlax-release-object obj)
  (setq obj (vlax-create-object "ADODB.Stream"))
  (vlax-put-property obj 'type 2)
  (vlax-put-property obj 'mode 3)
  (vlax-invoke obj 'open)
  (vlax-put-property obj "charset" charset2);;unicode;utf-8;ascii;gb2312;big5;gbk
  (vlax-invoke obj 'writetext encode)
  (vlax-invoke-method obj 'savetofile file 2);1-create，2-rewrite
  (vlax-invoke obj 'flush);force the data in cache outputed
  (vlax-invoke obj 'close)
  (vlax-release-object obj)
)

(defun ViewSelectedEntityDataUtils (/ ss ent entx)
  (setq ss (ssget))
  (setq ent (entget (ssname ss 0)))
  ;(setq entx (entget (entnext (cdr (assoc -1 ent)))))
  ;(setq entx (entget (cdr (assoc -1 ent))))
  (princ ent)(princ)
)

(defun GetEntityDataUtils ()
  (entget (car (entsel)))
)

; Returns the value of the specified DXF group code for the supplied entity name
(defun GetDXFValueUtils (entityName DXFcode / )
  (cdr (assoc DXFcode (entget entityName)))
)

; Sets the value of the specified DXF group code for the supplied entity name
(defun SetDXFValueUtils (entityName DXFcode newValue / entityData newPropList oldPropList)
  ; Get the entity data list for the object
  (setq entityData (entget entityName))
  ; Create the dotted pair for the new property value
  (setq newPropList (cons DXFcode newValue))
  (if (setq oldPropList (assoc DXFcode entityData))
    (setq entityData (subst newPropList oldPropList entityData))
    (setq entityData (append entityData (list newPropList)))
  )
  ; Update the object’s entity data list 
  (entmod entityData)
  ; Refresh the object on-screen
  (entupd entityName)
  ; Return the new entity data list
  entityData
)

(defun GetAllDataSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllDataSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllInstrumentAndPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentAndPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllEquipmentAndPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetEquipmentAndPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllInstrumentSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllEquipmentSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetEquipmentSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "Reactor")
          (2 . "Pump")
          (2 . "Tank")
          (2 . "Heater")
          (2 . "Centrifuge")
          (2 . "Vacuum")
          (2 . "CustomEquip")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllOuterPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetOuterPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllJoinDrawArrowSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "JoinDrawArrowTo")
          (2 . "JoinDrawArrowFrom")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetJoinDrawArrowSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "JoinDrawArrowTo")
          (2 . "JoinDrawArrowFrom")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetBlockSSBySelectByDataTypeUtils (dataType / ss) 
  (if (= dataType "AllDataType")
    (setq ss (GetAllDataSSBySelectUtils))
  )
  (if (= dataType "Pipe")
    (setq ss (GetPipeSSBySelectUtils))
  )
  (if (= dataType "Instrument")
    (setq ss (GetInstrumentSSBySelectUtils))
  )
  (if (= dataType "InstrumentAndPipe")
    (setq ss (GetInstrumentAndPipeSSBySelectUtils))
  )
  (if (= dataType "EquipmentAndPipe")
    (setq ss (GetEquipmentAndPipeSSBySelectUtils))
  )
  (if (= dataType "OuterPipe")
    (setq ss (GetOuterPipeSSBySelectUtils))
  )
  (if (= dataType "Equipment")
    (setq ss (GetEquipmentSSBySelectUtils))
  )
  (if (= dataType "JoinDrawArrow")
    (setq ss (GetJoinDrawArrowSSBySelectUtils))
  ) 
  (if (= dataType "InstrumentL")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentL"))))
  )
  (if (= dataType "InstrumentP")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentP"))))
  )
  (if (= dataType "InstrumentSIS")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentSIS"))))
  )
  (if (= dataType "Centrifuge")
    (setq ss (ssget '((0 . "INSERT") (2 . "Centrifuge"))))
  )
  (if (= dataType "Heater")
    (setq ss (ssget '((0 . "INSERT") (2 . "Heater"))))
  )
  (if (= dataType "Tank")
    (setq ss (ssget '((0 . "INSERT") (2 . "Tank"))))
  )
  (if (= dataType "Pump")
    (setq ss (ssget '((0 . "INSERT") (2 . "Pump"))))
  )
  (if (= dataType "Vacuum")
    (setq ss (ssget '((0 . "INSERT") (2 . "Vacuum"))))
  )
  (if (= dataType "Reactor")
    (setq ss (ssget '((0 . "INSERT") (2 . "Reactor"))))
  )
  (if (= dataType "CustomEquip")
    (setq ss (ssget '((0 . "INSERT") (2 . "CustomEquip"))))
  )
  (if (= dataType "DrawLabel")
    (setq ss (ssget '((0 . "INSERT") (2 . "title.2017"))))
  )
  (if (= dataType "JoinDrawArrowTo")
    (setq ss (ssget '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
  ) 
  (if (= dataType "JoinDrawArrowFrom")
    (setq ss (ssget '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
  )  
  ss
)

(defun GetAllBlockSSByDataTypeUtils (dataType / ss) 
  (if (= dataType "AllDataType")
    (setq ss (GetAllDataSSUtils))
  )
  (if (= dataType "Pipe")
    (setq ss (GetAllPipeSSUtils))
  )
  (if (= dataType "Instrument")
    (setq ss (GetAllInstrumentSSUtils))
  )
  (if (= dataType "InstrumentAndPipe")
    (setq ss (GetAllInstrumentAndPipeSSUtils))
  )
  (if (= dataType "EquipmentAndPipe")
    (setq ss (GetAllEquipmentAndPipeSSUtils))
  )
  (if (= dataType "OuterPipe")
    (setq ss (GetAllOuterPipeSSUtils))
  )
  (if (= dataType "JoinDrawArrow")
    (setq ss (GetAllJoinDrawArrowSSUtils))
  ) 
  (if (= dataType "Equipment")
    (setq ss (GetAllEquipmentSSUtils))
  )
  (if (= dataType "InstrumentL")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentL"))))
  )
  (if (= dataType "InstrumentP")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentP"))))
  )
  (if (= dataType "InstrumentSIS")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentSIS"))))
  )
  (if (= dataType "Centrifuge")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Centrifuge"))))
  )
  (if (= dataType "Heater")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Heater"))))
  )
  (if (= dataType "Tank")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Tank"))))
  )
  (if (= dataType "Pump")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Pump"))))
  )
  (if (= dataType "Vacuum")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Vacuum"))))
  )
  (if (= dataType "Reactor")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Reactor"))))
  )
  (if (= dataType "CustomEquip")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "CustomEquip"))))
  )
  (if (= dataType "DrawLabel")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "title.2017"))))
  )
  (if (= dataType "JoinDrawArrowTo")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
  ) 
  (if (= dataType "JoinDrawArrowFrom")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
  )  
  ss
)

(defun MergeTwoSSUtils (firstSS secondSS / i)
  (if (/= secondSS nil)
    (progn
      (setq i 0)
      (repeat (sslength secondSS)
        (ssadd (ssname secondSS i) firstSS)
        (setq i (+ i 1))
      )
      firstSS
    )
    firstSS
  )
)

(defun GetCurrentDirByBoxUtils (/ dcl_id fn currentDir filename)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (if (not (new_dialog "dataflow" dcl_id))
    (exit)
  )
  ;the default value of input box
  (set_tile "filename" "FileName")
  (mode_tile "filename" 2)
  (action_tile "filename" "(setq filename $value)")
  (setq status (start_dialog))
  (unload_dialog dcl_id)
  
  (if (= status 1)
    (progn 
      (setq fn filename)
      (setq currentDir (getvar "dwgprefix"))
      (setq fn (strcat currentDir fn ".txt"))
    )
    ; optional
    (done_dialog 0)
  )
)

(defun RemoveLastNumCharForStringUtils (oldStr num / )
  (substr oldStr 1 (- (strlen oldStr) num))
)

(defun ExtractBlockPropertyToJsonStringUtils (entityName propertyNameList / jsonPropertyString)
  (setq jsonPropertyString 
    (apply 'strcat 
      (mapcar '(lambda (x) 
                (strcat "\"" (strcase (car x) T) "\": \"" (cdr x) "\",")
              ) 
        ; remove the first item (entityhandle)
        (cdr (GetPropertyDictListForOneBlockByEntityName entityName propertyNameList))
      ) 
    )
  )
  (setq jsonPropertyString (RemoveLastNumCharForStringUtils jsonPropertyString 1))
  (setq jsonPropertyString (strcat "{" jsonPropertyString "}"))
)

(defun ExtractBlockPropertyToJsonStringByClassUtils (entityName propertyNameList classDict / jsonPropertyString)
  (setq jsonPropertyString 
    (apply 'strcat 
      (mapcar '(lambda (x) 
                (strcat "\"" (strcase (car x) T) "\": \"" (cdr x) "\",")
              ) 
        ; remove the first item (entityhandle) and add the item (class)
        (cons classDict (cdr (GetPropertyDictListForOneBlockByEntityName entityName propertyNameList)))
      ) 
    )
  )
  (setq jsonPropertyString (RemoveLastNumCharForStringUtils jsonPropertyString 1))
  (setq jsonPropertyString (strcat "{" jsonPropertyString "}"))
)

(defun WriteAPropertyValueToTextUtils (propertyName propertyNamePair entx f /)
  (if (= propertyName (car propertyNamePair))
    (princ (strcat "\"" (nth 1 propertyNamePair) "\": \"" (cdr (assoc 1 entx)) "\",") f)
  )
)

(defun WriteLastPropertyValueToTextUtils (propertyName lastPropertyPair classValuePair entx f /)
  (if (= propertyName (car lastPropertyPair))
    (progn
      (princ (strcat "\"" (car classValuePair) "\": \"" (nth 1 classValuePair) "\",") f)
      (princ (strcat "\"" (nth 1 lastPropertyPair) "\": \"" (cdr (assoc 1 entx)) "\"") f)
    )
  )
)

(defun ExtractBlockPropertyUtils (f ss propertyPairNameList lastPropertyPair classValuePair / i index ent blk entx propertyName)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq index 0)
              (setq propertyName (cdr (assoc 2 entx)))
              (repeat (length propertyPairNameList)
                (WriteAPropertyValueToTextUtils propertyName (nth index propertyPairNameList) entx f)
                (setq index (+ index 1))
              )
              (WriteLastPropertyValueToTextUtils propertyName lastPropertyPair classValuePair entx f)
              ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
      )
    )
  )
)

(defun GetEntityNameListBySSUtils (ss / entityNameList i)
  (setq i 0)
  (repeat (sslength ss) 
    (setq entityNameList (append entityNameList (list (ssname ss i))))
    (setq i (+ 1 i))
  )
  entityNameList
)

(defun GetEntityNameListByXPositionSortedUtils (ss / entityNameList resultList) 
  (setq entityNameList (GetEntityNameListBySSUtils ss))
  (setq resultList 
    (mapcar '(lambda (x) 
              (list (cdr (assoc -1 (entget x))) (car (cdr (assoc 10 (entget x)))))
            ) 
      entityNameList
    )
  )
  (setq resultList 
    (vl-sort resultList 
      '(lambda (x y) (< (cadr x) (cadr y)))
    )
  )
  (mapcar '(lambda (x) (car x)) resultList)
)

(defun GetEntityHandleListByEntityNameListUtils (entityNameList /) 
  (mapcar '(lambda (x) (GetEntityHandleByEntityNameUtils x)) 
    entityNameList
  )
)

(defun GetEntityHandleByEntityNameUtils (entityName / entityHandleList) 
  (setq entityHandle (cdr (assoc 5 (entget entityName))))
)

(defun GetCSVPropertyStringByEntityName (entityName propertyNameList / csvPropertyString)
  (setq csvPropertyString "")
  (mapcar '(lambda (x) 
             (setq csvPropertyString (strcat csvPropertyString x ","))
           ) 
    (GetPropertyValueListForOneBlockByEntityName entityName propertyNameList)
  )
  ; add the handle to the start of the csvPropertyString 
  ; (move to GetPropertyValueListForOneBlockByEntityName) - 20201104
  ; add "'" at the start of handle to prevent being converted by excel - 20201020
  (setq csvPropertyString (strcat "'" csvPropertyString))
)

(defun GetPropertyValueListForOneBlockByEntityName (entityName propertyNameList / allPropertyValue resultList) 
  (setq allPropertyValue (GetAllPropertyValueByEntityName entityName))
  ; add the entityhandle property default
  (setq propertyNameList (cons "entityhandle" propertyNameList))
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (cdr (assoc (strcase x T) allPropertyValue)))))
           ) 
    propertyNameList
  )
  resultList
)

(defun GetPropertyDictListForOneBlockByEntityName (entityName propertyNameList / allPropertyValue resultList) 
  (setq allPropertyValue (GetAllPropertyValueByEntityName entityName))
  ; add the entityhandle property default
  (setq propertyNameList (cons "entityhandle" propertyNameList))
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (cons x (cdr (assoc (strcase x T) allPropertyValue))))))
           ) 
    propertyNameList
  )
  resultList
)

(defun GetPropertyDictListByEntityNameList (entityNameList propertyNameList / resultList) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetPropertyDictListForOneBlockByEntityName x propertyNameList))))
           ) 
    entityNameList
  )
  resultList
)

(defun GetPropertyValueListByEntityNameList (entityNameList propertyNameList / resultList) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetPropertyValueListForOneBlockByEntityName x propertyNameList))))
           ) 
    entityNameList
  )
  resultList
)

(defun ReplaceNumberOfListByNumberedListUtils (numberedList originList / i newList)
  (setq newList '())
  (setq i 0)
  (repeat (length originList)
    (setq newList (append newList (list 
                                    (numberedStringSubstUtil (nth i numberedList) (nth i originList))
                                  )))
    (setq i (+ i 1))
  )
  newList
)

; Unit Test Compeleted
(defun ReplaceNumberOfListByNumberedListUtilsTest ()
  (AssertEqual 'ReplaceNumberOfListByNumberedListUtils 
    (list '("PL1201" "PL1202") '("YC-50-2J1" "YC-50-2J1"))
    '("PL1201-50-2J1" "PL1202-50-2J1")
  )
)

; Unit Test Compeleted
(defun numberedStringSubstUtil (newString originString / index replacedSubstring)
  (setq index (vl-string-search "-" originString))
  (setq replacedSubstring (substr originString 1 index))
  (StringSubstUtils newString replacedSubstring originString)
)

; Unit Test Compeleted
(defun StringSubstUtils (new old str / inc len)
    (setq len (strlen new)
          inc 0
    )
    (while (setq inc (vl-string-search old str inc))
        (setq str (vl-string-subst new old str inc)
              inc (+ inc len)
        )
    )
    str
)

; Unit Test Compeleted
(defun GetIndexforSearchMemberInListUtils (searchedMember searchedList / i matchedIndex)
  (setq i 0)
  (repeat (length searchedList)
    (if (= (nth i searchedList) searchedMember)
      (setq matchedIndex i)
    )
    (setq i (+ i 1))
  )
  matchedIndex
)

(defun GetDictValueByKeyUtils (key keyList ValueList /)
  (nth (GetIndexforSearchMemberInListUtils key keyList) ValueList)
)

;; copy source code from: [http://lee-mac.com/substn.html]
; Unit Test Compeleted
; do not understand the function now - 2020-10-29
(defun ReplaceListItemByindexUtils (newItem index originList / i)
    (setq i -1)
    (mapcar '(lambda (x) 
               (if (= (setq i (1+ i)) index) 
                 newItem 
                 x
               )
             ) 
             originList
    )
)

; Unit Test Completed
(defun AddItemToListStartUtils (firstList secondList /)
  (mapcar '(lambda (x y) (cons x y)) 
           firstList 
           secondList
  )
)

; Unit Test Compeleted
(defun SpliceElementInTwoListUtils (firstList secondList /)
  (mapcar '(lambda (x y) (strcat x y)) firstList secondList)
)

(defun ModifyOnePropertyForOneBlockUtils (entityName modifiedPropertyName newPropertyValue / entityData entx propertyName)
  (setq entityData (entget entityName))
  ; get attribute data of block
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (if (= propertyName modifiedPropertyName)
      (SetDXFValueByEntityDataUtils entx 1 newPropertyValue)
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  (entupd entityName)
)

(defun ModifyMultiplePropertyForOneBlockUtils (entityName modifiedPropertyNameList newPropertyValueList / entityData entx propertyName)
  (setq entityData (entget entityName))
  ; get attribute data of block
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (mapcar '(lambda (x y) 
                (if (= propertyName x)
                  (SetDXFValueByEntityDataUtils entx 1 y)
                ) 
             ) 
      modifiedPropertyNameList 
      newPropertyValueList 
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  (entupd entityName)
)

(defun GetMultiplePropertyForOneBlockUtils (entityName propertyNameList / entityData entx propertyName propertyValueList)
  (setq entityData (entget entityName))
  ; get attribute data of block
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (mapcar '(lambda (x) 
                (if (= propertyName x)
                  (setq propertyValueList (append propertyValueList (list (cdr (assoc 1 entx)))))
                ) 
             ) 
      propertyNameList 
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  propertyValueList
)

(defun GetMultiplePropertyDictForOneBlockUtils (entityName propertyNameList / entityData entx propertyName propertyValueDict)
  (setq entityData (entget entityName))
  ; get attribute data of block
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (mapcar '(lambda (x) 
                (if (= propertyName x)
                  (setq propertyValueDict (append propertyValueDict (list (cons (strcase propertyName T) (cdr (assoc 1 entx))))))
                ) 
             ) 
      propertyNameList 
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  propertyValueDict
)

(defun SetDXFValueByEntityDataUtils (entityData DXFcode propertyValue / oldValue newValue)
  (setq oldValue (assoc DXFcode entityData))
  (setq newValue (cons DXFcode propertyValue))
  (entmod (subst newValue oldValue entityData))
)

(defun ModifyPropertyByNameAndValueListUtils (entityNameList propertyNameList propertyValueList /)
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              propertyNameList
              propertyValueList
            )
          ) 
    entityNameList 
  )
)

(defun ModifyPropertyValueByEntityHandleUtils (importedDataList propertyNameList / entityNameList propertyValueList)
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

; Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Read and Write Utils

(defun WriteDataListToFileUtils (fileDir dataList / filePtr)
  (setq filePtr (open fileDir "w"))
  (foreach item dataList 
    (write-line item filePtr)
  )
  (close filePtr)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

(defun WriteDataToCSVByEntityNameListUtils (entityNameList fileDir firstRow propertyNameList / filePtr csvPropertyStringList)
  (setq filePtr (open fileDir "w"))
  (write-line firstRow filePtr)
  (foreach item entityNameList 
    (setq csvPropertyStringList (append csvPropertyStringList (list (GetCSVPropertyStringByEntityName item propertyNameList))))
  )
  (foreach item csvPropertyStringList 
    (write-line item filePtr)
  )
  (close filePtr)
)

(defun WritePipeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\pipeData.csv")
  (setq firstRow "数据ID,管道编号,工作介质,工作温度,工作压力,相态,管道起点,管道终点,流程图号,保温材料,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPipePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteInstrumentDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  (setq firstRow "数据ID,仪表功能代号,仪表位号,工作介质,工作温度,工作压力,仪表类型,相态,所在位置材质,控制点名称,所在管道或设备,最小值,最大值,正常值,流程图号,所在位置尺寸,备注,安装方向,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetInstrumentPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteReactorDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,设备体积,工作介质,工作温度,工作压力,电机功率,电机是否防爆,电机级数,反应釜转数,设备尺寸,设备材质,设备重量,设备型号,保温厚度,设备数量,极限温度,极限压力,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetReactorPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteTankDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,设备体积,工作介质,工作温度,工作压力,电机功率,电机是否防爆,电机级数,设备尺寸,设备材质,设备重量,设备型号,保温厚度,设备数量,极限温度,极限压力,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetTankPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteHeaterDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,换热面积,设备尺寸,换热元件规格,设备材质,设备重量,设备型号,保温厚度,设备数量,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetHeaterPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WritePumpDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,流量,扬程,电机功率,电机是否防爆,电机级数,设备材质,设备重量,设备数量,设备型号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPumpPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteVacuumDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,抽气量,极限压力,电机功率,电机是否防爆,电机级数,设备尺寸,设备材质,设备重量,设备型号,设备数量,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetVacuumPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteCentrifugeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,设备体积,装料限重,转鼓直径,转鼓转速,最大分离因素,设备尺寸,电机功率,电机是否防爆,电机级数,设备材质,设备重量,设备型号,设备数量,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCentrifugePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteCustomEquipDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,设备尺寸,电机功率,电机是否防爆,电机级数,关键参数1,关键参数2,关键参数3,关键参数4,设备材质,设备重量,设备型号,保温厚度,设备数量,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCustomEquipPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteDataToCSVByEntityNameListStrategy (entityNameList dataType /)
  (if (= dataType "Pipe") 
    (WritePipeDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Instrument") 
    (WriteInstrumentDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Reactor") 
    (WriteReactorDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Tank") 
    (WriteTankDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Heater") 
    (WriteHeaterDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Pump") 
    (WritePumpDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Vacuum") 
    (WriteVacuumDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Centrifuge") 
    (WriteCentrifugeDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "CustomEquip") 
    (WriteCustomEquipDataToCSVByEntityNameListUtils entityNameList)
  )
)

;; Separates a string using a given delimiter
;; copy from [http://www.lee-mac.com/stringtolist.html]
(defun StrToListUtils (strData delimiter / len resultList delimiterPosition)
    (setq len (1+ (strlen delimiter)))
    (while (setq delimiterPosition (vl-string-search delimiter strData))
        (setq resultList (cons (substr strData 1 delimiterPosition) resultList)
            strData (substr strData (+ delimiterPosition len))
        )
    )
    (reverse (cons strData resultList))
)

(defun StrListToListListUtils (strList / resultList)
  (foreach item strList 
    (setq resultList (append resultList (list (StrToListUtils item ","))))
  )
  resultList
)

(defun RemoveFirstCharOfItemInListUtils (originList /) 
  (mapcar '(lambda (x) (substr x 2)) originList)
)

(defun ReadDataFromCSVUtils (fileDir / filePtr i textLine resultList)
  (setq filePtr (open fileDir "r"))
  (if filePtr 
    (progn 
      (setq i 1)
      (while (setq textLine (read-line filePtr)) 
        (setq resultList (append resultList (list textLine)))
        (setq i (+ 1 i))
      )
    )
  )
  (close filePtr)
  (setq resultList (cdr resultList))
  (RemoveFirstCharOfItemInListUtils resultList)
)

(defun ReadDataFromCSVStrategy (dataType / fileDir)
  (if (= dataType "Pipe") 
    (setq fileDir "D:\\dataflowcad\\data\\pipeData.csv")
  )
  (if (= dataType "Instrument") 
    (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  )
  (if (= dataType "Reactor") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "Tank") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "Heater") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "Pump") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "Vacuum") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "Centrifuge") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (if (= dataType "CustomEquip") 
    (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  )
  (ReadDataFromCSVUtils fileDir)
)
; Read and Write Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Utils Field
; Sorting Select Set by XY cordinate
; source code copied from web

(defun sortListofSublistsbyItemX (lstOfSublists intItem intDirection)
 (if (> intDirection 0)
  (vl-sort lstOfSublists '(lambda (X Y) (< (nth intItem X) (nth intItem Y))))
  (vl-sort lstOfSublists '(lambda (X Y) (> (nth intItem X) (nth intItem Y))))
 )
)

(defun SelectionSetToList (ssSelections / intCount lstReturn)
 (if (and ssSelections 
          (= (type ssSelections) 'PICKSET)
     )
  (repeat (setq intCount (sslength ssSelections))
   (setq intCount  (1- intCount)
         lstReturn (cons (ssname ssSelections intCount) lstReturn)
   )
  )
 )
 (reverse lstReturn)
)

(defun ListToSelectionSet (lstOfEntities / ssReturn)
 (if lstOfEntities      
  (foreach entItem lstOfEntities
   (if (= (type entItem) 'ENAME)
    (if ssReturn 
     (setq ssReturn (ssadd entItem ssReturn))
     (setq ssReturn (ssadd entItem))
    )
   )
  )
 )
 ssReturn
)

(defun SortSelectionSetByXYZ (ssSelections /  lstOfSelections lstOfSublists lstSelections)
 (if
  (and 
   (setq lstSelections (SelectionSetToList ssSelections))
   (setq lstOfSublists (mapcar '(lambda (X)(cons X (cdr (assoc 10 (entget X))))) lstSelections))
   (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 3 1))
    ; the key is -1 for y cordinate
   (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 2 -1))
   (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 1 1))
   (setq ssSelections  (listtoselectionset (mapcar 'car lstOfSublists)))
  )
  ssSelections
 )
)

; Sorting Select Set by XY cordinate
; Utils Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for extract data

(defun c:exportBlockPropertyData (/ dataTypeList)
  (setq dataTypeList '("Pipe" "Equipment" "Instrument" "Electric" "OuterPipe"))
  (ExportBlockProperty dataTypeList)
)

(defun ExportBlockProperty (dataTypeList / dcl_id fileName currentDir fileDir exportDataType exportMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog "exportBlockPropertyDataBox" dcl_id "" '(-1 -1))
    ; Add the actions to the button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    ; Set the default value
    (mode_tile "fileName" 2)
    (mode_tile "exportDataType" 2)
    (action_tile "fileName" "(setq fileName $value)")
    (action_tile "exportDataType" "(setq exportDataType $value)")
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
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "文件名不能为空")
    )
    ; export data button
    (if (= 2 (setq status (start_dialog))) 
      (if (/= fileName "") 
        (progn 
          (setq dataType (nth (atoi exportDataType) dataTypeList))
          (ExportDataByDataType fileName dataType)
          (setq exportMsgBtnStatus 1)
        )
        (setq exportMsgBtnStatus 2)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun ExportDataByDataType (fileName dataType /) 
  (if (= dataType "Pipe") 
    (ExportPipeData fileName)
  )
  (if (= dataType "Equipment") 
    (ExportEquipmentData fileName)
  )
  (if (= dataType "Instrument") 
    (ExportInstrumentData fileName)
  )
  (if (= dataType "Electric") 
    (ExportEquipmentData fileName)
  )
  (if (= dataType "OuterPipe") 
    (ExportOuterPipeData fileName)
  )
)

(defun GetExportDataFileDir (fileName / currentDir fileDir)
  (setq currentDir (getvar "dwgprefix"))
  (setq fileDir (strcat currentDir fileName ".txt"))
)

(defun ExportInstrumentData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (append (ExtractBlockPropertyToJsonList "InstrumentP")
                                            (ExtractBlockPropertyToJsonList "InstrumentSIS")
                                            (ExtractBlockPropertyToJsonList "InstrumentL")
                                            (ExtractBlockPropertyToJsonList "Pipe")
                                            (ExtractBlockPropertyToJsonList "Reactor")
                                            (ExtractBlockPropertyToJsonList "Tank")
                                            (ExtractBlockPropertyToJsonList "Heater")
                                            (ExtractBlockPropertyToJsonList "Pump")
                                            (ExtractBlockPropertyToJsonList "Vacuum")
                                            (ExtractBlockPropertyToJsonList "Centrifuge")
                                            (ExtractBlockPropertyToJsonList "CustomEquip")
                                    )
  )
)

(defun ExportPipeData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (ExtractBlockPropertyToJsonList "Pipe"))
)

(defun ExportEquipmentData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (append (ExtractBlockPropertyToJsonList "Reactor")
                                            (ExtractBlockPropertyToJsonList "Tank")
                                            (ExtractBlockPropertyToJsonList "Heater")
                                            (ExtractBlockPropertyToJsonList "Pump")
                                            (ExtractBlockPropertyToJsonList "Vacuum")
                                            (ExtractBlockPropertyToJsonList "Centrifuge")
                                            (ExtractBlockPropertyToJsonList "CustomEquip")
                                    )
  )
)

(defun ExportOuterPipeData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (ExtractOuterPipeToJsonList)
  )
)

; the macro for extract data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; function for extract block property to text

(defun ExtractBlockPropertyToJsonList (dataType / ss entityNameList propertyNameList classDict resultList)
  (setq ss (GetAllBlockSSByDataTypeUtils dataType))
  (if (/= ss nil) ; repair bug for scenes of no exiting entity in CAD
    (progn 
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
  )
)

(defun ModifyPropertyNameForJsonListStrategy (dataType resultList /) 
  (if (or (= dataType "InstrumentP") 
          (= dataType "InstrumentL") 
          (= dataType "InstrumentSIS")
      ) 
    (progn 
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "minvalue" "min" x)
                ) 
          resultList
        )
      )
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "maxvalue" "max" x)
                ) 
          resultList
        )
      )
    )
  )
  (if (or (= dataType "Reactor") 
          (= dataType "Tank") 
          (= dataType "Heater")
          (= dataType "Pump")
          (= dataType "Vacuum")
          (= dataType "Centrifuge")
          (= dataType "CustomEquip")
      ) 
    (progn 
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "first_spec" "species" x)
                ) 
          resultList
        )
      )
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "is_antiexplosive" "antiexplosive" x)
                ) 
          resultList
        )
      )
      ; correct mistake made before
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "volumn" "volume" x)
                ) 
          resultList
        )
      )
    )
  )
  resultList
)

(defun GetClassDictStrategy (dataType / result) 
  (cond 
    ((= dataType "InstrumentP") (setq result (cons "class" "concentrated")))
    ((= dataType "InstrumentL") (setq result (cons "class" "location")))
    ((= dataType "InstrumentSIS") (setq result (cons "class" "sis")))
    ((= dataType "Pipe") (setq result (cons "class" "pipeline")))
    ((= dataType "OuterPipe") (setq result (cons "class" "outerpipe")))
    ((= dataType "Reactor") (setq result (cons "class" "reactor")))
    ((= dataType "Tank") (setq result (cons "class" "tank")))
    ((= dataType "Heater") (setq result (cons "class" "heater")))
    ((= dataType "Pump") (setq result (cons "class" "pump")))
    ((= dataType "Vacuum") (setq result (cons "class" "vacuum")))
    ((= dataType "Centrifuge") (setq result (cons "class" "centrifuge")))
    ((= dataType "CustomEquip") (setq result (cons "class" "custom")))
  )
  result
)

(defun ExtractOuterPipeToJsonList (/ outerPipeJsonList pipeSS pipeEntityNameList pipePropertyNameList outerPipeSS outerPipeEntityNameList 
                                   outerPipePropertyNameList outerPipePipeNumList pipeList selectedPipeEntityNameList selectedPipeList resultList) 
  (setq outerPipeJsonList (ExtractBlockPropertyToJsonList "OuterPipe"))
  (setq pipeSS (GetAllBlockSSByDataTypeUtils "Pipe"))
  (setq pipeEntityNameList (GetEntityNameListBySSUtils pipeSS))
  (setq pipePropertyNameList (GetPropertyNameListStrategy "Pipe"))
  (setq outerPipeSS (GetAllBlockSSByDataTypeUtils "OuterPipe"))
  (setq outerPipeEntityNameList (GetEntityNameListBySSUtils outerPipeSS))
  (setq outerPipePropertyNameList (GetPropertyNameListStrategy "OuterPipe"))
  (setq outerPipePipeNumList 
    (mapcar '(lambda (x) 
              (cdr (assoc "PIPENUM" x))
            ) 
      (GetPropertyDictListByEntityNameList outerPipeEntityNameList outerPipePropertyNameList)
    ) 
  )
  (setq pipeList 
    (vl-remove-if-not '(lambda (x) 
                        (= (type (member (cdr (assoc "PIPENUM" x)) outerPipePipeNumList)) 'list)
                      ) 
      (GetPropertyDictListByEntityNameList pipeEntityNameList pipePropertyNameList)
    )
  )
  (setq selectedPipeEntityNameList 
    (mapcar '(lambda (x) 
              (handent (cdr (assoc "entityhandle" x)))
            ) 
      pipeList
    ) 
  )
  (setq selectedPipeJsonList 
    (mapcar '(lambda (x) 
              (ExtractBlockPropertyToJsonStringByClassUtils x pipePropertyNameList (GetClassDictStrategy "Pipe"))
            ) 
      selectedPipeEntityNameList
    )
  )
  (setq resultList (append outerPipeJsonList selectedPipeJsonList))
)

; function for extract block property to text
; Gs Field
;;;-------------------------------------------------------------------------;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; Generate Entity Object in CAD

(defun GenerateTextByPositionAndContent (insPt textContent /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "管道编号") (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 3.0) (cons 1 textContent) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "Standard") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GenerateEquipTagText (insPt textContent /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "设备位号") (cons 100 "AcDbText") 
                  (cons 10 '(0.0 0.0 0.0)) (cons 11 insPt) (cons 40 3.0) (cons 1 textContent) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "Standard") (cons 71 0) (cons 72 1) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GeneratePublicPipePolyline (insPt /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "PL2") (cons 62 3) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 43 0.6) (cons 38 0.0) (cons 39 0.0) (cons 10 (MoveInsertPosition insPt 0 50)) (cons 40 0.6) 
          (cons 41 0.6) (cons 42 0.0) (cons 91 0) (cons 10 insPt) (cons 40 0.6) (cons 41 0.6) (cons 42 0.0) (cons 91 0) (cons 210 '(0.0 0.0 1.0))
    ))
  (princ)
)

(defun GeneratePublicPipeDownArrow (insPt /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "PL2") (cons 62 30) (cons 370 13) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 38 0.0) (cons 39 0.0) (cons 10 insPt) (cons 40 0.5) (cons 41 2.0) (cons 42 0.0) (cons 91 0) 
          (cons 10 (MoveInsertPosition insPt 0 4.75)) (cons 40 0.9) (cons 41 0.9) (cons 42 0.0) (cons 91 0) (cons 210 '(0.0 0.0 1.0))
    ))
  (princ)
)

(defun GeneratePublicPipeUpArrow (insPt /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "PL2") (cons 62 30) (cons 370 13) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 38 0.0) (cons 39 0.0) (cons 10 (MoveInsertPosition insPt 0 4.75)) (cons 40 0.5) (cons 41 2.0) (cons 42 0.0) (cons 91 0) 
          (cons 10 insPt) (cons 40 0.9) (cons 41 0.9) (cons 42 0.0) (cons 91 0) (cons 210 '(0.0 0.0 1.0))
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

(defun GenerateBlockAttribute (insPt propertyName propertyValue blockLayer /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 3.0) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons  7 "Standard") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 0) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateBlockHiddenAttribute (insPt propertyName propertyValue blockLayer /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 3.0) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons  7 "Standard") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 1) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateJoinDrawArrowToElement (insPt fromtoValue drawnumValue relatedIDValue/)
  (GenerateBlockReference insPt "JoinDrawArrowTo" "接图箭头")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "接图箭头")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "接图箭头")
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue/ "接图箭头")
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateJoinDrawArrowFromElement (insPt pipenumValue fromtoValue drawnumValue relatedIDValue/)
  (GenerateBlockReference insPt "JoinDrawArrowFrom" "接图箭头")
  (GenerateBlockAttribute (MoveInsertPosition insPt 30 2) "PIPENUM" pipenumValue "接图箭头")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "接图箭头")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "接图箭头")
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue/ "接图箭头")
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeElement (insPt textDataList blockName /)
  (entmake (list (cons 0 "INSERT") (cons 100 "AcDbEntity") (cons 100 "AcDbBlockReference") 
                 (cons 2 blockName) (cons 10 insPt) 
           )
  )
  (GenerateTextDataStrategy blockName insPt textDataList)
)

(defun GenerateTextDataStrategy (blockName insPt textDataList /) 
  (if (= blockName "PublicPipeElementS") 
    (progn 
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -0.85 6.3) (nth 1 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -3.5 -10) (nth 3 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt 1.21 -10) (nth 4 textDataList))
      (GeneratePublicPipePolyline insPt)
      (GeneratePublicPipeDownArrow (MoveInsertPosition insPt 0 20))
    )
  )
  (if (= blockName "PublicPipeElementW") 
    (progn 
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -0.85 6.3) (nth 1 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -3.5 -11.5) (nth 2 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt 1.21 -11.5) (nth 4 textDataList))
      (GeneratePublicPipePolyline insPt)
      (GeneratePublicPipeUpArrow (MoveInsertPosition insPt 0 20))
    )
  )
  (if (= blockName "EquipTagV2") 
    (progn 
      (GenerateEquipTagText (MoveInsertPosition insPt 0 1) (nth 0 textDataList))
      (GenerateEquipTagText (MoveInsertPosition insPt 0 -4.5) (nth 1 textDataList))
    )
  )
)

(defun GeneratEntityObjectElement (blockName insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeElement x y blockName)
          ) 
          insPtList
          dataList
  )
)

; have not been used now - 2020-10-30
(defun GetEntityNameListAfterGeneratedUtils (lastEntityName / resultList)
  (while lastEntityName 
    (setq lastEntityName (entnext lastEntityName))
    (setq resultList (append resultList (list lastEntityName)))
  )
  resultList
)

(defun InsertPublicPipeElement (dataList pipeSourceDirection / lastEntityName insPt insPtList) 
  (setq lastEntityName (entlast))
  (setq insPt (getpoint "\n选取辅助流程组件插入点："))
  (setq dataList (ProcessPublicPipeElementData dataList))
  ; sort data by drawnum
  (setq dataList (vl-sort dataList '(lambda (x y) (< (nth 4 x) (nth 4 y)))))
  (setq insPtList (GetInsertPtList insPt (GenerateSortedNumByList dataList) 10))
  (if (= pipeSourceDirection "0") 
    (GeneratEntityObjectElement "PublicPipeElementS" insPtList dataList)
    (GeneratEntityObjectElement "PublicPipeElementW" insPtList dataList)
  )
)

(defun ProcessPublicPipeElementData (dataList /) 
  (mapcar '(lambda (x) 
             ; the property value of drawnum may be null
             (if (< (strlen (nth 4 x)) 3) 
               (ReplaceListItemByindexUtils "XXXXX" 4 x)
               (ReplaceListItemByindexUtils (ExtractDrawNum (nth 4 x)) 4 x)
             )
           ) 
    dataList
  )
)

; Unit Test Completed
(defun ExtractDrawNum (str / result) 
  (if (> (strlen str) 2) 
    (setq result (substr str (- (strlen str) 4)))
    (setq result "无图号")
  )
)

(defun c:EquipTag (/ ss equipInfoList insPt insPtList)
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\n选取设备位号的插入点："))
  (setq insPtList (GetInsertPtList insPt (GenerateSortedNumByList equipInfoList) 30))
  (GeneratEntityObjectElement "EquipTagV2" insPtList equipInfoList)
)

; Unit Test Completed
(defun GenerateSortedNumByList (originList / i resultList)
  (setq i 0)
  (repeat (length originList) 
    (setq resultList (append resultList (list i)))
    (setq i (+ i 1))
  )
  resultList
)

; Unit Test Compeleted
(defun MoveInsertPosition (insPt xOffset yOffset / result)
  (setq result (ReplaceListItemByindexUtils (+ (car insPt) xOffset) 0 insPt))
  (setq result (ReplaceListItemByindexUtils (+ (nth 1 result) yOffset) 1 result))
  result
)

; get the new inserting position
; Unit Test Compeleted
(defun GetInsertPt (insPt i removeDistance /)
  (ReplaceListItemByindexUtils (+ (car insPt) (* i removeDistance)) 0 insPt)
)

; Unit Test Compeleted
(defun GetInsertPtList (insPt SortedNumByList removeDistance / resultList)
  (mapcar '(lambda (x) (GetInsertPt insPt x removeDistance)) 
    SortedNumByList
  )
)

(defun GetEquipTagList (ss / i ent blk entx value equipInfoList equipTag equipName)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (if (/= nil (ssname ss i))
          (progn
	          ; get the entity information of the i(th) block
            (setq ent (entget (ssname ss i)))
	          ; save the entity name of the i(th) block
            (setq blk (ssname ss i))
	          ; get the property information
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (if (= value "TAG")
		            (setq equipTag (append equipTag (list (cdr (assoc 1 entx)))))
              )
              (if (= value "NAME")
		            (setq equipName (append equipName (list (cdr (assoc 1 entx)))))
              )
	            ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
      )
    )
  )
  (setq equipInfoList (mapcar '(lambda (x y) (list x y)) equipTag equipName))
)

; Generate Entity Object in CAD
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for generate joinDrawArrow

(defun c:UpdateJoinDrawArrow ()
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowTo")
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowFrom")
  (alert "更新完成")(princ)
)

(defun UpdateJoinDrawArrowByDataType (dataType / entityNameList relatedPipeData) 
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  )
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyValueByEntityName (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    (GetAllPropertyValueListByEntityNameList entityNameList)
  )
  (UpdateJoinDrawArrowStrategy dataType entityNameList relatedPipeData)
)

(defun UpdateJoinDrawArrowStrategy (dataType entityNameList relatedPipeData /) 
  (cond 
    ((= dataType "JoinDrawArrowFrom") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "PIPENUM" "FROMTO" "DRAWNUM") 
                  (list 
                    (cdr (assoc "pipenum" y)) 
                    (strcat "自" (cdr (assoc "from" y)))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "JoinDrawArrowTo") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "FROMTO" "DRAWNUM") 
                  (list 
                    (strcat "去" (cdr (assoc "to" y)))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
)

(defun c:GenerateJoinDrawArrow (/ pipeSS pipeData insPt entityNameList)
  (prompt "\n选择生成接图箭头的边界管道：")
  (setq pipeSS (GetPipeSSBySelectUtils))
  (setq pipeData (GetAllPropertyValueByEntityName (car (GetEntityNameListBySSUtils pipeSS))))
  (setq insPt (getpoint "\n选取接图箭头的插入点："))
  (GenerateJoinDrawArrowToElement insPt
    (strcat "去" (cdr (assoc "to" pipeData))) 
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  )
  (GenerateJoinDrawArrowFromElement (MoveInsertPosition insPt 20 0)
    (cdr (assoc "pipenum" pipeData)) 
    (strcat "自" (cdr (assoc "from" pipeData)))
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  ) 
  (princ)
)

(defun GetRelatedEquipDataByTag (tag / equipData) 
  (setq equipData (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllEquipmentSSUtils))))
  (car 
    (vl-remove-if-not '(lambda (x) 
                        (= (cdr (assoc "tag" x)) tag)
                      ) 
      equipData
    ) 
  )
)

(defun GetRelatedEquipDrawNum (equipData / result) 
  (if (/= equipData nil) 
    (setq result (ExtractDrawNum (cdr (assoc "drawnum" equipData))))
    (setq result "无此设备")
  )
  result
)

; logic for generate joinDrawArrow
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for brushBlockPropertyValue

(defun c:brushLocationForInstrument (/ locationData entityNameList)
  (prompt "\n选择仪表所在位置（管道或设备）：")
  (setq locationData (GetPipenumOrTag))
  (prompt "\n选择要刷所在位置的仪表（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetInstrumentSSBySelectUtils)))
  (ModifyLocatonForInstrument entityNameList locationData)
  (princ)
)

(defun ModifyLocatonForInstrument (entityNameList locationData /)
  (if (/= locationData "") 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "LOCATION") (list locationData))
            ) 
      entityNameList
    )
  )
)

(defun c:brushStartEndForPipe (/ startData endData entityNameList)
  (prompt "\n选择管道起点（直接空格表示不修改）：")
  (setq startData (GetPipenumOrTag))
  (prompt "\n选择管道终点（直接空格表示不修改）：")
  (setq endData (GetPipenumOrTag))
  (prompt "\n选择要刷的管道（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList startData endData)
  (princ)
)

(defun ModifyStartEndForPipes (entityNameList startData endData /)
  (if (and (/= startData "") (/= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "FROM" "TO") (list startData endData))
            ) 
      entityNameList
    )
  )
  (if (and (/= startData "") (= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "FROM") (list startData))
            ) 
      entityNameList
    )
  )
  (if (and (= startData "") (/= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "TO") (list endData))
            ) 
      entityNameList
    )
  )
)

(defun GetPipenumOrTagList (dataSS /)
  (GetAllPropertyValueByEntityName 
    (car (GetEntityNameListBySSUtils dataSS))
  )
)

(defun GetPipenumOrTag (/ dataSS dataList result)
  (setq dataSS (GetEquipmentAndPipeSSBySelectUtils))
  (if (/= dataSS nil) 
    (progn 
      (setq dataList (GetPipenumOrTagList dataSS))
      (if (/= (cdr (assoc "tag" dataList)) nil) 
        (setq result (cdr (assoc "tag" dataList)))
      )
      (if (/= (cdr (assoc "pipenum" dataList)) nil) 
        (setq result (cdr (assoc "pipenum" dataList)))
      )
    )
    (setq result "")
  )
  result
)

(defun c:brushBlockPropertyValue ()
  (brushBlockPropertyValueByBox "brushBlockPropertyValueBox")
)

(defun brushBlockPropertyValueByBox (tileName / dcl_id selectedProperty selectedPropertyIndexList selectedPropertyNameList 
                                     status ss entityNameList brushedPropertyDict matchedList modifiedDataType modifiedSS modifiedEntityNameList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    ; the default value of input box
    (mode_tile "selectedProperty" 2)
    (mode_tile "modifiedDataType" 2)
    (action_tile "selectedProperty" "(setq selectedProperty $value)")
    (action_tile "modifiedDataType" "(setq modifiedDataType $value)")
    (progn
      (start_list "selectedProperty" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("工作介质" "工作温度" "工作压力" "相态" "流程图号" "管道编号"))
      (end_list)
    )
    (progn
      (start_list "modifiedDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("全部" "仪表和管道" "管道" "仪表" "设备"))
      (end_list)
    )
    ; init the default data of text
    (if (= nil selectedProperty)
      (setq selectedProperty "0")
    )
    (if (= nil modifiedDataType)
      (setq modifiedDataType "0")
    )
    (set_tile "selectedProperty" selectedProperty)
    (set_tile "modifiedDataType" modifiedDataType)
    ; Display the number of selected pipes
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq selectedPropertyIndexList (StrToListUtils selectedProperty " "))
        (setq selectedPropertyNameList (GetSelectedPropertyNameList selectedPropertyIndexList (GetBrushedPropertyNameDictList)))
        (setq ss (GetAllDataSSBySelectUtils))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq brushedPropertyDict (GetMultiplePropertyDictForOneBlockUtils (car entityNameList) selectedPropertyNameList))
        (setq matchedList (GetBrushedPropertyValueList brushedPropertyDict))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq modifiedSS (GetBlockSSBySelectByDataTypeUtils (cdr (assoc modifiedDataType (GetBrushedPropertyDataTypeDict)))))
        (setq modifiedEntityNameList (GetEntityNameListBySSUtils modifiedSS))
        (ModifyBrushedProperty modifiedEntityNameList brushedPropertyDict)
      )
    )
  )
  (setq matchedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun ModifyBrushedProperty (entityNameList brushedPropertyDict /) 
  (ModifyPropertyByNameAndValueListUtils entityNameList 
    (GetBrushedPropertyNameList brushedPropertyDict) 
    (GetBrushedPropertyValueList brushedPropertyDict)
  )
)

(defun GetBrushedPropertyNameList (brushedPropertyDict / brushedPropertyNameList) 
  (mapcar '(lambda (x) 
             (setq brushedPropertyNameList (append brushedPropertyNameList (list (strcase (car x)))))
           ) 
    brushedPropertyDict
  )
  brushedPropertyNameList
)

(defun GetBrushedPropertyValueList (brushedPropertyDict / brushedPropertyValueList) 
  (mapcar '(lambda (x) 
             (setq brushedPropertyValueList (append brushedPropertyValueList (list (cdr x))))
           ) 
    brushedPropertyDict
  )
  brushedPropertyValueList
)

(defun GetBrushedPropertyDataTypeDict () 
  (mapcar '(lambda (x y) (cons x y)) 
    '("0" "1" "2" "3" "4")
    '("AllDataType" "InstrumentAndPipe" "Pipe" "Instrument" "Equipment")      
  )
)

(defun GetSelectedPropertyNameList (selectedPropertyIndexList GetBrushedPropertyNameDictList / selectedPropertyNameList) 
  (mapcar '(lambda (x) 
             (setq selectedPropertyNameList 
                (append selectedPropertyNameList (list (cdr (assoc x GetBrushedPropertyNameDictList))))
             )
           ) 
    selectedPropertyIndexList
  )
  selectedPropertyNameList
)

(defun GetBrushedPropertyNameDictList (/ listBoxValueList brushedPropertyNameList) 
  (setq listBoxValueList '("0" "1" "2" "3" "4" "5"))
  (setq brushedPropertyNameList '("SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "DRAWNUM" "PIPENUM"))
  (mapcar '(lambda (x y) (cons x y)) 
    listBoxValueList 
    brushedPropertyNameList 
  )
)

; logic for brushBlockPropertyValue
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for generatePublicProcessElement

(defun c:generatePublicProcessElement ()
  (generatePublicProcessElementByBox "generatePublicProcessElementBox" "Pipe")
)

(defun generatePublicProcessElementByBox (tileName dataType / dcl_id pipeSourceDirection patternValue status ss sslen matchedList blockDataList entityNameList previewDataList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    (action_tile "btnShowOriginData" "(done_dialog 4)")
    
    ; optional setting for the popup_list tile
    (set_tile "pipeSourceDirection" "0")
    ; the default value of input box
    (mode_tile "pipeSourceDirection" 2)
    (action_tile "pipeSourceDirection" "(setq pipeSourceDirection $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    
    (progn
      (start_list "pipeSourceDirection" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("自总管" "去总管"))
      (end_list)
    )
    ; init the default data of text
    (if (= nil pipeSourceDirection)
      (setq pipeSourceDirection "0")
    )
    (if (= nil patternValue)
      (setq patternValue "*")
    )
    (set_tile "pipeSourceDirection" pipeSourceDirection)
    (set_tile "patternValue" patternValue)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq ss (GetBlockSSBySelectByDataTypeUtils dataType))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq ss (GetAllBlockSSByDataTypeUtils dataType))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
      )
    )
    ; view button
    (if (= 4 status)
      (progn 
        (InsertPublicPipeElement previewDataList pipeSourceDirection)
        (setq status 1)
      )
    )
  )
  (setq matchedList nil)
  (unload_dialog dcl_id)
  (princ)
)

; logic for generatePublicProcessElement
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; the macro for modify data

(defun c:modifyPipeProperty (/ pipePropertyNameList)
  (setq pipePropertyNameList (GetPipePropertyNameList))
  (filterAndModifyBlockPropertyByBox pipePropertyNameList "filterAndModifyEquipmentPropertyBox" "Pipe")
)

(defun c:modifyKsProperty (/ instrumentPropertyNameList)
  (setq instrumentPropertyNameList (GetInstrumentPropertyNameList))
  (filterAndModifyBlockPropertyByBox instrumentPropertyNameList "filterAndModifyEquipmentPropertyBox" "Instrument")
)

(defun c:modifyReactorProperty (/ reactorPropertyNameList dataTypeList)
  (setq reactorPropertyNameList (GetReactorPropertyNameList))
  (filterAndModifyBlockPropertyByBox reactorPropertyNameList "filterAndModifyEquipmentPropertyBox" "Reactor")
)

(defun c:modifyTankProperty (/ tankPropertyNameList dataTypeList)
  (setq tankPropertyNameList (GetTankPropertyNameList))
  (filterAndModifyBlockPropertyByBox tankPropertyNameList "filterAndModifyEquipmentPropertyBox" "Tank")
)

(defun c:modifyHeaterProperty (/ heaterPropertyNameList dataTypeList)
  (setq heaterPropertyNameList (GetHeaterPropertyNameList))
  (filterAndModifyBlockPropertyByBox heaterPropertyNameList "filterAndModifyEquipmentPropertyBox" "Heater")
)

(defun c:modifyPumpProperty (/ pumpPropertyNameList dataTypeList)
  (setq pumpPropertyNameList (GetPumpPropertyNameList))
  (filterAndModifyBlockPropertyByBox pumpPropertyNameList "filterAndModifyEquipmentPropertyBox" "Pump")
)

(defun c:modifyVacuumProperty (/ vacuumPropertyNameList dataTypeList)
  (setq vacuumPropertyNameList (GetVacuumPropertyNameList))
  (filterAndModifyBlockPropertyByBox vacuumPropertyNameList "filterAndModifyEquipmentPropertyBox" "Vacuum")
)

(defun c:modifyCentrifugeProperty (/ centrifugePropertyNameList dataTypeList)
  (setq centrifugePropertyNameList (GetCentrifugePropertyNameList))
  (filterAndModifyBlockPropertyByBox centrifugePropertyNameList "filterAndModifyEquipmentPropertyBox" "Centrifuge")
)

(defun c:modifyCustomEquipProperty (/ customEquipPropertyNameList dataTypeList)
  (setq customEquipPropertyNameList (GetCustomEquipPropertyNameList))
  (filterAndModifyBlockPropertyByBox customEquipPropertyNameList "filterAndModifyEquipmentPropertyBox" "CustomEquip")
)

; the macro for modify data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

; Unit Test Compeleted
(defun GetNumberedListByStartAndLengthUtils (startString startNumer listLength / numberedList)
  (setq startNumer (atoi startNumer))
  (setq numberedList (GetIncreasedNumberStringListUtils startNumer listLength))
  (mapcar '(lambda (x) (strcat startString x)) numberedList)
)

; Unit Test Compeleted
(defun GetIncreasedNumberListUtils (startNumer listLength / numberedList)
  (repeat listLength 
    (setq numberedList (append numberedList (list startNumer)))
    (setq startNumer (+ startNumer 1))
  )
  numberedList
)

; Unit Test Compeleted
(defun GetIncreasedNumberStringListUtils (startNumer listLength / minIncreasedNumberList maxIncreasedNumberList resultList) 
  (setq minIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (< x 10)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (setq maxIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (>= x 10)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (append (mapcar '(lambda (x) (strcat "0" (rtos x))) minIncreasedNumberList) 
    (mapcar '(lambda (x) (rtos x)) maxIncreasedNumberList)
  )
)

(defun GetNeedToNumberPropertyName (dataType / needToNumberPropertyNameList dataTypeList)
  (setq dataTypeList '("Pipe" "Instrument" "InstrumentP" "InstrumentL" "InstrumentSIS" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip"))
  (setq needToNumberPropertyNameList '("PIPENUM" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG" "TAG"))
  (GetDictValueByKeyUtils dataType dataTypeList needToNumberPropertyNameList)
)

(defun testDoubleClick (index /)
  (alert index)(princ)
)

(defun filterAndModifyBlockPropertyByBox (propertyNameList tileName dataType / dcl_id propertyName propertyValue filterPropertyName patternValue replacedSubstring status selectedName selectedFilterName ss sslen matchedList importedList confirmList blockDataList entityNameList viewPropertyName previewDataList importedDataList exportMsgBtnStatus importMsgBtnStatus modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    (action_tile "btnShowOriginData" "(done_dialog 4)")
    (action_tile "btnPreviewModify" "(done_dialog 5)")
    (action_tile "btnModify" "(done_dialog 6)")
    (action_tile "btnExportData" "(done_dialog 7)")
    (action_tile "btnImportData" "(done_dialog 8)")
    
    ; optional setting for the popup_list tile
    (set_tile "filterPropertyName" "0")
    (set_tile "propertyName" "0")
    (set_tile "viewPropertyName" "0")
    ; the default value of input box
    (set_tile "patternValue" "")
    (set_tile "replacedValue" "")
    (set_tile "propertyValue" "")
    (mode_tile "propertyName" 2)
    (mode_tile "viewPropertyName" 2)
    (mode_tile "filterPropertyName" 2)
    ;(mode_tile "matchedResult" 2)
    (action_tile "propertyName" "(setq propertyName $value)")
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "filterPropertyName" "(setq filterPropertyName $value)")
    (action_tile "viewPropertyName" "(setq viewPropertyName $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ;(action_tile "matchedResult" "(testDoubleClick $value)")
    
    (progn
      (start_list "filterPropertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (start_list "viewPropertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (start_list "propertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (set_tile "dataTypeMsg" (GetDataTypeMsgStrategy dataType))
    )
    ; init the default data of text
    (if (= nil propertyName)
      (setq propertyName "0")
    )
    (if (= nil filterPropertyName)
      (setq filterPropertyName "0")
    )
    (if (= nil viewPropertyName)
      (setq viewPropertyName "0")
    )
    (if (or (= nil patternValue) (= "" patternValue))
      (setq patternValue "*")
    )
    (if (= nil replacedSubstring)
      (setq replacedSubstring "")
    )
    (if (= nil propertyValue)
      (setq propertyValue "")
    )
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "修改CAD数据状态：已完成")
    )
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (set_tile "filterPropertyName" filterPropertyName)
        (set_tile "propertyName" propertyName)
        (set_tile "viewPropertyName" viewPropertyName)
        (set_tile "patternValue" patternValue)
        (set_tile "replacedSubstring" replacedSubstring)
        (set_tile "propertyValue" propertyValue)
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        (end_list)
      )
    )
    (if (/= importedList nil)
      (progn
        (start_list "originData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 importedList)
        (end_list)
      )
    )
    (if (/= confirmList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 confirmList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq ss (GetBlockSSBySelectByDataTypeUtils dataType))
        (setq selectedFilterName (nth (atoi filterPropertyName) propertyNameList))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss selectedFilterName patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq ss (GetAllBlockSSByDataTypeUtils dataType))
        (setq selectedFilterName (nth (atoi filterPropertyName) propertyNameList))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss selectedFilterName patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
      )
    )
    ; view button
    (if (= 4 status)
      (progn 
        (setq selectedName (nth (atoi viewPropertyName) propertyNameList))
        (if (/= importedDataList nil) 
          (setq importedList (GetImportedPropertyValueByPropertyName importedDataList selectedName dataType))
          (setq importedList (GetImportedPropertyValueByPropertyName previewDataList selectedName dataType))
        )
      )
    )
    ; confirm button
    (if (= 5 status)
      (progn 
        (setq selectedName (nth (atoi propertyName) propertyNameList))
        (if (or (/= propertyValue "") (/= replacedSubstring "")) 
          (progn 
            (if (= replacedSubstring "") 
              (if (/= importedDataList nil) 
                (progn 
                  ; update importedDataList
                  (setq importedDataList (ReplaceAllStrDataListByPropertyName importedDataList selectedName propertyValue dataType))
                  (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName dataType))
                )
                (progn 
                  ; update previewDataList
                  (setq previewDataList (ReplaceAllStrDataListByPropertyName previewDataList selectedName propertyValue dataType))
                  (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName dataType))
                )
              )
              (if (/= importedDataList nil) 
                (progn 
                  ; update importedDataList
                  (setq importedDataList (ReplaceSubStrDataListByPropertyName importedDataList selectedName propertyValue replacedSubstring dataType))
                  (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName dataType))
                )
                (progn 
                  ; update previewDataList
                  (setq previewDataList (ReplaceSubStrDataListByPropertyName previewDataList selectedName propertyValue replacedSubstring dataType))
                  (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName dataType))
                )
              )
            )
          )
          (if (/= importedDataList nil) 
            (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName dataType))
            (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName dataType))
          )
        )
      )
    )
    ; modify button
    (if (= 6 status)
      (progn 
        (if (/= importedDataList nil) 
          (ModifyPropertyValueByEntityHandleUtils importedDataList (GetPropertyNameListStrategy dataType))
          (ModifyPropertyValueByEntityHandleUtils previewDataList (GetPropertyNameListStrategy dataType))
        )
        (setq modifyMsgBtnStatus 1)
      )
    )
    ; export data button
    (if (= 7 status)
      (progn 
        (if (/= matchedList nil)
          (progn 
            (WriteDataToCSVByEntityNameListStrategy entityNameList dataType)
            (setq exportMsgBtnStatus 1)
          )
        )
      )
    )
    ; import data button
    (if (= 8 status)
      (progn 
        (if (= exportMsgBtnStatus 1)
          (progn 
            (setq importedDataList (StrListToListListUtils (ReadDataFromCSVStrategy dataType)))
            (setq importMsgBtnStatus 1)
          )
        )
      )
    )
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun GetImportedPropertyValueByPropertyName (importedDataList propertyName dataType / resultList)
  (foreach item importedDataList 
    (setq resultList (append resultList (list (nth (GetImportedDataListIndexByPropertyName propertyName dataType) item))))
  )
  resultList
)

(defun GetImportedDataListIndexByPropertyName (propertyName dataType / propertyNameList importedDataListIndex resultList)
  (if (= dataType "Pipe") 
    (progn 
      (setq propertyNameList (GetPipePropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9))
    )
  )
  (if (= dataType "Instrument") 
    (progn 
      (setq propertyNameList (GetInstrumentPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17))
    )
  )
  (if (= dataType "Reactor") 
    (progn 
      (setq propertyNameList (GetReactorPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
    )
  )
  (if (= dataType "Tank") 
    (progn 
      (setq propertyNameList (GetTankPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18))
    )
  )
  (if (= dataType "Heater") 
    (progn 
      (setq propertyNameList (GetHeaterPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14))
    )
  )
  (if (= dataType "Pump") 
    (progn 
      (setq propertyNameList (GetPumpPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
    )
  )
  (if (= dataType "Vacuum") 
    (progn 
      (setq propertyNameList (GetVacuumPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 16))
    )
  )
  (if (= dataType "Centrifuge") 
    (progn 
      (setq propertyNameList (GetCentrifugePropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
    )
  )
  (if (= dataType "CustomEquip") 
    (progn 
      (setq propertyNameList (GetCustomEquipPropertyNameList))
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
    )
  )
  (setq resultList (GetDictValueByKeyUtils propertyName propertyNameList importedDataListIndex))
)

(defun ReplaceAllStrDataListByPropertyName (importedDataList propertyName propertyValue dataType / resultDataList)
  (foreach item importedDataList 
    (setq resultDataList (append resultDataList (list (ReplaceListItemByindexUtils 
                                                propertyValue 
                                                (GetImportedDataListIndexByPropertyName propertyName dataType) 
                                                item
                                              ))))
  )
  resultDataList
)

(defun ReplaceSubStrDataListByPropertyName (importedDataList propertyName propertyValue replacedSubstring dataType / resultDataList)
  (foreach item importedDataList 
    (setq resultDataList (append resultDataList (list (ReplaceListItemByindexUtils 
                                                (StringSubstUtils propertyValue replacedSubstring (nth (GetImportedDataListIndexByPropertyName propertyName dataType) item)) 
                                                (GetImportedDataListIndexByPropertyName propertyName dataType) 
                                                item
                                              ))))
  )
  resultDataList
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; function for modify data

(defun GetAPropertyListAndEntityNameListByPropertyNamePattern (ss selectedName patternValue / i ent blk entx propertyName aPropertyValueList entityNameList)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (setq aPropertyValueList '())
      (setq entityNameList '())
      (repeat (sslength ss)
        (if (/= nil (ssname ss i))
          (progn
	          ; get the entity information of the i(th) block
            (setq ent (entget (ssname ss i)))
	          ; save the entity name of the i(th) block
            (setq blk (ssname ss i))
	          ; get the property information
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq propertyName (cdr (assoc 2 entx)))
              (if (= propertyName selectedName)
                (if (wcmatch (cdr (assoc 1 entx)) patternValue) 
                  (progn 
                    (setq aPropertyValueList (append aPropertyValueList (list (cdr (assoc 1 entx)))))
                    ; the key is listing the blk
                    (setq entityNameList (append entityNameList (list blk)))
                  )
                )
              )
	            ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
      )
    )
  )
  (list aPropertyValueList entityNameList)
)

(defun GetInstrumentPropertyDataListByFunctionPattern (ss patternValue / i ent blk entx propertyName aPropertyValueList entityNameList)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (setq instrumentFunctionList '())
      (setq instrumentTagList '())
      (setq entityNameList '())
      (repeat (sslength ss)
        (if (/= nil (ssname ss i))
          (progn
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq propertyName (cdr (assoc 2 entx)))
              (if (= propertyName "FUNCTION")
                (if (wcmatch (cdr (assoc 1 entx)) patternValue) 
                  (progn 
                    (setq instrumentFunctionList (append instrumentFunctionList (list (cdr (assoc 1 entx)))))
                    ; the key is listing the blk
                    (setq entityNameList (append entityNameList (list blk)))
                  )
                )
              )
              (if (= propertyName "TAG")
                (setq instrumentTagList (append instrumentTagList (list (cdr (assoc 1 entx)))))
              )
	            ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
      )
    )
  )
  (setq aPropertyValueList (SpliceElementInTwoListUtils instrumentFunctionList instrumentTagList))
  (list aPropertyValueList entityNameList)
)

(defun GetOnePropertyValueListByEntityNameList (entityNameList selectedName / onePropertyValueList) 
  (setq selectedName (strcase selectedName T))
  (mapcar '(lambda (x) 
             (setq onePropertyValueList (append onePropertyValueList 
                                          (list (cdr (assoc selectedName (GetAllPropertyValueByEntityName x))))
                                        )
             )
           ) 
    entityNameList
  )
  onePropertyValueList
)

(defun GetAllPropertyValueByEntityName (entityName / entityData entx propertyValueList)
  (setq entityData (entget entityName))
  ; get the property information
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyValueList (append propertyValueList 
                              (list (cons (strcase (cdr (assoc 2 entx)) T) (cdr (assoc 1 entx))))
                            )
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  (cons (cons "entityhandle" (cdr (assoc 5 entityData))) propertyValueList)
)

(defun GetAllPropertyValueListByEntityNameList (entityNameList / resultList)
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetAllPropertyValueByEntityName x))))
           ) 
    entityNameList
  )
  resultList
)

; function for modify data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Number Pipeline, Instrument and Equipment

(defun c:numberPipelineAndTag (/ dataTypeList)
  (setq dataTypeList '("Pipe" "Instrument" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip"))
  (numberPipelineAndTagByBox dataTypeList "filterAndNumberBox" "Pipe")
)

(defun numberPipelineAndTagByBox (propertyNameList tileName dataType / dcl_id propertyValue filterPropertyName patternValue replacedSubstring status selectedName selectedFilterName selectedDataType ss sslen matchedList previewList confirmList blockDataList APropertyValueList entityNameList modifyMessageStatus dataChildrenType modifyMsgBtnStatus numberedList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    (action_tile "btnPreviewModify" "(done_dialog 5)")
    (action_tile "btnModify" "(done_dialog 6)")
    (action_tile "btnClickSelect" "(done_dialog 4)")
    ; optional setting for the popup_list tile
    (set_tile "filterPropertyName" "0")
    (set_tile "dataChildrenType" "0")
    ; the default value of input box
    (set_tile "patternValue" "")
    (set_tile "replacedValue" "")
    (set_tile "propertyValue" "")
    (mode_tile "filterPropertyName" 2)
    (mode_tile "dataChildrenType" 2)
    (action_tile "filterPropertyName" "(setq filterPropertyName $value)")
    (action_tile "dataChildrenType" "(setq dataChildrenType $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ; init the default data of text
    (if (= nil filterPropertyName)
      (setq filterPropertyName "0")
    )
    (if (= nil dataChildrenType)
      (setq dataChildrenType "0")
    )
    (if (= nil patternValue)
      (setq patternValue "*")
    )
    (if (= nil propertyValue)
      (setq propertyValue "")
    )
    (if (= nil replacedSubstring)
      (setq replacedSubstring "")
    )
    (set_tile "filterPropertyName" filterPropertyName)
    (set_tile "dataChildrenType" dataChildrenType)
    (set_tile "patternValue" patternValue)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (/= selectedDataType nil)
      (set_tile "filterPropertyName" filterPropertyName)
    )
    
    (if (= modifyMessageStatus 0)
      (set_tile "resultMsg" "请先预览修改")
    )
    
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (set_tile "replacedSubstring" replacedSubstring)
        (set_tile "propertyValue" propertyValue)
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        ;(add_list matchedList)
        (end_list)
      )
    )
    (if (/= confirmList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 confirmList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq selectedDataType (nth (atoi filterPropertyName) propertyNameList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        ; sort by x cordinate
        (setq ss (SortSelectionSetByXYZ ss))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq APropertyValueList (GetPropertyDictListByEntityNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueList APropertyValueList selectedDataType dataChildrenType))
        (setq sslen (length matchedList))
        ;(princ APropertyValueList)(princ)
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq selectedDataType (nth (atoi filterPropertyName) propertyNameList))
        (setq selectedFilterName (GetNeedToNumberPropertyName selectedDataType))
        (setq ss (GetAllBlockSSByDataTypeUtils selectedDataType))
        (if (= selectedDataType "Pipe") 
          (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
          (progn 
            (if (= selectedDataType "Instrument") 
              (setq blockDataList (GetInstrumentFunctionTagByType dataChildrenType ss))
              (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "TAG" "*"))
            )
          )
        )
        (setq APropertyValueList (car blockDataList))
        (setq entityNameList (car (cdr blockDataList)))
        (setq matchedList APropertyValueList)
        (setq sslen (length APropertyValueList))
      )
    )
    ; click select button
    (if (= 4 status)
      (progn 
        (setq selectedDataType (nth (atoi filterPropertyName) propertyNameList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq APropertyValueList (GetPropertyDictListByEntityNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueList APropertyValueList selectedDataType dataChildrenType))
        (setq sslen (length matchedList))
      )
    )
    ; confirm button
    (if (= 5 status)
      (progn 
        (setq numberedList (GetNumberedListByStartAndLengthUtils replacedSubstring propertyValue (length matchedList)))
        (setq confirmList (ReplaceNumberOfListByNumberedListUtils numberedList matchedList))
      )
    )
    ; modify button
    (if (= 6 status)
      (progn 
        (if (= confirmList nil)
          (setq modifyMessageStatus 0)
          (progn 
            (setq selectedName (GetNeedToNumberPropertyName selectedDataType))
            (mapcar '(lambda (x y) 
                      (ModifyMultiplePropertyForOneBlockUtils x (list selectedName) (list y))
                    ) 
              entityNameList
              confirmList      
            )
          )
        )
        (setq modifyMsgBtnStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun numberedPropertyNameListStrategy (dataType /)
  (cond 
    ((= dataType "Pipe") '("PIPENUM"))
    ((= dataType "Instrument") '("FUNCTION" "TAG"))
    ((= dataType "Reactor") '("TAG"))
    ((= dataType "Pump") '("TAG"))
    ((= dataType "Tank") '("TAG"))
    ((= dataType "Heater") '("TAG"))
    ((= dataType "Centrifuge") '("TAG"))
    ((= dataType "CustomEquip") '("TAG"))
  )
)

(defun GetNumberedPropertyValueList (dictList dataType dataChildrenType /) 
  (if (= dataType "Instrument") 
    (progn 
      (setq dictList (GetInstrumentChildrenTypeList dictList dataType dataChildrenType))
      (mapcar '(lambda (x) 
                (strcat (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x)) 
                  (cdr (assoc (nth 1 (numberedPropertyNameListStrategy dataType)) x))
                )
              ) 
        dictList
      ) 
    )
    (mapcar '(lambda (x) 
              (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x))
            ) 
      dictList
    ) 
  )
)

(defun GetInstrumentChildrenTypeList (dictList dataType dataChildrenType /)
  (vl-remove-if-not '(lambda (x) 
                       (wcmatch (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x)) 
                                (instrumentFunctionMatchStrategy dataChildrenType)
                       ) 
                     ) 
    dictList
  )
)

(defun GetInstrumentFunctionTagByType (dataChildrenType ss / blockDataList)
  (if (= dataChildrenType "0") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "T[~CV]*"))
  )
  (if (= dataChildrenType "1") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "P[~CV]*"))
  )
  (if (= dataChildrenType "2") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "L[~CV]*"))
  )
  (if (= dataChildrenType "3") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "F[~CV]*"))
  )
  (if (= dataChildrenType "4") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "W[~CV]*"))
  )
  (if (= dataChildrenType "5") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "A[~CV]*"))
  )
  (if (= dataChildrenType "6") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "XV*"))
  )
  (if (= dataChildrenType "7") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "T[CV]*"))
  )
  (if (= dataChildrenType "8") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "P[CV]*"))
  )
  (if (= dataChildrenType "9") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "L[CV]*"))
  )
  (if (= dataChildrenType "10") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "F[CV]*"))
  )
  blockDataList
)

(defun instrumentFunctionMatchStrategy (dataChildrenType /)
  (cond 
    ((= dataChildrenType "0") "T[~CV]*")
    ((= dataChildrenType "1") "P[~CV]*")
    ((= dataChildrenType "2") "L[~CV]*")
    ((= dataChildrenType "3") "F[~CV]*")
    ((= dataChildrenType "4") "W[~CV]*")
    ((= dataChildrenType "5") "A[~CV]*")
    ((= dataChildrenType "6") "XV*")
    ((= dataChildrenType "7") "T[CV]*")
    ((= dataChildrenType "8") "P[CV]*")
    ((= dataChildrenType "9") "L[CV]*")
    ((= dataChildrenType "10") "F[CV]*")
  )
)

; Number Pipeline, Instrument and Equipment
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Number DrawNum

(defun c:numberDrawNum () 
  (NumberDrawNumByBox "numberDrawNumBox")
)

(defun NumberDrawNumByBox (tileName / dcl_id propertyValue replacedSubstring status ss sslen previewList 
                           confirmList entityNameList modifyMsgBtnStatus numMsgStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnPreviewModify" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    (action_tile "btnBrushDrawNum" "(done_dialog 5)")
    ; the default value of input box
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ; init the default data of text
    (if (= nil propertyValue)
      (setq propertyValue "")
    )
    (if (= nil replacedSubstring)
      (setq replacedSubstring "")
    )
    (set_tile "propertyValue" propertyValue)
    (set_tile "replacedSubstring" replacedSubstring)
    ; Display the number of selected pipes
    (if (= modifyMsgBtnStatus 0)
      (set_tile "msg" (strcat "匹配到的数量：" (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (= modifyMsgBtnStatus 2)
      (set_tile "modifyBtnMsg" "刷数据所在图号已完成")
    )
    (if (= numMsgStatus 1)
      (set_tile "msg" (strcat "所刷数据的数量：" (rtos sslen)))
    )
    (if (/= previewList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 previewList)
        (end_list)
      )
    )
    (if (/= confirmList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 confirmList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq ss (GetBlockSSBySelectByDataTypeUtils "DrawLabel"))
        ; sort by x cordinate
        (setq entityNameList (GetEntityNameListByXPositionSortedUtils ss))
        (setq previewList (GetDrawNumList entityNameList))
        (setq sslen (length previewList))
        (setq modifyMsgBtnStatus 0)
      )
    )
    ; confirm button
    (if (= 3 status)
      (setq confirmList (GetNumberedListByStartAndLengthUtils replacedSubstring propertyValue (length previewList)))
    )
    ; modify button
    (if (= 4 status)
      (progn 
        (ModifyDrawNum entityNameList confirmList)
        (setq modifyMsgBtnStatus 1)
        (setq previewList nil confirmList nil)
      )
    )
    ; brush drawnum button
    (if (= 5 status)
      (progn 
        (setq sslen (BrushDrawNum))
        (setq modifyMsgBtnStatus 2)
        (setq numMsgStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun ModifyDrawNum (entityNameList drawNumList /)
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x (list "DwgNo") (list y))
          ) 
    entityNameList
    drawNumList      
  )
)

(defun GetDrawNumList (entityNameList / drawNumList)
  (mapcar '(lambda (x) 
             (setq drawNumList 
                (append drawNumList (list (cdr (assoc "dwgno" (GetAllPropertyValueByEntityName x)))))
             )
           ) 
    entityNameList
  )
  DrawNumList 
)

(defun BrushDrawNum (/ drawNum dataSS entityNameList)
  (prompt "\n选择图签：")
  (setq drawNum 
    (car (GetDrawNumList (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "DrawLabel"))))
  )
  (prompt (strcat "\n所选择的图号：" drawNum))
  (prompt "\n选择要刷的数据（管道、仪表、设备）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetAllDataSSBySelectUtils)))
  (ModifyDrawNumForData entityNameList drawNum)
  (prompt "\n刷数据所在图号完成！")
  (length entityNameList)
)

(defun ModifyDrawNumForData (entityNameList drawNum /)
  (if (/= drawNum "") 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "DRAWNUM") (list drawNum))
            ) 
      entityNameList
    )
  )
)

; Number DrawNum
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;