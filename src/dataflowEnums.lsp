;冯大龙开发于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Enums

(defun GetSyncFlowBlockNameList ()
  '("InstrumentL" "InstrumentP" "InstrumentSIS" "Centrifuge" "CustomEquip" "Heater" "Pump" "Reactor" "Tank" "Vacuum" "OuterPipeLeft" "OuterPipeRight" "GsCleanAir")
)

; refactored at 2021-04-08
(defun GetDataTypeMsgStrategy (dataType / dataTypeMsg)
  (cond 
    ((= dataType "Pipe") (setq dataTypeMsg "批量修改管道数据"))
    ((= dataType "Instrument") (setq dataTypeMsg "批量修改仪表数据"))
    ((= dataType "Reactor") (setq dataTypeMsg "批量修改反应釜数据"))
    ((= dataType "Tank") (setq dataTypeMsg "批量修改储罐数据"))
    ((= dataType "Heater") (setq dataTypeMsg "批量修改换热器数据"))
    ((= dataType "Pump") (setq dataTypeMsg "批量修改输送泵数据"))
    ((= dataType "Vacuum") (setq dataTypeMsg "批量修改真空泵数据"))
    ((= dataType "Centrifuge") (setq dataTypeMsg "批量修改离心机数据"))
    ((= dataType "CustomEquip") (setq dataTypeMsg "批量修改自定义设备数据"))
  ) 
)

; 2021-03-22
(defun GetPropertyNameListStrategy (dataType /) 
  (cond 
    ((= dataType "Pipe") (GetPipePropertyNameList))
    ((= dataType "OuterPipe") (GetOuterPipePropertyNameList))
    ((= dataType "PublicPipe") (GetPublicPipePropertyNameList))
    ((= dataType "Instrument") (GetInstrumentPropertyNameList))
    ((= dataType "InstrumentL") (GetInstrumentPropertyNameList))
    ((= dataType "InstrumentP") (GetInstrumentPPropertyNameList))
    ((= dataType "InstrumentSIS") (GetInstrumentPPropertyNameList))
    ((= dataType "Reactor") (GetReactorPropertyNameList))
    ((= dataType "Tank") (GetTankPropertyNameList))
    ((= dataType "Heater") (GetHeaterPropertyNameList))
    ((= dataType "Pump") (GetPumpPropertyNameList))
    ((= dataType "Vacuum") (GetVacuumPropertyNameList))
    ((= dataType "Centrifuge") (GetCentrifugePropertyNameList))
    ((= dataType "CustomEquip") (GetCustomEquipPropertyNameList))
    ((= dataType "GsCleanAir") (GetGsCleanAirPropertyNameList))
    ((= dataType "KsInstallMaterial") (GetKsInstallMaterialPropertyNameList))
    ; default List
    (T '("TAG"))
  ) 
)

; 2021-03-24
(defun GetCSVPropertyNameListStrategy (dataType /) 
  (cond 
    ((= dataType "KsInstallMaterial") (GetCSVKsInstallMaterialPropertyNameList))
    ; default List
    (T '("TAG"))
  ) 
)

; refactored at 2021-04-08
(defun GetPropertyChNameListStrategy (dataType /) 
  (cond 
    ((= dataType "Pipe") (GetPipePropertyChNameList))
    ((= dataType "PublicPipe") (GetPublicPipePropertyChNameList))
    ((= dataType "Instrument") (GetInstrumentPropertyChNameList))
    ((= dataType "Reactor") (GetReactorPropertyChNameList))
    ((= dataType "Tank") (GetTankPropertyChNameList))
    ((= dataType "Heater") (GetHeaterPropertyChNameList))
    ((= dataType "Pump") (GetPumpPropertyChNameList))
    ((= dataType "Vacuum") (GetVacuumPropertyChNameList))
    ((= dataType "Centrifuge") (GetCentrifugePropertyChNameList))
    ((= dataType "CustomEquip") (GetCustomEquipPropertyChNameList))
    ((= dataType "GsCleanAir") (GetGsCleanAirPropertyChNameList))
  ) 
)

(defun GetPipePropertyNameList ()
  '("PIPENUM" "SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "FROM" "TO" "DRAWNUM" "INSULATION" "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetPipePropertyChNameList ()
  '("管道编号" "工作介质" "工作温度" "工作压力" "相态" "管道起点" "管道终点" "流程图号" "保温材料" "变等级信息" "变管径信息")
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
  '("FUNCTION" "TAG" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION"  "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetInstrumentPPropertyNameList ()
  '("FUNCTION" "TAG" "HALARM" "LALARM" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION"  "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetInstrumentPropertyChNameList ()
  '("仪表功能代号" "仪表位号" "工作介质" "工作温度" "工作压力" "仪表类型" "相态" "所在位置材质" "控制点名称" "所在管道或设备" "最小值" "最大值" "正常值" "流程图号" "所在位置尺寸" "备注" "安装方向"  "变等级信息" "变管径信息")
)

(defun GetReactorPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SPEED" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM" "EXTEMP" "EXPRESSURE")
)

(defun GetReactorPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "设备体积" "工作介质" "工作温度" "工作压力" "电机功率" "电机是否防爆" "电机级数" "反应釜转数" "设备尺寸" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "流程图号" "自定义关键参数1" "自定义关键参数2")
)

(defun GetTankPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM" "EXTEMP" "EXPRESSURE")
)

(defun GetTankPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "设备体积" "工作介质" "工作温度" "工作压力" "电机功率" "电机是否防爆" "电机级数" "设备尺寸" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "流程图号" "自定义关键参数1" "自定义关键参数2")
)

(defun GetHeaterPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "AREA" "SIZE" "ELEMENT" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM")
)

(defun GetHeaterPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "换热面积" "设备尺寸" "换热元件规格" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "流程图号")
)

(defun GetPumpPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "FLOW" "HEAD" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "NUMBER" "TYPE" "DRAWNUM")
)

(defun GetPumpPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "流量" "扬程" "电机功率" "电机是否防爆" "电机级数" "设备材质" "设备重量" "设备数量" "设备型号" "流程图号")
)

(defun GetVacuumPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "CAPACITY" "EXPRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "NUMBER" "DRAWNUM")
)

(defun GetVacuumPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "抽气量" "极限压力" "电机功率" "电机是否防爆" "电机级数" "设备尺寸" "设备材质" "设备重量" "设备型号" "设备数量" "流程图号")
)

(defun GetCentrifugePropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "VOLUME" "CAPACITY" "DIAMETER" "SPEED" "FACTOR" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "TYPE" "NUMBER" "DRAWNUM")
)

(defun GetCentrifugePropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "设备体积" "装料限重" "转鼓直径" "转鼓转速" "最大分离因素" "设备尺寸" "电机功率" "电机是否防爆" "电机级数" "设备材质" "设备重量" "设备型号" "设备数量" "流程图号")
)

(defun GetCustomEquipPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "PARAM1" "PARAM2" "PARAM3" "PARAM4" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM")
)

(defun GetCustomEquipPropertyChNameList ()
  '("设备位号" "设备名称" "设备类型" "工作介质" "工作温度" "工作压力" "设备尺寸" "电机功率" "电机是否防爆" "电机级数" "关键参数1" "关键参数2" "关键参数3" "关键参数4" "设备材质" "设备重量" "设备型号" "保温厚度" "设备数量" "流程图号")
)

(defun GetJoinDrawArrowPropertyNameList ()
  '("FROMTO" "DRAWNUM" "RELATEDID")
)

(defun GetGsCleanAirPropertyNameList ()
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "TEMP_PRECISION" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT" "SYSTEM_NUM" "FLOOR_HEIGHT" "EXPLOSION_PROOF_STATUS")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("房间名称" "房间编号" "洁净等级" "房间吊顶高度" "房间面积" "室压" "房间人数" "温度控制精度" "湿度控制精度" "职业暴露等级" "电热设备功率" "电热设备有无排风" "电热设备有无保温" "电动设备功率" "电动设备效率" "其他设备表面面积" "其他设备表面温度" "敞开水面表面面积" "敞开水面表面温度" "设备是否连续排风" "设备排风量" "是否连续排湿除味" "排湿除味排风率" "除尘排风粉尘量" "除尘排风排风率" "是否事故排风" "事故通风介质" "层流保护区域" "层流保护面积" "监控温度" "监控相对湿度" "监控压差" "备注" "系统编号" "所在楼层" "是否防爆区")
)

; 2021-03-09
(defun GetGsLcEquipTypeList ()
  '("Reactor" "Tank" "Heater" "Pump" "Centrifuge" "Vacuum" "CustomEquip")
)

; modified at - 2021-03-14
(defun GetGsBzEquipPropertyNameList ()
  '("VERSION" "TAG" "GSBZTYPE" "SPECIES" "VOLUME" "FLOORHEIGHT" "XPOSITION" "YPOSITION" "EMPTYWEIGHT" "STATICLOAD" "DYNAMICLOAD" "SUPPORMETHOD" "HOLEMETHOD" "BASEMETHOD" "COMMENT" "OPTION")
)

; 2021-03-22
(defun GetKsInstallMaterialPropertyNameList ()
  '("STANDARDNUM" "MATERIALTYPE" "SPECIFICATION" "MATERIAL" "NUM" "MULTIPLE" "KSTYPE" "COMMENT")
)

; 2021-03-24
(defun GetCSVKsInstallMaterialPropertyNameList ()
  '("SERIALID" "STANDARDNUM" "MATERIALTYPE" "SPECIFICATION" "MATERIAL" "NUM" "MULTIPLE" "KSTYPE" "COMMENT")
)

; 2021-05-19
(defun GetSaddleSupportDownOffsetEnums (saddleType /)
  (cond 
    ((= saddleType "BsGCTGraphSaddleSupport-SideView-BI-800") 90)
    ((= saddleType "BsGCTGraphSaddleSupport-SideView-BI-1000") 104)
    (T 100)
  )
)

; 2021-05-19
(defun GetSaddleSupportUpOffsetEnums (saddleType /)
  (cond 
    ((= saddleType "BsGCTGraphSaddleSupport-SideView-BI-800") 234)
    ((= saddleType "BsGCTGraphSaddleSupport-SideView-BI-1000") 292)
    (T 250)
  )
)


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Enums