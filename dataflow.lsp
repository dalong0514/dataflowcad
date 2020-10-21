;冯大龙编于 2020 年
(princ "\n数据流一体化开发者：冯大龙、谢雨东、华雷、曾涵卫、靳淳、陈杰，版本号V-1.0")
(vl-load-com)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo (/ versionInfo)
  (setq versionInfo "最新版本号 V1.0，更新时间：2020-10-27")
  (alert versionInfo)(princ)
)

; basic Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Get Constant Data

(defun GetPipePropertyNameList ()
  '("PIPENUM" "SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "FROM" "TO" "DRAWNUM" "INSULATION")
)

(defun GetInstrumentPropertyNameList ()
  '("FUNCTION" "TAG" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION")
)

(defun GetPropertyNameListStrategy (dataType / propertyNameList)
  (if (= dataType "Pipe") 
    (setq propertyNameList (GetPipePropertyNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
  )
  ; must give the return
  propertyNameList
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
  (vlax-put-property obj 'type 2);1-二进制读取，2-文本读取
  (vlax-put-property obj 'mode 3);1-读，2-写，3-读写
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
  (vlax-invoke obj 'flush);将缓存中的数据强制输出
  (vlax-invoke obj 'close)
  (vlax-release-object obj)
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

(defun GetssEntityNameListUtils (ss / i ssEntityNameList)
  (if (/= ss nil)
    (progn
      (setq ssEntityNameList '())
      (setq i 0)
      (repeat (sslength ss)
        (append ssEntityNameList (list (ssname ss i)))
        (setq i (+ i 1))
      )
      ssEntityNameList
    )
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
  (setq entityNameList '())
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

(defun WriteDataToCSVByEntityNameListStrategy (entityNameList dataType /)
  (if (= dataType "Pipe") 
    (WritePipeDataToCSVByEntityNameListUtils entityNameList)
  )
  (if (= dataType "Instrument") 
    (WriteInstrumentDataToCSVByEntityNameListUtils entityNameList)
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
  (ReadDataFromCSVUtils fileDir)
)

(defun ReplaceAllStirngOfListUtils (newStr originList / i newList)
  (setq newList '())
  (setq i 0)
  (repeat (length originList)
    (setq newList (append newList (list newStr)))
    (setq i (+ i 1))
  )
  newList
)

(defun ReplaceSubstOfListByPatternUtils (newStr pattern originList / i newList)
  (setq newList '())
  (setq i 0)
  (repeat (length originList)
    (setq newList (append newList (list 
                                    (StringSubstUtils newStr pattern (nth i originList))
                                  )))
    (setq i (+ i 1))
  )
  newList
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

(defun numberedStringSubstUtil (newString originString / index replacedSubstring)
  (setq index (vl-string-search "-" originString))
  (setq replacedSubstring (substr originString 1 index))
  (StringSubstUtils newString replacedSubstring originString)
)

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

(defun GetIndexforSearchMemberInListUtils (searchedMember searchedList / searchedList i matchedIndex)
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
(defun ReplaceListItemByindexUtils (newItem index originList / i)
    (setq i -1)
    (mapcar '(lambda ( x ) (if (= (setq i (1+ i)) index) newItem x)) originList)
)
; Utils Function 
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

(defun ExportBlockProperty (dataTypeList / dcl_id fileName currentDir fileDir exportDataType)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog "exportBlockPropertyDataBox" dcl_id "" '(-1 -1))
    ; Add the actions to the button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    ; Set the default value
    (set_tile "fileName" "fileName")
    (set_tile "exportDataType" "0")
    (mode_tile "fileName" 2)
    (mode_tile "exportDataType" 2)
    (action_tile "fileName" "(setq fileName $value)")
    (action_tile "exportDataType" "(setq exportDataType $value)")
    ; init the default value list box
    (if (= nil exportDataType)
      (setq exportDataType "0")
    )
    ; export data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq dataType (nth (atoi exportDataType) dataTypeList))
        (ExportDataByDataType fileName dataType)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun c:exportBlockPropertyData (/ dataTypeList)
  (setq dataTypeList '("Pipe" "Instrument" "Electric"))
  (ExportBlockProperty dataTypeList)
)

(defun ExportDataByDataType (fileName dataType /) 
  (if (= dataType "Pipe") 
    (ExportPipeData fileName)
  )
  (if (= dataType "Instrument") 
    (ExportInstrumentData fileName)
  )
)

(defun GetExportDataFileDir (fileName / currentDir fileDir)
  (setq currentDir (getvar "dwgprefix"))
  (setq fileDir (strcat currentDir fileName ".txt"))
)

(defun ExportPipeData (fileName / fileDir f)
  (setq fileDir (GetExportDataFileDir fileName))
  (setq f (open fileDir "w"))
  (ExtractPipeToText)
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

(defun c:gsinstrument (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  ; do not know why f can not be a arg of the GsExtractGs2InstrumentToText--20201011
  (ExtractInstrumentToText)
  (ExtractPipeToText)
  (ExtractEquipToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:gspipe (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (ExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:gsouterpipe (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (ExtractOuterPipeToText)
  (ExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:gsequipment (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (ExtractEquipToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:gselectric (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (ExtractElectricEquipToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
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
; function for propertyPairNameList

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

; function for propertyPairNameList
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; Generate Entity in CAD

(defun c:EquipTag (/ insPt equipInfoList equipTag equipName i tag name)
  (setvar "ATTREQ" 1)
  (setvar "ATTDIA" 0)
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  (setq equipTag (car equipInfoList))
  (setq equipName (nth 1 equipInfoList))
  (setq insPt (getpoint "\n选取设备位号的插入点："))
  (setq i 0)
  (repeat (length equipTag) 
    (setq tag (nth i equipTag))
    (setq name (nth i equipName))
    (InsertEquipTag (GetInsertPt insPt i) tag name)
    (setq i (+ 1 i))
  )
  (setvar "ATTREQ" 0)
)

; get the new inserting position
(defun GetInsertPt (insPt i / xPosition yPosition newInsPt)
  (setq xPosition (+ (nth 0 insPt) (* i 30)))
  (setq yPosition (nth 1 insPt))
  (setq newInsPt (list xPosition yPosition))
)

(defun InsertEquipTag (insPt tag name / )
  (command "-insert" "EquipTag" insPt 1 1 0 tag name)
)

(defun GetEquipTagList (ss / i ent blk entx value equipInfoList equipTag equipName)
  (if (/= ss nil)
    (progn
      (setq i 0)
      (setq equipTag '())
      (setq equipName '())
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
  (setq equipInfoList (list equipTag equipName))
)

; Generate Entity in CAD
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for modify data

(defun c:modifyPipeProperty (/ pipePropertyNameList)
  (setq pipePropertyNameList (GetPipePropertyNameList))
  (filterAndModifyBlockPropertyByBox pipePropertyNameList "filterAndModifyPipePropertyBox" "Pipe")
)

(defun c:modifyKsProperty (/ instrumentPropertyNameList)
  (setq instrumentPropertyNameList (GetInstrumentPropertyNameList))
  (filterAndModifyBlockPropertyByBox instrumentPropertyNameList "filterAndModifyInstrumentPropertyBox" "Instrument")
)

(defun c:modifyEquipmentProperty (/ equipmentPropertyNameListList dataTypeList)
  (setq equipmentPropertyNameListList (GetInstrumentPropertyNameList))
  (filterAndModifyBlockPropertyByBox equipmentPropertyNameListList "filterAndModifyEquipmentPropertyBox" dataTypeList)
)

(defun c:foo (/ ss entityNameList)
  (setq ss (ssget))
  (setq entityNameList (GetEntityNameListBySSUtils ss))
  (RemoveFirstCharOfItemInListUtils '("'jdoit,edh" "'dhjfhu,iuid"))
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
    (action_tile "propertyName" "(setq propertyName $value)")
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "filterPropertyName" "(setq filterPropertyName $value)")
    (action_tile "viewPropertyName" "(setq viewPropertyName $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
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
        (if (/= propertyValue "") 
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
; Gs Field
; function for modify data

(defun ModifyPropertyValueBySS (ss selectedName property_value / i ent blk entx value)
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
              (if (= value selectedName)
                (progn
                  (setq a (cons 1 property_value))
                  (setq b (assoc 1 entx))
                  (entmod (subst a b entx))
                )
              )
	            ; get the next property information
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (princ)
      )
    )
  )
)

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

(defun SpliceElementInTwoListUtils (firstList secondList / newList i)
  (setq newList '())
  (setq i 0)
  (repeat (length firstList)
    (setq newList (append newList (list (strcat (nth i firstList) (nth i secondList)))))
    (setq i (+ i 1))
  )
  newList
)

(defun GetPropertyValueByEntityName (entityNameList selectedName / i ent blk entx propertyName aPropertyValueList)
  (setq i 0)
  (setq aPropertyValueList '())
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
        (setq aPropertyValueList (append aPropertyValueList (list (cdr (assoc 1 entx)))))
      )
      ; get the next property information
      (setq entx (entget (entnext (cdr (assoc -1 entx)))))
    )
    (entupd blk)
    (setq i (+ 1 i))
  )
  aPropertyValueList
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
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;




;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; Number Pipeline, Instrument and Equipment

(defun c:numberPipelineAndTag (/ dataTypeList)
  (setq dataTypeList '("Pipe" "InstrumentP" "InstrumentL" "InstrumentSIS" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip"))
  (numberPipelineAndTagByBox dataTypeList "filterAndNumberBox" "Pipe")
)

(defun numberPipelineAndTagByBox (propertyNameList tileName dataType / dcl_id propertyValue filterPropertyName patternValue replacedSubstring status selectedName selectedFilterName selectedDataType ss sslen matchedList previewList confirmList blockDataList APropertyValueList entityNameList modifyMessageStatus dataChildrenType)
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
    (mode_tile "propertyValue" 2)
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "filterPropertyName" "(setq filterPropertyName $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    (action_tile "dataChildrenType" "(setq dataChildrenType $value)")
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

    (if (/= selectedDataType nil)
      (set_tile "filterPropertyName" filterPropertyName)
    )
    
    (if (= modifyMessageStatus 0)
      (set_tile "resultMsg" "请先预览修改")
    )
    
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (set_tile "filterPropertyName" filterPropertyName)
        (set_tile "patternValue" patternValue)
        (set_tile "replacedSubstring" replacedSubstring)
        (set_tile "propertyValue" propertyValue)
        (set_tile "dataChildrenType" dataChildrenType)
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
        (setq previewList (GetPropertyValueByEntityName entityNameList selectedName))
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
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun GetInstrumentFunctionTagByType (dataChildrenType ss / blockDataList)
  (if (= dataChildrenType "0") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "T*"))
  )
  (if (= dataChildrenType "1") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "P*"))
  )
  (if (= dataChildrenType "2") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "L*"))
  )
  (if (= dataChildrenType "3") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "F*"))
  )
  (if (= dataChildrenType "4") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "F*"))
  )
  (if (= dataChildrenType "5") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "F*"))
  )
  (if (= dataChildrenType "6") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "XV*"))
  )
  (if (= dataChildrenType "7") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "TV*"))
  )
  (if (= dataChildrenType "8") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "PV*"))
  )
  (if (= dataChildrenType "9") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "LV*"))
  )
  (if (= dataChildrenType "10") 
    (setq blockDataList (GetInstrumentPropertyDataListByFunctionPattern ss "FV*"))
  )
  blockDataList
)

; Number Pipeline, Instrument and Equipment
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;