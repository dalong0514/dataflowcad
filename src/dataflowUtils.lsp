;冯大龙编于 2020-2021 年
(vl-load-com)

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

(defun GetSelectedEntityDataUtils (ss /)
  (mapcar '(lambda (x) (entget x)) 
    (GetEntityNameListBySSUtils ss)
  )
)

(defun GetEntityDataUtils ()
  ;(entget (car (entsel)))
  (car (GetSelectedEntityDataUtils (ssget)))
)

(defun GetBlockNameBySelectUtils (/ entityName) 
  (setq entityName (car (GetEntityNameListBySSUtils (ssget '((0 . "INSERT"))))))
  (cdr (assoc 2 (entget entityName)))
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

(defun GetInstrumentPipeEquipSSUtils ()
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

(defun GetInstrumentPipeEquipSSBySelectUtils ()
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

(defun GetAllPublicPipeLineSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "PublicPipeUpPipeLine")
          (2 . "PublicPipeDownPipeLine")
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

(defun GetInstrumentAndPipeAndPipeClassChangeSSBySelectUtils ()
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

(defun GetInstrumentAndPipeAndReducerSSBySelectUtils ()
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

(defun GetAllDrawLabelSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "title.2017")
          (2 . "title")
          (2 . "TITLE_20170")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetDrawLabelSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") 
        (-4 . "<OR")
          (2 . "title.2017")
          (2 . "title")
          (2 . "TITLE_20170")
        (-4 . "OR>")
      )
    )
  )
)

(defun GetTextSSBySelectUtils ()
  (ssget '((0 . "TEXT")))
)

; 2021-02-02
(defun GetAllRawFireFightVPipeSSUtilsV1 ()
  (setq ss (ssget "X" '((0 . "ARC") (8 . "VPIPE-消防"))))
)

; 2021-02-0
(defun GetAllRawFireFightVPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "TCH_PIPE") (8 . "VPIPE-消防"))))
)

; 2021-02-02
(defun GetRawFireFightVPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "TCH_PIPE") (8 . "VPIPE-消防"))))
)

; 2021-02-02
(defun GetAllFireFightVPipeSSUtils ()
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "FireFightHPipe"))))
)

; 2021-02-02
(defun GetFireFightVPipeSSBySelectUtils ()
  (setq ss (ssget '((0 . "INSERT") (2 . "FireFightHPipe"))))
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
  (if (= dataType "DrawLabel")
    (setq ss (GetDrawLabelSSBySelectUtils))
  ) 
  (if (= dataType "InstrumentAndPipeAndPipeClassChange")
    (setq ss (GetInstrumentAndPipeAndPipeClassChangeSSBySelectUtils))
  )
  (if (= dataType "InstrumentAndPipeAndReducer")
    (setq ss (GetInstrumentAndPipeAndReducerSSBySelectUtils))
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
  (if (= dataType "JoinDrawArrowTo")
    (setq ss (ssget '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
  ) 
  (if (= dataType "JoinDrawArrowFrom")
    (setq ss (ssget '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
  )  
  (if (= dataType "GsCleanAir")
    (setq ss (ssget '((0 . "INSERT") (2 . "GsCleanAir"))))
  )   
  (if (= dataType "PipeClassChange")
    (setq ss (ssget '((0 . "INSERT") (2 . "PipeClassChange"))))
  ) 
  (if (= dataType "Reducer")
    (setq ss (ssget '((0 . "INSERT") (2 . "Reducer"))))
  )  
  (if (= dataType "FireFightHPipe")
    (setq ss (ssget '((0 . "INSERT") (2 . "FireFightHPipe"))))
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
  (if (= dataType "PublicPipeLine")
    (setq ss (GetAllPublicPipeLineSSUtils))
  ) 
  (if (= dataType "DrawLabel")
    (setq ss (GetAllDrawLabelSSUtils))
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
  (if (= dataType "JoinDrawArrowTo")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowTo"))))
  ) 
  (if (= dataType "JoinDrawArrowFrom")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "JoinDrawArrowFrom"))))
  ) 
  (if (= dataType "PublicPipeUpArrow")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "PublicPipeUpArrow"))))
  ) 
  (if (= dataType "PublicPipeDownArrow")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "PublicPipeDownArrow"))))
  ) 
  (if (= dataType "GsCleanAir")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "GsCleanAir"))))
  ) 
  (if (= dataType "PipeClassChange")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "PipeClassChange"))))
  ) 
  (if (= dataType "Reducer")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "Reducer"))))
  ) 
  (if (= dataType "FireFightPipe")
    (setq ss (ssget "X" '((0 . "INSERT") (2 . "FireFightHPipe"))))
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

(defun GetAllPropertyDictList (entityNameList / propertyNameList resultList) 
  ; entityhandle will have been added twice, delete it first
  (setq propertyNameList (cdr (GetBlockPropertyNameListByEntityNameUtils (car entityNameList))))
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
  (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Pipe")))
)

(defun GetAllEquipDataUtils () 
  (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Equipment")))
)

; 2021-02-23
(defun GetAllFireFightPipeDataUtils () 
  (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "FireFightPipe")))
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

; 2021-02-26
(defun DeleteEntityBySSUtils (ss /) 
  (mapcar '(lambda (x) 
             (entdel x)
             (princ)
           ) 
    (GetEntityNameListBySSUtils ss) 
  ) 
  (princ)
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

; Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate CAD Graph Utils Function 

; 2021-02-02
(defun GenerateLineByPosition (firstPt secondPt lineLayer /)
  (entmake (list (cons 0 "LINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 lineLayer) (cons 100 "AcDbText") 
                  (cons 10 firstPt) (cons 11 secondPt) (cons 210 '(0.0 0.0 1.0)) 
             )
  )(princ)
)

; 2021-02-02
(defun GenerateVerticallyTextByPositionAndContent (insPt textContent textLayer textHeight /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 textLayer) (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 textHeight) (cons 1 textContent) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "DataFlow") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

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

; 2021-03-05
(defun GenerateVerticalPolyline (insPt blockLayer lineWidth /)
  (entmake 
    (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 62 3) (cons 100 "AcDbPolyline") 
          (cons 90 2) (cons 70 0) (cons 43 lineWidth) (cons 38 0.0) (cons 39 0.0) 
          (cons 10 (MoveInsertPosition insPt 0 50)) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 10 insPt) (cons 40 lineWidth) (cons 41 lineWidth) (cons 42 0.0) (cons 91 0) 
          (cons 210 '(0.0 0.0 1.0))
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

; directionStatus: dxfcode 50; 0 水平方向 - 1.57 垂直方向
; hiddenStatus dxfcode 70; 0 可见 - 1 隐藏
; moveStatus: dxfcode 280; 1 固定 - 0 可移动
(defun GenerateCenterBlockAttribute (insPt propertyName propertyValue blockLayer textHeight directionStatus hiddenStatus moveStatus /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 (MoveInsertPosition insPt -5.8 0)) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 directionStatus) 
          (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 1) (cons 11 insPt) (cons 210 '(0.0 0.0 1.0)) 
          (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 hiddenStatus) (cons 73 0) (cons 74 0) (cons 280 moveStatus)
    )
  )
  (princ)
)

(defun GenerateLeftBlockAttribute (insPt propertyName propertyValue blockLayer textHeight directionStatus hiddenStatus moveStatus /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 directionStatus) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 hiddenStatus) 
          (cons 73 0) (cons 74 0) (cons 280 moveStatus)
    )
  )
  (princ)
)

(defun GenerateBlockAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 0) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateVerticallyBlockAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) 
          (cons 70 0) (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateBlockHiddenAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 0.0) (cons 41 0.7) (cons 51 0.0) (cons 7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) (cons 70 1) 
          (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

(defun GenerateVerticallyBlockHiddenAttribute (insPt propertyName propertyValue blockLayer textHeight /)
  (entmake 
    (list (cons 0 "ATTRIB") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 blockLayer) (cons 100 "AcDbText") 
          (cons 10 insPt) (cons 40 textHeight) (cons 1 propertyValue) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) (cons  7 "DataFlow") (cons 71 0) (cons 72 0) 
          (cons 11 '(0.0 0.0 0.0)) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbAttribute") (cons 280 0) (cons 2 propertyName) 
          (cons 70 1) (cons 70 1) (cons 73 0) (cons 74 0) (cons 280 0)
    )
  )
  (princ)
)

; 2021-03-07
(defun InsertBlockUtils (insPt blockName layerName / acadObj curDoc insertionPnt modelSpace blockRefObj blockAttributes)
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
  (vla-put-TextString (vlax-safearray-get-element blockAttributes 1) "JC1101-50-2J1")
  ;(vla-ZoomAll acadObj) 
  (princ)
)

(defun c:ssfoo (/ curDoc blocks)
  (setq curDoc (vla-get-activedocument (vlax-get-acad-object))) 
  ; Gets the blocks collection 
  (setq blocks (vla-get-blocks curDoc)) 
  ; Creates a report header 
  (vlax-dump-object blocks T)
  (princ)
)

(defun c:foo ()
  (InsertBlockUtils '(0 0 0) "PipeArrowLeft" "DataFlow-Pipe")
)

; Generate CAD Graph Utils Function 
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

; Read and Write Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;