;冯大龙编于2020年
(princ "\n数据流一体化开发者：冯大龙、谢雨东、华雷、靳淳、陈杰，版本号V-0.7")
(vl-load-com)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo (/ versionInfo)
  (setq versionInfo "最新版本号 V0.7，更新时间：2020-10-10")
  (alert versionInfo)(princ)
)

; basic Function
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

; Utils Function 
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for extract data

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
; the macro for extract data

(defun c:modifyKsProperty ()
  (modifyBlockPropertyByBox "modifyInstrumentProperty" "Instrument")
)

(defun c:modifyPipeProperty ()
  (modifyBlockPropertyByBox "modifyPipeProperty" "Pipe")
)

; Gs Field
; the macro for extract data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


(defun modifyBlockPropertyByBox (tileName blockSSName / dcl_id property_name property_value status selectedName ss)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (if (not (new_dialog tileName dcl_id))
    (exit)
  )
  ; optional setting for the popup_list tile
  (set_tile "property_name" "0")
  ; the default value of input box
  (set_tile "property_value" "")
  (mode_tile "property_name" 2)
  (mode_tile "property_value" 2)
  (action_tile "property_name" "(setq property_name $value)")
  (action_tile "property_value" "(setq property_value $value)")
  (if (= nil property_name)
    (setq property_name "0")
  )

  (setq status (start_dialog))
  (unload_dialog dcl_id)
  
  (if (= status 1)
    (progn 
      (setq selectedName (GetPropertyName property_name blockSSName))
      (setq ss (GetBlockSS blockSSName))
      (ModifyPropertyValue ss selectedName property_value)
      (alert "更新数据成功")(princ)
    )
  )
)

; get the property name of the block
(defun GetPropertyName (property_name blockSSName / propertyNameList selectedName)
  (if (= blockSSName "Pipe")
    (progn
      (setq propertyNameList '((0 . "DRAWNUM")
                              (1 . "PIPENUM")
                              (2 . "SUBSTANCE")
                              (3 . "TEMP")
                              (4 . "PRESSURE")
                              (5 . "PHASE")
                              (6 . "FROM")
                              (7 . "TO")
                              (8 . "INSULATION")))
      ; need to convert the data type of property_name
      (setq selectedName (cdr (assoc (atoi property_name) propertyNameList)))
    )
  )
  (if (= blockSSName "Instrument")
    (progn
      (setq propertyNameList '((0 . "DRAWNUM")
                              (1 . "LOCATION")
                              (2 . "SUBSTANCE")
                              (3 . "TEMP")
                              (4 . "PRESSURE")
                              (5 . "COMMENT")
                              (6 . "PHASE")
                              (7 . "FUNCTION")
                              (8 . "TAG")
                              (9 . "NAME")
                              (10 . "SORT")
                              (11 . "MATERIAL")
                              (12 . "INSTALLSIZE")
                              (13 . "MIN")
                              (14 . "NOMAL")
                              (15 . "MAX")
                              (16 . "DIRECTION")))
      ; need to convert the data type of property_name
      (setq selectedName (cdr (assoc (atoi property_name) propertyNameList)))
    )
  )
  selectedName
)

; get the select set
(defun GetBlockSS (blockSSName / ss)
  ; need to refactor
  (if (= blockSSName "Pipe")
    (progn
      (setq ss (ssget '((0 . "INSERT") 
            (-4 . "<OR")
              (2 . "PipeArrowLeft")
              (2 . "PipeArrowUp")
            (-4 . "OR>")
          )
        )
      )
    )
  )
  (if (= blockSSName "Instrument")
    (progn
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
  )
  (if (= blockSSName "Equipment")
    (progn
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
  )
  ss
)

; modify property value of a block entity
(defun ModifyPropertyValue (ss selectedName property_value / i ent blk entx value)
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
    (InsertEquipTag (GetInsPt insPt i) tag name)
    (setq i (+ 1 i))
  )
  (setvar "ATTREQ" 0)
)

; get the new inserting position
(defun GetInsPt (insPt i / xPosition yPosition newInsPt)
  (setq xPosition (+ (nth 0 insPt) (* i 30)))
  (setq yPosition (nth 1 insPt))
  (setq newInsPt (list xPosition yPosition))
)

; command for insert the equipment tag
(defun InsertEquipTag (insPt tag name / )
  (command "-insert" "EquipTag" insPt 1 1 0 tag name)
)

; modify property value of a block entity
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

