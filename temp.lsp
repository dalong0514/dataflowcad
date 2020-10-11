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
; test zoom

(defun c:sstest (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  ; do not know why f can not be a arg of the GsExtractGs2InstrumentToText--20201011
  (GsExtractInstrumentToText)
  (GsExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

; test zoom
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field



; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for extract data

(defun c:gspipe (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (GsExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:gsouterpipe (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (GsExtractOuterPipeToText)
  (GsExtractPipeToText)
  (close f)
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

(defun c:sspipe (/ fn f)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (GsExtractCentrifugeEquipToText)
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

(defun GsExtractInstrumentToText ()
  (GsExtractInstrumentPToText)
  (GsExtractInstrumentLToText)
  (GsExtractInstrumentSISToText)
)

(defun GsExtractInstrumentPToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentP"))))
  (setq propertyPairNameList (GsGetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "concentrated"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun GsExtractInstrumentLToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentL"))))
  (setq propertyPairNameList (GsGetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "location"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun GsExtractInstrumentSISToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "InstrumentSIS"))))
  (setq propertyPairNameList (GsGetInstrumentPropertyPairNameList))
  (setq lastPropertyPair '("DIRECTION" "direction"))
  (setq classValuePair '("class" "sis"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun GsExtractPipeToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (GetAllPipeSSUtils))
  (setq propertyPairNameList (GsGetPipePropertyPairNameList))
  (setq lastPropertyPair '("INSULATION" "insulation"))
  (setq classValuePair '("class" "pipeline"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun GsExtractOuterPipeToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (GetAllOuterPipeSSUtils))
  (setq propertyPairNameList (GsGetOuterPipePropertyPairNameList))
  (setq lastPropertyPair '("PROTECTION" "protection"))
  (setq classValuePair '("class" "outerpipe"))
  (ExtractBlockPropertyUtils f ss propertyPairNameList lastPropertyPair classValuePair)
)

(defun GsExtractCentrifugeEquipToText (/ ss propertyPairNameList lastPropertyPair classValuePair)
  (setq ss (ssget "X" '((0 . "INSERT") (2 . "Centrifuge"))))
  (setq propertyPairNameList (GsGetCentrifugeEquipPropertyPairNameList))
  (setq lastPropertyPair '("NUMBER" "number"))
  (setq classValuePair '("class" "centrifuge"))
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

(defun GsGetInstrumentPropertyPairNameList (/ propertyPairNameList)
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

(defun GsGetPipePropertyPairNameList (/ propertyPairNameList)
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

(defun GsGetOuterPipePropertyPairNameList (/ propertyPairNameList)
  (setq propertyPairNameList '(
                            ("PIPENUM" "pipenum")
                            ("FROMTO" "fromto")
                            ("DRAWNUM" "drawnum")
                            ("DESIGNFLOW" "designflow")
                            ("OPERATESPEC" "operatespec")
                            ("INSULATION" "insulation")
                           ))
)

(defun GsGetCentrifugeEquipPropertyPairNameList (/ propertyPairNameList)
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
; function for propertyPairNameList
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;








; write the proptery of block to txt
(defun writeProperty (value captialName lowerName entx f / proptery)
  (if (= value captialName)
    (progn
      (setq proptery (cdr (assoc 1 entx)))
      (princ (strcat "\"" lowerName "\": \"" proptery "\",") f)
    )
  )
)

; command for modify the property of a Instrument block
(defun c:modifyKsProperty ()
  (modifyBlockProperty "modifyInstrumentProperty" "Instrument")
)

(defun c:modifyPipeProperty ()
  (modifyBlockProperty "modifyPipeProperty" "Pipe")
)

(defun modifyBlockProperty (tileName blockSSName / dcl_id property_name property_value status selectedName ss)
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
  (setq ss (GetBlockSS "Equipment"))
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

; the command for extarcting data from globalVentilation Block
(defun c:nsglobal (/ fn f ssRoom ssSubstance ssHotWet)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (setq ssRoom (ssget "x" '((0 . "INSERT") (2 . "RoomData"))))
  (setq ssSubstance (ssget "x" '((0 . "INSERT") (2 . "SubstanceData"))))
  (setq ssHotWet (ssget "x" '((0 . "INSERT") (2 . "HotWetData"))))
  (ExtactGlobalRoom f ssRoom)
  (ExtactGlobalSubstance f ssSubstance)
  (ExtactGlobalHotWet f ssHotWet)
  (close f)
  ; tansfor the encode
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)


; the command for extarcting data from InstrumentP/InstrumentL Block
(defun c:gsinstrument (/ fn f ssP ssL)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (setq ssP (ssget "x" '((0 . "INSERT") (2 . "InstrumentP"))))
  (setq ssL (ssget "x" '((0 . "INSERT") (2 . "InstrumentL"))))
  (setq ssLeft (ssget "x" '((0 . "INSERT") (2 . "PipeArrowLeft"))))
  (setq ssUp (ssget "x" '((0 . "INSERT") (2 . "PipeArrowUp"))))
  (setq ssReactor (ssget "x" '((0 . "INSERT") (2 . "Reactor"))))
  (setq ssPump (ssget "x" '((0 . "INSERT") (2 . "Pump"))))
  (setq ssTank (ssget "x" '((0 . "INSERT") (2 . "Tank"))))
  (setq ssHeater (ssget "x" '((0 . "INSERT") (2 . "Heater"))))
  (setq ssCentrifuge (ssget "x" '((0 . "INSERT") (2 . "Centrifuge"))))
  (setq ssVacuum (ssget "x" '((0 . "INSERT") (2 . "Vacuum"))))
  (setq ssCustomEquip (ssget "x" '((0 . "INSERT") (2 . "CustomEquip"))))
  (ExtactInstrumentP f ssP)
  (ExtactInstrumentL f ssL)
  (ExtactPipeArrow f ssLeft)
  (ExtactPipeArrow f ssUp)
  (ExtactReactor f ssReactor)
  (ExtactPump f ssPump)
  (ExtactTank f ssTank)
  (ExtactHeater f ssHeater)
  (ExtactCentrifuge f ssCentrifuge)
  (ExtactVacuum f ssVacuum)
  (ExtactCustomEquip f ssCustomEquip)
  (close f)
  ; tansfor the encode
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

; the command for extarcting data from Equipment Block
(defun c:gsequipment (/ fn f ssReactor ssPump ssTank ssHeater ssCentrifuge ssVacuum ssCustom)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (setq ssReactor (ssget "x" '((0 . "INSERT") (2 . "Reactor"))))
  (setq ssPump (ssget "x" '((0 . "INSERT") (2 . "Pump"))))
  (setq ssTank (ssget "x" '((0 . "INSERT") (2 . "Tank"))))
  (setq ssHeater (ssget "x" '((0 . "INSERT") (2 . "Heater"))))
  (setq ssCentrifuge (ssget "x" '((0 . "INSERT") (2 . "Centrifuge"))))
  (setq ssVacuum (ssget "x" '((0 . "INSERT") (2 . "Vacuum"))))
  (setq ssCustomEquip (ssget "x" '((0 . "INSERT") (2 . "CustomEquip"))))
  (ExtactReactor f ssReactor)
  (ExtactPump f ssPump)
  (ExtactTank f ssTank)
  (ExtactHeater f ssHeater)
  (ExtactCentrifuge f ssCentrifuge)
  (ExtactVacuum f ssVacuum)
  (ExtactCustomEquip f ssCustomEquip)
  (close f)
  ; tansfor the encode
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

; extarcting data from Equipment Block for electric condition
(defun c:gselectric (/ fn f ssReactor ssPump ssCentrifuge ssVacuum)
  (setq fn (GetCurrentDirByBoxUtils))
  (setq f (open fn "w"))
  (setq ssReactor (ssget "x" '((0 . "INSERT") (2 . "Reactor"))))
  (setq ssPump (ssget "x" '((0 . "INSERT") (2 . "Pump"))))
  (setq ssCentrifuge (ssget "x" '((0 . "INSERT") (2 . "Centrifuge"))))
  (setq ssVacuum (ssget "x" '((0 . "INSERT") (2 . "Vacuum"))))
  (ExtactReactor f ssReactor)
  (ExtactPump f ssPump)
  (ExtactCentrifuge f ssCentrifuge)
  (ExtactVacuum f ssVacuum)
  (close f)
  ; tansfor the encode
  (FileEncodeTransUtils fn "gb2312" "utf-8")
  (alert "数据提取成功")(princ)
)

; extarct data form Centrifuge Block
(defun ExtactCentrifuge (f ss / N index i ent blk entx value number)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "VOLUME" "volumn" entx f)
              (writeProperty value "CAPACITY" "capacity" entx f)
              (writeProperty value "DIAMETER" "diameter" entx f)
              (writeProperty value "SPEED" "speed" entx f)
              (writeProperty value "FACTOR" "factor" entx f)
              (writeProperty value "DIAMETER" "diameter" entx f)
	      (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (if (= value "NUMBER")
                (progn
                  (setq number (cdr (assoc 1 entx)))
		  (princ (strcat "\"class\": \"" "centrifuge" "\",") f)
                  (princ (strcat "\"number\": \"" number "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form Vacuum Block
(defun ExtactVacuum (f ss / N index i ent blk entx value number)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)              
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "CAPACITY" "capacity" entx f)
              (writeProperty value "EXPRESSURE" "expressure" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (if (= value "NUMBER")
                (progn
                  (setq number (cdr (assoc 1 entx)))
		  (princ (strcat "\"class\": \"" "vacuum" "\",") f)
                  (princ (strcat "\"number\": \"" number "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form Heater Block
(defun ExtactHeater (f ss / N index i ent blk entx value number)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "AREA" "area" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "ELEMENT" "element" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (writeProperty value "INSULATIONTHICK" "insulationthick" entx f)
              (if (= value "NUMBER")
                (progn
                  (setq number (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "heater" "\",") f)
                  (princ (strcat "\"number\": \"" number "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form Tank Block
(defun ExtactTank (f ss / N index i ent blk entx value expressure)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "VOLUME" "volumn" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (writeProperty value "INSULATIONTHICK" "insulationthick" entx f)
              (writeProperty value "NUMBER" "number" entx f)
              (writeProperty value "EXTEMP" "extemp" entx f)
              (if (= value "EXPRESSURE")
                (progn
                  (setq expressure (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "tank" "\",") f)
                  (princ (strcat "\"expressure\": \"" expressure "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form Pump Block
(defun ExtactPump (f ss / N index i ent blk entx value equiptype)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
	      (writeProperty value "FLOW" "flow" entx f)
              (writeProperty value "HEAD" "head" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "NUMBER" "number" entx f)
              (if (= value "TYPE")
                (progn
                  (setq equiptype (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "pump" "\",") f)
                  (princ (strcat "\"type\": \"" equiptype "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form Reactor Block
(defun ExtactReactor (f ss / N index i ent blk entx value expressure)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "VOLUME" "volumn" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "SPEED" "speed" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (writeProperty value "INSULATIONTHICK" "insulationthick" entx f)
              (writeProperty value "NUMBER" "number" entx f)
              (writeProperty value "EXTEMP" "extemp" entx f)
              (if (= value "EXPRESSURE")
                (progn
                  (setq expressure (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "reactor" "\",") f)
                  (princ (strcat "\"expressure\": \"" expressure "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form CustomEquip Block
(defun ExtactCustomEquip (f ss / N index i ent blk entx value number)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "SPECIES" "first_spec" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "ANTIEXPLOSIVE" "is_antiexplosive" entx f)
              (writeProperty value "MOTORSERIES" "motorseries" entx f)
              (writeProperty value "PARAM1" "param1" entx f)
              (writeProperty value "PARAM2" "param2" entx f)
              (writeProperty value "PARAM3" "param3" entx f)
              (writeProperty value "PARAM4" "param4" entx f)
              (writeProperty value "SIZE" "size" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "WEIGHT" "weight" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (writeProperty value "INSULATIONTHICK" "insulationthick" entx f)
              (if (= value "NUMBER")
                (progn
                  (setq number (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "custom" "\",") f)
                  (princ (strcat "\"number\": \"" number "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form InstrumentL Block
(defun ExtactInstrumentL (f ss / N index i ent blk entx value nomal)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "FUNCTION" "function" entx f)
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
	      (writeProperty value "SORT" "sort" entx f)
              (writeProperty value "PHASE" "phase" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "LOCATION" "location" entx f)
              (writeProperty value "MIN" "minvalue" entx f)
              (writeProperty value "MAX" "maxvalue" entx f)
	      (writeProperty value "NOMAL" "nomal" entx f)
	      (writeProperty value "DRAWNUM" "drawnum" entx f)
	      (writeProperty value "COMMENT" "comment" entx f)
	      (writeProperty value "INSTALLSIZE" "installsize" entx f)
              (if (= value "DIRECTION")
                (progn
                  (setq direction (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "location" "\",") f)
                  (princ (strcat "\"direction\": \"" direction "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form InstrumentP Block
(defun ExtactInstrumentP (f ss / N index i ent blk entx value nomal)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "FUNCTION" "function" entx f)
              (writeProperty value "TAG" "tag" entx f)
              (writeProperty value "HALARM" "halarm" entx f)
              (writeProperty value "LALARM" "lalarm" entx f)
              (writeProperty value "SUBSTANCE" "substance" entx f)
              (writeProperty value "TEMP" "temp" entx f)
              (writeProperty value "PRESSURE" "pressure" entx f)
	      (writeProperty value "SORT" "sort" entx f)
              (writeProperty value "PHASE" "phase" entx f)
              (writeProperty value "MATERIAL" "material" entx f)
              (writeProperty value "NAME" "name" entx f)
              (writeProperty value "LOCATION" "location" entx f)
              (writeProperty value "MIN" "minvalue" entx f)
              (writeProperty value "MAX" "maxvalue" entx f)
	      (writeProperty value "NOMAL" "nomal" entx f)
	      (writeProperty value "DRAWNUM" "drawnum" entx f)
	      (writeProperty value "COMMENT" "comment" entx f)
	      (writeProperty value "INSTALLSIZE" "installsize" entx f)
              (if (= value "DIRECTION")
                (progn
                  (setq direction (cdr (assoc 1 entx)))
                  (princ (strcat "\"class\": \"" "concentrated" "\",") f)
                  (princ (strcat "\"direction\": \"" direction "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form HotWetData Block
(defun ExtactGlobalHotWet (f ss / N index i ent blk entx value water_temp)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "ROOM_NUM" "room_num" entx f)
              (writeProperty value "EQUIPMENT_NUM" "equipment_num" entx f)
              (writeProperty value "TYPE" "type" entx f)
              (writeProperty value "AIR_EXHAUST" "air_exhaust" entx f)
              (writeProperty value "PRESERVE_HEAT" "preserve_heat" entx f)
              (writeProperty value "POWER" "power" entx f)
              (writeProperty value "SURFACE_AREA" "surface_area" entx f)
              (writeProperty value "SURFACE_TEMP" "surface_temp" entx f)
              (writeProperty value "WATER_AREA" "water_area" entx f)
              (if (= value "WATER_TEMP")
                (progn
                  (setq water_temp (cdr (assoc 1 entx)))
                  (princ (strcat "\"block_data\": \"" "hotwet" "\",") f)
                  (princ (strcat "\"water_temp\": \"" water_temp "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form SubstanceData Block
(defun ExtactGlobalSubstance (f ss / N index i ent blk entx value compress_num)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "ROOM_NUM" "room_num" entx f)
              (writeProperty value "SUBSTANCE_NAME" "substance_name" entx f)
              (writeProperty value "VALUE_NUM" "value_num" entx f)
              (writeProperty value "PUMPSEAL_NUM" "pumpseal_num" entx f)
              (writeProperty value "FLANGE_NUM" "flange_num" entx f)
              (writeProperty value "DISCHARGE_NUM" "discharge_num" entx f)
              (writeProperty value "SAFETY_NUM" "safety_num" entx f)
              (if (= value "COMPRESS_NUM")
                (progn
                  (setq compress_num (cdr (assoc 1 entx)))
                  (princ (strcat "\"block_data\": \"" "substance" "\",") f)
                  (princ (strcat "\"compress_num\": \"" compress_num "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

; extarct data form RoomData Block
(defun ExtactGlobalRoom (f ss / N index i ent blk entx value winter_rehumidity)
  (if (/= ss nil)
    (progn
      (setq N (sslength ss))
      (setq index 0)
      (setq i index)
      (repeat N
        (if (/= nil (ssname ss i))
          (progn
            (princ "{" f)
            (setq ent (entget (ssname ss i)))
            (setq blk (ssname ss i))
            (setq entx (entget (entnext (cdr (assoc -1 ent)))))
            (while (= "ATTRIB" (cdr (assoc 0 entx)))
              (setq value (cdr (assoc 2 entx)))
              (writeProperty value "ROOM_NUM" "room_num" entx f)
              (writeProperty value "ROOM_NAME" "room_name" entx f)
              (writeProperty value "ROOM_AREA" "room_area" entx f)
              (writeProperty value "ROOM_HEIGHT" "room_height" entx f)
              (writeProperty value "ROOM_PRESSURE" "room_pressure" entx f)
              (writeProperty value "SUMMER_TEMP" "summer_temp" entx f)
              (writeProperty value "SUMMER_REHUMIDITY" "summer_rehumidity" entx f)
              (writeProperty value "WINTER_TEMP" "winter_temp" entx f)
              (if (= value "WINTER_REHUMIDITY")
                (progn
                  (setq winter_rehumidity (cdr (assoc 1 entx)))
                  (princ (strcat "\"block_data\": \"" "room" "\",") f)
                  (princ (strcat "\"winter_rehumidity\": \"" winter_rehumidity "\"") f)
                )
              )
              ; 下面的语句必须设置，否则无限写数据
              (setq entx (entget (entnext (cdr (assoc -1 entx)))))
            )
            (princ "}\n" f)
            (entupd blk)
            (setq i (+ 1 i))
          )
        )
        (setq index (+ 1 index))
        (princ)
      )
    )
  )
)

