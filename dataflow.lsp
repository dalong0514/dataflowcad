;��������� 2020 ��
(princ "\n������һ�廯�����ߣ��������л�궫�����ס����������������½ܣ��汾��V-1.1")
(vl-load-com)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo (/ versionInfo)
  (setq versionInfo "���°汾�� V1.1������ʱ�䣺2020-11-04")
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
  (DL:PrintTestResults (DL:CountBooleans *testList*))
)

(defun SpliceElementInTwoListUtilsTest ()
  (AssertEqual 'SpliceElementInTwoListUtils 
    (list '("PL" "YC" "EC") '("1101" "1102" "1103")) 
    '("PL1101" "YC1102" "EC1103")
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
    (setq dataTypeMsg "�����޸Ĺܵ�����")
  )
  (if (= dataType "Instrument") 
    (setq dataTypeMsg "�����޸��Ǳ�����")
  )
  (if (= dataType "Reactor") 
    (setq dataTypeMsg "�����޸ķ�Ӧ������")
  )
  (if (= dataType "Tank") 
    (setq dataTypeMsg "�����޸Ĵ�������")
  )
  (if (= dataType "Heater") 
    (setq dataTypeMsg "�����޸Ļ���������")
  )
  (if (= dataType "Pump") 
    (setq dataTypeMsg "�����޸����ͱ�����")
  )
  (if (= dataType "Vacuum") 
    (setq dataTypeMsg "�����޸���ձ�����")
  )
  (if (= dataType "Centrifuge") 
    (setq dataTypeMsg "�����޸����Ļ�����")
  )
  (if (= dataType "CustomEquip") 
    (setq dataTypeMsg "�����޸��Զ����豸����")
  )
  ; must give the return
  dataTypeMsg
)

(defun GetPropertyNameListStrategy (dataType / propertyNameList)
  (if (= dataType "Pipe") 
    (setq propertyNameList (GetPipePropertyNameList))
  )
  (if (= dataType "PublicPipe") 
    (setq propertyNameList (GetPublicPipePropertyNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
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
  '("�ܵ����" "��������" "�����¶�" "����ѹ��" "��̬" "�ܵ����" "�ܵ��յ�" "����ͼ��" "���²���")
)

(defun GetPublicPipePropertyNameList ()
  '("PIPENUM" "FROM" "TO" "DRAWNUM")
)

(defun GetPublicPipePropertyChNameList ()
  '("�ܵ����" "�ܵ����" "�ܵ��յ�" "����ͼ��")
)

(defun GetInstrumentPropertyNameList ()
  '("FUNCTION" "TAG" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION")
)

(defun GetInstrumentPropertyChNameList ()
  '("�Ǳ��ܴ���" "�Ǳ�λ��" "��������" "�����¶�" "����ѹ��" "�Ǳ�����" "��̬" "����λ�ò���" "���Ƶ�����" "���ڹܵ����豸" "��Сֵ" "���ֵ" "����ֵ" "����ͼ��" "����λ�óߴ�" "��ע" "��װ����")
)

(defun GetReactorPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SPEED" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "EXTEMP" "EXPRESSURE")
)

(defun GetReactorPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "�豸���" "��������" "�����¶�" "����ѹ��" "�������" "����Ƿ����" "�������" "��Ӧ��ת��" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "�����¶�" "����ѹ��")
)

(defun GetTankPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "EXTEMP" "EXPRESSURE")
)

(defun GetTankPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "�豸���" "��������" "�����¶�" "����ѹ��" "�������" "����Ƿ����" "�������" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "�����¶�" "����ѹ��")
)

(defun GetHeaterPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "AREA" "SIZE" "ELEMENT" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER")
)

(defun GetHeaterPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�������" "�豸�ߴ�" "����Ԫ�����" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����")
)

(defun GetPumpPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "FLOW" "HEAD" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "NUMBER" "TYPE")
)

(defun GetPumpPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "����" "���" "�������" "����Ƿ����" "�������" "�豸����" "�豸����" "�豸����" "�豸�ͺ�")
)

(defun GetVacuumPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "CAPACITY" "EXPRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "NUMBER")
)

(defun GetVacuumPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "������" "����ѹ��" "�������" "����Ƿ����" "�������" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "�豸����")
)

(defun GetCentrifugePropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "VOLUME" "CAPACITY" "DIAMETER" "SPEED" "FACTOR" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "TYPE" "NUMBER")
)

(defun GetCentrifugePropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�豸���" "װ������" "ת��ֱ��" "ת��ת��" "����������" "�豸�ߴ�" "�������" "����Ƿ����" "�������" "�豸����" "�豸����" "�豸�ͺ�" "�豸����")
)

(defun GetCustomEquipPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "PARAM1" "PARAM2" "PARAM3" "PARAM4" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER")
)

(defun GetCustomEquipPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�豸�ߴ�" "�������" "����Ƿ����" "�������" "�ؼ�����1" "�ؼ�����2" "�ؼ�����3" "�ؼ�����4" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����")
)

(defun GetInstrumentPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("FUNCTION" "function")
                            ("TAG" "tag")
                            ("HALARM" "halarm")
                            ("LALARM" "lalarm")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("SORT" "sort")
                            ("PHASE" "phase")
                            ("MATERIAL" "material")
                            ("NAME" "name")
                            ("LOCATION" "location")
                            ("MIN" "minvalue")
                            ("MAX" "maxvalue")
                            ("NOMAL" "nomal")
                            ("DRAWNUM" "drawnum")
                            ("COMMENT" "comment")
                            ("INSTALLSIZE" "installsize")
                           ))
)

(defun GetPipePropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("PIPENUM" "pipenum")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("PHASE" "phase")
                            ("FROM" "from")
                            ("TO" "to")
                            ("DRAWNUM" "drawnum")
                           ))
)

(defun GetOuterPipePropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("PIPENUM" "pipenum")
                            ("FROMTO" "fromto")
                            ("DRAWNUM" "drawnum")
                            ("DESIGNFLOW" "designflow")
                            ("OPERATESPEC" "operatespec")
                            ("INSULATION" "insulation")
                           ))
)

(defun GetCentrifugeEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("VOLUME" "volumn")
                            ("CAPACITY" "capacity")
                            ("DIAMETER" "diameter")
                            ("SPEED" "speed")
                            ("FACTOR" "factor")
                            ("SIZE" "size")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                           ))
)

(defun GetHeaterEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("AREA" "area")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("SIZE" "size")
                            ("ELEMENT" "element")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                            ("INSULATIONTHICK" "insulationthick")
                           ))
)

(defun GetTankEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("VOLUME" "volumn")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("SIZE" "size")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                            ("INSULATIONTHICK" "insulationthick")
                            ("NUMBER" "number")
                            ("EXTEMP" "extemp")
                           ))
)

(defun GetPumpEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("FLOW" "flow")
                            ("HEAD" "head")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("NUMBER" "number")
                           ))
)

(defun GetVacuumEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("CAPACITY" "capacity")
                            ("EXPRESSURE" "expressure")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("SIZE" "size")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                           ))
)

(defun GetReactorEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("VOLUME" "volumn")
                            ("SPECIES" "first_spec")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("SIZE" "size")
                            ("SPEED" "speed")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                            ("INSULATIONTHICK" "insulationthick")
                            ("NUMBER" "number")
                            ("EXTEMP" "extemp")
                           ))
)

(defun GetCustomEquipPropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("TAG" "tag")
                            ("NAME" "name")
                            ("SPECIES" "first_spec")
                            ("SUBSTANCE" "substance")
                            ("TEMP" "temp")
                            ("PRESSURE" "pressure")
                            ("POWER" "power")
                            ("ANTIEXPLOSIVE" "is_antiexplosive")
                            ("MOTORSERIES" "motorseries")
                            ("PARAM1" "param1")
                            ("PARAM2" "param2")
                            ("PARAM3" "param3")
                            ("PARAM4" "param4")
                            ("SIZE" "size")
                            ("MATERIAL" "material")
                            ("WEIGHT" "weight")
                            ("TYPE" "type")
                            ("INSULATIONTHICK" "insulationthick")
                           ))
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
  (vlax-invoke-method obj 'savetofile file 2);1-create��2-rewrite
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
  ; Update the object��s entity data list 
  (entmod entityData)
  ; Refresh the object on-screen
  (entupd entityName)
  ; Return the new entity data list
  entityData
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

(defun GetBlockSSBySelectByDataTypeUtils (dataType / ss)
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
  (if (= dataType "InstrumentL")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentL"))))
  )
  (if (= dataType "InstrumentP")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentP"))))
  )
  (if (= dataType "InstrumentSIS")
    (setq ss (ssget '((0 . "INSERT") (2 . "InstrumentSIS"))))
  )
  (if (= dataType "Equipment")
    (setq ss (GetEquipmentSSBySelectUtils))
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
  ss
)

(defun GetAllBlockSSByDataTypeUtils (dataType / ss)
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
  (if (= dataType "InstrumentL")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentL"))))
  )
  (if (= dataType "InstrumentP")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentP"))))
  )
  (if (= dataType "InstrumentSIS")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentSIS"))))
  )
  (if (= dataType "Equipment")
    (setq ss (GetAllEquipmentSSUtils))
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

(defun GetEntityHandleListByEntityNameListUtils (entityNameList / entityHandleList i)
  (setq entityHandleList '())
  (foreach item entityNameList
    (setq entityHandleList (append entityHandleList (list (cdr (assoc 5 (entget item))))))
  )
  entityHandleList
)

(defun GetCSVPropertyStringByEntityName (entityName propertyNameList / ent entx propertyName csvPropertyString)
  (setq csvPropertyString "")
  (setq ent (entget entityName))
  (setq entx (entget (entnext (cdr (assoc -1 ent)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (foreach item propertyNameList 
      (if (= propertyName item) 
        (setq csvPropertyString (strcat csvPropertyString (cdr (assoc 1 entx)) ","))
      )
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  ; add the handle to the start of the csvPropertyString
  ; add "'" at the start of handle to prevent being converted by excel - 20201020
  (setq csvPropertyString (strcat "'" (cdr (assoc 5 ent)) "," csvPropertyString ))
)

(defun GetPropertyValueListByEntityName (entityName propertyNameList / ent entx propertyName csvPropertyString resultList)
  (setq ent (entget entityName))
  (setq entx (entget (entnext (cdr (assoc -1 ent)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyName (cdr (assoc 2 entx)))
    (foreach item propertyNameList 
      (if (= propertyName item) 
        (setq resultList (append resultList (list (cdr (assoc 1 entx)))))
      )
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  ; add the handle to the start of the csvPropertyString
  (setq resultList (cons (cdr (assoc 5 ent)) resultList))
)

(defun GetPropertyValueListListByEntityNameList (entityNameList propertyNameList / resultList)
  (foreach item entityNameList 
    (setq resultList (append resultList (list (GetPropertyValueListByEntityName item propertyNameList))))
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

(defun SetDXFValueByEntityDataUtils (entityData DXFcode propertyValue / oldValue newValue)
  (setq oldValue (assoc DXFcode entityData))
  (setq newValue (cons DXFcode propertyValue))
  (entmod (subst newValue oldValue entityData))
)

; Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Read and Write Utils
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
  (setq firstRow "����ID,�ܵ����,��������,�����¶�,����ѹ��,��̬,�ܵ����,�ܵ��յ�,����ͼ��,���²���,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPipePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteInstrumentDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  (setq firstRow "����ID,�Ǳ��ܴ���,�Ǳ�λ��,��������,�����¶�,����ѹ��,�Ǳ�����,��̬,����λ�ò���,���Ƶ�����,���ڹܵ����豸,��Сֵ,���ֵ,����ֵ,����ͼ��,����λ�óߴ�,��ע,��װ����,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetInstrumentPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteReactorDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,�豸���,��������,�����¶�,����ѹ��,�������,����Ƿ����,�������,��Ӧ��ת��,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,�����¶�,����ѹ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetReactorPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteTankDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,�豸���,��������,�����¶�,����ѹ��,�������,����Ƿ����,�������,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,�����¶�,����ѹ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetTankPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteHeaterDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�������,�豸�ߴ�,����Ԫ�����,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetHeaterPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WritePumpDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,����,���,�������,����Ƿ����,�������,�豸����,�豸����,�豸����,�豸�ͺ�,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPumpPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteVacuumDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,������,����ѹ��,�������,����Ƿ����,�������,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,�豸����,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetVacuumPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteCentrifugeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�豸���,װ������,ת��ֱ��,ת��ת��,����������,�豸�ߴ�,�������,����Ƿ����,�������,�豸����,�豸����,�豸�ͺ�,�豸����,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCentrifugePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList)
)

(defun WriteCustomEquipDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\equipmentData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�豸�ߴ�,�������,����Ƿ����,�������,�ؼ�����1,�ؼ�����2,�ؼ�����3,�ؼ�����4,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,")
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
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "�ļ�������Ϊ��")
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

(defun c:exportBlockPropertyData (/ dataTypeList)
  (setq dataTypeList '("Pipe" "Equipment" "Instrument" "Electric" "OuterPipe"))
  (ExportBlockProperty dataTypeList)
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
    (ExportElectricData fileName)
  )
  (if (= dataType "OuterPipe") 
    (ExportOuterPipeData fileName)
  )
)

(defun GetExportDataFileDir (fileName / currentDir fileDir)
  (setq currentDir (getvar "dwgprefix"))
  (setq fileDir (strcat currentDir fileName ".txt"))
)

(defun ExportPipeData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  ; do not know why f can not be a arg of the GsExtractGs2InstrumentToText - 20201011
  ; f should be the global variable - 20201021
  (setq f (open fileDir "w"))
  (ExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

(defun ExportEquipmentData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  (setq f (open fileDir "w"))
  (ExtractEquipToText)
  (close f)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

(defun ExportInstrumentData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  (setq f (open fileDir "w"))
  (ExtractInstrumentToText)
  (ExtractPipeToText)
  (ExtractEquipToText)
  (close f)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

(defun ExportElectricData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  (setq f (open fileDir "w"))
  (ExtractElectricEquipToText)
  (close f)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

(defun ExportOuterPipeData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  (setq f (open fileDir "w"))
  (ExtractOuterPipeToText)
  (ExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fileDir "gb2312" "utf-8")
)

; the macro for extract data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; function for extract block property to text

(defun ExtractInstrumentToText ()
  (ExtractInstrumentPToText)
  (ExtractInstrumentLToText)
  (ExtractInstrumentSISToText)
)

(defun ExtractInstrumentPToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentP"))))
  (setq propertyPairNameList (GetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "concentrated"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractInstrumentLToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentL"))))
  (setq propertyPairNameList (GetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "location"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractInstrumentSISToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentSIS"))))
  (setq propertyPairNameList (GetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "sis"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractPipeToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (GetAllPipeSSUtils))
  (setq propertyPairNameList (GetPipePropertyPairNameList))
  (setq lastPropertyPair '("INSULATION" "insulation"))
  (setq classValuePair '("class" "pipeline"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractOuterPipeToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (GetAllOuterPipeSSUtils))
  (setq propertyPairNameList (GetOuterPipePropertyPairNameList))
  (setq lastPropertyPair '("PROTECTION" "protection"))
  (setq classValuePair '("class" "outerpipe"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractEquipToText ()
  (ExtractCentrifugeEquipToText)
  (ExtractHeaterEquipToText)
  (ExtractTankEquipToText)
  (ExtractPumpEquipToText)
  (ExtractVacuumEquipToText)
  (ExtractReactorEquipToText)
  (ExtractCustomEquipToText)
)

(defun ExtractElectricEquipToText ()
  (ExtractCentrifugeEquipToText)
  (ExtractPumpEquipToText)
  (ExtractVacuumEquipToText)
  (ExtractReactorEquipToText)
  ; ready to require
  ;(ExtractCustomEquipToText)
)

(defun ExtractCentrifugeEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Centrifuge"))))
  (setq propertyPairNameList (GetCentrifugeEquipPropertyPairNameList))
  (setq lastPropertyPair '("NUMBER" "number"))
  (setq classValuePair '("class" "centrifuge"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractHeaterEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Heater"))))
  (setq propertyPairNameList (GetHeaterEquipPropertyPairNameList))
  (setq lastPropertyPair '("NUMBER" "number"))
  (setq classValuePair '("class" "heater"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractTankEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Tank"))))
  (setq propertyPairNameList (GetTankEquipPropertyPairNameList))
  (setq lastPropertyPair '("EXPRESSURE" "expressure"))
  (setq classValuePair '("class" "tank"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractPumpEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Pump"))))
  (setq propertyPairNameList (GetPumpEquipPropertyPairNameList))
  (setq lastPropertyPair '("TYPE" "type"))
  (setq classValuePair '("class" "pump"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractVacuumEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Vacuum"))))
  (setq propertyPairNameList (GetVacuumEquipPropertyPairNameList))
  (setq lastPropertyPair '("NUMBER" "number"))
  (setq classValuePair '("class" "vacuum"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractReactorEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Reactor"))))
  (setq propertyPairNameList (GetReactorEquipPropertyPairNameList))
  (setq lastPropertyPair '("EXPRESSURE" "expressure"))
  (setq classValuePair '("class" "reactor"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun ExtractCustomEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "CustomEquip"))))
  (setq propertyPairNameList (GetCustomEquipPropertyPairNameList))
  (setq lastPropertyPair '("NUMBER" "number"))
  (setq classValuePair '("class" "custom"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
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
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "�ܵ����") (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 3.0) (cons 1 textContent) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "Standard") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GenerateEquipTagText (insPt textContent /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "�豸λ��") (cons 100 "AcDbText") 
                  (cons 10 '(0.0 0.0 0.0)) (cons 11 insPt) (cons 40 3.0) (cons 1 textContent) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "Standard") (cons 71 0) (cons 72 1) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
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
    )
  )
  (if (= blockName "PublicPipeElementW") 
    (progn 
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -0.85 6.3) (nth 1 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt -3.5 -11.5) (nth 2 textDataList))
      (GenerateTextByPositionAndContent (MoveInsertPosition insPt 1.21 -11.5) (nth 4 textDataList))
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
  (setq insPt (getpoint "\nѡȡ���������������㣺"))
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
(defun ExtractDrawNum (str /)
  (substr str (- (strlen str) 4))
)

(defun c:EquipTag (/ ss equipInfoList insPt insPtList)
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\nѡȡ�豸λ�ŵĲ���㣺"))
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
; logic for brushBlockPropertyValue

(defun c:brushStartEndForPipe (/ startData endData entityNameList)
  (prompt "\nѡ��ܵ���㣺")
  (setq startData (GetPipeStartOrEndData))
  (prompt "\nѡ��ܵ��յ㣺")
  (setq endData (GetPipeStartOrEndData))
  (prompt "\nѡ��Ҫˢ�Ĺܵ���")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList startData endData)
  (princ)
)

(defun ModifyStartEndForPipes (entityNameList startData endData /)
  (mapcar '(lambda (x) 
             (ModifyOnePropertyForOneBlockUtils x "FROM" startData)
             (ModifyOnePropertyForOneBlockUtils x "TO" endData)
           ) 
    entityNameList
  )
)

(defun GetPipeStartOrEndDataList (dataSS /)
  (GetAllPropertyValueByEntityName 
    (car (GetEntityNameListBySSUtils dataSS))
  )
)

(defun GetPipeStartOrEndData (/ dataSS dataList result)
  (setq dataSS (GetEquipmentAndPipeSSBySelectUtils))
  (if (/= dataSS nil) 
    (progn 
      (setq dataList (GetPipeStartOrEndDataList dataSS))
      (if (/= (cdr (assoc "tag" dataList)) nil) 
        (setq result (cdr (assoc "tag" dataList)))
      )
      (if (/= (cdr (assoc "pipenum" dataList)) nil) 
        (setq result (cdr (assoc "pipenum" dataList)))
      )
    )
    (setq result (getstring "\n������Ҫ�Լ�������ݣ�ֱ�ӿո�Ĭ��Ϊ���ַ�����"))
  )
  result
)

(defun c:brushBlockPropertyValue ()
  (brushBlockPropertyValueByBox "brushBlockPropertyValueBox" "Pipe")
)

(defun brushBlockPropertyValueByBox (tileName dataType / dcl_id pipeSourceDirection patternValue status ss sslen matchedList blockDataList entityNameList previewDataList)
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
                '("��������" "�����¶�" "����ѹ��" "����ͼ��"))
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
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
        (setq previewDataList (GetPropertyValueListListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (princ pipeSourceDirection)(princ)
      )
    )
  )
  (setq matchedList nil)
  (unload_dialog dcl_id)
  (princ)
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
                '("���ܹ�" "ȥ�ܹ�"))
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
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
        (setq previewDataList (GetPropertyValueListListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
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
        (setq previewDataList (GetPropertyValueListListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
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

(defun GetNumberedListByStartAndLengthUtils (startNumer startString listLength / numberedList)
  (setq numberedList '())
  (setq startNumer (atoi startNumer))
  (setq listLength (- listLength 1))
  (setq numberedList (append numberedList (list (strcat startString (rtos startNumer)))))
  (repeat listLength 
    (setq startNumer (+ startNumer 1))
    (setq numberedList (append numberedList (list (strcat startString (rtos startNumer)))))
  )
  numberedList
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "��������״̬�������")
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "�޸�CAD����״̬�������")
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
        (setq previewDataList (GetPropertyValueListListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
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
        (setq previewDataList (GetPropertyValueListListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
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
          (ModifyPropertyValueByEntityHandle importedDataList (GetPropertyNameListStrategy dataType))
          (ModifyPropertyValueByEntityHandle previewDataList (GetPropertyNameListStrategy dataType))
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
      (setq importedDataListIndex '(1 2 3 4 5 6 7 8 9 10 11 12 13 14))
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
  propertyValueList
)

(defun ModifyPropertyValueByEntityName (entityNameList selectedName propertyValue / i ent blk entx propertyName)
  (setq i 0)
  (repeat (length entityNameList)
    ; get the entity information of the i(th) block
    (setq ent (entget (nth i entityNameList)))
    ; save the entity name of the i(th) block
    (setq blk (nth i entityNameList))
    ; get the property information
    (setq entx (entget (entnext (cdr (assoc -1 ent)))))
    (while (= "ATTRIB" (cdr (assoc 0 entx)))
      (setq propertyName (cdr (assoc 2 entx)))
      (if (= propertyName selectedName)
        (SwitchPropertyValueFromStringOrList propertyValue entx i)
      )
      ; get the next property information
      (setq entx (entget (entnext (cdr (assoc -1 entx)))))
    )
    (entupd blk)
    (setq i (+ 1 i))
  )
)

(defun ModifyPropertyValueByEntityHandle (importedDataList propertyNameList / entityHandleList entityNameList i index ent blk entx propertyName)
  (foreach item importedDataList 
    (setq entityHandleList (append entityHandleList (list (car item))))
  )
  (foreach item entityHandleList 
    (setq entityNameList (append entityNameList (list (handent item))))
  )
  (setq i 0)
  (repeat (length entityNameList)
    ; get the entity information of the i(th) block
    (setq ent (entget (nth i entityNameList)))
    ; save the entity name of the i(th) block
    (setq blk (nth i entityNameList))
    ; get the property information
    (setq entx (entget (entnext (cdr (assoc -1 ent)))))
    (while (= "ATTRIB" (cdr (assoc 0 entx)))
      (setq propertyName (cdr (assoc 2 entx)))

      (setq index 0)
      (repeat (length propertyNameList) 
        (if (= propertyName (nth index propertyNameList))
          (SwitchPropertyValueFromStringOrList (nth (+ 1 index) (nth i importedDataList)) entx i)
        )
        (setq index (+ 1 index))
      )
      ; get the next property information
      (setq entx (entget (entnext (cdr (assoc -1 entx)))))
    )
    (entupd blk)
    (setq i (+ 1 i))
  )
)

(defun SwitchPropertyValueFromStringOrList (propertyValue entx i / oldValue newValue)
  (setq oldValue (assoc 1 entx))
  (if (= (type propertyValue) 'list)
    (setq newValue (cons 1 (nth i propertyValue)))
    (setq newValue (cons 1 propertyValue))
  )
  (entmod (subst newValue oldValue entx))
)

; function for modify data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Number Pipeline, Instrument and Equipment

(defun c:numberPipelineAndTag (/ dataTypeList)
  (setq dataTypeList '("Pipe" "InstrumentP" "InstrumentL" "InstrumentSIS" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip"))
  (numberPipelineAndTagByBox dataTypeList "filterAndNumberBox" "Pipe")
)

(defun numberPipelineAndTagByBox (propertyNameList tileName dataType / dcl_id propertyValue filterPropertyName patternValue replacedSubstring status selectedName selectedFilterName selectedDataType ss sslen matchedList previewList confirmList blockDataList APropertyValueList entityNameList modifyMessageStatus dataChildrenType modifyMsgBtnStatus)
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "���״̬�������")
    )
    (if (/= selectedDataType nil)
      (set_tile "filterPropertyName" filterPropertyName)
    )
    
    (if (= modifyMessageStatus 0)
      (set_tile "resultMsg" "����Ԥ���޸�")
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
        (setq selectedFilterName (GetNeedToNumberPropertyName selectedDataType))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        ; sort by x cordinate
        (setq ss (SortSelectionSetByXYZ ss))
        (if (= selectedDataType "Pipe") 
          (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
          (progn 
            (if (or (= selectedDataType "InstrumentP") (= selectedDataType "InstrumentL") (= selectedDataType "InstrumentSIS")) 
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
    ; all select button
    (if (= 3 status)
      (progn 
        (setq selectedDataType (nth (atoi filterPropertyName) propertyNameList))
        (setq selectedFilterName (GetNeedToNumberPropertyName selectedDataType))
        (setq ss (GetAllBlockSSByDataTypeUtils selectedDataType))
        (if (= selectedDataType "Pipe") 
          (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
          (progn 
            (if (or (= selectedDataType "InstrumentP") (= selectedDataType "InstrumentL") (= selectedDataType "InstrumentSIS")) 
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
    ; confirm button
    (if (= 5 status)
      (progn 
        (setq selectedName (GetNeedToNumberPropertyName selectedDataType))
        (setq previewList (GetOnePropertyValueListByEntityNameList entityNameList selectedName))
        (setq numberedList (GetNumberedListByStartAndLengthUtils propertyValue replacedSubstring (length previewList)))
        (setq confirmList (ReplaceNumberOfListByNumberedListUtils numberedList previewList))
      )
    )
    ; modify button
    (if (= 6 status)
      (progn 
        (if (= confirmList nil)
          (setq modifyMessageStatus 0)
          (progn 
            (setq selectedName (GetNeedToNumberPropertyName selectedDataType))
            (ModifyPropertyValueByEntityName entityNameList selectedName confirmList)
          )
        )
        (setq modifyMsgBtnStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
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

; Number Pipeline, Instrument and Equipment
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;