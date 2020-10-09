;冯大龙编于2020年
(princ "\n数据流一体化开发者：冯大龙、谢雨东、华雷、靳淳、陈杰，版本号V-0.4")
(vl-load-com)

; command for modify the property of a Instrument block
(defun c:modifyKsProperty (/ dcl_id property_name property_value status selectedName ss)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
  (if (not (new_dialog "modifyBlockProperty" dcl_id))
    (exit)
  )
  
  (set_tile "property_value" "");the default value of input box
  (mode_tile "property_value" 2)
  (action_tile "property_name" "(setq property_name $value)")
  (action_tile "property_value" "(setq property_value $value)")

  (setq status (start_dialog))
  (unload_dialog dcl_id)
  
  (if (= status 1)
    (progn 
      (setq selectedName (getKsPropertyName property_name))
      (setq ss (GetInstrumentSS))
      ;(setq ss (ssget '((0 . "INSERT") (2 . "InstrumentP"))))
      (ModifyPropertyValue ss selectedName property_value)
      (alert "更新数据成功")(princ)
    )
    (alert "取消选择")
  )
)

; get the property name of the instrument block
(defun getKsPropertyName (property_name / propertyNameList selectedName)
  (setq propertyNameList '((0 . "DRAWNUM")
                          (1 . "SUBSTANCE")
                          (2 . "TEMP")
                          (3 . "PRESSURE")))
  (setq selectedName (cdr (assoc (atoi property_name) propertyNameList)))
)

; get the select set of instrument
(defun GetInstrumentSS ()
  (setq ss (ssget '((0 . "INSERT") 
		    (-4 . "<OR")
		      (2 . "InstrumentP")
		      (2 . "InstrumentL")
		    (-4 . "OR>")
		   )
	   )
  )
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






(defun c:testEquipTag (/ insPt equipInfoList equipTag equipName i tag name)
  (setvar "ATTREQ" 1)
  (setq ss (GetEquipSS))
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

; get the select set of equipment
(defun GetEquipSS ()
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



