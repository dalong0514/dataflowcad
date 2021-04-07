;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoSS ()
  (alert "最新版本号 V0.1，更新时间：2021-03-08\n数据流内网地址：192.168.1.38")(princ)
)
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; SS

; 2021-02-02
(defun c:GenerateFireFightVPipeText (/ insPt) 
  (princ "\n请选择消火栓平面图中的消防立管：")
  (mapcar '(lambda (x) 
             (GenerateLineByPosition (cadr x) (AddPositonOffSetUtils (cadr x) '(500 -1300 0)) "DataflowFireFightPipe")
             (GenerateOneFireFightHPipe (AddPositonOffSetUtils (cadr x) '(500 -1300 0)) "XHL" (GetFireFightPipeDiameter x) (car x) 350)
          ) 
    (GetRawFireFightPipeDataListBySelect)
  ) 
  (alert "自动生成平面消防立管标注完成！")(princ)
)

; 2021-02-03
(defun GetFireFightPipeDiameter (dataList /)
  (strcat "DN" (RemoveDecimalForStringUtils (rtos (caddr dataList))))
)

; 2021-02-07
(defun c:GenerateFireFightVPipe (/ firstPt ss insPt linePoint textHeight elevation) 
  (princ "\n")
  (initget (+ 1 2 4))
  (setq textHeight (getint "\n请设置字体高度："))
  (setq elevation (getstring "\n请设置自动生成的标高值："))
  (setq firstPt (getpoint "拾取平面图中消防水管最左下角的管道点："))
  (princ "\n拾取平面图中的消防水管：")
  (setq ss (GetFireFightVPipeSSBySelectUtils))
  (setq insPt (getpoint "拾取轴侧图中消防水管最左下角的管道点："))
  (GenerateFireFightLabel firstPt ss insPt textHeight elevation)
)

; 2021-02-07
(defun GenerateFireFightLabel (firstPt ss insPt textHeight elevation / linePoint) 
  (mapcar '(lambda (x) 
             (setq linePoint (AddPositonOffSetUtils (AddPositonOffSetUtils (TranforCoordinateToPolarUtils (cdr (assoc "rawPosition" x))) insPt) '(0 -1000 0)))
             (GenerateOneFireFightElevation (AddPositonOffSetUtils linePoint '(-900 -3000 0)) elevation textHeight)
             (GenerateLineByPosition linePoint (AddPositonOffSetUtils linePoint '(500 -1300 0)) "DataflowFireFightPipe")
             (GenerateOneFireFightHPipe 
               (AddPositonOffSetUtils linePoint '(500 -1300 0))
               (cdr (assoc "PIPENUM" x))
               (cdr (assoc "PIPEDIAMETER" x))
               (cdr (assoc "entityhandle" x))
               textHeight)
          ) 
    (GetFireFightDataList ss firstPt)
  ) 
)

; 2021-02-02
(defun GetAllFireFightVPipeEntityHandleAndPositionList () 
  (mapcar '(lambda (x) 
             (GetEntityHandleAndPositionByEntityNameUtils x)
          ) 
    (GetEntityNameListBySSUtils (GetAllRawFireFightVPipeSSUtils))
  ) 
)

; 2021-02-02
(defun GetAllRawFireFightPipeDataList () 
  (mapcar '(lambda (x) 
             (GetFireFightPipeData x)
          ) 
    (GetEntityNameListBySSUtils (GetAllRawFireFightVPipeSSUtils))
  ) 
)

; 2021-02-23
(defun GetRawFireFightPipeDataListBySelect () 
  (mapcar '(lambda (x) 
             (GetFireFightPipeData x)
          ) 
    (GetEntityNameListBySSUtils (GetRawFireFightVPipeSSBySelectUtils))
  ) 
)

; 2021-02-03
(defun GetFireFightPipeData (entityName /)
  (list 
    (cdr (assoc 5 (entget entityName)))
    ; the problem of tiantan ss - wrong position - 2021-01-03
    (AddPositonOffSetUtils (cdr (assoc 10 (entget entityName))) '(0 200 0))
    (cdr (assoc 140 (entget entityName)))
  )
)

; 2021-02-03
(defun GetFireFightDataList (ss firstPt /)
  (mapcar '(lambda (x) 
             ; must reset the left-down point to (0 0 0)
             (cons 
               ; the problem of tiantan ss - wrong position - 2021-01-03
               ;(cons "rawPosition" (RemovePositonOffSetUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "RELATEDID" x)))) firstPt))
               (cons "rawPosition" (RemovePositonOffSetUtils (AddPositonOffSetUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "RELATEDID" x)))) '(0 200 0)) firstPt))
               x
             )
          ) 
    (GetPropertyDictListByPropertyNameList (GetEntityNameListBySSUtils ss) '("RELATEDID" "PIPENUM" "PIPEDIAMETER"))
  )  
)

; 2021-02-07
(defun c:GenerateFireFightPipeByBox ()
  (labelFireFightPipeByBox "labelFireFightPipeBox")
)

; 2021-02-07
(defun labelFireFightPipeByBox (tileName / dcl_id status textHeight elevationValue firstPt insPt floorDrawMsgStatus axialDrawMsgStatus ss sslen)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnfloorDraw" "(done_dialog 3)")
    (action_tile "btnAxialDraw" "(done_dialog 4)")
    (action_tile "btnComfirmNumber" "(done_dialog 5)")
    (action_tile "textHeight" "(setq textHeight $value)")
    (action_tile "elevationValue" "(setq elevationValue $value)")
    ; init the default data of text 
    (if (= nil textHeight)
      (setq textHeight "")
    ) 
    (if (= nil elevationValue)
      (setq elevationValue "")
    ) 
    ; setting for saving the existed value of a box
    (set_tile "textHeight" textHeight)
    (set_tile "elevationValue" elevationValue)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= floorDrawMsgStatus 1) 
      (set_tile "floorDrawMsg" "平面图拾取状态：已完成")
    )
    (if (= axialDrawMsgStatus 1) 
      (set_tile "axialDrawMsg" "平面图拾取状态：已完成")
    )
    (if (= infoMsgStatus 1) 
      (set_tile "infoMsg" "状态：数据输入不完整")
    ) 
    (if (= infoMsgStatus 2) 
      (set_tile "infoMsg" "状态：已完成")
    ) 
    (if (= infoMsgStatus 0) 
      (set_tile "infoMsg" "状态：")
    )  
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq ss (GetFireFightVPipeSSBySelectUtils))
        (setq sslen (length (GetEntityNameListBySSUtils ss)))
      )
    )
    ; floorDraw button
    (if (= 3 status)
      (progn 
        (setq firstPt (getpoint "拾取平面图中消防水管最左下角的管道点："))
        (setq floorDrawMsgStatus 1)
      )
    )
    ; axialDraw button
    (if (= 4 status)
      (progn 
        (setq insPt (getpoint "拾取轴侧图中消防水管最左下角的管道点："))
        (setq axialDrawMsgStatus 1)
      )
    )
    ; modify button
    (if (= 5 status)
      (if (and (/= textHeight "") (/= elevationValue "") (/= firstPt nil) (/= insPt nil) (/= sslen nil)) 
        (progn 
          (GenerateFireFightLabel firstPt ss insPt (atoi textHeight) elevationValue)
          (setq infoMsgStatus 2)
        )
        (setq infoMsgStatus 1)
      )
    )
  )
  (setq infoMsgStatus 0)
  (unload_dialog dcl_id)
  (princ)
)

(defun c:UpdateFireFightPipeLable (/ entityNameList allPipeHandleList relatedPipeData)
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "FireFightPipe"))
  )
  (setq allPipeHandleList (GetAllFireFightPipeEntityHandle))
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    ; relatedid value maybe null or relatedid may be not in the allPipeHandleList
    (vl-remove-if-not '(lambda (x) 
                        (and (/= (cdr (assoc "relatedid" x)) "") (/= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetBlockAllPropertyDictListUtils entityNameList)
    )
  ) 
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "PIPENUM" "PIPEDIAMETER") 
              (list 
                (cdr (assoc "pipenum" y)) 
                (cdr (assoc "pipediameter" y)) 
              )
            )
          ) 
    entityNameList
    relatedPipeData 
  ) 
  (alert "更新完成")(princ)
)

(defun GetAllFireFightPipeEntityHandle () 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    (GetAllFireFightPipeDataUtils)
  )
)

; SS
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;