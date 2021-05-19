;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

; 2021-04-22
(defun GetVerifyDataFromServer (/ fileDir)
  (setq fileDir "\\\\192.168.1.38\\dataflow\\system-data\\verifydata.txt")
  ; (setq fileDir "\\\\MEDICINE--DC\\dataflow\\system-data\\verifydata.txt")
  (if (/= (type (vl-catch-all-apply 'ReadDataFromFileUtils (list fileDir))) 'VL-CATCH-ALL-APPLY-ERROR) 
    (mapcar '(lambda (x) (atoi x)) (ReadDataFromFileUtils fileDir))
    ; offline - set the verify date 20210601
    '(20210501 20210615)
  ) 
)

; 2021-04-09
(if (= *dataflowDate* nil) 
  (setq *dataflowDate* (fix (getvar "cdate"))) 
)

; 2021-04-09
; very importance for me, convert a function to the parameter for another function
(defun ExecuteFunctionAfterVerifyDateUtils (functionName argumentList / result)
  (if (and (> *dataflowDate* (car (GetVerifyDataFromServer))) (< *dataflowDate* (cadr (GetVerifyDataFromServer))) )
    (progn 
      (setq result (vl-catch-all-apply functionName argumentList))
      (if (= (type result) 'VL-CATCH-ALL-APPLY-ERROR) 
        (vl-catch-all-error-message result)
      )
    )
    (alert "用户未注册，请于管理员联系！")
  ) 
)

; 2021-04-20
(defun c:RemoveEducation () 
  (ExecuteFunctionAfterVerifyDateUtils 'RemoveEducationMacro '())
  (alert "去教育版成功，请保存文件！")
)

; 2021-04-20
(defun RemoveEducationMacro ()
  (arxload "D:\\dataflowcad\\remove-education.arx")
  ; (command "_.qsave")
)

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

; 2021-03-06 source from [2019116AutoCAD-Platform-Customization0203.md]
; Custom implementation of expanding variables in AutoLISP 
; To use: 
; 1. Define a variable with the setq function. 
; 2. Add the variable name with % symbols on both sides of the variable name. 
; For example, the variable named *program* would appear as %*program*% in the string. 
; 3. Use the function on the string that contains the variable. 
; Example
;| 
; Define a global variable and string to expand 
(setq *program* (getvar "PROGRAM") str2expand "PI=%PI% Program=%*program*%" ) 
; Execute the custom function to expand the variables defined in the string 
(InlineExpandVariableUtils str2expand) 
|; 
(defun InlineExpandVariableUtils (string / start_pos next_pos var2expand expand_var) 
  (while (wcmatch string "*%*%*") 
         (progn 
          (setq start_pos (1+ (vl-string-search "%" string))) 
          (setq next_pos (vl-string-search "%" string start_pos)) 
          (setq var2expand (substr string start_pos (- (+ next_pos 2) start_pos))) 
          (setq expand_var (vl-princ-to-string (eval (read (vl-string-trim "%" var2expand))))) 
          (if (/= expand_var nil) 
            (setq string (vl-string-subst expand_var var2expand string)) 
          ) 
         ) 
  ) 
  string 
) 

; 2021-03-28
(defun JsonToListUtils (json / data newData inStr dPrev strPos)
  ; Converts json string to list. By Denon Deterding (VL2 - 20200924)
  ; NOTE: json object strings will be truncated to 2300 characters MAX ('read' function limitation)
  ; ----- (the 'json' input variable is NOT limited to the 2300 chr limit)
  ; json - string, as json data
  ; returns - list, of data from json
  (setq data (vl-string->list json))
  (foreach d data
    (cond
      ;if we're in a string, test length and continue
      (inStr
        (if (or (setq inStr (and (= 34 d) (/= 92 dPrev)))
                (<= strPos 2300)) ;[--- MAX string length is 2300 characters ---]
          (setq strPos (1+ strPos) newData (cons d newData))
        );if
        (setq instr (not inStr))
      );cond 1
      ;this signals that we're starting a string
      ((= 34 d)
        (setq inStr t strPos 1 newData (cons d newData))
      );cond 2
      ;replacing relevant characters Outside of json object strings
      ((member d '(44 58 91 93 123 125)) ; ("," ":" "[" "]" "{" "}")
        (foreach n (cond
                     ((= 44 d) '(41 32 40))             ; ") ("
                     ((= 58 d) '(32))                   ; " "
                     ((or (= 91 d) (= 123 d)) '(40 40)) ; "(("
                     ((or (= 93 d) (= 125 d)) '(41 41)) ; "))"
                   );cond
          (setq newData (cons n newData))
        );foreach
      );cond 3
      ;these will signal a "true" value
      ((or (= 116 d) (= 84 d)) ; ("t" "T")
        (setq newData (cons 116 newData)) ; "t"
      );cond 4
      ;these will signal a "null" or "false" value (both are nil in lisp)
      ((or (= 110 d) (= 102 d) (= 78 d) (= 70 d)) ; ("n" "f" "N" "F")
        (foreach n '(110 105 108) (setq newData (cons n newData))) ; "nil"
      );cond 5
      ;this handles numbers.. real/int, pos/neg
      ((member d '(45 46 48 49 50 51 52 53 54 55 56 57)) ; ("-" "." "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
        (setq newData (cons d newData))
      );cond 6
    );cond
    (setq dPrev d)
  );foreach
  (read (vl-list->string (reverse newData)))
)

(defun GetSelectedEntityDataUtils (ss /)
  (mapcar '(lambda (x) (entget x)) 
    (GetEntityNameListBySSUtils ss)
  )
)

; 2021-03-08
(defun GetDottedPairValueUtils (keyName dataList /)
  (cdr (assoc keyName dataList))
)

; refactored at 2021-03-08
(defun GetOneEntityDataUtils ()
  ;(entget (car (entsel)))
  (car (GetSelectedEntityDataUtils (ssget)))
)

(defun GetBlockNameBySelectUtils (/ entityName) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "INSERT"))))))
  (cdr (assoc 2 (entget entityName)))
)

; Returns the value of the specified DXF group code for the supplied entity name
(defun GetDXFValueUtils (entityName DXFcode /)
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

(defun GetAllDataSSUtils (/ ss)
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

(defun GetAllDataSSBySelectUtils (/ ss)
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

(defun GetAllInstrumentPipeEquipSSUtils (/ ss)
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
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentPipeEquipSSBySelectUtils (/ ss)
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
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllInstrumentAndEquipSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
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
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentAndEquipSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
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
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllInstrumentAndPipeSSUtils (/ ss)
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

(defun GetAllPublicPipeLineSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PublicPipeUpPipeLine")
          (2 . "PublicPipeDownPipeLine")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentAndPipeSSBySelectUtils (/ ss)
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

(defun GetInstrumentAndPipeAndPipeClassChangeSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
          (2 . "PipeClassChange")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetInstrumentAndPipeAndReducerSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "InstrumentP")
          (2 . "InstrumentL")
          (2 . "InstrumentSIS")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
          (2 . "Reducer")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllEquipmentAndPipeSSUtils (/ ss)
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

(defun GetEquipmentAndPipeSSBySelectUtils (/ ss)
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

(defun GetAllInstrumentSSUtils (/ ss)
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

(defun GetInstrumentSSBySelectUtils (/ ss)
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

(defun GetAllEquipmentSSUtils (/ ss)
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

(defun GetEquipmentSSBySelectUtils (/ ss)
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

(defun GetAllPipeSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetPipeSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PipeArrowLeft")
          (2 . "PipeArrowUp")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllOuterPipeSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetOuterPipeSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "OuterPipeRight")
          (2 . "OuterPipeLeft")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetAllJoinDrawArrowSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "JoinDrawArrowTo")
          (2 . "JoinDrawArrowFrom")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetJoinDrawArrowSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "JoinDrawArrowTo")
          (2 . "JoinDrawArrowFrom")
        (-4 . "OR>")
      )
    )
  )
)

; refactored at 2021-05-13
(defun GetAllDrawLabelSSUtils (/ ss)
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "title.2017")
          (2 . "title")
          (2 . "TITLE_20170")
          (2 . "title.equip.2017")
        (-4 . "OR>")
      )
    )
  )
)

; refactored at 2021-05-13
(defun GetDrawLabelSSBySelectUtils (/ ss)
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "title.2017")
          (2 . "title")
          (2 . "TITLE_20170")
          (2 . "title.equip.2017")
        (-4 . "OR>")
      )
    )
  )
)

; 2021-03-22
(defun GetAllKsInstallMaterialSSUtils () 
  (ssget "X" '((0 . "INSERT") (2 . "KsInstallMaterial")))
)

; 2021-03-22
(defun GetKsInstallMaterialSSBySelectUtils () 
  (ssget '((0 . "INSERT") (2 . "KsInstallMaterial")))
)

; 2021-03-16
(defun GetTextSSBySelectUtils ()
  (ssget '((0 . "TEXT")))
)

; 2021-03-16
(defun GetAllTextSSBySelectUtils ()
  (ssget "X" '((0 . "TEXT")))
)

; 2021-03-16
(defun GetTextSSByLayerBySelectUtils (layerName / ss)
  (setq ss (ssget (list (cons 0 "TEXT") (cons 8 layerName))))
)

; 2021-02-02
(defun GetAllRawFireFightVPipeSSUtilsV1 ()
  (ssget "X" '((0 . "ARC") (8 . "VPIPE-消防")))
)

; 2021-02-0
(defun GetAllRawFireFightVPipeSSUtils ()
  (ssget "X" '((0 . "TCH_PIPE") (8 . "VPIPE-消防")))
)

; 2021-02-02
(defun GetRawFireFightVPipeSSBySelectUtils ()
  (ssget '((0 . "TCH_PIPE") (8 . "VPIPE-消防")))
)

; 2021-02-02
(defun GetAllFireFightVPipeSSUtils ()
  (ssget "X" '((0 . "INSERT") (2 . "FireFightHPipe")))
)

; 2021-02-02
(defun GetFireFightVPipeSSBySelectUtils ()
  (ssget '((0 . "INSERT") (2 . "FireFightHPipe")))
)

; refactored at 2021-04-15
(defun GetBlockSSBySelectByDataTypeUtils (dataType / ss) 
  (cond 
    ((= dataType "AllDataType") (GetAllDataSSBySelectUtils))
    ((= dataType "Pipe") (GetPipeSSBySelectUtils))
    ((= dataType "Instrument") (GetInstrumentSSBySelectUtils))
    ((= dataType "InstrumentAndEquipmentAndPipe") (GetInstrumentPipeEquipSSBySelectUtils))
    ((= dataType "InstrumentAndPipe") (GetInstrumentAndPipeSSBySelectUtils))
    ((= dataType "InstrumentAndEquipment") (GetInstrumentAndEquipSSBySelectUtils))
    ((= dataType "EquipmentAndPipe") (GetEquipmentAndPipeSSBySelectUtils))
    ((= dataType "OuterPipe") (GetOuterPipeSSBySelectUtils))
    ((= dataType "JoinDrawArrow") (GetAllJoinDrawArrowSSUtils))
    ((= dataType "Equipment") (GetEquipmentSSBySelectUtils))
    ((= dataType "Electric") (GetEquipmentSSBySelectUtils))
    ((= dataType "JoinDrawArrow") (GetJoinDrawArrowSSBySelectUtils))
    ((= dataType "DrawLabel") (GetDrawLabelSSBySelectUtils))
    ((= dataType "InstrumentAndPipeAndPipeClassChange") (GetInstrumentAndPipeAndPipeClassChangeSSBySelectUtils))
    ((= dataType "InstrumentAndPipeAndReducer") (GetInstrumentAndPipeAndReducerSSBySelectUtils))
    ((= dataType "InstrumentL") (ssget '((0 . "INSERT") (2 . "InstrumentL"))))
    ((= dataType "InstrumentP") (ssget '((0 . "INSERT") (2 . "InstrumentP"))))
    ((= dataType "InstrumentSIS") (ssget '((0 . "INSERT") (2 . "InstrumentSIS"))))
    ((= dataType "Centrifuge") (ssget '((0 . "INSERT") (2 . "Centrifuge"))))
    ((= dataType "Heater") (ssget '((0 . "INSERT") (2 . "Heater"))))
    ((= dataType "Tank") (ssget '((0 . "INSERT") (2 . "Tank"))))
    ((= dataType "Pump") (ssget '((0 . "INSERT") (2 . "Pump"))))
    ((= dataType "Vacuum") (ssget '((0 . "INSERT") (2 . "Vacuum"))))
    ((= dataType "Reactor") (ssget '((0 . "INSERT") (2 . "Reactor"))))
    ((= dataType "CustomEquip") (ssget '((0 . "INSERT") (2 . "CustomEquip"))))
    ((= dataType "JoinDrawArrowTo") (ssget '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
    ((= dataType "JoinDrawArrowFrom") (ssget '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
    ((= dataType "PublicPipeUpArrow") (ssget '((0 . "INSERT") (2 . "PublicPipeUpArrow")))) 
    ((= dataType "PublicPipeDownArrow") (ssget '((0 . "INSERT") (2 . "PublicPipeDownArrow"))))
    ((= dataType "GsCleanAir") (ssget '((0 . "INSERT") (2 . "GsCleanAir"))))
    ((= dataType "PipeClassChange") (ssget '((0 . "INSERT") (2 . "PipeClassChange"))))
    ((= dataType "Reducer") (ssget '((0 . "INSERT") (2 . "Reducer"))))
    ((= dataType "FireFightHPipe") (ssget '((0 . "INSERT") (2 . "FireFightHPipe")))) 
    ((= dataType "GsBzEquip") (ssget '((0 . "INSERT") (2 . "GsBz*"))))
    ((= dataType "EquipTag") (ssget '((0 . "INSERT") (2 . "EquipTag"))))
  ) 
)

; refactored at 2021-03-24
(defun GetAllBlockSSByDataTypeUtils (dataType /) 
  (cond 
    ((= dataType "AllDataType") (GetAllDataSSUtils))
    ((= dataType "Pipe") (GetAllPipeSSUtils))
    ((= dataType "Instrument") (GetAllInstrumentSSUtils))
    ((= dataType "InstrumentAndEquipmentAndPipe") (GetAllInstrumentPipeEquipSSUtils))
    ((= dataType "InstrumentAndPipe") (GetAllInstrumentAndPipeSSUtils))
    ((= dataType "InstrumentAndEquipment") (GetAllInstrumentAndEquipSSUtils))
    ((= dataType "EquipmentAndPipe") (GetAllEquipmentAndPipeSSUtils))
    ((= dataType "OuterPipe") (GetAllOuterPipeSSUtils))
    ((= dataType "JoinDrawArrow") (GetAllJoinDrawArrowSSUtils))
    ((= dataType "Equipment") (GetAllEquipmentSSUtils))
    ((= dataType "Electric") (GetAllEquipmentSSUtils))
    ((= dataType "PublicPipeLine") (GetAllPublicPipeLineSSUtils))
    ((= dataType "DrawLabel") (GetAllDrawLabelSSUtils))
    ((= dataType "InstrumentL") (ssget "X" '((0 . "INSERT") (2 . "InstrumentL"))))
    ((= dataType "InstrumentP") (ssget "X" '((0 . "INSERT") (2 . "InstrumentP"))))
    ((= dataType "InstrumentSIS") (ssget "X" '((0 . "INSERT") (2 . "InstrumentSIS"))))
    ((= dataType "Centrifuge") (ssget "X" '((0 . "INSERT") (2 . "Centrifuge"))))
    ((= dataType "Heater") (ssget "X" '((0 . "INSERT") (2 . "Heater"))))
    ((= dataType "Tank") (ssget "X" '((0 . "INSERT") (2 . "Tank"))))
    ((= dataType "Pump") (ssget "X" '((0 . "INSERT") (2 . "Pump"))))
    ((= dataType "Vacuum") (ssget "X" '((0 . "INSERT") (2 . "Vacuum"))))
    ((= dataType "Reactor") (ssget "X" '((0 . "INSERT") (2 . "Reactor"))))
    ((= dataType "CustomEquip") (ssget "X" '((0 . "INSERT") (2 . "CustomEquip"))))
    ((= dataType "JoinDrawArrowTo") (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
    ((= dataType "JoinDrawArrowFrom") (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
    ((= dataType "PublicPipeUpArrow") (ssget "X" '((0 . "INSERT") (2 . "PublicPipeUpArrow")))) 
    ((= dataType "PublicPipeDownArrow") (ssget "X" '((0 . "INSERT") (2 . "PublicPipeDownArrow"))))
    ((= dataType "GsCleanAir") (ssget "X" '((0 . "INSERT") (2 . "GsCleanAir"))))
    ((= dataType "PipeClassChange") (ssget "X" '((0 . "INSERT") (2 . "PipeClassChange"))))
    ((= dataType "Reducer") (ssget "X" '((0 . "INSERT") (2 . "Reducer"))))
    ((= dataType "FireFightPipe") (ssget "X" '((0 . "INSERT") (2 . "FireFightHPipe")))) 
    ((= dataType "GsBzEquip") (ssget "X" '((0 . "INSERT") (2 . "GsBz*"))))
    ((= dataType "EquipTag") (ssget "X" '((0 . "INSERT") (2 . "EquipTag")))) 
  )
)

; 2021-04-18
(defun GetLineSSBySelectUtils () 
  (ssget '((0 . "LINE")))
)

; 2021-05-13
(defun GetAllLineSSUtils ()
  (ssget "X" '((0 . "LINE")))
)

; 2021-05-13
(defun GetPloyLineSSBySelectUtils () 
  (ssget '((0 . "LWPOLYLINE")))
)

; 2021-05-13
(defun GetAllPloyLineESSUtils ()
  (ssget "X" '((0 . "LWPOLYLINE")))
)

; 2021-05-13
(defun GetAllLineAndPloyLineSSUtils (/ ss)
  (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LWPOLYLINE")
          (0 . "LINE")
        (-4 . "OR>")
      )
  )
)

; 2021-05-13
(defun GetAllTextAndPloyLineSSUtils (/ ss)
  (ssget "X" '( 
        (-4 . "<OR")
          (0 . "TEXT")
          (0 . "LWPOLYLINE")
        (-4 . "OR>")
      )
  )
)

; refactored at 2021-04-18 - rename function name
(defun ClearEntityDataForCopyUtils (ss /) 
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
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
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

; refactored at 2021-03-28
; the item of DictList must be string - 2021-04-18
(defun DictListToJsonStringUtils (DictList / jsonPropertyString)
  (setq jsonPropertyString 
    (apply 'strcat 
      (mapcar '(lambda (x) 
                 (if (IsListDataTypeUtils (cdr x)) 
                   ; must has the , at the end - 2021-03-28
                   (strcat "\"" (strcase (car x) T) "\": " (DictListToJsonStringUtils (cdr x)) ",")
                   (strcat "\"" (strcase (car x) T) "\": \"" (cdr x) "\",")
                 )
              ) 
        DictList
      ) 
    )
  )
  (setq jsonPropertyString (RemoveLastNumCharForStringUtils jsonPropertyString 1))
  (setq jsonPropertyString (strcat "{" jsonPropertyString "}"))
)

(defun ExtractBlockPropertyToJsonStringUtils (entityName propertyNameList / jsonPropertyString)
  (setq jsonPropertyString 
    (apply 'strcat 
      (mapcar '(lambda (x) 
                (strcat "\"" (strcase (car x) T) "\": \"" (cdr x) "\",")
              ) 
        ; remove the first item (entityhandle)
        (cdr (GetPropertyDictListForOneBlockByPropertyNameList entityName propertyNameList))
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
                 ; replace , by ，for get the nomal csv data - 2020-12-31
                (strcat "\"" (strcase (car x) T) "\": \"" (StringSubstUtils "，" "," (cdr x)) "\",")
              ) 
        ; remove the first item (entityhandle) and add the item (class)
        (cons classDict (cdr (GetPropertyDictListForOneBlockByPropertyNameList entityName propertyNameList)))
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
  (if (/= ss nil) 
    (repeat (sslength ss) 
      (setq entityNameList (append entityNameList (list (ssname ss i))))
      (setq i (+ 1 i))
    )
  )
  entityNameList
)

(defun GetEntityNameListByEntityHandleListUtils (entityHandleList /)
  (mapcar '(lambda (x) 
            (handent x)
          ) 
    entityHandleList
  )
)

(defun GetEntityHandleListByPropertyDictListUtils (propertyDictList /)
  (mapcar '(lambda (x) 
            (cdr (assoc "entityhandle" x))
          ) 
    propertyDictList
  )
)

; 2021-03-08
(defun GetEntityNameListByPropertyDictListUtils (propertyDictList /) 
  (GetEntityNameListByEntityHandleListUtils (GetEntityHandleListByPropertyDictListUtils propertyDictList))
)

; refactored at 2021-04-02
(defun GetEntityNameListByXPositionSortedUtils (ss / resultList) 
  (setq resultList 
    (mapcar '(lambda (x) 
              (list (cdr (assoc -1 (entget x))) (car (cdr (assoc 10 (entget x)))))
            ) 
      (GetEntityNameListBySSUtils ss)
    )
  )
  (setq resultList 
    (vl-sort resultList 
      '(lambda (x y) (< (cadr x) (cadr y)))
    )
  )
  (mapcar '(lambda (x) (car x)) resultList)
)

; 2021-02-202
(defun GetEntityHandleAndPositionByEntityNameUtils (entityName /)
  (cons 
    (cdr (assoc 5 (entget entityName)))
    (cdr (assoc 10 (entget entityName)))
  )
)

; 2021-01-26
(defun GetEntityPositionByEntityNameUtils (entityName /)
  (cdr (assoc 10 (entget entityName)))
)

; 2021-01-28
(defun GetTextEntityContentBySelectUtils ()
  (cdr (assoc 1 (entget (car (GetEntityNameListBySSUtils (GetTextSSBySelectUtils))))))
)

; 2021-03-16
(defun GetEntitylayerBySelectUtils ()
  (cdr (assoc 8 (entget (car (GetEntityNameListBySSUtils (ssget))))))
)

(defun GetEntityHandleListByEntityNameListUtils (entityNameList /) 
  (mapcar '(lambda (x) (GetEntityHandleByEntityNameUtils x)) 
    entityNameList
  )
)

(defun GetEntityHandleByEntityNameUtils (entityName / entityHandleList) 
  (setq entityHandle (cdr (assoc 5 (entget entityName))))
)

(defun GetCSVPropertyStringByDataListUtils (dataList / csvPropertyString)
  (setq csvPropertyString "")
  (mapcar '(lambda (x) 
             (setq csvPropertyString (strcat csvPropertyString x ","))
           ) 
    dataList
  )
  csvPropertyString
)

(defun AddApostrForListUtils (originList /)
  ; add "'" at the start of item to prevent being converted by excel
  (mapcar '(lambda (x) 
             (strcat "'" x)
           ) 
    originList
  ) 
)

(defun RemoveApostrForListUtils (originList /)
  ; remove "'" at the start of item to prevent being converted by excel
  (mapcar '(lambda (x) 
             (StringSubstUtils "" "'" x)
           ) 
    originList
  ) 
)

(defun RemoveApostrForListListUtils (originList /)
  ; remove "'" at the start of item to prevent being converted by excel
  (mapcar '(lambda (x) 
             (RemoveApostrForListUtils x)
           ) 
    originList
  ) 
)

(defun GetUpperCaseForListUtils (originList /)
  (mapcar '(lambda (x) 
             (strcase x)
           ) 
    originList
  ) 
)

(defun GetCSVPropertyStringByEntityName (entityName propertyNameList apostrMode / csvPropertyString propertyValueList)
  (setq csvPropertyString "")
  (setq propertyValueList (GetApostrPropertyValueListStrategy entityName propertyNameList apostrMode))
  ; replace , by ，for get the nomal csv data - 2020-12-31
  (mapcar '(lambda (x) 
             (setq csvPropertyString (strcat csvPropertyString (StringSubstUtils "，" "," x) ","))
           ) 
    propertyValueList
  )
  ; add the handle to the start of the csvPropertyString 
  ; (move to GetPropertyValueListForOneBlockByPropertyNameList) - 20201104
  ; add "'" at the start of handle to prevent being converted by excel - 20201020
  (setq csvPropertyString (strcat "'" csvPropertyString))
)

(defun GetApostrPropertyValueListStrategy (entityName propertyNameList apostrMode /) 
  (cond 
    ((= apostrMode "0") (GetPropertyValueListForOneBlockByPropertyNameList entityName propertyNameList))
    ((= apostrMode "1") (AddApostrForListUtils (GetPropertyValueListForOneBlockByPropertyNameList entityName propertyNameList)))
  ) 
)

(defun GetBlockPropertyNameListByEntityNameUtils (entityName /)
  (mapcar '(lambda (x) 
             (car x)
           )
    (GetAllPropertyDictForOneBlock entityName)
  )
)

(defun GetPropertyValueListForOneBlockByPropertyNameList (entityName propertyNameList / allPropertyValue resultList) 
  (setq allPropertyValue (GetAllPropertyDictForOneBlock entityName))
  ; add the entityhandle property default
  (setq propertyNameList (cons "entityhandle" propertyNameList))
  (mapcar '(lambda (x) 
             ; fix bug - the new peoperty name may not be in the old block - 2021-01-11
             (if (/= (cdr (assoc (strcase x T) allPropertyValue)) nil) 
               (setq resultList (append resultList (list (cdr (assoc (strcase x T) allPropertyValue)))))
               (setq resultList (append resultList (list "")))
             )
           ) 
    propertyNameList
  )
  resultList
)

(defun GetOnePropertyValueForOneBlockByPropertyName (entityName propertyName / allPropertyValue) 
  (setq allPropertyValue (GetAllPropertyDictForOneBlock entityName))
  (cdr (assoc (strcase propertyName T) allPropertyValue))
)

(defun GetPropertyDictListForOneBlockByPropertyNameList (entityName propertyNameList / allPropertyValue resultList) 
  (setq allPropertyValue (GetAllPropertyDictForOneBlock entityName))
  (setq propertyNameList (FilterPropertyNameListbyActualBlock entityName propertyNameList))
  ; add the entityhandle property default
  (setq propertyNameList (cons "entityhandle" propertyNameList))
  (mapcar '(lambda (x) 
             ; fix bug - the new peoperty name may not be in the old block - 2021-01-11
             (if (/= (cdr (assoc (strcase x T) allPropertyValue)) nil) 
               (setq resultList (append resultList (list (cons x (cdr (assoc (strcase x T) allPropertyValue))))))
               (setq resultList (append resultList (list (cons x ""))))
             )
           ) 
    propertyNameList
  )
  resultList
)

; the property of old version block may not exist in propertyNameList - 2021-01-05
(defun FilterPropertyNameListbyActualBlock (entityName propertyNameList /)
  (setq actualBlockPropertyNameList 
    (mapcar '(lambda (x) 
              (strcase x)
            ) 
      (GetBlockPropertyNameListByEntityNameUtils entityName)
    )
  )
  (vl-remove-if-not '(lambda (x) 
                      (/= (member x actualBlockPropertyNameList) nil) 
                    ) 
    propertyNameList
  )
)

(defun GetPropertyDictListByPropertyNameList (entityNameList propertyNameList / resultList) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetPropertyDictListForOneBlockByPropertyNameList x propertyNameList))))
           ) 
    entityNameList
  )
  resultList
)

(defun GetPropertyValueListByEntityNameList (entityNameList propertyNameList / resultList) 
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetPropertyValueListForOneBlockByPropertyNameList x propertyNameList))))
           ) 
    entityNameList
  )
  resultList
)

(defun GetNumberedListByFirstDashUtils (numberedList originList /) 
  (mapcar '(lambda (x y)  
             (numberedStringSubstUtil x y)
           ) 
    numberedList
    originList
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

; 2021-05-07
(defun ModifyBlockPropertiesByDictDataUtils (entityName dictData /)
  (ModifyMultiplePropertyForOneBlockUtils entityName 
    (mapcar '(lambda (x) (car x)) dictData)
    (mapcar '(lambda (x) (cdr x)) dictData)
  )
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

(defun ReplaceDXFValueByEntityDataUtils (entityData DXFcodeList valueList / oldValue newValue) 
  (mapcar '(lambda (x y) 
            (setq oldValue (assoc x entityData))
            (setq newValue (cons x y))
            (setq entityData (subst newValue oldValue entityData))
          ) 
    DXFcodeList 
    valueList
  ) 
  entityData
)

(defun ModifyMultiplePropertyForBlockUtils (entityNameList propertyNameList propertyValueList /)
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
  (setq importedDataList (TrimDataNotExistedInCADUtils importedDataList))
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

; repair bug - data may not be in CAD - 2020-12-24
(defun TrimDataNotExistedInCADUtils (dataList /)
  (vl-remove-if-not '(lambda (x) 
                      (/= (handent (car x)) nil)
                    ) 
    dataList
  )
)

(defun GetValueListByOneKeyUtils (dataList key /)
  (mapcar '(lambda (x) 
             (cdr (assoc key x))
           ) 
    dataList
  )
)

;; Returns a list with duplicate elements removed.
(defun DeduplicateForListUtils (resultList /)
  (if resultList 
    (cons (car resultList) 
          (DeduplicateForListUtils (vl-remove (car resultList) (cdr resultList)))
    )
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
(defun GetIncreasedNumberStringListUtils (startNumer listLength / minIncreasedNumberList maxIncreasedNumberList) 
  (GetIncreasedNumberStringListHundredUtils startNumer listLength)
)

(defun GetIncreasedNumberStringListHundredUtils (startNumer listLength / tenIncreasedNumberList hundredIncreasedNumberList) 
  (setq tenIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (< x 10)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (setq hundredIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (>= x 10)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (append (mapcar '(lambda (x) (strcat "0" (rtos x))) tenIncreasedNumberList) 
    (mapcar '(lambda (x) (rtos x)) hundredIncreasedNumberList)
  )
)

(defun GetIncreasedNumberStringListThousandUtils (startNumer listLength / tenIncreasedNumberList hundredIncreasedNumberList thousandIncreasedNumberList) 
  (setq tenIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (< x 10)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (setq hundredIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (and (>= x 10) (< x 100))) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  )
  (setq thousandIncreasedNumberList 
    (vl-remove-if-not '(lambda (x) (>= x 100)) 
      (GetIncreasedNumberListUtils startNumer listLength)
    )
  ) 
  (append (mapcar '(lambda (x) (strcat "00" (rtos x))) tenIncreasedNumberList) 
    (mapcar '(lambda (x) (strcat "0" (rtos x))) hundredIncreasedNumberList) 
    (mapcar '(lambda (x) (rtos x)) thousandIncreasedNumberList)
  )
)

; very importance for me, convert a function to the parameter for another function - 2020-12-25
(defun ExecuteFunctionForOneSourceDataUtils (dataListLength functionName argumentList /)
  (if (= dataListLength 1)
    (vl-catch-all-apply functionName argumentList)
    (progn 
      (alert "数据源只能选一个！")
      (princ)
    )
  ) 
)

(defun GetAllPipeDataUtils () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Pipe")))
)

(defun GetAllEquipDataUtils () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Equipment")))
)

; 2021-05-08
(defun GetAllEquipHandleTagDictDataUtils () 
  (mapcar '(lambda (x) 
              (cons (GetDottedPairValueUtils "entityhandle" x) (GetDottedPairValueUtils "tag" x))
            ) 
    (GetAllEquipDataUtils)
  ) 
)

; 2021-04-29
(defun GetEquipDictDataBySelectUtils () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetEquipmentSSBySelectUtils)))
)

; 2021-03-14
(defun GetAllPipeAndEquipDataUtils () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "EquipmentAndPipe")))
)

; refacotred at 2021-03-14
(defun GetAllPipeHandleListUtils () 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    (GetAllPipeDataUtils)
  )
)

; 2021-04-14
(defun GetAllPipeAndEquipHandleListUtils () 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    (GetAllPipeAndEquipDataUtils)
  )
)

; 2021-04-22
(defun GetAllEquipHandleListUtils () 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    (GetAllEquipDataUtils)
  )
)

; 2021-03-09
(defun GetAllMarkedDataByTypeUtils (dataType /) 
  (cons dataType 
        (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType)))
  )
)

; 2021-03-09
(defun GetAllMarkedDataListByTypeListUtils (dataTypeList /) 
  (mapcar '(lambda (x) 
             (GetAllMarkedDataByTypeUtils x)
           ) 
    dataTypeList
  )
)

; 2021-03-09
; for a blank dwg, result:
; (("Reactor") ("Tank") ("Heater") ("Pump") ("Centrifuge") ("Vacuum") ("CustomEquip"))
(defun GetAllMarkedEquipDataListByTypeListUtils () 
  (GetAllMarkedDataListByTypeListUtils (GetGsLcEquipTypeList))
)

; 2021-02-23
(defun GetAllFireFightPipeDataUtils () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "FireFightPipe")))
)

(defun GetAllEquipPositionDictListUtils ()
  (mapcar '(lambda (x) 
             (cons 
               (cdr (assoc "tag" x)) 
               (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x))))
             )
           ) 
    (GetAllEquipDataUtils)
  ) 
)

(defun GetAllEquipChNameDictListUtils ()
  (mapcar '(lambda (x) 
             (cons 
               (cdr (assoc "tag" x)) 
               (cdr (assoc "name" x)) 
             )
           ) 
    (GetAllEquipDataUtils)
  ) 
)

(defun GetEquipChNameByEquipTag (equipTag / allEquipChNameDictList) 
  (setq allEquipChNameDictList (GetAllEquipChNameDictListUtils))
  (if (cdr (assoc equipTag allEquipChNameDictList)) 
    (setq result (cdr (assoc equipTag allEquipChNameDictList))) 
    (setq result "")
  )
  result
)

;; Separates a string using a given delimiter
;; copy from [http://www.lee-mac.com/stringtolist.html]
; uint test compeleted
(defun StrToListUtils (strData delimiter / len resultList delimiterPosition)
    (setq len (1+ (strlen delimiter)))
    (while (setq delimiterPosition (vl-string-search delimiter strData))
        (setq resultList (cons (substr strData 1 delimiterPosition) resultList)
            strData (substr strData (+ delimiterPosition len))
        )
    )
    (reverse (cons strData resultList))
)

;; Separates a string to list by index
; uint test compeleted
(defun SplitStrToListByIndexUtils (strData index /)
  (list 
    (substr strData 1 index)
    (substr strData (1+ index))
  )
)

(defun StrListToListListUtils (strList / resultList)
  (foreach item strList 
    (setq resultList (append resultList (list (StrToListUtils item ","))))
  )
  resultList
)

; 2021-02-26
(defun DeleteEntityBySSUtils (ss /) 
  (mapcar '(lambda (x) 
             (entdel x)
           ) 
    (GetEntityNameListBySSUtils ss) 
  ) 
)

; 2021-05-13
(defun DeleteEntityByEntityNameListUtils (entityNameList /) 
  (mapcar '(lambda (x) 
             (entdel x)
           ) 
    entityNameList
  ) 
)

; 2021-02-02
(defun AddPositonOffSetUtils (insPt moveDistance /) 
  (mapcar '(lambda (x y) 
             (+ x y)
          ) 
    insPt
    moveDistance
  ) 
)

; 2021-02-02
(defun RemovePositonOffSetUtils (insPt moveDistance /) 
  (mapcar '(lambda (x y) 
             (- x y)
          ) 
    insPt
    moveDistance
  ) 
)

; 2021-02-02
(defun TranforCoordinateToPolarUtils (insPt /)
  (polar (list (car insPt) 0 0) 0.785398 (cadr insPt))
)

; 2021-02-03
(defun RemoveDecimalForStringUtils (rawString /)
  (RegExpReplace rawString "(\\d+)\..*" "$1" nil nil)
)

; Unit Test Completed
(defun ExtractDrawNumUtils (str / result) 
  (if (> (strlen str) 2) 
    (setq result (substr str (- (strlen str) 4)))
    (setq result "无图号")
  )
)

; 2021-03-11
; Unit Test Completed
(defun FilterListByTestMemberUtils (dataList testList /)
  (vl-remove-if-not '(lambda (x) 
                      (member x testList)
                    ) 
    dataList
  )
)

; 2021-03-11
; Unit Test Completed
(defun FilterListByTestNotMemberUtils (dataList testList /)
  (vl-remove-if-not '(lambda (x) 
                      (not (member x testList))
                    ) 
    dataList
  )
)

; refactored at 2021-03-16
(defun ModifyTextEntityContentUtils (entityNameList textContent /)
  (mapcar '(lambda (x) 
            (SetDXFValueByEntityDataUtils (entget x) 1 textContent)
          ) 
    entityNameList
  ) 
)

; get the new inserting position
; Unit Test Compeleted
(defun GetInsertPtByXMove (insPt i removeDistance /)
  (ReplaceListItemByindexUtils (+ (car insPt) (* i removeDistance)) 0 insPt)
)

; Unit Test Compeleted
(defun GetInsertPtListByXMoveUtils (insPt SortedNumByList xDistance / resultList)
  (mapcar '(lambda (x) (GetInsertPtByXMove insPt x xDistance)) 
    SortedNumByList
  )
)

; 2021-03-17
(defun GetInsertPtByYMove (insPt i removeDistance /)
  (ReplaceListItemByindexUtils (+ (cadr insPt) (* i removeDistance)) 1 insPt)
)

; 2021-03-17
(defun GetInsertPtListByYMoveUtils (insPt SortedNumByList yDistance / resultList)
  (mapcar '(lambda (x) (GetInsertPtByYMove insPt x yDistance)) 
    SortedNumByList
  )
)

; 2021-03-17
; Unit Test Compeleted
(defun RemoveNullStringForListUtils (dataList /)
  (vl-remove-if-not '(lambda (x) 
                      (/= x "") 
                    ) 
    dataList
  )  
)

; 2021-03-17
; Unit Test Compeleted
(defun SplitListByNumUtils (dataList num / i tempList resultList) 
  (setq i 0)
  (repeat (length dataList) 
    (setq tempList (append tempList (list (nth i dataList))))
    (setq i (1+ i))
    (if (= (rem i num) 0) 
      (progn 
        (setq resultList (append resultList (list tempList)))
        (setq tempList nil) 
      )
    )
  )
  (setq resultList (append resultList (list tempList)))
  resultList
)

; 2021-04-20
; Copied from Lee Mac
; Unit Test Compeleted
(defun SplitListByItemUtils (x originList / r)
   (setq originList 
      (vl-member-if '(lambda (y) (setq r (cons y r)) (equal x y)) originList)
   )
   (list (reverse (cdr r)) originList)
)

; 2021-04-20
; Unit Test Compeleted
(defun SplitListByIndexUtils (index originList /) 
   (SplitListByItemUtils (nth index originList) originList)
)

; 2021-04-20
; Copied from Lee Mac
; Unit Test Compeleted
(defun SplitListListByItemUtils (x originList / r) 
  ; ready for refactor
   (setq originList 
      (vl-member-if '(lambda (y) (setq r (cons y r)) (equal (car x) (car y))) 
                     originList)
   )
   (list (reverse (cdr r)) originList)
)

; 2021-04-20
; Unit Test Compeleted
(defun SplitListListByIndexUtils (index originList /) 
   (SplitListListByItemUtils (nth index originList) originList)
)

; 2021-04-21
; Unit Test Compeleted
(defun SplitLDictListByDictKeyUtils (dictKey originList / r) 
  (setq originList 
    (vl-member-if '(lambda (y) (setq r (cons y r)) (equal dictKey (car y))) 
                    originList)
  )
  (list (reverse (cdr r)) originList) 
)

; 2021-03-22
(defun GetAllDrawLabelPositionListUtils () 
  (mapcar '(lambda (x) 
             (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x))))
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

; 2021-03-22
(defun GetCurrentCADFileDirUtils (/ )
  (getvar "dwgprefix")
)

; 2021-04-02
(defun PurgeAllUtils (/ acadObj doc)
  ;; This example removes all unused named references from the database
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (vla-PurgeAll doc) 
)

; 2021-04-08
(defun ChunkListByColumnIndexUtils (listData keyIndex / keyList resultList) 
  (setq keyList 
    (DeduplicateForListUtils 
      (mapcar '(lambda (x) (nth keyIndex x)) listData) 
    ) 
  )  
  (foreach item keyList
    (setq resultList 
           (append resultList 
              (list 
                (cons item 
                  (vl-remove-if-not '(lambda (x) 
                                      (= item (nth keyIndex x))
                                    ) 
                    listData
                  ) 
                ) 
              )
           )
    )
  )
  resultList
)

; 2021-04-19
(defun GetNegativeNumberUtils (originNumber /)
  (- 0 originNumber)
)

; 2021-04-19
(defun GetHalfNumberUtils (originNumber /)
  (/ originNumber 2)
)

; 2021-05-18
(defun FilterListListByFirstItemUtils (listList itemName /)
  (mapcar '(lambda (x) (cadr x)) 
    (vl-remove-if-not '(lambda (x) 
                        (= (car x) itemName) 
                      ) 
      listList
    )  
  )
)

; Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Extract and Replace subString by Reguar Match

;; RegExpSet
;; Returns the current VBScript.RegExp instance after defining its properties.
;;
;; Arguments
;; pattern    : Pattern to search.
;; ignoreCase : If non nil, the search is done ignoring the case.
;; global     : If non nil, search all occurences of the pattern;
;;              if nil, only searches the first occurence.

(defun RegExpSet (pattern ignoreCase global / regex)
  (setq regex
         (cond
           ((vl-bb-ref '*regexp*))
           ((vl-bb-set '*regexp* (vlax-create-object "VBScript.RegExp")))
         )
  )
  (vlax-put regex 'Pattern pattern)
  (if ignoreCase
    (vlax-put regex 'IgnoreCase acTrue)
    (vlax-put regex 'IgnoreCase acFalse)
  )
  (if global
    (vlax-put regex 'Global acTrue)
    (vlax-put regex 'Global acFalse)
  )
  regex
)

;; RegexpTestUtils
;; Return T if a match with the pattern is found in the string; otherwise, nil.
;;
;; Arguments
;; string     : String in which the pattern is searched.
;; pattern    : Pattern to search.
;; ignoreCase : If non nil, the search is done ignoring the case.
;;
;; Examples :
;; (RegexpTestUtils "fsoo bar" "Ba" nil)  ; => nil
;; (RegexpTestUtils "fsoo bar" "Ba" T)    ; => T
;; (RegexpTestUtils "42C" "[0-9]+" nil)  ; => T

(defun RegexpTestUtils (string pattern ignoreCase)
  (= (vlax-invoke (RegExpSet pattern ignoreCase nil) 'Test string) -1)
)

;; RegExpExecute
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

;;
;; Examples
;; (RegExpExecute "fsoo bar baz" "ba" nil nil)               ; => (("ba" 4 nil))
;; (RegexpExecute "12B 4bis" "([0-9]+)([A-Z]+)" T T)        ; => (("12B" 0 ("12" "B")) ("4bis" 4 ("4" "bis")))
;; (RegexpExecute "-12 25.4" "(-?\\d+(?:\\.\\d+)?)" nil T)  ; => (("-12" 0 ("-12")) ("25.4" 4 ("25.4")))

(defun RegExpExecuteUtils (string pattern ignoreCase global / sublst lst)
  (vlax-for match (vlax-invoke (RegExpSet pattern ignoreCase global) 'Execute string)
    (setq sublst nil)
    (vl-catch-all-apply
      '(lambda ()
     (vlax-for submatch (vlax-get match 'SubMatches)
       (if submatch
         (setq sublst (cons submatch sublst))
       )
     )
       )
    )
    (setq lst (cons (list (vlax-get match 'Value)
              (vlax-get match 'FirstIndex)
              (reverse sublst)
            )
            lst
          )
    )
  )
  (reverse lst)
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
(defun RegExpReplace (string pattern newStr ignoreCase global)
  (vlax-invoke (RegExpSet pattern ignoreCase global) 'Replace string newStr)
)

; Extract and Replace subString by Reguar Match
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
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

; 2021-04-02
(defun SortSelectionSetByRowColumn (ssSelections /  lstOfSelections lstOfSublists lstSelections)
 (if
  (and 
    (setq lstSelections (SelectionSetToList ssSelections))
    (setq lstOfSublists (mapcar '(lambda (X)(cons X (cdr (assoc 10 (entget X))))) lstSelections))
    (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 1 1))
    ; the key is -1 for y cordinate
    (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 2 -1))
    (setq ssSelections  (listtoselectionset (mapcar 'car lstOfSublists)))
  )
  ssSelections
 )
)

(defun SortSSByMinxMiny (ssSelections /  lstOfSelections lstOfSublists lstSelections)
 (if
  (and 
   (setq lstSelections (SelectionSetToList ssSelections))
   (setq lstOfSublists 
          (mapcar '(lambda (x) 
                     (cons x (cdr (assoc 10 (entget x))))
                   ) 
            lstSelections
          )
   )
    ; the key is -1 for y cordinate
   (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 2 1))
   (setq lstOfSublists (sortlistofsublistsbyitemX lstOfSublists 1 1))
   (setq ssSelections  (listtoselectionset (mapcar 'car lstOfSublists)))
  )
  ssSelections
 )
)

; 2021-02-27
(defun SortPositionListByMinxMinyUtils (PositionList / resultList) 
  (setq resultList 
    (vl-sort PositionList '(lambda (x y) (< (car x) (car y))))
  )
  (setq resultList 
    (vl-sort resultList '(lambda (x y) (< (cadr x) (cadr y))))
  ) 
)

; Sorting Select Set by XY cordinate
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Redefining AutoCAD Commands

; 2021-03-02
(defun CADLispMove (ss firstPoint secondPoint /)
  (command "_.move" ss firstPoint "" secondPoint "")
)

; 2021-03-02
(defun CADLispCopy (ss firstPoint secondPoint /)
  (command "_.copy" ss firstPoint "" secondPoint "")
)

; Redefining AutoCAD Commands
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

(defun WriteDataToCSVByEntityNameListUtils (entityNameList fileDir firstRow propertyNameList apostrMode / filePtr csvPropertyStringList)
  (setq filePtr (open fileDir "w"))
  (write-line firstRow filePtr)
  (foreach item entityNameList 
    (setq csvPropertyStringList (append csvPropertyStringList (list (GetCSVPropertyStringByEntityName item propertyNameList apostrMode))))
  )
  (foreach item csvPropertyStringList 
    (write-line item filePtr)
  )
  (close filePtr) 
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

(defun RemoveFirstCharOfItemInListUtils (originList /) 
  (mapcar '(lambda (x) (substr x 2)) originList)
)

; 2021-04-17
(defun ReadDataFromFileUtils (fileDir / filePtr i textLine resultList) 
  (setq filePtr (open fileDir "r"))
  (if filePtr
    (progn 
      (setq i 1)
      (while (setq textLine (read-line filePtr)) 
        (setq resultList (append resultList (list textLine)))
        (setq i (1+ i))
      )
    ) 
  )
  (close filePtr)
  resultList
)

; Read and Write Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Bool Function Utils

(defun IsGsLcBlockPipePropertyDictUtils (blockPropertyDict / result)
  (if (and (/= (assoc "pipenum" blockPropertyDict) nil) (/= (assoc "from" blockPropertyDict) nil) )
    (setq result T)
  )
)

(defun IsGsLcBlockEquipmentPropertyDictUtils (blockPropertyDict / result)
  (if (and (/= (assoc "species" blockPropertyDict) nil) (/= (assoc "weight" blockPropertyDict) nil) )
    (setq result T)
  )
)

(defun IsGsLcBlockInstrumentPropertyDictUtils (blockPropertyDict / result)
  (if (and (/= (assoc "function" blockPropertyDict) nil) (/= (assoc "sort" blockPropertyDict) nil) )
    (setq result T)
  )
)

; 2021-03-29
(defun IsListDataTypeUtils (data / result)
  (if (= (type data) 'LIST) 
    T
  )
)

; 2021-03-29
(defun IsStringDataTypeUtils (data / result)
  (if (= (type data) 'STR) 
    T
  )
)

; 2021-04-09
(defun IsPositionInTheRegionUtils (position firstX secondX firstY secondY /) 
  (and 
    (> (car position) firstX) 
    (< (car position) secondX) 
    (> (cadr position) firstY) 
    (< (cadr position) secondY) 
  )
)

; Bool Function Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Filter DataFlow Data Utils

(defun FilterBlockPipeDataUtils (blockPropertyDict /)
  (vl-remove-if-not '(lambda (x) 
                      (IsGsLcBlockPipePropertyDictUtils x) 
                    ) 
    blockPropertyDict
  ) 
)

(defun FilterBlockEquipmentDataUtils (blockPropertyDict /)
  (vl-remove-if-not '(lambda (x) 
                      (IsGsLcBlockEquipmentPropertyDictUtils x) 
                    ) 
    blockPropertyDict
  ) 
)

(defun FilterBlockInstrumentDataUtils (blockPropertyDict /)
  (vl-remove-if-not '(lambda (x) 
                      (IsGsLcBlockInstrumentPropertyDictUtils x) 
                    ) 
    blockPropertyDict
  ) 
)

; Filter DataFlow Data Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Extract Data Utils

; 2021-04-14
(defun ExtractProjectNumUtils (projectInfo /)
  (RegExpReplace projectInfo "(.*)-(.*)-(.*)-(.*).*" "$1" nil nil)
)

; 2021-04-14
(defun ExtractMonomerNumUtils (projectInfo /)
  (RegExpReplace projectInfo "(.*)-(.*)-(.*)-(.*).*" "$2" nil nil)
)

; 2021-03-08
(defun ExtractGsPipeClassUtils (pipenum /)
  (RegExpReplace pipenum ".*-(\\d[A-Z]\\d+).*" "$1" nil nil)
)

; 2021-03-08
(defun ExtractGsPipeDiameterUtils (pipenum /)
  (RegExpReplace pipenum "(.*)-(\\d+)-(.*)" "$2" nil nil)
)

; 2021-03-11
; @return integer
; unit test compeleted
(defun ExtractEquipVolumeNumUtils (volume /) 
  (atoi (RegExpReplace volume "(\\d+)(.*)" "$1" nil nil))
)

; 2021-03-12
; @return string
(defun ExtractEquipVolumeStringUtils (volume /) 
  (RegExpReplace volume "(\\d+)(.*)" "$1" nil nil)
)

; 2021-03-12
; @return string
; unit test compeleted
(defun ExtractEquipDiameterStringUtils (equipDiameter /) 
  (RegExpReplace equipDiameter "([^0-9]*)(\\d+)(.*)" "$2" nil nil)
)

; 2021-03-12
(defun ProcessNullStringUtils (originString / result)
  (if (/= originString nil) 
    (setq result originString)
    (setq result "")
  )
  result
)

; Extract Data Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Extract External File Data Utils

; 2021-03-09
; ready to develop
(defun GetExternalDwgEntityDataUtils (/ acadObj curDoc filePath externalDoc externalModelSpace objCollection count retObjects) 
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj))
  
  (setq filePath "D:\\dataflowcad\\allBlocks\\GsBzBlocks.dwg")
  (setq externalDoc (GetdocumentobjectUtils filePath))
  ;(GetVlaObjectPropertyAndMethodUtils externalDoc)
  (setq externalModelSpace (vla-get-ModelSpace externalDoc))
  ;(GetVlaObjectPropertyAndMethodUtils modelSpace)
  
  
  (setq objCollection (vlax-make-safearray vlax-vbObject (cons 0 (- (vla-get-Count externalModelSpace) 1)))
          count 0)
  ;; Copy objects
  (vlax-for eachObj externalModelSpace
    (vlax-safearray-put-element objCollection count eachObj)
    (setq count (1+ count))
  )
  ;; Copy object and get back a collection of the new objects (copies)
  (setq retObjects (vla-CopyObjects acadObj objCollection (vla-get-ModelSpace (vla-get-Database curDoc))))
  

  (vlax-release-object externalDoc)
)

; 2021-03-09
(defun GetExternalDwgEntityHandleListUtils (/ filePath externalDoc modelSpace resultList) 
  (setq filePath "D:\\dataflowcad\\allBlocks\\GsBzBlocks.dwg")
  (setq externalDoc (GetdocumentobjectUtils filePath))
  (setq modelSpace (vla-get-ModelSpace externalDoc))
  ;(GetVlaObjectPropertyAndMethodUtils modelSpace)
  ;; the handle of each object found.
  (vlax-for entry modelSpace
    (setq resultList (append resultList (list (vla-get-Handle entry))))
  ) 
  (vlax-release-object externalDoc)
  resultList
)

(defun InsertBlockUtilsTTSS (insPt blockName layerName propertyDictList / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq insertionPnt (vlax-3d-point insPt))
  (setq modelSpace (vla-get-ModelSpace curDoc))
  (setq blockRefObj (vla-InsertBlock modelSpace insertionPnt blockName 1 1 1 0))
  ;(vlax-dump-object blockRefObj T)
  (vlax-put-property blockRefObj 'Layer layerName)
  (setq blockAttributes (vlax-variant-value (vla-GetAttributes blockRefObj)))
  ; another method get the blockAttributes
  ;(setq blockAttributes (vlax-variant-value (vlax-invoke-method blockRefObj 'GetAttributes)))
  ;(vlax-safearray->list blockAttributes)
  ; setting block property value
  (mapcar '(lambda (x) 
            (vla-put-TextString (vlax-safearray-get-element blockAttributes (car x)) (cdr x))
          ) 
    propertyDictList
  ) 
  ;(vla-ZoomAll acadObj) 
  (princ)
)

; 2021-03-10
; copy apart code from [202102StealV1-8] - LeeMac-Library
(defun GetdocumentobjectUtils (filename / acdocs dbdoc vers)
  (vlax-map-collection (vla-get-documents (vlax-get-acad-object))
    (function
      (lambda (doc)
        (setq acdocs (cons (cons (strcase (vla-get-fullname doc)) doc) acdocs))
      )
    )
  )
  (cond
    ((null (setq filename (findfile filename)))
      nil
    )
    ((cdr (assoc (strcase filename) acdocs))
    )
    ((null
      (vl-catch-all-error-p
        (vl-catch-all-apply 'vla-open
          (list
            (setq dbdoc
              (vla-getinterfaceobject (vlax-get-acad-object)
                (if (< (setq vers (atoi (getvar 'acadver))) 16)
                  "ObjectDBX.AxDbDocument"
                  (strcat "ObjectDBX.AxDbDocument." (itoa vers))
                )
              )
            )
            filename
          )
        )
      )
    )
      dbdoc
    )
  )
)


; Extract External File Data Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Vla-Object Utils Function 

; 2021-05-13
(defun FilterBlockByOnePropertyUtils (entityNameList propertyName propertyValue /)
  (vl-remove-if-not '(lambda (x) 
                      (= (VlaGetBlockPropertyValueUtils x propertyName) propertyValue) 
                    ) 
    entityNameList
  ) 
)

; 2021-05-12
(defun VlaGetEntityPropertyAndMethodUtils (entityName /)
  (vlax-dump-object (vlax-ename->vla-object entityName) T)
)

; 2021-05-12
(defun VlaGetEntityPropertyAndMethodBySelectUtils ()
  (vlax-dump-object (VlaGetObjectBySelectUtils) T)
)

; 2021-03-09
(defun GetVlaObjectPropertyAndMethodUtils (VlaObject /)
  (vlax-dump-object VlaObject T)
)

; 2021-03-25
(defun VlaGetObjectBySelectUtils (/ )
  (vlax-ename->vla-object 
    (car (GetEntityNameListBySSUtils (ssget)))
  ) 
)

; 2021-03-25
(defun GetLastVlaObjectUtils (/ )
  (vlax-ename->vla-object (entlast)) 
)

; 2021-05-13
;; Get Attribute Value
;; Returns the value held by the specified tag within the supplied block, if present.
;; blk - [vla] VLA Block Reference Object
;; tag - [str] Attribute TagString
;; Returns: [str] Attribute value, else nil if tag is not found.
(defun VlaGetBlockPropertyValueUtils (entityName tag / blk)
  (setq blk (vlax-ename->vla-object entityName))
  (setq tag (strcase tag))
  (vl-some 
    '(lambda (att) (if (= tag (strcase (vla-get-tagstring att))) (vla-get-textstring att))) 
    (vlax-invoke blk 'getattributes)
  )
)

; 2021-03-25
;; Get Dynamic Block Property Value
;; Returns the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
(defun GetOneDynamicBlockPropertyValueUtils (blk prp /)
  (setq prp (strcase prp))
  (vl-some '(lambda (x) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'value)))
    (vlax-invoke blk 'getdynamicblockproperties)
  )
)

; 2021-03-25
;; Set Dynamic Block Property Value
;; Modifies the value of a Dynamic Block property (if present)
;; blk - [vla] VLA Dynamic Block Reference object
;; prp - [str] Dynamic Block property name (case-insensitive)
;; val - [any] New value for property
;; Returns: [any] New value if successful, else nil
(defun SetOneDynamicBlockPropertyValueUtils (blk prp val /)
  (setq prp (strcase prp))
  (vl-some
    '(lambda ( x )
      (if (= prp (strcase (vla-get-propertyname x)))
        (progn
          (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
          (cond (val) (t))
        )
      )
    )
    (vlax-invoke blk 'getdynamicblockproperties)
  )
)

; 2021-03-25
;; Get Dynamic Block Properties
;; Returns an association list of Dynamic Block properties & values.
;; blk - [vla] VLA Dynamic Block Reference object
;; Returns: [lst] Association list of ((<prop> . <value>) ... )
(defun GetDynamicBlockPropertyValueUtils (blk /)
  (mapcar '(lambda (x) (cons (vla-get-propertyname x) (vlax-get x 'value)))
    (vlax-invoke blk 'getdynamicblockproperties)
  )
)

; 2021-03-25
;; Set Dynamic Block Properties
;; Modifies values of Dynamic Block properties using a supplied association list.
;; blk - [vla] VLA Dynamic Block Reference object
;; lst - [lst] Association list of ((<Property> . <Value>) ... )
;; Returns: nil
(defun SetDynamicBlockPropertyValueUtils (blk lst / itm)
  (setq lst (mapcar '(lambda (x) (cons (strcase (car x)) (cdr x))) lst))
  (foreach x (vlax-invoke blk 'getdynamicblockproperties)
    (if (setq itm (assoc (strcase (vla-get-propertyname x)) lst))
      (vla-put-value x (vlax-make-variant (cdr itm) (vlax-variant-type (vla-get-value x))))
    )
  )
)

; Vla-Object Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; XData Utils Function

; 2021-03-26
; DXF Code for XData 1050
(defun CreateStringXDataUtils (xdataString / appName)
  (setq appName "DataFlowXData") 
  (regapp "DataFlowXData") 
  (list -3 (list appName 
                (cons 1000 xdataString)))
)

; 2021-03-26
; refactored at 2021-05-13
(defun BindDataFlowXDataToObjectUtils (entityName xdataString / xdataList entityData) 
  (setq xdataList (CreateStringXDataUtils xdataString))
  (setq entityData (entget entityName))
  (setq entityData (append entityData (list xdataList)))
  (entmod entityData)
  (entupd entityName)
  (princ)
)

; 2021-03-28
(defun UpdateXDataByStringDataUtils (entityName xdataString / entityData) 
  (setq entityData (entget entityName '("DataFlowXData")))
  (if (/= (assoc -3 entityData) nil) 
    (setq entityData (subst (CreateStringXDataUtils xdataString) (assoc -3 entityData) entityData)) 
  )  
  (entmod entityData)
  (entupd entityName)
  (princ)
)

; 2021-03-28
(defun UpdateXDataByDictDataUtils (entityName dictData /)
  (UpdateXDataByStringDataUtils entityName (DictListToJsonStringUtils dictData))
)

; 2021-03-26
(defun GetStringXDataByEntityNameUtils (entityName / entityData)
  (setq entityData 
    (entget entityName '("DataFlowXData")))
  (if (/= (assoc -3 entityData) nil) 
    (GetDottedPairValueUtils 1000 
      (GetDottedPairValueUtils "DataFlowXData" (GetDottedPairValueUtils -3 entityData))
    )
  ) 
)

; 2021-03-26
(defun GetdataFlowXDataUtils () 
  (entget (car (GetEntityNameListBySSUtils (ssget))) '("DataFlowXData"))
)

; 2021-03-28
(defun GetListXDataLByEntityNameUtils (entityName /) 
  (JsonToListUtils (GetStringXDataByEntityNameUtils entityName))
)

; XData Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Dictionary Utils Function

; 2021-03-29
; Custom function that returns the entity name of a specific dictionary entry 
(defun GetDictEntityNameByKeyEntryUtils (dictionaryEntity dKeyEntry / entityData dKeyEntry dEntityName cnt) 
  (setq entityData (entget dictionaryEntity)) 
  (setq dEntityName nil) 
  (setq cnt 0) 
  (while (and (= dEntityName nil)(< cnt (length entityData))) 
    (if (and (= (car (nth cnt entityData)) 3) 
             (= (cdr (nth cnt entityData)) dKeyEntry)) 
      (progn 
        (setq dEntityName (cdr (nth (1+ cnt) entityData))) 
      ) 
    ) 
    (setq cnt (1+ cnt)) 
  ) 
  dEntityName 
)

; 2021-03-29;
(defun GetDictEntityDataByKeyEntryUtils (entityName dKeyEntry /) 
  (dictsearch (GetDictionaryEntityNameUtils entityName) dKeyEntry)  
)

; 2021-03-29;
(defun RemoveDictEntityDataByKeyEntryUtils (entityName dKeyEntry /) 
  (dictremove (GetDictionaryEntityNameUtils entityName) dKeyEntry)  
)

; 2021-03-29
(defun CreateCustomDictionaryByEntityNameUtils (entityName / dictionary exDictionary)
  ; Creates a new dictionary
  (setq dictionary (entmakex (list (cons 0 "DICTIONARY") (cons 100 "AcDbDictionary"))))
  (setq exDictionary (list (cons 102 "{ACAD_XDICTIONARY") (cons 360 dictionary)(cons 102 "}"))) 
  ; Attach the extension dictionary to the last object 
  (setq entityData (append (entget entityName) exDictionary)) 
  (entmod entityData) 
  (entupd entityName)
  (princ)
)

; 2021-03-29
(defun CreateDictionaryByEntityNameUtils (entityName / dictionary exDictionary)
  ; Creates a new dictionary
  (setq dictionary (entmakex (list (cons 0 "DICTIONARY") (cons 100 "AcDbDictionary"))))
  (setq newdictionary (dictadd (namedobjdict) "DATAFLOW_GS" dictionary))
)

; refactored at 2021-04-02
(defun BindStringDictionaryDataToObjectUtils (entityName stringData dKeyEntry /) 
  (if (GetDictionaryEntityNameUtils entityName) 
    (dictadd (GetDictionaryEntityNameUtils entityName) dKeyEntry 
      (entmakex (list (cons 0 "XRECORD")(cons 100 "AcDbXrecord") 
                      (cons 1 stringData))
      )
    ) 
    (progn 
      (CreateCustomDictionaryByEntityNameUtils entityName) 
      (dictadd (GetDictionaryEntityNameUtils entityName) dKeyEntry 
        (entmakex (list (cons 0 "XRECORD")(cons 100 "AcDbXrecord") 
                        (cons 1 stringData))
        )
      ) 
    )
  )
  (princ)
)

; 2021-03-29
(defun BindDictDictionaryDataToObjectUtils (entityName dictData dKeyEntry /)
  (BindStringDictionaryDataToObjectUtils 
    entityName 
    (DictListToJsonStringUtils dictData) 
    dKeyEntry)
)

; 2021-03-29
(defun BindGsStringDictionaryDataToObjectUtils (entityName stringData /) 
  (BindStringDictionaryDataToObjectUtils entityName stringData "DATAFLOW_GS")
)

; 2021-03-29
(defun BindGsDictDictionaryDataToObjectUtils (entityName dictData /) 
  (BindDictDictionaryDataToObjectUtils entityName dictData "DATAFLOW_GS")
)

; 2021-03-29
(defun GetDictionaryDataByEntityNameUtils (entityName /)
  (entget (cdr (assoc 360 (entget entityName))))
)

; 2021-03-29
(defun GetDictionaryDataByEntityDataUtils (entityData/)
  (entget (cdr (assoc 360 entityData)))
)

; 2021-03-29
(defun GetDictionaryEntityNameUtils (entityName /)
  (cdr (assoc 360 (entget entityName)))
)

; 2021-03-29
(defun GetStringDictionaryDataByEntityNameUtils (entityName dKeyEntry / entityData) 
  (setq entityData 
    (entget (GetDictEntityNameByKeyEntryUtils (GetDictionaryEntityNameUtils entityName) dKeyEntry))
  )
  (cdr (assoc 1 entityData))
)

; 2021-03-29
(defun GetDictDictionaryDataByEntityNameUtils (entityName dKeyEntry /) 
  (JsonToListUtils (GetStringDictionaryDataByEntityNameUtils entityName dKeyEntry))
)

; 2021-03-29
(defun GetGsDictDictionaryDataByEntityNameUtils (entityName /) 
  (GetDictDictionaryDataByEntityNameUtils entityName "DATAFLOW_GS")
)

; 2021-04-02
(defun UpdateGsDictDictionaryDataUtils (entityName dictData / entityData) 
  (if (GetDictionaryEntityNameUtils entityName) 
    (RemoveDictEntityDataByKeyEntryUtils entityName "DATAFLOW_GS")
  ) 
  (UpdateGsStringDictionaryDataUtils 
    entityName 
    (DictListToJsonStringUtils dictData)) 
)

; 2021-04-02
(defun UpdateGsStringDictionaryDataUtils (entityName stringData / entityData) 
  (if (GetDictionaryEntityNameUtils entityName) 
    (RemoveDictEntityDataByKeyEntryUtils entityName "DATAFLOW_GS")
  ) 
  (BindGsStringDictionaryDataToObjectUtils entityName stringData)
)

; 2021-03-29
; do not be valid, ready for refactor
; (defun UpdateStringDictDataByDictEntityNameUtilsV1 (entityName stringData / entityData) 
;   (setq entityData (entget entityName))
;   (if (/= (assoc 1 entityData) nil) 
;     (setq entityData (subst (cons 1 stringData) (assoc 1 entityData) entityData)) 
;   ) 
;   (entmod entityData)
;   (entupd entityName)
;   (princ)
; )

; Dictionary Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Export All Type Data Utils Function

; 2021-04-07
(defun GetDataByDataTypeStrategyUtils (ss classType dataType /) 
  (cond 
    ((= classType "Gs") (GetGsJsonListDataByDataType ss dataType))
    ((= classType "Ks") (GetKsJsonListDataByDataType ss dataType))
  ) 
)

; 2021-04-07
(defun GetBlockSSBySelectByDataTypeStrategyUtils (classType dataType /) 
  (cond 
    ((= classType "Gs") (GetBlockSSBySelectByDataTypeUtils dataType))
    ((= classType "Ks") (GetKsBlockSSBySelectByDataTypeUtils dataType))
  )
)

; 2021-04-07
(defun GetAllBlockSSByDataTypeStrategyUtils (classType dataType /) 
  (cond 
    ((= classType "Gs") (GetAllBlockSSByDataTypeUtils dataType))
    ((= classType "Ks") (GetAllKsBlockSSByDataTypeUtils dataType))
  ) 
)

; 2021-03-22
(defun ExtractBlockPropertyToJsonListStrategy (ss dataType / entityNameList propertyNameList classDict resultList) 
  ; the key is filter ss by dataType - refactored at 2021-04-07
  (setq entityNameList (FilterEntityNameByBlockName (GetEntityNameListBySSUtils ss) dataType))
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

; 2021-04-07
(defun FilterEntityNameByBlockName (entityNameList dataType /)
  (vl-remove-if-not '(lambda (x) 
                       (wcmatch (GetDottedPairValueUtils 2 (entget x)) 
                                (strcat dataType "*"))
                     ) 
    entityNameList
  ) 
)

; 2021-03-22
(defun ExportBlockDataUtils (fileName dataList / fileDir) 
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir dataList) 
)

; 2021-03-22
; refactored at 2021-04-07
(defun ExportTempDataByBox (tileName dataTypeList dataTypeChNameList classType / dcl_id status fileName exportDataType dataType exportMsgBtnStatus ss sslen dataList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
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
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "文件名不能为空！")
    )
    (if (= exportMsgBtnStatus 3)
      (set_tile "exportBtnMsg" "请先选择要导的数据！")
    )
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "导出数据数量： " (rtos sslen)))
    )
    (set_tile "fileName" fileName)
    (set_tile "exportDataType" exportDataType)
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq dataType (nth (atoi exportDataType) dataTypeList))
        (setq ss (GetBlockSSBySelectByDataTypeStrategyUtils classType dataType))
        (setq sslen (sslength ss)) 
        (setq dataList (GetDataByDataTypeStrategyUtils ss classType dataType))
      )
    )
    ; All select button
    (if (= 3 status) 
      (progn 
        (setq dataType (nth (atoi exportDataType) dataTypeList))
        (setq ss (GetAllBlockSSByDataTypeStrategyUtils classType dataType))
        (setq sslen (sslength ss)) 
        (setq dataList (GetDataByDataTypeStrategyUtils ss classType dataType)) 
      )
    ) 
    ; export data button
    (if (= 4 status) 
      (cond 
        ((= fileName "") (setq exportMsgBtnStatus 2))
        ((= dataList nil) (setq exportMsgBtnStatus 3))
        (T (progn 
             (ExportBlockDataUtils fileName dataList)
             (setq exportMsgBtnStatus 1)
           ))
      ) 
    ) 
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-04-12
(defun GetFileNameByDataTypeStrategy (dataType /)
  (cond 
    ((= dataType "Pipe") "GsPipe")
    ((= dataType "Equipment") "GsEquipment")
    ((= dataType "InstrumentAndEquipmentAndPipe") "GsInstrument")
    ((= dataType "Electric") "GsElectric")
    ((= dataType "OuterPipe") "GsOuterPipe")
    ((= dataType "GsCleanAir") "GsCleanAir")
    ((= dataType "KsInstallMaterial") "KsInstallMaterial")
  )  
)

; refactored 2021-04-14
(defun ExportCADBlockDataUtils (fileName dataList / fileDir) 
  (setq fileDir (strcat "D:\\dataflowcad\\tempdata\\" fileName ".txt"))
  ; refactored 2021-04-15 - file is opening because electron read file, delete the file first
  (vl-file-delete fileDir)
  (WriteDataListToFileUtils 
    fileDir 
    (cons (DictListToJsonStringUtils (GetProjectInfoUtils)) dataList)) 
)

; 2021-04-11
(defun ExportCADDataByBox (tileName dataTypeList dataTypeChNameList classType / dcl_id status fileName exportDataType dataType exportMsgBtnStatus ss sslen dataList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
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
    (mode_tile "exportDataType" 2)
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
    (if (/= exportMsgBtnStatus nil)
      (set_tile "exportDataType" exportDataType)
    )
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "请先选择要导的数据！")
    )
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "导出数据数量： " (rtos sslen)))
    )
    (set_tile "exportDataType" exportDataType)
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq dataType (nth (atoi exportDataType) dataTypeList))
        (setq ss (GetBlockSSBySelectByDataTypeStrategyUtils classType dataType))
        (setq sslen (sslength ss)) 
        (setq dataList (GetDataByDataTypeStrategyUtils ss classType dataType))
      )
    )
    ; All select button
    (if (= 3 status) 
      (progn 
        (setq dataType (nth (atoi exportDataType) dataTypeList))
        (setq ss (GetAllBlockSSByDataTypeStrategyUtils classType dataType))
        (setq sslen (sslength ss)) 
        (setq dataList (GetDataByDataTypeStrategyUtils ss classType dataType)) 
      )
    ) 
    ; export data button
    (if (= 4 status) 
      (progn 
        (setq fileName (GetFileNameByDataTypeStrategy dataType))
        (cond 
          ((= dataList nil) (setq exportMsgBtnStatus 2))
          (T (progn 
              (ExportCADBlockDataUtils fileName dataList)
              (setq exportMsgBtnStatus 1)
            ))
        )  
      )
    ) 
  )
  (unload_dialog dcl_id)
  (princ)
)

; 2021-04-14
(defun GetProjectInfoUtils (/ ss allDrawLabelData)
  (setq ss (SortSelectionSetByXYZ (GetAllBlockSSByDataTypeUtils "DrawLabel")))
  (setq allDrawLabelData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils ss))))
  (list 
    (cons "projectNum" (ExtractProjectNumUtils (GetDottedPairValueUtils "dwgno" allDrawLabelData)))
    (cons "monomerNum" (ExtractMonomerNumUtils (GetDottedPairValueUtils "dwgno" allDrawLabelData)))
    (cons "projectName" 
      (strcat (GetDottedPairValueUtils "project1" allDrawLabelData) 
              (GetDottedPairValueUtils "project2l1" allDrawLabelData) 
              (GetDottedPairValueUtils "project2l2" allDrawLabelData)) 
    )
  )
)

; Export All Type Data Utils Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;