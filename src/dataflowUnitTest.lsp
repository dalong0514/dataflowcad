;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

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
  (GetNumberedListByFirstDashUtilsTest)
  (RegExpExecuteUtilsTest)
  (RegExpReplaceTest)
  (DeduplicateForListUtilsTest)
  (GetTempExportedDataTypeByindexTest)
  (GetGsCleanAirCodeNameListTest)
  (IsKsLocationOnPipeTest)
  (IsKsLocationOnEquipTest)
  (GetPipeLineByPipeNumTest)
  (RemoveDecimalForStringUtilsTest)
  (ExtractGsPipeClassUtilsTest)
  (GetDottedPairValueUtilsTest)
  (ExtractGsPipeDiameterUtilsTest)
  (FilterListByTestMemberUtilsTest)
  (FilterListByTestNotMemberUtilsTest)
  (ExtractEquipVolumeNumUtilsTest)
  (ExtractEquipDiameterStringUtilsTest)
  (GetGsBzEquipTypeTest)
  (DL:PrintTestResults (DL:CountBooleans *testList*))
)

; 2021-03-13
(defun GetGsBzEquipTypeTest () 
  (AssertEqual 'GetGsBzEquipType (list "GsBzTank-V300D600LS") "V300D600LS")
  (AssertEqual 'GetGsBzEquipType (list "V1000D1000LS") "V1000D1000LS")
  (AssertEqual 'GetGsBzEquipType (list "") "")
)

; 2021-03-12
(defun ExtractEquipDiameterStringUtilsTest () 
  (AssertEqual 'ExtractEquipDiameterStringUtils (list "φ700X1000（H）") "700")
  (AssertEqual 'ExtractEquipDiameterStringUtils (list "φ400x600") "400")
)

; 2021-03-11
(defun ExtractEquipVolumeNumUtilsTest () 
  (AssertEqual 'ExtractEquipVolumeNumUtils (list "500L") 500)
  (AssertEqual 'ExtractEquipVolumeNumUtils (list "1000") 1000)
)

; 2021-03-11
(defun FilterListByTestNotMemberUtilsTest (/ dataList) 
  (AssertEqual 'FilterListByTestNotMemberUtils 
    (list (list "R1101" "R1102" "E1103") (list "R1101" "R1102" "V1103")) 
    (list "E1103"))
  (AssertEqual 'FilterListByTestNotMemberUtils 
    (list (list "R1101" "R1102" "P1102" "P1103" "E1103") (list "R1101" "R1102" "V1103" "P1102")) 
    (list "P1103" "E1103")) 
)

; 2021-03-11
(defun FilterListByTestMemberUtilsTest (/ dataList) 
  (AssertEqual 'FilterListByTestMemberUtils 
    (list (list "R1101" "R1102" "E1103") (list "R1101" "R1102" "V1103")) 
    (list "R1101" "R1102"))
  (AssertEqual 'FilterListByTestMemberUtils 
    (list (list "R1101" "R1102" "P1102" "P1103" "E1103") (list "R1101" "R1102" "V1103" "P1102")) 
    (list "R1101" "R1102" "P1102")) 
)

; 2021-03-08
(defun GetDottedPairValueUtilsTest (/ dataList) 
  (setq dataList 
    (list (cons "substance" "methane") (cons "pipenum" "JC2101-80-2A1"))
  )
  (AssertEqual 'GetDottedPairValueUtils (list "pipenum" dataList) "JC2101-80-2A1")
)

; 2021-03-08
(defun ExtractGsPipeDiameterUtilsTest () 
  (AssertEqual 'ExtractGsPipeDiameterUtils (list "PL1101-50-2J1") "50")
  (AssertEqual 'ExtractGsPipeDiameterUtils (list "JC2101-80-2A1-H5") "80")
)

; 2021-03-08
(defun ExtractGsPipeClassUtilsTest () 
  (AssertEqual 'ExtractGsPipeClassUtils (list "PL1101-50-2J1") "2J1")
  (AssertEqual 'ExtractGsPipeClassUtils (list "JC2101-80-2A1-H5") "2A1")
)

; 2021-02-03
(defun RemoveDecimalForStringUtilsTest () 
  (AssertEqual 'RemoveDecimalForStringUtils (list "65.00") "65")
  (AssertEqual 'RemoveDecimalForStringUtils (list "100.0000") "100")
)

; 2021-01-25
(defun GetPipeLineByPipeNumTest () 
  (AssertEqual 'GetPipeLineByPipeNum (list "PL1101-50-2J1") "PL1101")
  (AssertEqual 'GetPipeLineByPipeNum (list "PL1102") "PL1102")
  (AssertEqual 'GetPipeLineByPipeNum (list "RWRa23108-25-2A5") "RWRa23108")
)

; 2021-01-25
(defun IsKsLocationOnEquipTest () 
  (AssertEqual 'IsKsLocationOnEquip (list "PL1101-50-2J1") nil)
  (AssertEqual 'IsKsLocationOnEquip (list "R23101") T)
  (AssertEqual 'IsKsLocationOnEquip (list "氮气总管") nil)
)

; 2021-01-25
(defun IsKsLocationOnPipeTest () 
  (AssertEqual 'IsKsLocationOnPipe (list "PL1101-50-2J1") T)
  (AssertEqual 'IsKsLocationOnPipe (list "PL1101-50-2J1-H5") T)
  (AssertEqual 'IsKsLocationOnPipe (list "PL1101-100-2J11") T)
  (AssertEqual 'IsKsLocationOnPipe (list "R23101") nil)
)

(defun GetGsCleanAirCodeNameListTest ()
  (AssertEqual 'GetGsCleanAirCodeNameList 
    (list '("C01" "2D01")) 
    '("C" "2D") 
  )
)

(defun GetTempExportedDataTypeByindexTest ()
  (AssertEqual 'GetTempExportedDataTypeByindex (list "0") "Pipe")
  (AssertEqual 'GetTempExportedDataTypeByindex (list "2") "Equipment")
)

(defun DeduplicateForListUtilsTest ()
  (AssertEqual 'DeduplicateForListUtils 
    (list '("aa" "bb" "cc" "aa" "cc"))
    '("aa" "bb" "cc")
  )
)

;; RegExpReplaceUtils
;; Returns the string after replacing matches with the pattern
;;
;; Arguments
;; string     : String in which the pattern is searched.
;; pattern    : Pattern to search.
;; newStr     : replacement string.
;; pattern    : Pattern to search.
;; ignoreCase : If non nil, the search is done ignoring the case.
;; global     : If non nil, search all occurences of the pattern;
;;              if nil, only searches the first occurence.
;;
;; Examples :
;; (RegexpReplace "fsoo bar baz" "a" "oo" nil T)                  ; => "fsoo boor booz"
;; (RegexpReplace "fsoo bar baz" "(\\w)\\w(\\w)" "$1_$2" nil T)   ; => "f_o b_r b_z"
;; (RegexpReplace "$ 3.25" "\\$ (\\d+(\\.\\d+)?)" "$1 �" nil T)  ; => "3.25 �"
; similar using with php regular replace - 2020-11-15
(defun RegExpReplaceTest ()
  (AssertEqual 'RegExpReplace 
    (list "fsoo dalong baz" "a" "oo" nil T)
    "fsoo doolong booz"
  )
  (AssertEqual 'RegExpReplace 
    (list "fos bar baz" "(\\w)\\w(\\w)" "$1_$2" nil T)
    "f_s b_r b_z"
  )
  (AssertEqual 'RegExpReplace 
    (list "$ 3.25" "\\$ (\\d+(\\.\\d+)?)" "$1 �" nil T)
    "3.25 �"
  )
  (AssertEqual 'RegExpReplace 
    (list "PL1201-50-2J1" "([A-Z]+)\\d*-.*" "$1" nil nil)
    "PL"
  ) 
  (AssertEqual 'RegExpReplace 
    (list "VT-50-2J1" "([A-Z]+)\\d*-.*" "$1" nil nil)
    "VT"
  )  
)

;; RegExpExecuteUtils
;; Returns the list of matches with the pattern found in the string.
;; Each match is returned as a sub-list containing:
;; - the match value
;; - the index of the first character (0 based)
;; - a list of sub-groups.
;;
;; Arguments
;; string     : String in which the pattern is searched.
;; pattern    : Pattern to search.
;; ignoreCase : If non nil, the search is done ignoring the case.
;; global     : If non nil, search all occurences of the pattern;
;;              if nil, only searches the first occurence.
(defun RegExpExecuteUtilsTest ()
  (AssertEqual 'RegExpExecuteUtils 
    (list "fsoo dalong baz" "da" nil nil)
    (list '("da" 5 nil))
  )
  (AssertEqual 'RegExpExecuteUtils 
    (list "12B 4bis" "([0-9]+)([A-Z]+)" T T)
    (list (list "12B" 0 '("12" "B")) (list "4bis" 4 '("4" "bis")))
  )
  (AssertEqual 'RegExpExecuteUtils 
    (list "-12 25.4" "(-?\\d+(?:\\.\\d+)?)" T T)
    (list (list "-12" 0 '("-12")) (list "25.4" 4 '("25.4")))
  )
)

(defun GetNumberedListByFirstDashUtilsTest ()
  (AssertEqual 'GetNumberedListByFirstDashUtils 
    (list '("PL1201" "PL1202") '("YC-50-2J1" "YC-50-2J1"))
    '("PL1201-50-2J1" "PL1202-50-2J1")
  )
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
  (AssertEqual 'MoveInsertPositionUtils (list '(1 1 0) 10 20) '(11 21 0))
  (AssertEqual 'MoveInsertPositionUtils (list '(10 10 0) -15 -20) '(-5 -10 0))
  (AssertEqual 'MoveInsertPositionUtils (list '(1.5 3.6 0) -5 -2) '(-3.5 1.6 0))
)

(defun GetInsertPtListTest ()
  (AssertEqual 'GetInsertPtListByXMoveUtils (list '(1 1 1) '(0 1 2 3 4) 10) 
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
  (AssertEqual 'ExtractDrawNumUtils '("S20101GS-101-04-04") "04-04")
  (AssertEqual 'ExtractDrawNumUtils '("") "无图号")
)

(defun GetInsertPtTest () 
  (AssertEqual 'GetInsertPt (list '(100 100 0) 1 10) '(110 100 0))
)

(defun GenerateSortedNumByListTest ()
  (AssertEqual 'GenerateSortedNumByList (list '("13" "134" "456") 0) '(0 1 2))
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
  (AssertEqual 'StringSubstUtils '("" "'" "''2E10") "2E10")
  (AssertEqual 'StringSubstUtils '("" "'" "2E10") "2E10")
  (AssertEqual 'StringSubstUtils '("" " " "R1101 ") "R1101")
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
          (setq actualReturn nil))
      (T
        (princ "failed...(")
        (setq passed nil)
        (setq actualReturn 
            (strcat (vl-princ-to-string actualReturn) " instead of ")))
  )
  ;; continue printing result...
  (princ (strcase (vl-symbol-name functionName) T))
  (princ " ")
  (princ 
      (DL:ReplaceAllSubst 
          "'"
          "(QUOTE " 
          (vl-prin1-to-string argumentList)))
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
(defun DL:PrintTestResults (testResults / trues falses)
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