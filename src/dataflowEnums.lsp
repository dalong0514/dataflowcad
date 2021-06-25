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
  '("InstrumentL" "InstrumentP" "InstrumentSIS" "Centrifuge" "CustomEquip" "Heater" "Pump" "Reactor" "Tank" "Vacuum" "OuterPipeLeft" "OuterPipeRight" "OuterPipeDoubleArrow" "GsCleanAir" "GsComfortAir")
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
    ((= dataType "GsComfortAir") (GetGsComfortAirPropertyNameList))
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
    ((= dataType "GsComfortAir") (GetGsComfortAirPropertyChNameList))
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
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "SUMMER_TEMP" "WINTER_TEMP" "TEMP_PRECISION" "SUMMER_REHUMIDITY" "WINTER_REHUMIDITY" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT" "SYSTEM_NUM" "FLOOR_HEIGHT" "EXPLOSION_PROOF_STATUS")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("房间名称" "房间编号" "洁净等级" "房间吊顶高度" "房间面积" "室压" "房间人数" "房间夏季温度" "房间冬季温度" "温度控制精度" "房间夏季相对湿度" "房间冬季相对湿度" "湿度控制精度" "职业暴露等级" "电热设备功率" "电热设备有无排风" "电热设备有无保温" "电动设备功率" "电动设备效率" "其他设备表面面积" "其他设备表面温度" "敞开水面表面面积" "敞开水面表面温度" "设备是否连续排风" "设备排风量" "是否连续排湿除味" "排湿除味排风率" "除尘排风粉尘量" "除尘排风排风率" "是否事故排风" "事故通风介质" "层流保护区域" "层流保护面积" "监控温度" "监控相对湿度" "监控压差" "备注" "系统编号" "所在楼层" "是否防爆区")
)

; 2021-06-25
(defun GetGsComfortAirPropertyNameList () 
  (mapcar '(lambda (x) (strcase x)) 
    (vl-remove-if-not '(lambda (x) 
                        (not (member x '("entityhandle" "version")))
                      ) 
      (GetBlockPropertyNameListByEntityNameUtils (ssname (GetAllBlockSSByDataTypeUtils "GsComfortAir") 0))
    )
  )
)

; 2021-06-25
(defun GetGsComfortAirPropertyChNameList ()
  '("房间编号" "房间名称" "房间面积" "防爆等级" "生产类别" "工作班数" "每班操作人数" "房间夏季温度" "房间冬季温度" "房间夏季相对湿度" "房间冬季相对湿度" "发热设备表面积" "发热设备表面温度" "设备发热量" "设备同时运转电机总功率" "有害气体或或灰尘名称" "有害气体或或灰尘名数量" "散湿量" "事故排风设备位号" "正负压要求" "备注")
)

; 2021-06-25
(defun GetGsComfortAirPropertyChNameStirng ()
  (apply 'strcat 
    (mapcar '(lambda (x) 
              (strcat x ",")
            ) 
      (GetGsComfortAirPropertyChNameList)
    ) 
  )
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


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Bs Enums

; 2021-05-19
(defun GetSaddleSupportDownOffsetEnums (barrelDiameter /)
  (cond 
    ((<= barrelDiameter 750) 83)
    ((<= barrelDiameter 950) 90)
    ((<= barrelDiameter 1200) 114)
    ((<= barrelDiameter 1700) 128)
    ((<= barrelDiameter 2000) 136)
    ((<= barrelDiameter 2400) 158)
    ((<= barrelDiameter 2800) 193)
    (T 214)
  )
)

; 2021-05-19
(defun GetSaddleSupportUpOffsetEnums (barrelDiameter /)
  (cond 
    ((<= barrelDiameter 500) 143)
    ((<= barrelDiameter 600) 184)
    ((<= barrelDiameter 700) 202)
    ((<= barrelDiameter 800) 234)
    ((<= barrelDiameter 900) 261)
    ((<= barrelDiameter 1000) 292)
    ((<= barrelDiameter 1200) 324)
    ((<= barrelDiameter 1400) 383)
    ((<= barrelDiameter 1600) 441)
    ((<= barrelDiameter 1800) 500)
    ((<= barrelDiameter 2000) 560)
    ((<= barrelDiameter 2200) 620)
    ((<= barrelDiameter 2400) 679)
    ((<= barrelDiameter 2600) 737)
    ((<= barrelDiameter 2800) 797)
    ((<= barrelDiameter 3000) 854)
    (T 886)
  )
)

; 2021-05-26
(defun GetFlangeBarrelHeightEnums (heaterDiameter /)
  (cond 
    ((<= heaterDiameter 400) 35)
    ((<= heaterDiameter 450) 35)
    ((<= heaterDiameter 500) 35)
    ((<= heaterDiameter 600) 35)
    ((<= heaterDiameter 700) 35)
    ((<= heaterDiameter 800) 35)
    ((<= heaterDiameter 900) 35)
    ((<= heaterDiameter 1000) 35)
    ((<= heaterDiameter 1200) 35)
    ((<= heaterDiameter 1400) 35)
    ((<= heaterDiameter 1600) 35)
    ((<= heaterDiameter 1800) 35)
    ((<= heaterDiameter 2000) 35)
    ((<= heaterDiameter 2200) 35)
    ((<= heaterDiameter 2400) 35)
    ((<= heaterDiameter 2600) 35)
    (T 35)
  )
)

; 2021-05-26
(defun GetFlangeNeckHeightEnums (heaterDiameter /)
  (cond 
    ((<= heaterDiameter 400) 25)
    ((<= heaterDiameter 450) 25)
    ((<= heaterDiameter 500) 25)
    ((<= heaterDiameter 600) 25)
    ((<= heaterDiameter 700) 25)
    ((<= heaterDiameter 800) 25)
    ((<= heaterDiameter 900) 25)
    ((<= heaterDiameter 1000) 25)
    ((<= heaterDiameter 1200) 25)
    ((<= heaterDiameter 1400) 25)
    ((<= heaterDiameter 1600) 25)
    ((<= heaterDiameter 1800) 25)
    ((<= heaterDiameter 2000) 25)
    ((<= heaterDiameter 2200) 25)
    ((<= heaterDiameter 2400) 25)
    ((<= heaterDiameter 2600) 25)
    (T 25)
  )
)

; 2021-05-26
(defun GetFlangeHeightEnums (heaterDiameter /)
  (cond 
    ((<= heaterDiameter 400) 41)
    ((<= heaterDiameter 450) 41)
    ((<= heaterDiameter 500) 41)
    ((<= heaterDiameter 600) 41)
    ((<= heaterDiameter 700) 41)
    ((<= heaterDiameter 800) 41)
    ((<= heaterDiameter 900) 41)
    ((<= heaterDiameter 1000) 41)
    ((<= heaterDiameter 1200) 41)
    ((<= heaterDiameter 1400) 41)
    ((<= heaterDiameter 1600) 41)
    ((<= heaterDiameter 1800) 41)
    ((<= heaterDiameter 2000) 41)
    ((<= heaterDiameter 2200) 41)
    ((<= heaterDiameter 2400) 41)
    ((<= heaterDiameter 2600) 41)
    (T 41)
  )
)

; 2021-05-27
(defun GetNeckFlangeDiameterEnums (heaterDiameter /)
  (cond 
    ((<= heaterDiameter 650) (+ heaterDiameter 140))
    ((<= heaterDiameter 1400) (+ heaterDiameter 160))
    ((<= heaterDiameter 1800) (+ heaterDiameter 195))
    ((<= heaterDiameter 2000) (+ heaterDiameter 215))
    ((<= heaterDiameter 2200) (+ heaterDiameter 240))
    (T (+ heaterDiameter 240))
  )
)

; 2021-05-27
(defun GetNeckFlangeBoltDiameterEnums (heaterDiameter /)
  (cond 
    ((<= heaterDiameter 650) (- (GetNeckFlangeDiameterEnums heaterDiameter) 40))
    ((<= heaterDiameter 1400) (- (GetNeckFlangeDiameterEnums heaterDiameter) 45))
    ((<= heaterDiameter 1800) (- (GetNeckFlangeDiameterEnums heaterDiameter) 55))
    ((<= heaterDiameter 2000) (- (GetNeckFlangeDiameterEnums heaterDiameter) 60))
    ((<= heaterDiameter 2200) (- (GetNeckFlangeDiameterEnums heaterDiameter) 70))
    (T (- (GetNeckFlangeDiameterEnums heaterDiameter) 20))
  )
)

; 2021-05-30
(defun GetLugSupportBlotOffsetEnums (supportType /)
  (cond 
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B1") 126)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B2") 136)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B3") 151)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B4") 215)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B5") 234)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B6") 256)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B7") 290)
    ((= supportType "BsGCTGraphSaddleSupport-SideView-B8") 350)
    (T 136)
  )
)

; 2021-06-13
(defun GetBsInspectRateByWeldJointEnums (weldJoint /)
  (cond 
    ((= weldJoint "1.0") "100%")
    ((= weldJoint "0.85") "20%")
    (T "")
  )
)

; 2021-05-19
; 标准封头的直边段高度，小于等于 2000 直径的是 25mm，大于 2000 直径的是 40mm
(defun GetBsGCTStraightEdgeHeightEnums (barrelRadius /)
  (cond 
    ((<= barrelRadius 1000) 25)
    ((> barrelRadius 1000) 40)
    (T 25)
  )
)

; Bs Enums
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Ns Enums

; 2021-06-09
(defun GetNsCAHUnitWidthEnums (blockName /)
  (cond 
    ((= blockName "NsCAH-AHU-OutdoorAir") 1500)
    ((= blockName "NsCAH-AHU-ReturnAir") 1500)
    ((= blockName "NsCAH-AHU-SupplyAir") 1500)
    ((= blockName "NsCAH-AHU-MixAir") 1500)
    ((= blockName "NsCAH-AHU-EmptyAir") 1500)
    ((= blockName "NsCAH-AHU-MeanFlowAir") 1500)
    ((= blockName "NsCAH-AHU-MuffledAir") 1500)
    ((= blockName "NsCAH-AHU-NewExhaustAir") 3000)
    ; filter unit
    ((= blockName "NsCAH-AHU-PlateRough") 1000)
    ((= blockName "NsCAH-AHU-FabricRough") 1500)
    ((= blockName "NsCAH-AHU-MediumEfficiency") 1500)
    ((= blockName "NsCAH-AHU-HighMediumEfficiency") 1500)
    ((= blockName "NsCAH-AHU-SubHighEfficiency") 1500)
    ((= blockName "NsCAH-AHU-HighEfficiency") 1500)
    ; heat and cool unit
    ((= blockName "NsCAH-AHU-SurfaceCooler") 2000)
    ((= blockName "NsCAH-AHU-SurfaceCoolerEliminator") 2000)
    ((= blockName "NsCAH-AHU-HotWaterHeat") 2000)
    ((= blockName "NsCAH-AHU-SteamPreHeat") 2000)
    ((= blockName "NsCAH-AHU-SteamHeat") 2000)
    ((= blockName "NsCAH-AHU-SteamHumidify") 2000)
    ((= blockName "NsCAH-AHU-ElectricHeat") 2000)
    ((= blockName "NsCAH-AHU-ElectricHumidify") 2000)
    ; FanSection
    ((= blockName "NsCAH-AHU-FanSection-Level") 4000)
    ((= blockName "NsCAH-AHU-FanSection-Top") 4000)
    (T 1500)
  )
)

; 2021-06-10
(defun NsCAHChUnitNameToUnitNameEnums (chUnitName /)
  (cond 
    ((= chUnitName "新风段") "NsCAH-AHU-OutdoorAir")
    ((= chUnitName "回风段") "NsCAH-AHU-ReturnAir")
    ((= chUnitName "送风段") "NsCAH-AHU-SupplyAir")
    ((= chUnitName "混合段") "NsCAH-AHU-MixAir")
    ((= chUnitName "空段") "NsCAH-AHU-EmptyAir")
    ((= chUnitName "均流段") "NsCAH-AHU-MeanFlowAir")
    ((= chUnitName "消声段") "NsCAH-AHU-MuffledAir")
    ((= chUnitName "新排风段") "NsCAH-AHU-NewExhaustAir")
    ; filter unit
    ((= chUnitName "板式粗效段") "NsCAH-AHU-PlateRough")
    ((= chUnitName "袋式粗效段") "NsCAH-AHU-FabricRough")
    ((= chUnitName "中效段") "NsCAH-AHU-MediumEfficiency")
    ((= chUnitName "高中效段") "NsCAH-AHU-HighMediumEfficiency")
    ((= chUnitName "亚高效段") "NsCAH-AHU-SubHighEfficiency")
    ((= chUnitName "高效段") "NsCAH-AHU-HighEfficiency")
    ; heat and cool unit
    ((= chUnitName "表冷段") "NsCAH-AHU-SurfaceCooler")
    ((= chUnitName "表冷挡水段") "NsCAH-AHU-SurfaceCoolerEliminator")
    ((= chUnitName "热水加热段") "NsCAH-AHU-HotWaterHeat")
    ((= chUnitName "蒸汽预热段") "NsCAH-AHU-SteamPreHeat")
    ((= chUnitName "蒸汽加热段") "NsCAH-AHU-SteamHeat")
    ((= chUnitName "蒸汽加湿段") "NsCAH-AHU-SteamHumidify")
    ((= chUnitName "电加热段") "NsCAH-AHU-ElectricHeat")
    ((= chUnitName "电加湿段") "NsCAH-AHU-ElectricHumidify")
    ; FanSection
    ((= chUnitName "水平出风风机段") "NsCAH-AHU-FanSection-Level")
    ((= chUnitName "顶部出风风机段") "NsCAH-AHU-FanSection-Top")
  )
)

; 2021-06-10
(defun GetNsCAHAirValveBlockNameEnums (chUnitName /)
  (cond 
    ((= chUnitName "对开多叶风量调节阀") "NsCAH-RE-OMD")
    ((= chUnitName "电动对开多叶风量调节阀") "NsCAH-RE-EOMD")
    ((= chUnitName "文丘里定风量阀") "NsCAH-RE-CAV-Venturi")
    ((= chUnitName "文丘里双稳态定风量阀") "NsCAH-RE-CAV-Venturi")
    ((= chUnitName "EN定风量阀") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "EN双稳态定风量阀") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "RN定风量阀") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "RN双稳态定风量阀") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "文丘里变风量阀") "NsCAH-RE-VAV-Venturi")
    ((= chUnitName "TVT变风量阀") "NsCAH-RE-VAV-TROX")
    ((= chUnitName "TVR变风量阀") "NsCAH-RE-VAV-TROX")
  )
)