;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo ()
  (alert "最新版本号 V2.2，更新时间：2021-05-01\n数据流内网地址：192.168.1.38")(princ)
)

(defun c:syncAllDataFlowBlock (/ item) 
    (foreach item (GetSyncFlowBlockNameList) 
    (command "._attsync" "N" item)
  )
  (alert "数据流相关块同时完成！")(princ)
)

(defun c:GetEntityData ()
  (GetOneEntityDataUtils)
)

; basic Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Get Constant Data

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
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "TEMP_PRECISION" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("房间名称" "房间编号" "洁净等级" "房间吊顶高度" "房间面积" "室压" "房间人数" "温度控制精度" "湿度控制精度" "职业暴露等级" "电热设备功率" "电热设备有无排风" "电热设备有无保温" "电动设备功率" "电动设备效率" "其他设备表面面积" "其他设备表面温度" "敞开水面表面面积" "敞开水面表面温度" "设备是否连续排风" "设备排风量" "是否连续排湿除味" "排湿除味排风率" "除尘排风粉尘量" "除尘排风排风率" "是否事故排风" "事故通风介质" "层流保护区域" "层流保护面积" "监控温度" "监控相对湿度" "监控压差" "备注")
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

; Get Constant Data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Read and Write Gs Data

(defun WriteCommonDataToCSVByEntityNameListUtils (entityNameList / fileDir propertyNameList firstRow)
  (setq fileDir "D:\\dataflowcad\\data\\commonData.csv")
  (setq propertyNameList (GetBlockPropertyNameListByEntityNameUtils (car entityNameList)))
  (setq firstRow (GetCSVPropertyStringByDataListUtils propertyNameList))
  ; note: (cdr propertyNameList) - delete the entityhandle frist
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow (cdr propertyNameList) "1")
)

(defun WritePipeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\pipeData.csv")
  (setq firstRow "数据ID,管道编号,工作介质,工作温度,工作压力,相态,管道起点,管道终点,流程图号,保温材料,变等级信息,变管径信息,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPipePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteInstrumentDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  (setq firstRow "数据ID,仪表功能代号,仪表位号,工作介质,工作温度,工作压力,仪表类型,相态,所在位置材质,控制点名称,所在管道或设备,最小值,最大值,正常值,流程图号,所在位置尺寸,备注,安装方向,变等级信息,变管径信息,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetInstrumentPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteReactorDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\reactorData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,设备体积,工作介质,工作温度,工作压力,电机功率,电机是否防爆,电机级数,反应釜转数,设备尺寸,设备材质,设备重量,设备型号,保温厚度,设备数量,流程图号,自定义关键参数1,自定义关键参数2,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetReactorPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteTankDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\tankData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,设备体积,工作介质,工作温度,工作压力,电机功率,电机是否防爆,电机级数,设备尺寸,设备材质,设备重量,设备型号,保温厚度,设备数量,流程图号,自定义关键参数1,自定义关键参数2,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetTankPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteHeaterDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\heaterData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,换热面积,设备尺寸,换热元件规格,设备材质,设备重量,设备型号,保温厚度,设备数量,流程图号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetHeaterPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WritePumpDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\pumpData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,流量,扬程,电机功率,电机是否防爆,电机级数,设备材质,设备重量,设备数量,设备型号,流程图号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPumpPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteVacuumDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\vacuumData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,抽气量,极限压力,电机功率,电机是否防爆,电机级数,设备尺寸,设备材质,设备重量,设备型号,设备数量,流程图号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetVacuumPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteCentrifugeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\centrifugeData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,设备体积,装料限重,转鼓直径,转鼓转速,最大分离因素,设备尺寸,电机功率,电机是否防爆,电机级数,设备材质,设备重量,设备型号,设备数量,流程图号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCentrifugePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteCustomEquipDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\customEquipData.csv")
  (setq firstRow "数据ID,设备位号,设备名称,设备类型,工作介质,工作温度,工作压力,设备尺寸,电机功率,电机是否防爆,电机级数,关键参数1,关键参数2,关键参数3,关键参数4,设备材质,设备重量,设备型号,保温厚度,设备数量,流程图号,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCustomEquipPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteGsCleanAirDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\gsCleanAirData.csv")
  (setq firstRow "数据ID,房间名称,房间编号,洁净等级,房间吊顶高度,房间面积,室压,房间人数,温度控制精度,湿度控制精度,职业暴露等级,电热设备功率,电热设备有无排风,电热设备有无保温,电动设备功率,电动设备效率,其他设备表面面积,其他设备表面温度,敞开水面表面面积,敞开水面表面温度,设备是否连续排风,设备排风量,是否连续排湿除味,排湿除味排风率,除尘排风粉尘量,除尘排风排风率,是否事故排风,事故通风介质,层流保护区域,层流保护面积,监控温度,监控相对湿度,监控压差,备注,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetGsCleanAirPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteGsBzEquipDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\gsBzEquipData.csv")
  (setq firstRow "数据ID,设备大类,设备位号,设备类型代号,设备种类,设备体积,设备所在楼层,设备所在横向区域,设备所在纵向区域,设备空重,设备静荷载,设备动荷载,支撑方式,开孔形式,基础做法,备注,预留字段,")
  (setq propertyNameList (GetGsBzEquipPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

; 2021-03-24
(defun WriteKsInstallMaterialDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\ksdata\\installMaterialData.csv")
  (setq firstRow "数据ID,序号,图号及标准号,名称,材料规格,材质,数量,倍数,仪表类型,备注,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCSVKsInstallMaterialPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

; refactored at - 2021-03-24
(defun WriteDataToCSVByEntityNameListStrategy (entityNameList dataType /)
  (cond 
    ((= dataType "Pipe") (WritePipeDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Instrument") (WriteInstrumentDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Reactor") (WriteReactorDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Tank") (WriteTankDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Heater") (WriteHeaterDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Pump") (WritePumpDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Vacuum") (WriteVacuumDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Centrifuge") (WriteCentrifugeDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "CustomEquip") (WriteCustomEquipDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "GsCleanAir") (WriteGsCleanAirDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "GsBzEquip") (WriteGsBzEquipDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "KsInstallMaterial") (WriteKsInstallMaterialDataToCSVByEntityNameListUtils entityNameList))
    ((= dataType "Equipment") 
     (progn 
        (WriteReactorDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Reactor")))
        (WriteTankDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Tank")))
        (WriteHeaterDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Heater")))
        (WritePumpDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Pump")))
        (WriteVacuumDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Vacuum")))
        (WriteCentrifugeDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "Centrifuge")))
        (WriteCustomEquipDataToCSVByEntityNameListUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils "CustomEquip")))
     )
    ) 
  ) 
  (princ)
)

(defun ReadGsDataFromCSVStrategy (dataType / fileDir)
  (if (= dataType "Pipe") 
    (setq fileDir "D:\\dataflowcad\\data\\pipeData.csv")
  )
  (if (= dataType "Instrument") 
    (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  )
  (if (= dataType "Reactor") 
    (setq fileDir "D:\\dataflowcad\\data\\reactorData.csv")
  )
  (if (= dataType "Tank") 
    (setq fileDir "D:\\dataflowcad\\data\\tankData.csv")
  )
  (if (= dataType "Heater") 
    (setq fileDir "D:\\dataflowcad\\data\\heaterData.csv")
  )
  (if (= dataType "Pump") 
    (setq fileDir "D:\\dataflowcad\\data\\pumpData.csv")
  )
  (if (= dataType "Vacuum") 
    (setq fileDir "D:\\dataflowcad\\data\\vacuumData.csv")
  )
  (if (= dataType "Centrifuge") 
    (setq fileDir "D:\\dataflowcad\\data\\centrifugeData.csv")
  )
  (if (= dataType "CustomEquip") 
    (setq fileDir "D:\\dataflowcad\\data\\customEquipData.csv")
  )
  (if (= dataType "GsCleanAir") 
    (setq fileDir "D:\\dataflowcad\\data\\gsCleanAirData.csv")
  ) 
  (if (= dataType "commonBlock") 
    (setq fileDir "D:\\dataflowcad\\data\\commonData.csv")
  ) 
  (if (= dataType "GsBzEquip") 
    (setq fileDir "D:\\dataflowcad\\data\\gsBzEquipData.csv")
  )
  (ReadDataFromCSVUtils fileDir)
)

; 2021-04-24
(defun ReadKsDataFromCSVStrategy (dataType / fileDir)
  (cond 
    ((= dataType "KsInstallMaterial") (setq fileDir "D:\\dataflowcad\\ksdata\\installMaterialData.csv"))
  )
  (ReadDataFromCSVUtils fileDir)
)

; Read and Write Gs Data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for extract data

; refactored at 2021-04-09
(defun c:exportGsData ()
  (ExecuteFunctionAfterVerifyDateUtils 'ExportGsDataMacro '())
)

; 2021-04-09
(defun ExportGsDataMacro (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("Pipe" "Equipment" "InstrumentAndEquipmentAndPipe" "Equipment" "OuterPipe" "GsCleanAir"))
  (setq dataTypeChNameList '("管道数据" "设备数据" "仪表数据" "电气数据" "外管数据" "洁净空调")) 
  (ExportTempDataByBox "exportTempDataBox" dataTypeList dataTypeChNameList "Gs")
)

; 2021-04-09
(defun ExportGsDataMacroV2 (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("Pipe" "Equipment" "InstrumentAndEquipmentAndPipe" "Electric" "OuterPipe" "GsCleanAir"))
  (setq dataTypeChNameList '("管道数据" "设备数据" "仪表数据" "电气数据" "外管数据" "洁净空调")) 
  (ExportCADDataByBox "exportCADDataBox" dataTypeList dataTypeChNameList "Gs")
)

; 2021-04-07
(defun GetGsJsonListDataByDataType (ss dataType /) 
  (cond 
    ((= dataType "Pipe") (ExtractBlockPropertyToJsonListStrategy ss "Pipe"))
    ((= dataType "Equipment") (GetGsEquipmentJsonListData ss))
    ((= dataType "InstrumentAndEquipmentAndPipe") (GetGsInstrumentJsonListData ss))
    ((= dataType "Electric") (GetGsEquipmentJsonListData ss))
    ((= dataType "OuterPipe") (ExtractOuterPipeToJsonList))
    ((= dataType "GsCleanAir") (ExtractBlockPropertyToJsonListStrategy ss "GsCleanAir"))
  ) 
)

; 2021-04-07
(defun GetGsInstrumentJsonListData (ss /)
  (append (ExtractBlockPropertyToJsonListStrategy ss "InstrumentP")
          (ExtractBlockPropertyToJsonListStrategy ss "InstrumentSIS")
          (ExtractBlockPropertyToJsonListStrategy ss "InstrumentL")
          (ExtractBlockPropertyToJsonListStrategy ss "Pipe")
          (ExtractBlockPropertyToJsonListStrategy ss "Reactor")
          (ExtractBlockPropertyToJsonListStrategy ss "Tank")
          (ExtractBlockPropertyToJsonListStrategy ss "Heater")
          (ExtractBlockPropertyToJsonListStrategy ss "Pump")
          (ExtractBlockPropertyToJsonListStrategy ss "Vacuum")
          (ExtractBlockPropertyToJsonListStrategy ss "Centrifuge")
          (ExtractBlockPropertyToJsonListStrategy ss "CustomEquip")
        )
)

; 2021-04-07
(defun GetGsEquipmentJsonListData (fileName / fileDir)
  (append (ExtractBlockPropertyToJsonListStrategy ss "Reactor")
          (ExtractBlockPropertyToJsonListStrategy ss "Tank")
          (ExtractBlockPropertyToJsonListStrategy ss "Heater")
          (ExtractBlockPropertyToJsonListStrategy ss "Pump")
          (ExtractBlockPropertyToJsonListStrategy ss "Vacuum")
          (ExtractBlockPropertyToJsonListStrategy ss "Centrifuge")
          (ExtractBlockPropertyToJsonListStrategy ss "CustomEquip")
        )
)

; refactored at 2021-04-09
(defun c:exportBlockPropertyData ()
  (ExecuteFunctionAfterVerifyDateUtils 'ExportBlockPropertyDataMacro '())
)

; 2021-04-09
(defun ExportBlockPropertyDataMacro (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("Pipe" "Equipment" "Instrument" "Electric" "OuterPipe" "GsCleanAir"))
  (setq dataTypeChNameList '("管道数据" "设备数据" "仪表数据" "电气数据" "外管数据" "洁净空调数据"))
  (ExportBlockProperty dataTypeList dataTypeChNameList)
)

(defun ExportBlockProperty (dataTypeList dataTypeChNameList / dcl_id status fileName currentDir fileDir exportDataType exportMsgBtnStatus ss sslen)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog "exportBlockPropertyDataBox" dcl_id "" '(-1 -1))
    ; Add the actions to the button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    ; Set the default value
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
      (set_tile "exportBtnMsg" "文件名不能为空")
    )
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "导出数据数量： " (rtos sslen)))
    )
    ; export data button
    (if (= 2 (setq status (start_dialog))) 
      (if (/= fileName "") 
        (progn 
          (setq dataType (nth (atoi exportDataType) dataTypeList))
          (setq ss (GetAllBlockSSByDataTypeUtils dataType))
          (if (/= ss nil)
            (setq sslen (sslength ss)) 
            (setq sslen 0) 
          ) 
          (ExportDataByDataType fileName dataType)
          (setq exportMsgBtnStatus 1)
        )
        (setq exportMsgBtnStatus 2)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun ExportDataByDataType (fileName dataType /) 
  (if (= dataType "Pipe") 
    (ExportPipeData fileName)
  )
  (if (= dataType "Equipment") 
    (ExportEquipmentData fileName)
  )
  (if (= dataType "Instrument") 
    (ExportInstrumentData fileName)
  )
  (if (= dataType "Electric") 
    (ExportEquipmentData fileName)
  )
  (if (= dataType "OuterPipe") 
    (ExportOuterPipeData fileName)
  )
  (if (= dataType "GsCleanAir") 
    (ExportGsCleanAirData fileName)
  ) 
)

(defun GetExportDataFileDir (fileName / currentDir fileDir)
  (setq currentDir (getvar "dwgprefix"))
  (setq fileDir (strcat currentDir fileName ".txt"))
)

(defun ExportInstrumentData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (append (ExtractBlockPropertyToJsonList "InstrumentP")
                                            (ExtractBlockPropertyToJsonList "InstrumentSIS")
                                            (ExtractBlockPropertyToJsonList "InstrumentL")
                                            (ExtractBlockPropertyToJsonList "Pipe")
                                            (ExtractBlockPropertyToJsonList "Reactor")
                                            (ExtractBlockPropertyToJsonList "Tank")
                                            (ExtractBlockPropertyToJsonList "Heater")
                                            (ExtractBlockPropertyToJsonList "Pump")
                                            (ExtractBlockPropertyToJsonList "Vacuum")
                                            (ExtractBlockPropertyToJsonList "Centrifuge")
                                            (ExtractBlockPropertyToJsonList "CustomEquip")
                                    )
  )
)

(defun ExportPipeData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (ExtractBlockPropertyToJsonList "Pipe"))
)

(defun ExportEquipmentData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (append (ExtractBlockPropertyToJsonList "Reactor")
                                            (ExtractBlockPropertyToJsonList "Tank")
                                            (ExtractBlockPropertyToJsonList "Heater")
                                            (ExtractBlockPropertyToJsonList "Pump")
                                            (ExtractBlockPropertyToJsonList "Vacuum")
                                            (ExtractBlockPropertyToJsonList "Centrifuge")
                                            (ExtractBlockPropertyToJsonList "CustomEquip")
                                    )
  )
)

(defun ExportOuterPipeData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (ExtractOuterPipeToJsonList)
  )
)

(defun ExportGsCleanAirData (fileName / fileDir)
  (setq fileDir (GetExportDataFileDir fileName))
  (WriteDataListToFileUtils fileDir (ExtractBlockPropertyToJsonList "GsCleanAir"))
)

; the macro for extract data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; function for extract block property to text

(defun ExtractBlockPropertyToJsonList (dataType / ss entityNameList propertyNameList classDict resultList)
  (setq ss (GetAllBlockSSByDataTypeUtils dataType))
  (if (/= ss nil) ; repair bug for scenes of no exiting entity in CAD
    (progn 
      (setq entityNameList (GetEntityNameListBySSUtils ss))
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
  )
)

(defun ModifyPropertyNameForJsonListStrategy (dataType resultList /) 
  (if (or (= dataType "InstrumentP") 
          (= dataType "InstrumentL") 
          (= dataType "InstrumentSIS")
      ) 
    (progn 
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "minvalue" "min" x)
                ) 
          resultList
        )
      )
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "maxvalue" "max" x)
                ) 
          resultList
        )
      )
    )
  )
  (if (or (= dataType "Reactor") 
          (= dataType "Tank") 
          (= dataType "Heater")
          (= dataType "Pump")
          (= dataType "Vacuum")
          (= dataType "Centrifuge")
          (= dataType "CustomEquip")
      ) 
    (progn 
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "first_spec" "species" x)
                ) 
          resultList
        )
      )
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "is_antiexplosive" "antiexplosive" x)
                ) 
          resultList
        )
      )
      ; correct mistake made before
      (setq resultList 
        (mapcar '(lambda (x) 
                  (StringSubstUtils "volumn" "volume" x)
                ) 
          resultList
        )
      )
    )
  )
  resultList
)

(defun GetClassDictStrategy (dataType / result) 
  (cond 
    ((= dataType "InstrumentP") (setq result (cons "class" "concentrated")))
    ((= dataType "InstrumentL") (setq result (cons "class" "location")))
    ((= dataType "InstrumentSIS") (setq result (cons "class" "sis")))
    ((= dataType "Pipe") (setq result (cons "class" "pipeline")))
    ((= dataType "OuterPipe") (setq result (cons "class" "outerpipe")))
    ((= dataType "Reactor") (setq result (cons "class" "reactor")))
    ((= dataType "Tank") (setq result (cons "class" "tank")))
    ((= dataType "Heater") (setq result (cons "class" "heater")))
    ((= dataType "Pump") (setq result (cons "class" "pump")))
    ((= dataType "Vacuum") (setq result (cons "class" "vacuum")))
    ((= dataType "Centrifuge") (setq result (cons "class" "centrifuge")))
    ((= dataType "CustomEquip") (setq result (cons "class" "custom")))
    ((= dataType "GsCleanAir") (setq result (cons "class" "gscleanair")))
    ((= dataType "KsInstallMaterial") (setq result (cons "class" "ksinstallmaterial")))
  )
  result
)

(defun ExtractOuterPipeToJsonList (/ outerPipeJsonList pipeSS pipeEntityNameList pipePropertyNameList outerPipeSS outerPipeEntityNameList 
                                   outerPipePropertyNameList outerPipePipeNumList pipeList selectedPipeEntityNameList selectedPipeList resultList) 
  (setq outerPipeJsonList (ExtractBlockPropertyToJsonList "OuterPipe"))
  (setq pipeSS (GetAllBlockSSByDataTypeUtils "Pipe"))
  (setq pipeEntityNameList (GetEntityNameListBySSUtils pipeSS))
  (setq pipePropertyNameList (GetPropertyNameListStrategy "Pipe"))
  (setq outerPipeSS (GetAllBlockSSByDataTypeUtils "OuterPipe"))
  (setq outerPipeEntityNameList (GetEntityNameListBySSUtils outerPipeSS))
  (setq outerPipePropertyNameList (GetPropertyNameListStrategy "OuterPipe"))
  (setq outerPipePipeNumList 
    (mapcar '(lambda (x) 
              (cdr (assoc "PIPENUM" x))
            ) 
      (GetPropertyDictListByPropertyNameList outerPipeEntityNameList outerPipePropertyNameList)
    ) 
  )
  (setq pipeList 
    (vl-remove-if-not '(lambda (x) 
                        (= (type (member (cdr (assoc "PIPENUM" x)) outerPipePipeNumList)) 'list)
                      ) 
      (GetPropertyDictListByPropertyNameList pipeEntityNameList pipePropertyNameList)
    )
  )
  (setq selectedPipeEntityNameList 
    (mapcar '(lambda (x) 
              (handent (cdr (assoc "entityhandle" x)))
            ) 
      pipeList
    ) 
  )
  (setq selectedPipeJsonList 
    (mapcar '(lambda (x) 
              (ExtractBlockPropertyToJsonStringByClassUtils x pipePropertyNameList (GetClassDictStrategy "Pipe"))
            ) 
      selectedPipeEntityNameList
    )
  )
  (setq resultList (append outerPipeJsonList selectedPipeJsonList))
)

; function for extract block property to text
; Gs Field
;;;-------------------------------------------------------------------------;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for brushBlockPropertyValue

; refactored at 2021-04-09
(defun c:brushLocationForInstrument () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushLocationForInstrumentMacro '())
)

; 2021-04-09
(defun BrushLocationForInstrumentMacro (/ ss sourceData instrumentData locationData entityNameList) 
  (prompt "\n选择数据集（只能包含一个仪表或管道）：")
  (setq ss (GetBlockSSBySelectByDataTypeUtils "InstrumentAndEquipmentAndPipe"))
  (setq sourceData (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils ss)))
  (setq instrumentData (FilterBlockInstrumentDataUtils sourceData))
  (setq locationData (GetPipenumOrTag sourceData))
  (setq entityNameList (GetEntityNameListByPropertyDictListUtils instrumentData))
  (ModifyLocatonForInstrument entityNameList locationData)
  (princ)
)

; refactored at 2021-04-29
(defun GetPipenumOrTag (sourceData / equipmentData pipeData result) 
  (setq equipmentData (FilterBlockEquipmentDataUtils sourceData))
  (setq pipeData (FilterBlockPipeDataUtils sourceData)) 
  (cond 
    ((/= equipmentData nil) 
     (list (GetDottedPairValueUtils "entityhandle" (car equipmentData)) (GetDottedPairValueUtils "tag" (car equipmentData)))
     )
    ((/= pipeData nil) 
     (list (GetDottedPairValueUtils "entityhandle" (car pipeData)) (GetDottedPairValueUtils "pipenum" (car pipeData)))
     )
    ((and (= equipmentData nil) (= pipeData nil)) 
     (alert "请选择一个设备或管道")
     )
  )
)

; refactored at 2021-04-29
(defun ModifyLocatonForInstrument (entityNameList locationData /)
  (if (/= locationData "") 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "VERSION" "LOCATION") locationData)
            ) 
      entityNameList
    )
  )
)

; refatored at 2021-04-09
(defun c:brushStartEndForPipe () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushStartEndForPipeMacro '())
)

; refatored at 2021-04-09
(defun BrushStartEndForPipeMacro (/ startData endData entityNameList)
  (prompt "\n选择管道起点（直接空格表示不修改）：")
  (setq startData (GetPipenumOrTagForBrushPipe))
  (prompt "\n选择管道终点（直接空格表示不修改）：")
  (setq endData (GetPipenumOrTagForBrushPipe))
  (prompt "\n选择要刷的管道（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList startData endData)
  (princ)
)

; refatored at 2021-04-09
(defun c:brushStartForPipe () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushStartForPipeMacro '())
)

; refatored at 2021-04-09
(defun BrushStartForPipeMacro (/ startData entityNameList)
  (prompt "\n选择管道起点（直接空格表示不修改）：")
  (setq startData (GetPipenumOrTagForBrushPipe))
  (prompt "\n选择要刷的管道（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList startData "")
  (princ)
)

; refatored at 2021-04-09
(defun c:brushEndForPipe () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushEndForPipeMacro '())
)

; refatored at 2021-04-09
(defun BrushEndForPipeMacro (/ endData entityNameList)
  (prompt "\n选择管道终点（直接空格表示不修改）：")
  (setq endData (GetPipenumOrTagForBrushPipe))
  (prompt "\n选择要刷的管道（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList "" endData)
  (princ)
)

; refatored at 2021-05-08
(defun GetPipenumOrTagForBrushPipe (/ dataList) 
  (setq dataList (GetPipenumOrTagList (GetEquipmentAndPipeSSBySelectUtils)))
  (cond 
    ((/= (GetDottedPairValueUtils "tag" dataList) nil) 
     (cons (GetDottedPairValueUtils "entityhandle" dataList) (GetDottedPairValueUtils "tag" dataList)))
    ((/= (GetDottedPairValueUtils "pipenum" dataList) nil) 
     (cons (GetDottedPairValueUtils "entityhandle" dataList) (GetDottedPairValueUtils "pipenum" dataList)))
    (T "")
  )
)

; refatored at 2021-05-08
(defun GetPipenumOrTagList (dataSS /)
  (if (/= dataSS nil) 
    (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils dataSS)))
  )
)

; refatored at 2021-05-08
(defun ModifyStartEndForPipes (entityNameList startData endData /)
  (cond 
    ((and (/= startData "") (/= endData "")) (ModifyGsLcPipeStartAndEndData entityNameList startData endData))
    ((and (/= startData "") (= endData "")) (ModifyGsLcPipeStartData entityNameList startData))
    ((and (= startData "") (/= endData "")) (ModifyGsLcPipeEndData entityNameList endData))
  )
)

; 2021-05-08
(defun ModifyGsLcPipeStartAndEndData (entityNameList startData endData /)
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "VERSION" "FROM" "TO") 
              (list (car startData) (cdr startData) (cdr endData)))
          ) 
    entityNameList
  )
)

; 2021-05-08
(defun ModifyGsLcPipeStartData (entityNameList startData /)
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "VERSION" "FROM") 
              (list (car startData) (cdr startData)))
          ) 
    entityNameList
  )
)

; 2021-05-08
(defun ModifyGsLcPipeEndData (entityNameList endData /)
  (mapcar '(lambda (x) 
            (ModifyMultiplePropertyForOneBlockUtils x 
              (list "VERSION" "TO") 
              (list (car endData) (cdr endData)))
          ) 
    entityNameList
  )
)

; refactored at 2021-04-09
(defun c:brushBlockPropertyValueByCommand () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushBlockPropertyValueByCommandMacro '())
)

; refactored at 2021-04-09
(defun BrushBlockPropertyValueByCommandMacro (/ sourceEntityNameList sourceEntityPropertyDict sourceEntityPropertyNameList sourceEntityPropertyValueList targetEntityNameList targetEntityPropertyDict) 
  (prompt "\n选择要提取属性的数据源（数据源只能选一个）：") 
  (setq sourceEntityNameList (GetEntityNameListBySSUtils (ssget '((0 . "INSERT")))))
  (setq sourceEntityPropertyDict (GetAllPropertyDictForOneBlock (car sourceEntityNameList)))
  (setq sourceEntityPropertyNameList 
    (mapcar '(lambda (x) (strcase (car x))) 
      sourceEntityPropertyDict 
    )
  )
  (setq sourceEntityPropertyValueList 
    (mapcar '(lambda (x) (cdr x)) 
      sourceEntityPropertyDict 
    )
  ) 
  (prompt "\n选择要刷的数据（可批量选择）：")
  (setq targetEntityNameList (GetEntityNameListBySSUtils (ssget '((0 . "INSERT")))))
  (ModifyMultiplePropertyForBlockUtils targetEntityNameList sourceEntityPropertyNameList sourceEntityPropertyValueList)
  (princ "刷数据完成！")(princ)
)

; refactored at 2021-04-09
(defun c:brushBlockPropertyValue ()
  (ExecuteFunctionAfterVerifyDateUtils 'brushBlockPropertyValueByBox '("brushBlockPropertyValueBox"))
)

(defun brushBlockPropertyValueByBox (tileName / dcl_id selectedProperty selectedPropertyIndexList selectedPropertyNameList 
                                     status ss entityNameList brushedPropertyDict matchedList modifiedDataType modifiedSS modifiedEntityNameList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    ; the default value of input box
    (mode_tile "selectedProperty" 2)
    (mode_tile "modifiedDataType" 2)
    (action_tile "selectedProperty" "(setq selectedProperty $value)")
    (action_tile "modifiedDataType" "(setq modifiedDataType $value)")
    (progn
      (start_list "selectedProperty" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("工作介质" "工作温度" "工作压力" "相态" "流程图号" "管道编号"))
      (end_list)
    )
    (progn
      (start_list "modifiedDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("全部" "仪表和管道" "管道" "仪表" "设备"))
      (end_list)
    )
    ; init the default data of text
    (if (= nil selectedProperty)
      (setq selectedProperty "0")
    )
    (if (= nil modifiedDataType)
      (setq modifiedDataType "0")
    )
    (set_tile "selectedProperty" selectedProperty)
    (set_tile "modifiedDataType" modifiedDataType)
    ; Display the number of selected pipes
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq selectedPropertyIndexList (StrToListUtils selectedProperty " "))
        (setq selectedPropertyNameList (GetSelectedPropertyNameList selectedPropertyIndexList (GetBrushedPropertyNameDictList)))
        (setq ss (GetAllDataSSBySelectUtils))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq brushedPropertyDict (GetMultiplePropertyDictForOneBlockUtils (car entityNameList) selectedPropertyNameList))
        (setq matchedList (GetBrushedPropertyValueList brushedPropertyDict))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq modifiedSS (GetBlockSSBySelectByDataTypeUtils (cdr (assoc modifiedDataType (GetBrushedPropertyDataTypeDict)))))
        (setq modifiedEntityNameList (GetEntityNameListBySSUtils modifiedSS))
        (ModifyBrushedProperty modifiedEntityNameList brushedPropertyDict)
      )
    )
  )
  (setq matchedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun ModifyBrushedProperty (entityNameList brushedPropertyDict /) 
  (ModifyMultiplePropertyForBlockUtils entityNameList 
    (GetBrushedPropertyNameList brushedPropertyDict) 
    (GetBrushedPropertyValueList brushedPropertyDict)
  )
)

(defun GetBrushedPropertyNameList (brushedPropertyDict / brushedPropertyNameList) 
  (mapcar '(lambda (x) 
             (setq brushedPropertyNameList (append brushedPropertyNameList (list (strcase (car x)))))
           ) 
    brushedPropertyDict
  )
  brushedPropertyNameList
)

(defun GetBrushedPropertyValueList (brushedPropertyDict / brushedPropertyValueList) 
  (mapcar '(lambda (x) 
             (setq brushedPropertyValueList (append brushedPropertyValueList (list (cdr x))))
           ) 
    brushedPropertyDict
  )
  brushedPropertyValueList
)

(defun GetBrushedPropertyDataTypeDict () 
  (mapcar '(lambda (x y) (cons x y)) 
    '("0" "1" "2" "3" "4")
    '("AllDataType" "InstrumentAndPipe" "Pipe" "Instrument" "Equipment")      
  )
)

(defun GetSelectedPropertyNameList (selectedPropertyIndexList GetBrushedPropertyNameDictList / selectedPropertyNameList) 
  (mapcar '(lambda (x) 
             (setq selectedPropertyNameList 
                (append selectedPropertyNameList (list (cdr (assoc x GetBrushedPropertyNameDictList))))
             )
           ) 
    selectedPropertyIndexList
  )
  selectedPropertyNameList
)

(defun GetBrushedPropertyNameDictList (/ listBoxValueList brushedPropertyNameList) 
  (setq listBoxValueList '("0" "1" "2" "3" "4" "5"))
  (setq brushedPropertyNameList '("SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "DRAWNUM" "PIPENUM"))
  (mapcar '(lambda (x y) (cons x y)) 
    listBoxValueList 
    brushedPropertyNameList 
  )
)

; logic for brushBlockPropertyValue
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for generatePublicProcessElement

; refactored at 2021-04-09
(defun c:generatePublicProcessElement ()
  (ExecuteFunctionAfterVerifyDateUtils 'generatePublicProcessElementByBox '("generatePublicProcessElementBox" "Pipe"))
)

(defun generatePublicProcessElementByBox (tileName dataType / dcl_id pipeSourceDirection patternValue status ss sslen matchedList blockDataList entityNameList previewDataList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    (action_tile "btnShowOriginData" "(done_dialog 4)")
    
    ; optional setting for the popup_list tile
    (set_tile "pipeSourceDirection" "0")
    ; the default value of input box
    (mode_tile "pipeSourceDirection" 2)
    (action_tile "pipeSourceDirection" "(setq pipeSourceDirection $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    
    (progn
      (start_list "pipeSourceDirection" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("自总管" "去总管"))
      (end_list)
    )
    ; init the default data of text
    (if (= nil pipeSourceDirection)
      (setq pipeSourceDirection "0")
    )
    (if (= nil patternValue)
      (setq patternValue "*")
    )
    (set_tile "pipeSourceDirection" pipeSourceDirection)
    (set_tile "patternValue" patternValue)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (/= matchedList nil)
      (progn
        ; setting for saving the existed value of a box
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq ss (GetBlockSSBySelectByDataTypeUtils dataType))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq ss (GetAllBlockSSByDataTypeUtils dataType))
        (setq blockDataList (GetAPropertyListAndEntityNameListByPropertyNamePattern ss "PIPENUM" patternValue))
        (setq matchedList (car blockDataList))
        (setq sslen (length matchedList))
        (setq entityNameList (nth 1 blockDataList))
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy "PublicPipe")))
      )
    )
    ; generate button
    (if (= 4 status)
      (progn 
        (InsertPublicPipe previewDataList pipeSourceDirection)
        (setq status 1)
      )
    )
  )
  (setq matchedList nil)
  (unload_dialog dcl_id)
  (princ)
)

; logic for generatePublicProcessElement
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; the macro for modify data

; refactored at 2021-04-09
(defun c:modifyCommonBlockProperty ()
  (ExecuteFunctionAfterVerifyDateUtils 'modifyCommonBlockPropertyByBox '("modifyBlockPropertyBox"))
)

; refactored at 2021-04-09
(defun c:modifyAllBlockProperty ()
  (ExecuteFunctionAfterVerifyDateUtils 'filterAndModifyBlockPropertyByBoxV2 '("filterAndModifyPropertyBox"))
)

; refactored at 2021-04-09
(defun c:modifyPipeProperty ()
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyPipePropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyPipePropertyMacro (/ pipePropertyNameList)
  (setq pipePropertyNameList (GetPipePropertyNameList))
  (filterAndModifyBlockPropertyByBox pipePropertyNameList "filterAndModifyEquipmentPropertyBox" "Pipe")
)

; refactored at 2021-04-09
(defun c:modifyKsProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyKsPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyKsPropertyMacro (/ instrumentPropertyNameList)
  (setq instrumentPropertyNameList (GetInstrumentPropertyNameList))
  (filterAndModifyBlockPropertyByBox instrumentPropertyNameList "filterAndModifyEquipmentPropertyBox" "Instrument")
)

; refactored at 2021-04-09
(defun c:modifyReactorProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyReactorPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyReactorPropertyMacro (/ reactorPropertyNameList dataTypeList)
  (setq reactorPropertyNameList (GetReactorPropertyNameList))
  (filterAndModifyBlockPropertyByBox reactorPropertyNameList "filterAndModifyEquipmentPropertyBox" "Reactor")
)

; refactored at 2021-04-09
(defun c:modifyTankProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyTankPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyTankPropertyMacro (/ tankPropertyNameList dataTypeList)
  (setq tankPropertyNameList (GetTankPropertyNameList))
  (filterAndModifyBlockPropertyByBox tankPropertyNameList "filterAndModifyEquipmentPropertyBox" "Tank")
)

; refactored at 2021-04-09
(defun c:modifyHeaterProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyHeaterPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyHeaterPropertyMacro (/ heaterPropertyNameList dataTypeList)
  (setq heaterPropertyNameList (GetHeaterPropertyNameList))
  (filterAndModifyBlockPropertyByBox heaterPropertyNameList "filterAndModifyEquipmentPropertyBox" "Heater")
)

; refactored at 2021-04-09
(defun c:modifyPumpProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyPumpPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyPumpPropertyMacro (/ pumpPropertyNameList dataTypeList)
  (setq pumpPropertyNameList (GetPumpPropertyNameList))
  (filterAndModifyBlockPropertyByBox pumpPropertyNameList "filterAndModifyEquipmentPropertyBox" "Pump")
)

; refactored at 2021-04-09
(defun c:modifyVacuumProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyVacuumPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyVacuumPropertyMacro (/ vacuumPropertyNameList dataTypeList)
  (setq vacuumPropertyNameList (GetVacuumPropertyNameList))
  (filterAndModifyBlockPropertyByBox vacuumPropertyNameList "filterAndModifyEquipmentPropertyBox" "Vacuum")
)

; refactored at 2021-04-09
(defun c:modifyCentrifugeProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyCentrifugePropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyCentrifugePropertyMacro (/ centrifugePropertyNameList dataTypeList)
  (setq centrifugePropertyNameList (GetCentrifugePropertyNameList))
  (filterAndModifyBlockPropertyByBox centrifugePropertyNameList "filterAndModifyEquipmentPropertyBox" "Centrifuge")
)

; refactored at 2021-04-09
(defun c:modifyCustomEquipProperty () 
  (ExecuteFunctionAfterVerifyDateUtils 'ModifyCustomEquipPropertyMacro '())
)

; refactored at 2021-04-09
(defun ModifyCustomEquipPropertyMacro (/ customEquipPropertyNameList dataTypeList)
  (setq customEquipPropertyNameList (GetCustomEquipPropertyNameList))
  (filterAndModifyBlockPropertyByBox customEquipPropertyNameList "filterAndModifyEquipmentPropertyBox" "CustomEquip")
)

; the macro for modify data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


(defun testDoubleClick (index /)
  (alert index)(princ)
)

(defun modifyCommonBlockPropertyByBox (tileName / dcl_id status ss sslen entityNameList importedDataList entityHandle propertyNameList exportMsgBtnStatus importMsgBtnStatus modifyMsgBtnStatus blockName)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnExportData" "(done_dialog 3)")
    (action_tile "btnImportData" "(done_dialog 4)")
    (action_tile "btnModify" "(done_dialog 5)")
    (action_tile "btnGetBlockType" "(done_dialog 6)")
    ; Display the number of selected pipes
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "请先导入数据！")
    )  
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "修改CAD数据状态：已完成")
    )
    (if (/= sslen nil)
      (set_tile "selectDataNumMsg" (strcat "选择数据块的数量： " (rtos sslen)))
    )
    (if (/= blockName nil)
      (set_tile "getBlockTypeMsg" (strcat "提取数据块的名称：" blockName))
    ) 
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (if (/= blockName nil)
          (setq ss (ssget (list (cons 0 "INSERT") (cons 2 blockName))))
          (setq ss (ssget '((0 . "INSERT"))))
        ) 
        (if (/= ss nil)
          (setq sslen (sslength ss)) 
          (setq sslen 0) 
        )
      )
    )
    ; export data button
    (if (= 3 status) 
      (progn 
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (WriteCommonDataToCSVByEntityNameListUtils entityNameList)
        (setq exportMsgBtnStatus 1) 
      )
    ) 
    ; import data button
    (if (= 4 status) 
      (progn 
        (setq importedDataList (StrListToListListUtils (ReadGsDataFromCSVStrategy "commonBlock")))
        (setq importedDataList (RemoveApostrForListListUtils importedDataList))
        (setq importMsgBtnStatus 1)
      )
    )
    ; modify button
    (if (= 5 status) 
      (progn 
        (if (/= importedDataList nil) 
          (progn 
            (setq entityHandle (car (car importedDataList)))
            (setq propertyNameList (GetBlockPropertyNameListByEntityNameUtils (handent entityHandle)))
            (ModifyPropertyValueByEntityHandleUtils importedDataList (GetUpperCaseForListUtils (cdr propertyNameList)))
            (setq modifyMsgBtnStatus 1)
          )
          (setq importMsgBtnStatus 2)
        )
      )
    )
    ; get block type button
    (if (= 6 status) 
      (progn 
        (setq blockName (GetBlockNameBySelectUtils))
      )
    ) 
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun filterAndModifyBlockPropertyByBoxV2 (tileName / dcl_id exportDataType viewPropertyName dataType importedDataList selectedName propertyNameList status ss confirmList entityNameList exportMsgBtnStatus importMsgBtnStatus comfirmMsgBtnStatus modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnExportData" "(done_dialog 2)")
    (action_tile "btnImportData" "(done_dialog 3)")
    (action_tile "btnPreviewModify" "(done_dialog 4)")
    (action_tile "btnModify" "(done_dialog 5)")
    ; optional setting for the popup_list tile
    (set_tile "exportDataType" "0")
    (set_tile "viewPropertyName" "0")
    ; the default value of input box
    (mode_tile "viewPropertyName" 2)
    (mode_tile "exportDataType" 2)
    (action_tile "exportDataType" "(setq exportDataType $value)")
    (action_tile "viewPropertyName" "(setq viewPropertyName $value)")
    ; init the value of listbox
    (progn
      (start_list "exportDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetTempExportedDataTypeChNameList))
      (end_list)
      (start_list "viewPropertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
    )
    ; init the default data of text
    (if (= nil exportDataType)
      (setq exportDataType "0")
    )
    (if (= nil viewPropertyName)
      (setq viewPropertyName "0")
    )
    ; Display the number of selected pipes
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "导出数据状态：已完成")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "导入数据状态：已完成")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "导入数据状态：不能所有设备一起导入")
    ) 
    (if (= importMsgBtnStatus 3)
      (set_tile "importBtnMsg" "请先导入数据！")
    )  
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "修改CAD数据状态：已完成")
    )
    (if (= modifyMsgBtnStatus 2)
      (set_tile "modifyBtnMsg" "请先预览确认一下数据，一旦写错 CAD 数据全毁！")
    ) 
    (set_tile "exportDataType" exportDataType)
    (set_tile "viewPropertyName" viewPropertyName) 
    (if (/= confirmList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 confirmList)
        (end_list)
      )
    )
    ; all select button
    ; export data button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq dataType (GetTempExportedDataTypeByindex exportDataType))
        (setq ss (GetAllBlockSSByDataTypeUtils dataType))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (WriteDataToCSVByEntityNameListStrategy entityNameList dataType)
        (setq exportMsgBtnStatus 1) 
      )
    )
    ; import data button
    (if (= 3 status) 
      (progn 
        (setq dataType (GetTempExportedDataTypeByindex exportDataType))
        (if (/= dataType "Equipment") 
          (progn 
            (setq importedDataList (StrListToListListUtils (ReadGsDataFromCSVStrategy dataType)))
            (setq importMsgBtnStatus 1)
          ) 
          (setq importMsgBtnStatus 2)
        ) 
      )
    )
    ; confirm button
    (if (= 4 status) 
      (if (= importMsgBtnStatus 1) 
        (progn 
          (setq dataType (GetTempExportedDataTypeByindex exportDataType))
          (setq propertyNameList (GetPropertyNameListStrategy dataType))
          (setq selectedName (nth (atoi viewPropertyName) propertyNameList))
          (if (/= importedDataList nil) 
            (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName dataType))
            (setq confirmList '(""))
          ) 
          (setq comfirmMsgBtnStatus 1)
        ) 
        (setq importMsgBtnStatus 3)
      )
    )
    ; modify button
    (if (= 5 status) 
      (progn 
        (if (/= importedDataList nil) 
          (progn 
            (ModifyPropertyValueByEntityHandleUtils importedDataList (GetPropertyNameListStrategy dataType))
            (setq modifyMsgBtnStatus 1)
          )
          (setq importMsgBtnStatus 3)
        )
      ) 
    )
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun GetTempExportedDataTypeChNameList ()
  '("管道" "仪表" "所有设备" "反应釜" "输送泵" "储罐" "换热器" "离心机" "真空泵" "自定义设备" "洁净空凋条件")
)

; unit test compeleted
(defun GetTempExportedDataTypeByindex (index / result)
  (setq result (nth (atoi index) '("Pipe" "Instrument" "Equipment" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip" "GsCleanAir")))
  result
)

(defun filterAndModifyBlockPropertyByBox (propertyNameList tileName dataType / dcl_id propertyName propertyValue filterPropertyName patternValue replacedSubstring status selectedName selectedFilterName ss sslen matchedList importedList confirmList blockDataList entityNameList viewPropertyName previewDataList importedDataList exportMsgBtnStatus importMsgBtnStatus modifyMsgBtnStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
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
    ;(mode_tile "matchedResult" 2)
    (action_tile "propertyName" "(setq propertyName $value)")
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "filterPropertyName" "(setq filterPropertyName $value)")
    (action_tile "viewPropertyName" "(setq viewPropertyName $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ;(action_tile "matchedResult" "(testDoubleClick $value)")
    
    (progn
      (start_list "filterPropertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (start_list "viewPropertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (start_list "propertyName" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetPropertyChNameListStrategy dataType))
      (end_list)
      (set_tile "dataTypeMsg" (GetDataTypeMsgStrategy dataType))
    )
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
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
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
        (setq previewDataList (GetPropertyValueListByEntityNameList entityNameList (GetPropertyNameListStrategy dataType)))
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
        (if (or (/= propertyValue "") (/= replacedSubstring "")) 
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
          (ModifyPropertyValueByEntityHandleUtils importedDataList (GetPropertyNameListStrategy dataType))
          (ModifyPropertyValueByEntityHandleUtils previewDataList (GetPropertyNameListStrategy dataType))
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
        (setq importedDataList (StrListToListListUtils (ReadGsDataFromCSVStrategy dataType)))
        (setq importMsgBtnStatus 1)
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
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Instrument") 
    (progn 
      (setq propertyNameList (GetInstrumentPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Reactor") 
    (progn 
      (setq propertyNameList (GetReactorPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Tank") 
    (progn 
      (setq propertyNameList (GetTankPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Heater") 
    (progn 
      (setq propertyNameList (GetHeaterPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Pump") 
    (progn 
      (setq propertyNameList (GetPumpPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Vacuum") 
    (progn 
      (setq propertyNameList (GetVacuumPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "Centrifuge") 
    (progn 
      (setq propertyNameList (GetCentrifugePropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "CustomEquip") 
    (progn 
      (setq propertyNameList (GetCustomEquipPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
    )
  )
  (if (= dataType "GsCleanAir") 
    (progn 
      (setq propertyNameList (GetGsCleanAirPropertyNameList))
      (setq importedDataListIndex (GenerateSortedNumByList propertyNameList 1))
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
; function for modify data

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

(defun GetOnePropertyValueListByEntityNameList (entityNameList selectedName / onePropertyValueList) 
  (setq selectedName (strcase selectedName T))
  (mapcar '(lambda (x) 
             (setq onePropertyValueList (append onePropertyValueList 
                                          (list (cdr (assoc selectedName (GetAllPropertyDictForOneBlock x))))
                                        )
             )
           ) 
    entityNameList
  )
  onePropertyValueList
)

(defun GetAllPropertyDictForOneBlock (entityName / entityData entx propertyValueList)
  (setq entityData (entget entityName))
  ; get the property information
  (setq entx (entget (entnext (cdr (assoc -1 entityData)))))
  (while (= "ATTRIB" (cdr (assoc 0 entx)))
    (setq propertyValueList (append propertyValueList 
                              (list (cons (strcase (cdr (assoc 2 entx)) T) (cdr (assoc 1 entx))))
                            )
    )
    ; get the next property information
    (setq entx (entget (entnext (cdr (assoc -1 entx)))))
  )
  (cons (cons "entityhandle" (cdr (assoc 5 entityData))) propertyValueList)
)

(defun GetBlockAllPropertyDictListUtils (entityNameList / resultList)
  (mapcar '(lambda (x) 
             (setq resultList (append resultList (list (GetAllPropertyDictForOneBlock x))))
           ) 
    entityNameList
  )
  resultList
)

; function for modify data
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Number Pipeline, Instrument and Equipment

(defun GetNumberDataTypeChNameList ()
  '("管道" "仪表" "反应釜" "输送泵" "储罐" "换热器" "离心机" "真空泵" "自定义设备")
)

(defun GetNumberDataTypeList ()
  '("Pipe" "Instrument" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip")
)

(defun GetNumberdataChildrenTypeChNameList ()
  '("温度" "压力" "液位" "流量" "称重" "检测" "开关阀" "温度调节阀" "压力调节阀" "液位调节阀" "流量调节阀")
)

; refactored at 2021-05-02
(defun numberedPropertyNameListStrategy (dataType /)
  (cond 
    ((= dataType "Pipe") '("PIPENUM" "DRAWNUM"))
    ((= dataType "Instrument") '("TAG" "FUNCTION" "DRAWNUM" "LOCATION"))
    ((= dataType "Reactor") '("TAG" "DRAWNUM"))
    ((= dataType "Pump") '("TAG" "DRAWNUM"))
    ((= dataType "Tank") '("TAG" "DRAWNUM"))
    ((= dataType "Heater") '("TAG" "DRAWNUM"))
    ((= dataType "Centrifuge") '("TAG" "DRAWNUM"))
    ((= dataType "Vacuum") '("TAG" "DRAWNUM"))
    ((= dataType "CustomEquip") '("TAG" "DRAWNUM"))
    ((= dataType "Equipment") '("TAG" "DRAWNUM"))
    ((= dataType "GsCleanAir") '("ROOM_NUM"))
    ((= dataType "FireFightHPipe") '("PIPENUM"))  ; 2021-02-03
    ((= dataType "GsBzEquip") '("TAG"))  ; 2021-05-02
  )
)

(defun instrumentFunctionMatchStrategy (dataChildrenType /)
  (cond 
    ((= dataChildrenType "0") "T[~CV]*")
    ((= dataChildrenType "1") "P[~CV]*")
    ((= dataChildrenType "2") "L[~CV]*")
    ((= dataChildrenType "3") "F[~CV]*")
    ((= dataChildrenType "4") "W[~CV]*")
    ((= dataChildrenType "5") "A[~CV]*")
    ((= dataChildrenType "6") "XV*")
    ((= dataChildrenType "7") "T[CV]*")
    ((= dataChildrenType "8") "P[CV]*")
    ((= dataChildrenType "9") "L[CV]*")
    ((= dataChildrenType "10") "F[CV]*")
    ((= dataChildrenType "Instrument") "*")
  )
)


; refactored at 2021-04-09
(defun c:numberPipelineAndTag () 
  (ExecuteFunctionAfterVerifyDateUtils 'NumberPipelineAndTagMacro '())
)

; refactored at 2021-04-09
(defun NumberPipelineAndTagMacro (/ dataTypeList)
  (setq dataTypeList (GetNumberDataTypeList))
  (numberPipelineAndTagByBox dataTypeList "filterAndNumberBox")
)

(defun numberPipelineAndTagByBox (propertyNameList tileName / dcl_id dataType dataChildrenType patternValue propertyValue replacedSubstring status selectedPropertyName selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList modifyMessageStatus modifyMsgBtnStatus numberedList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAll" "(done_dialog 3)")
    (action_tile "btnClickSelect" "(done_dialog 4)")
    (action_tile "btnPreviewModify" "(done_dialog 5)")
    (action_tile "btnModify" "(done_dialog 6)")
    (mode_tile "dataType" 2)
    (mode_tile "dataChildrenType" 2)
    (action_tile "dataType" "(setq dataType $value)")
    (action_tile "dataChildrenType" "(setq dataChildrenType $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ; init the default data of text
    (progn 
      (start_list "dataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberDataTypeChNameList)
      )
      (end_list)
      (start_list "dataChildrenType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberdataChildrenTypeChNameList)
      )
      (end_list)
    )  
    (if (= nil dataType)
      (setq dataType "0")
    )
    (if (= nil dataChildrenType)
      (setq dataChildrenType "0")
    )
    (if (= nil patternValue)
      (setq patternValue "*")
    )
    (if (= nil propertyValue)
      (setq propertyValue "")
    )
    (if (= nil replacedSubstring)
      (setq replacedSubstring "")
    )
    ; setting for saving the existed value of a box
    (set_tile "dataType" dataType)
    (set_tile "dataChildrenType" dataChildrenType)
    (set_tile "patternValue" patternValue)
    (set_tile "replacedSubstring" replacedSubstring)
    (set_tile "propertyValue" propertyValue) 
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "resultMsg" "请先预览修改")
    )
    (if (/= selectedDataType nil)
      (set_tile "dataType" dataType)
    )
    (if (/= matchedList nil)
      (progn 
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
        (setq selectedDataType (nth (atoi dataType) propertyNameList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        ; sort by x cordinate
        (setq ss (SortSelectionSetByXYZ ss))
        (setq entityNameList (GetNumberedEntityNameList ss selectedDataType dataChildrenType))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        ; filter pipe by patternValue
        (setq propertyValueDictList (FilterPipeByPatternValue propertyValueDictList patternValue selectedDataType))
        (setq matchedList (GetNumberedPropertyValueListStrategy propertyValueDictList selectedDataType dataChildrenType))
        (setq sslen (length matchedList))
      )
    )
    ; all select button
    (if (= 3 status)
      (progn 
        (setq selectedDataType (nth (atoi dataType) propertyNameList))
        (setq ss (GetAllBlockSSByDataTypeUtils selectedDataType))
        ; sort by x cordinate
        (setq ss (SortSelectionSetByXYZ ss))
        (setq entityNameList (GetNumberedEntityNameList ss selectedDataType dataChildrenType))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        ; filter pipe by patternValue
        (setq propertyValueDictList (FilterPipeByPatternValue propertyValueDictList patternValue selectedDataType)) 
        (setq matchedList (GetNumberedPropertyValueListStrategy propertyValueDictList selectedDataType dataChildrenType))
        (setq sslen (length matchedList))
      )
    )
    ; click select button
    (if (= 4 status)
      (progn 
        (setq selectedDataType (nth (atoi dataType) propertyNameList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        (setq entityNameList (GetNumberedEntityNameList ss selectedDataType dataChildrenType))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        ; filter pipe by patternValue
        (setq propertyValueDictList (FilterPipeByPatternValue propertyValueDictList patternValue selectedDataType)) 
        (setq matchedList (GetNumberedPropertyValueListStrategy propertyValueDictList selectedDataType dataChildrenType))
        (setq sslen (length matchedList))
      )
    )
    ; confirm button
    (if (= 5 status)
      (progn 
        (setq numberedList (GetNumberedListByStartAndLengthUtils replacedSubstring propertyValue (length matchedList)))
        (setq confirmList (GetNumberedListByFirstDashUtils numberedList matchedList))
      )
    )
    ; modify button
    (if (= 6 status)
      (progn 
        (if (= confirmList nil)
          (setq modifyMessageStatus 0)
          (progn 
            (setq selectedPropertyName (car (numberedPropertyNameListStrategy selectedDataType)))
            (setq entityNameList (GetNewEntityNameList propertyValueDictList))
            (mapcar '(lambda (x y) 
                      (ModifyMultiplePropertyForOneBlockUtils x (list selectedPropertyName) (list y))
                    ) 
              entityNameList
              confirmList 
            )
          )
        )
        (setq modifyMsgBtnStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun GetNewEntityNameList (dictList /)
  (mapcar '(lambda (x) 
             (handent (cdr (assoc "entityhandle" x)))
           ) 
    dictList
  )
)

(defun FilterPipeByPatternValue (dictList patternValue dataType /) 
  (if (= dataType "Pipe") 
    (setq dictList 
      (vl-remove-if-not '(lambda (x) 
                          (wcmatch (cdr (assoc "PIPENUM" x)) 
                                    patternValue
                          ) 
                        ) 
        dictList
      )     
    )
  )
  dictList
)

(defun GetNumberedEntityNameList (ss dataType dataChildrenType / dictList entityNameList resultList)
  (if (= dataType "Instrument") 
    (progn 
      (setq entityNameList (GetEntityNameListBySSUtils ss))
      (setq dictList (GetPropertyDictListByPropertyNameList entityNameList '("entityhandle" "FUNCTION")))
      (setq dictList 
        (vl-remove-if-not '(lambda (x) 
                            (wcmatch (cdr (assoc "FUNCTION" x)) 
                                      (instrumentFunctionMatchStrategy dataChildrenType)
                            ) 
                          ) 
          dictList
        ) 
      )
      (mapcar '(lambda (x) 
                 (setq resultList (append resultList (list (handent (cdr (assoc "entityhandle" x))))))
               ) 
        dictList
      )
    )
    (setq resultList (GetEntityNameListBySSUtils ss))
  )
  resultList
)

; refactored at 2021-05-02
(defun GetNumberedPropertyValueListStrategy (dictList dataType dataChildrenType /) 
  (if (= dataType "Instrument") 
    (progn 
      (setq dictList (GetInstrumentChildrenTypeList dictList dataType dataChildrenType))
      (mapcar '(lambda (x) 
                (strcat (cdr (assoc (nth 1  (numberedPropertyNameListStrategy dataType)) x)) 
                  (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x))
                )
              ) 
        dictList
      ) 
    )
    (GetNumberedPropertyValueList dictList dataType)
  )
)

(defun GetInstrumentChildrenTypeList (dictList dataType dataChildrenType /)
  (vl-remove-if-not '(lambda (x) 
                       (wcmatch (cdr (assoc (nth 1 (numberedPropertyNameListStrategy dataType)) x)) 
                                (instrumentFunctionMatchStrategy dataChildrenType)
                       ) 
                     ) 
    dictList
  )
)

; 2021-05-02
(defun GetNumberedPropertyValueList (dictList dataType /) 
  (mapcar '(lambda (x) 
            (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x))
          ) 
    dictList
  )
)

;;;----------------------------Enhanced Number Data------------------------;;;

; refactored at 2021-04-09
(defun c:enhancedNumber () 
  (ExecuteFunctionAfterVerifyDateUtils 'EnhancedNumberMacro '())
)

; refactored at 2021-04-09
(defun EnhancedNumberMacro (/ dataTypeList dataTypeChNameList dataModeChNameList)
  (setq dataTypeList (GetEnhancedNumberDataTypeList))
  (setq dataTypeChNameList (GetEnhancedNumberDataTypeChNameList))
  (setq dataModeChNameList (GetNumberGsLcDataModeChNameList))
  (enhancedNumberByBox dataTypeList dataTypeChNameList dataModeChNameList "enhancedNumberBox")
)

(defun GetEnhancedNumberDataTypeList ()
  '("Pipe" "Instrument" "Equipment")
)

(defun GetEnhancedNumberDataTypeChNameList ()
  '("管道" "仪表" "设备")
)

(defun GetNumberGsLcDataModeChNameList ()
  '("按流程图号" "不按流程图号" "仪表编号按设备位号")
)

(defun enhancedNumberByBox (dataTypeList dataTypeChNameList dataModeChNameList tileName / dcl_id dataType numberMode numberDirection status selectedPropertyName 
                            selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList 
                            modifyMessageStatus numberedDataList numberedList codeNameList startNumberString)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnPreviewNumber" "(done_dialog 3)")
    (action_tile "btnComfirmNumber" "(done_dialog 4)")
    (mode_tile "dataType" 2)
    (mode_tile "numberMode" 2)
    (mode_tile "numberDirection" 2)
    (action_tile "dataType" "(setq dataType $value)")
    (action_tile "numberMode" "(setq numberMode $value)")
    (action_tile "numberDirection" "(setq numberDirection $value)")
    (action_tile "startNumberString" "(setq startNumberString $value)")
    ; init the default data of text
    (progn 
      (start_list "dataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                dataTypeChNameList
      )
      (end_list)
      (start_list "numberMode" 3)
      (mapcar '(lambda (x) (add_list x)) 
                dataModeChNameList
      )
      (end_list)
      (start_list "numberDirection" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("自上而下" "自左而右")
      )
      (end_list)
    ) 
    (if (= nil dataType)
      (setq dataType "0")
    )
    (if (= nil numberMode)
      (setq numberMode "0")
    )
    (if (= nil numberDirection)
      (setq numberDirection "0")
    )
    (if (= nil startNumberString)
      (setq startNumberString "")
    ) 
    ; setting for saving the existed value of a box
    (set_tile "dataType" dataType)
    (set_tile "numberMode" numberMode)
    (set_tile "numberDirection" numberDirection)
    (set_tile "startNumberString" startNumberString)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "匹配到的数量： " (rtos sslen)))
    )
    (if (= modifyMessageStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "modifyBtnMsg" "请先预览修改")
    )
    (if (/= selectedDataType nil)
      (set_tile "dataType" dataType)
    )
    (if (/= matchedList nil)
      (progn
        (start_list "matchedResult" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 matchedList)
        ;(add_list matchedList)
        (end_list)
      )
    )
    ; select button
    (if (= 2 (setq status (start_dialog)))
      (progn 
        (setq selectedDataType (nth (atoi dataType) dataTypeList))
        (setq ss (GetBlockSSBySelectByDataTypeUtils selectedDataType))
        ; 2021-05-02 sort by numberDirecion
        (setq ss (GetSSByNumberDirectionStrategy numberDirection ss)) 
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueListStrategy propertyValueDictList selectedDataType "Instrument"))
        (setq sslen (length matchedList))
      )
    )
    ; confirm button
    (if (= 3 status)
      (progn 
        (setq codeNameList (GetCodeNameListStrategy propertyValueDictList selectedDataType))
        (setq numberedDataList (GetNumberedDataListStrategy propertyValueDictList selectedDataType codeNameList numberMode startNumberString))
        (setq matchedList (GetNumberedListStrategy numberedDataList selectedDataType))
        (setq confirmList matchedList)
      )
    )
    ; modify button
    (if (= 4 status)
      (progn 
        (if (/= confirmList nil) 
          (progn 
            (UpdateNumberedData numberedDataList selectedDataType)
            (setq modifyMessageStatus 1)
          )
          (setq modifyMessageStatus 0)
        )
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun GetNumberedStringforEnhancedNumber (childrenData dataType /)
  (numberedStringSubstUtil 
    (cdr (assoc "numberedString" childrenData)) 
    (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) childrenData))
  )
)

(defun UpdateNumberedData (numberedDataList dataType / selectedPropertyName numberedString) 
  (setq selectedPropertyName (car (numberedPropertyNameListStrategy dataType)))
  (foreach item numberedDataList 
    (mapcar '(lambda (x) 
               (setq numberedString (GetNumberedStringforEnhancedNumber x dataType))
               (setq entityName (handent (cdr (assoc "entityhandle" x))))
               (ModifyMultiplePropertyForOneBlockUtils entityName (list selectedPropertyName) (list numberedString))
            ) 
      item
    ) 
  )
)

; 2021-05-02
(defun GetSSByNumberDirectionStrategy (numberDirection ss /) 
  (cond 
    ((= numberDirection "0") (SortSelectionSetByRowColumn ss))
    ((= numberDirection "1") (SortSelectionSetByXYZ ss))
  )
)

; refactored at 2021-05-02
(defun GetNumberedDataListStrategy (propertyValueDictList dataType codeNameList numberMode startNumberString / childrenData childrenDataList numberedList) 
  (cond 
    ((or (= dataType "Pipe") (= dataType "Equipment") ) 
      (GetPipeAndEquipChildrenDataList propertyValueDictList dataType codeNameList numberMode startNumberString)
    )
    ((= dataType "Instrument") 
      (GetInstrumentChildrenDataList propertyValueDictList dataType numberMode startNumberString)
    )
    ((or (= dataType "GsCleanAir") (= dataType "FireFightHPipe") (= dataType "GsBzEquip")) 
      (GetGsCleanAirRoomNumDataList propertyValueDictList dataType codeNameList numberMode startNumberString)
    )
  )
)

; refactored at 2021-05-02
(defun GetGsCleanAirRoomNumDataList (propertyValueDictList dataType codeNameList numberMode startNumberString / childrenDataList numberedList) 
  (cond 
    ((= numberMode "0") 
      (progn 
        (setq childrenDataList (car (GetGsCleanAirChildrenDataListByRoomNum propertyValueDictList dataType codeNameList)))
        (setq numberedList (cadr (GetGsCleanAirChildrenDataListByRoomNum propertyValueDictList dataType codeNameList)))
      )
    )
    ((= numberMode "1") 
      (progn 
        (setq childrenDataList (car (GetGsCleanAirChildrenDataListByByNoRoomNum propertyValueDictList dataType codeNameList)))
        (setq numberedList (cadr (GetGsCleanAirChildrenDataListByByNoRoomNum propertyValueDictList dataType codeNameList)))
      )
    )
  )
  (mapcar '(lambda (x y) 
              (mapcar '(lambda (xx yy) 
                        (append xx (list (cons "numberedString" (GetGsCleanAirCodeNameByNumberModeStrategy yy numberMode startNumberString dataType))))
                      ) 
                x 
                y
              )  
           ) 
    childrenDataList 
    numberedList
  ) 
)

; 2021-02-03
(defun GetLayoutCodeNameStrategy (dataType /)
  (cond 
    ((= dataType "GsCleanAir") 
      (GetGsCleanAirCodeName (cdr (assoc "ROOM_NUM" x)))
    )
    ((= dataType "FireFightHPipe") 
      (GetGsCleanAirCodeName (cdr (assoc "PIPENUM" x)))
    ) 
    ((= dataType "GsBzEquip") 
      (GetGsCleanAirCodeName (cdr (assoc "TAG" x)))
    )
  )
)

(defun GetGsCleanAirChildrenDataListByRoomNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (mapcar '(lambda (roomNum) 
              (setq childrenData 
                (vl-remove-if-not '(lambda (x) 
                                      ; sort data by codeName
                                      (= roomNum (GetLayoutCodeNameStrategy dataType))
                                  ) 
                  propertyValueDictList
                ) 
              )
              (setq childrenDataList (append childrenDataList (list childrenData))) 
              (setq numberedList 
                (append numberedList (list (GetNumberedListByStartAndLengthUtils roomNum "1" (length childrenData))))
              ) 
           ) 
    codeNameList
  )
  (list childrenDataList numberedList)
)

(defun GetGsCleanAirChildrenDataListByByNoRoomNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (setq childrenDataList (append childrenDataList (list propertyValueDictList))) 
  (setq numberedList 
    (append numberedList (list (GetNumberedListByStartAndLengthUtils "" "1" (length propertyValueDictList))))
  ) 
  (list childrenDataList numberedList)
)

; fix bug - add the SIS instrument - 2021-01-14
(defun GetInstrumentTypeMatchList ()
  '("T[~CVZ]*" "P[~CVZ]*" "L[~CVZ]*" "F[~CVZ]*" "W[~CVZ]*" "A[~CVZ]*" "XV*" "T[CV]*" "P[CV]*" "L[CV]*" "F[CV]*" "W[CV]*" "A[CV]*"
    "TZ[~CV]*" "PZ[~CV]*" "LZ[~CV]*" "FZ[~CV]*" "WZ[~CV]*" "AZ[~CV]*" "XZV*" "TZ[CV]*" "PZ[CV]*" "LZ[CV]*" "FZ[CV]*" "WZ[CV]*" "AZ[CV]*")
)

(defun GetInstrumentChildrenDataList (propertyValueDictList dataType numberMode startNumberString / instrumentTypeMatchList childrenData childrenDataList numberedList) 
  (cond 
    ((= numberMode "0") 
      (progn 
        (setq childrenDataList (car (GetInstrumentChildrenDataListByDrawNum propertyValueDictList dataType)))
        (setq numberedList (cadr (GetInstrumentChildrenDataListByDrawNum propertyValueDictList dataType)))
        (GetNumberedKsChildrenDataListByDrawNum childrenDataList numberedList startNumberString)
      )
    )
    ((= numberMode "1") 
      (progn 
        (setq childrenDataList (car (GetInstrumentChildrenDataListByNoDrawNum propertyValueDictList dataType)))
        (setq numberedList (cadr (GetInstrumentChildrenDataListByNoDrawNum propertyValueDictList dataType)))
        (GetNumberedKsChildrenDataListByNoDrawNum childrenDataList numberedList startNumberString)
      )
    )
    ((= numberMode "2") 
      (progn 
        ; refactor propertyValueDictList, set all location feild to equipTag - 2021-01-25
        (setq propertyValueDictList (RefactorPropertyValueDictList propertyValueDictList))
        (setq childrenDataList (car (GetInstrumentChildrenDataListByEquipTag propertyValueDictList dataType)))
        (setq numberedList (cadr (GetInstrumentChildrenDataListByEquipTag propertyValueDictList dataType)))
        (GetNumberedKsChildrenDataListByEquipTag childrenDataList numberedList startNumberString)
      )
    ) 
  )
)

(defun RefactorPropertyValueDictList (propertyValueDictList / pipeFromAndToDictList ksDataOnPipe ksDataOnEquip oldValue oldValue) 
  (setq pipeFromAndToDictList (GetAllPipeFromAndToDictList))
  (setq equipPositionDictList (GetAllEquipPositionDictListUtils))
  (setq ksDataOnPipe 
    (vl-remove-if-not '(lambda (x) 
                        (/= (IsKsLocationOnPipe (cdr (assoc "LOCATION" x))) nil)
                      ) 
      propertyValueDictList
    )
  )
  (setq ksDataOnPipe 
    (mapcar '(lambda (x) 
               (setq oldValue (assoc "LOCATION" x))
               (setq newValue (cons "LOCATION" (GetNewEquipTagLocation x pipeFromAndToDictList equipPositionDictList)))
               (subst newValue oldValue x)
            )
      ksDataOnPipe
    ) 
  ) 
  (setq ksDataOnEquip 
    (vl-remove-if-not '(lambda (x) 
                        (/= (IsKsLocationOnEquip (cdr (assoc "LOCATION" x))) nil)
                      ) 
      propertyValueDictList
    )
  ) 
  (append ksDataOnEquip ksDataOnPipe)
)

; 2021-01-26
; refactored at 2021-03-30
(defun GetNewEquipTagLocation (oneKsDataOnPipe pipeFromAndToDictList equipPositionDictList / pipeLine pipeFromToPair)
  (setq pipeLine (GetPipeLineByPipeNum (cdr (assoc "LOCATION" oneKsDataOnPipe))))
  (setq pipeFromToPair (cdr (assoc pipeLine pipeFromAndToDictList)))
  ; red hat - pipeFromToPair may be nil, beacuse the pipeLine(instrument location is wrong)
  (if (/= pipeFromToPair nil) 
    (GetEquipTagLinkedPipe (car pipeFromToPair) (cadr pipeFromToPair) oneKsDataOnPipe equipPositionDictList)
  )
)

; 2021-01-25
(defun GetEquipTagLinkedPipe (fromData toData oneKsDataOnPipe equipPositionDictList / result)
  (if (and (/= (IsKsLocationOnEquip fromData) nil) (= (IsKsLocationOnEquip toData) nil)) 
    (setq result fromData)
  )
  (if (and (/= (IsKsLocationOnEquip toData) nil) (= (IsKsLocationOnEquip fromData) nil)) 
    (setq result toData)
  ) 
  ; ready for develop for from and to both be equip - 2021-01-25
  (if (and (/= (IsKsLocationOnEquip toData) nil) (/= (IsKsLocationOnEquip fromData) nil)) 
    (setq result (GetNearestEquipForKsData fromData toData oneKsDataOnPipe equipPositionDictList))
  )  
  result
)

(defun GetNearestEquipForKsData (fromData toData oneKsDataOnPipe equipPositionDictList / firstDistance secondDistance result) 
  (setq ksPositon (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" oneKsDataOnPipe)))))
  (if (and (/= (assoc fromData equipPositionDictList) nil) (/= (assoc toData equipPositionDictList) nil)) 
    (progn 
      (setq firstDistance 
        (distance 
          ksPositon 
          (cdr (assoc fromData equipPositionDictList)) 
        ) 
      )
      (setq secondDistance 
        (distance 
          ksPositon 
          (cdr (assoc toData equipPositionDictList)) 
        ) 
      ) 
      (if (< firstDistance secondDistance) 
        (setq result fromData)
        (setq result toData)
      )
    )
  ) 
  (if (and (/= (assoc fromData equipPositionDictList) nil) (= (assoc toData equipPositionDictList) nil)) 
    (setq result fromData)
  ) 
  (if (and (= (assoc fromData equipPositionDictList) nil) (/= (assoc toData equipPositionDictList) nil)) 
    (setq result toData)
  ) 
  (if (and (= (assoc fromData equipPositionDictList) nil) (= (assoc toData equipPositionDictList) nil)) 
    (setq result fromData)
  ) 
  result
)

; 2021-01-25
(defun GetAllPipeFromAndToDictList ()
  (mapcar '(lambda (x) 
             (cons 
               (GetPipeLineByPipeNum (cdr (assoc "pipenum" x))) 
               (list (cdr (assoc "from" x)) (cdr (assoc "to" x)))
             )
           )
    (GetAllPipeDataUtils)
  )
)

(defun GetPipeLineByPipeNum (pipeNum /)
  (RegExpReplace pipeNum "([A-Za-z]+\\d+)-?.*" "$1" nil nil)
)

; 2021-01-25
(defun GetNumberedKsChildrenDataListByDrawNum (childrenDataList numberedList startNumberString /) 
  (mapcar '(lambda (x y) 
              (mapcar '(lambda (xx yy) 
                        (append xx (list (cons "numberedString" (GetInstrumentCodeNameByDrawNum yy (cdr (assoc "DRAWNUM" xx)) startNumberString))))
                      ) 
                x 
                y
              )  
           ) 
    childrenDataList 
    numberedList
  ) 
)

; 2021-01-25
(defun GetNumberedKsChildrenDataListByNoDrawNum (childrenDataList numberedList startNumberString /) 
  (mapcar '(lambda (x y) 
              (mapcar '(lambda (xx yy) 
                        (append xx (list (cons "numberedString" (strcat startNumberString yy))))
                      ) 
                x 
                y
              )  
           ) 
    childrenDataList 
    numberedList
  ) 
)

; 2021-01-25
(defun GetNumberedKsChildrenDataListByEquipTag (childrenDataList numberedList startNumberString /) 
  (mapcar '(lambda (x y) 
              (mapcar '(lambda (xx yy) 
                        (append xx (list (cons "numberedString" (GetInstrumentCodeNameByEquipTag yy (cdr (assoc "LOCATION" xx)) startNumberString))))
                      ) 
                x 
                y
              )  
           ) 
    childrenDataList 
    numberedList
  ) 
)

(defun GetInstrumentCodeNameByDrawNum (originString drawNum startNumberString /) 
  (setq drawNum (RegExpReplace (ExtractDrawNumUtils drawNum) "0(\\d)-(\\d*)" (strcat "$1" "$2") nil nil))
  (strcat startNumberString drawNum originString)
)

; 2021-01-25
(defun GetInstrumentCodeNameByEquipTag (originString equipTag startNumberString /) 
  (strcat startNumberString equipTag "-" originString)
)

(defun GetInstrumentChildrenDataListByEquipTag (propertyValueDictList dataType / instrumentTypeMatchList childrenData childrenDataList numberedList) 
  (setq instrumentTypeMatchList (GetInstrumentTypeMatchList))
  (mapcar '(lambda (equipTag) 
      (foreach item instrumentTypeMatchList 
        (setq childrenData 
          (vl-remove-if-not '(lambda (x) 
                                ; sort data by codeName
                                (and 
                                  (wcmatch (cdr (assoc (cadr (numberedPropertyNameListStrategy dataType)) x)) item)
                                  (= equipTag (cdr (assoc "LOCATION" x)))
                                )
                            ) 
            propertyValueDictList
          ) 
        )
        (setq childrenDataList (append childrenDataList (list childrenData))) 
        (setq numberedList 
          (append numberedList (list (GetNumberedListByStartAndLengthUtils "" "1" (length childrenData))))
        ) 
      ) 
    ) 
    (GetUniqueKsLocationList propertyValueDictList)
  )
  (list childrenDataList numberedList)
)

(defun GetInstrumentChildrenDataListByNoDrawNum (propertyValueDictList dataType / instrumentTypeMatchList childrenData childrenDataList numberedList) 
  (setq instrumentTypeMatchList (GetInstrumentTypeMatchList))
  (foreach item instrumentTypeMatchList 
    (setq childrenData 
      (vl-remove-if-not '(lambda (x) 
                           ; sort data by codeName
                          (wcmatch (cdr (assoc (cadr (numberedPropertyNameListStrategy dataType)) x)) item)
                        ) 
        propertyValueDictList
      ) 
    )
    (setq childrenDataList (append childrenDataList (list childrenData))) 
    (setq numberedList 
      (append numberedList (list (GetNumberedListByStartAndLengthUtils "" "1" (length childrenData))))
    ) 
  )
  (list childrenDataList numberedList)
)

(defun GetInstrumentChildrenDataListByDrawNum (propertyValueDictList dataType / instrumentTypeMatchList childrenData childrenDataList numberedList) 
  (setq instrumentTypeMatchList (GetInstrumentTypeMatchList))
  (mapcar '(lambda (drawNum) 
      (foreach item instrumentTypeMatchList 
        (setq childrenData 
          (vl-remove-if-not '(lambda (x) 
                                ; sort data by codeName
                                (and 
                                  (wcmatch (cdr (assoc (cadr (numberedPropertyNameListStrategy dataType)) x)) item)
                                  (= drawNum (ExtractDrawNumUtils (cdr (assoc "DRAWNUM" x))))
                                )
                            ) 
            propertyValueDictList
          ) 
        )
        (setq childrenDataList (append childrenDataList (list childrenData))) 
        (setq numberedList 
          (append numberedList (list (GetNumberedListByStartAndLengthUtils "" "1" (length childrenData))))
        ) 
      ) 
    ) 
    (GetUniqueDrawNumList propertyValueDictList)
  )
  (list childrenDataList numberedList)
)

(defun GetPipeAndEquipChildrenDataList (propertyValueDictList dataType codeNameList numberMode startNumberString / childrenData childrenDataList numberedList) 
  (cond 
    ((= numberMode "0") 
      (progn 
        (setq childrenDataList (car (GetPipeAndEquipChildrenDataListByDrawNum propertyValueDictList dataType codeNameList)))
        (setq numberedList (cadr (GetPipeAndEquipChildrenDataListByDrawNum propertyValueDictList dataType codeNameList)))
      )
    )
    ((= numberMode "1") 
      (progn 
        (setq childrenDataList (car (GetPipeAndEquipChildrenDataListByNoDrawNum propertyValueDictList dataType codeNameList)))
        (setq numberedList (cadr (GetPipeAndEquipChildrenDataListByNoDrawNum propertyValueDictList dataType codeNameList)))
      )
    )
  )
  (mapcar '(lambda (x y) 
              (mapcar '(lambda (xx yy) 
                        (append xx (list (cons "numberedString" (GetPipeCodeNameByNumberMode yy numberMode (cdr (assoc "DRAWNUM" xx)) startNumberString dataType))))
                      ) 
                x 
                y
              )  
           ) 
    childrenDataList 
    numberedList
  ) 
)

; 2021-03-22
; fix bug 上次重构完，这个匹配逻辑管道没问题，但设备匹配不到了，这里再抽象出一个策略模式
(defun MatchDataBycodeNameStrategy (dataType propertyValueDict item /)
  (cond 
    ((= dataType "Pipe") 
     (MatchDataBycodeName (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) propertyValueDict)) item))
    ((= dataType "Equipment") 
     (wcmatch (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) propertyValueDict)) (strcat item "*")))
  )  
)

; refactored at 2021-03-22
(defun GetPipeAndEquipChildrenDataListByNoDrawNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (foreach item codeNameList 
    (setq childrenData 
      (vl-remove-if-not '(lambda (x) 
                           ; sort data by codeName
                           ; red hat - bug - 氮气N 会匹配到乙二醇 NEGR - 2021-03-16 - refactored at 2021-03-22
                           (MatchDataBycodeNameStrategy dataType x item)
                        ) 
        propertyValueDictList
      ) 
    )
    (setq childrenDataList (append childrenDataList (list childrenData))) 
    (setq numberedList 
      (append numberedList (list (GetNumberedListByStartAndLengthUtils item "1" (length childrenData))))
    ) 
  )
  (list childrenDataList numberedList)
)

; 2021-03-16
(defun MatchDataBycodeName (pipeNum codeName /)
  (= (GetPipeCodeByPipeNum pipeNum) codeName)
)

; refactored at 2021-03-22
(defun GetPipeAndEquipChildrenDataListByDrawNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (mapcar '(lambda (drawNum) 
            (foreach item codeNameList 
              (setq childrenData 
                (vl-remove-if-not '(lambda (x) 
                                      ; sort data by codeName
                                      (and 
                                        ; red hat - bug - 氮气N 会匹配到乙二醇 NEGR - 2021-03-16 - refactored at 2021-03-22
                                        (MatchDataBycodeNameStrategy dataType x item)
                                        (= drawNum (ExtractDrawNumUtils (cdr (assoc "DRAWNUM" x))))
                                      )
                                  ) 
                  propertyValueDictList
                ) 
              )
              (setq childrenDataList (append childrenDataList (list childrenData))) 
              (setq numberedList 
                (append numberedList (list (GetNumberedListByStartAndLengthUtils item "1" (length childrenData))))
              ) 
            )  
           ) 
    (GetUniqueDrawNumList propertyValueDictList)
  )
  (list childrenDataList numberedList)
)

(defun GetGsCleanAirCodeNameByNumberModeStrategy (originString numberMode startNumberString dataType /) 
  (cond 
    ((= dataType "GsCleanAir") 
     (GetGsCleanAirCodeNameByNumberMode originString numberMode startNumberString))
    ((= dataType "GsBzEquip") 
     (GetGsBzEquipTagNameByNumberMode originString numberMode startNumberString))
  ) 
)

; 2021-05-02
(defun GetGsCleanAirCodeNameByNumberMode (originString numberMode startNumberString /) 
  (cond 
    ((= numberMode "0") (RegExpReplace originString "(.*[A-Za-z]+)(\\d*).*" (strcat startNumberString "$1" "$2") nil nil))
    ((= numberMode "1") (RegExpReplace originString "(\\d*).*" (strcat startNumberString "$1") nil nil))
  ) 
)

; 2021-05-02
(defun GetGsBzEquipTagNameByNumberMode (originString numberMode startNumberString /) 
  (cond 
    ((= numberMode "0") (RegExpReplace originString "(.*[A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString "$2") nil nil))
    ((= numberMode "1") (RegExpReplace originString "(\\d*).*" (strcat startNumberString "$1") nil nil))
  ) 
)

; ready for refactor - 2021-03-05
; refactored at 2021-04-07
(defun GetPipeCodeNameByNumberMode (originString numberMode drawNum startNumberString dataType /) 
  (setq drawNum (RegExpReplace (ExtractDrawNumUtils drawNum) "0(\\d)-(\\d*)" (strcat "$1" "$2") nil nil))
  (cond 
    ((= numberMode "0") (RegExpReplace originString "([A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString drawNum "$2") nil nil))
    ; bug 不按流程图编，按单体号（1A3）有问题，提取逻辑做了修改 - 2021-03-02
    ; 补充：因为该函数与处理设备位号编号共用，按之前逻辑改后，设备位号编号又不对了，目前加了分支处理 - 2021-03-05
     ((= numberMode "1") 
      (if (= dataType "Pipe") 
        ; fix bug - 管道原来的匹配模式匹配不到氮气管道 N 2021-04-07
        (RegExpReplace originString "([A-Za-z]?[0-9]?[A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString "$2") nil nil)
        (RegExpReplace originString "([A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString "$2") nil nil)
      )
     )
  ) 
)

(defun GetNumberedListStrategy (numberedDataList dataType / resultList) 
  (cond 
    ((or (= dataType "Pipe") (= dataType "Equipment") (= dataType "GsCleanAir") (= dataType "FireFightHPipe") (= dataType "GsBzEquip"))
      (GetPipeAndEquipNumberedList numberedDataList dataType)
    )
    ((= dataType "Instrument") (GetInstrumentNumberedList numberedDataList dataType))
  ) 
)

(defun GetPipeAndEquipNumberedList (numberedDataList dataType / resultList) 
  (foreach item numberedDataList 
    (mapcar '(lambda (x) 
              (setq resultList 
                (append resultList (list (GetNumberedStringforEnhancedNumber x dataType)))
              )
            ) 
      item
    ) 
  )
  resultList
)

; add the "-" between functon and numbered tag
(defun GetInstrumentNumberedList (numberedDataList dataType / resultList) 
  (foreach item numberedDataList 
    (mapcar '(lambda (x) 
              (setq resultList 
                (append resultList 
                  (list (strcat 
                          (cdr (assoc "FUNCTION" x)) 
                          "-"
                          (GetNumberedStringforEnhancedNumber x dataType)
                        )
                  )
                )
              )
            ) 
      item
    ) 
  )
  resultList
)

(defun GetUniqueDrawNumList (propertyValueDictList / resultList) 
  (setq resultList 
    (mapcar '(lambda (x) 
              (ExtractDrawNumUtils x)
            ) 
      (GetValueListByOneKeyUtils propertyValueDictList "DRAWNUM")
    )
  )
  (DeduplicateForListUtils resultList)
)

; 2021-01-25
(defun GetUniqueKsLocationList (propertyValueDictList / resultList) 
  (setq resultList 
    (vl-remove-if-not '(lambda (x) 
                        (/= x nil)  ; the key logic
                      ) 
      (GetValueListByOneKeyUtils propertyValueDictList "LOCATION")
    )
  )
  (DeduplicateForListUtils resultList)
)

; 2021-01-25
(defun IsKsLocationOnPipe (ksLocation /) 
  (RegexpTestUtils ksLocation ".*\-[0-9]+\-[0-9][A-Z].*" nil)
)

; refactored at 2021-03-29
; unit test compeleted
(defun IsKsLocationOnEquip (ksLocation /) 
  ; for match [04C-R1101A] - 2021-03-30
  (or (RegexpTestUtils ksLocation "^[A-Z]+[0-9]+[A-Z]?$" nil) 
    (RegexpTestUtils ksLocation "^[0-9]+[A-Z]+-[A-Z]+[0-9]+[A-Z]?$" nil)
  )
)

; refactored at 2021-05-02
(defun GetCodeNameListStrategy (propertyValueDictList dataType / propertyName dataList resultList) 
  (setq propertyName (car (numberedPropertyNameListStrategy dataType)))
  (setq dataList (GetValueListByOneKeyUtils propertyValueDictList propertyName)) 
  (if (= dataType "Pipe") 
    (setq resultList (GetPipeCodeNameList dataList))
  ) 
  (if (or (= dataType "Equipment") (= dataType "Instrument")) ; 2021-02-03
    (setq resultList (GetEquipmentCodeNameList dataList))
  ) 
  (if (or (= dataType "GsCleanAir") (= dataType "FireFightHPipe") (= dataType "GsBzEquip")) ; 2021-02-03
    (setq resultList (GetGsCleanAirCodeNameList dataList))
  )
  (DeduplicateForListUtils resultList)
)

; refactored at 2021-05-02
(defun GetPipeCodeNameList (pipeNumList /) 
  (mapcar '(lambda (x) 
             (GetPipeCodeByPipeNum x)
          ) 
    pipeNumList
  )
)

; 2021-03-16
(defun GetPipeCodeByPipeNum (pipeNum /)
  (RegExpReplace pipeNum "([A-Za-z]+)\\d*-.*" "$1" nil nil)
)

; refactored at 2021-05-02
(defun GetEquipmentCodeNameList (tagList /) 
  (mapcar '(lambda (x) 
            (GetEquipmentCodeName x)
          ) 
    tagList
  )
)

; 2021-05-02
(defun GetEquipmentCodeName (equipmentCodeName /) 
  (RegExpReplace equipmentCodeName "([A-Za-z]+).*" "$1" nil nil)
)

; unit test compeleted
(defun GetGsCleanAirCodeNameList (CleanAirRoomNumList /) 
  (mapcar '(lambda (x) 
            (GetGsCleanAirCodeName x)
          ) 
    CleanAirRoomNumList
  )
)

(defun GetGsCleanAirCodeName (CleanAirRoomNum /) 
  (RegExpReplace CleanAirRoomNum "(.*[A-Za-z]+)\\d*" "$1" nil nil)
)
;;;----------------------------Enhanced Number Data------------------------;;;

; Number Pipeline, Instrument and Equipment
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Number DrawNum

; refactored at 2021-04-09
(defun c:numberDrawNum () 
  (ExecuteFunctionAfterVerifyDateUtils 'NumberDrawNumByBox '("numberDrawNumBox"))
)

; refactored at 2021-04-09
(defun c:brushDataDrawNum () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushDrawNum '())
)

(defun NumberDrawNumByBox (tileName / dcl_id propertyValue replacedSubstring status ss sslen previewList 
                           confirmList entityNameList modifyMsgBtnStatus numMsgStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflow.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnPreviewModify" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    (action_tile "btnBrushDrawNum" "(done_dialog 5)")
    ; the default value of input box
    (action_tile "propertyValue" "(setq propertyValue $value)")
    (action_tile "replacedSubstring" "(setq replacedSubstring $value)")
    ; init the default data of text
    (if (= nil propertyValue)
      (setq propertyValue "")
    )
    (if (= nil replacedSubstring)
      (setq replacedSubstring "")
    )
    (set_tile "propertyValue" propertyValue)
    (set_tile "replacedSubstring" replacedSubstring)
    ; Display the number of selected pipes
    (if (= modifyMsgBtnStatus 0)
      (set_tile "msg" (strcat "匹配到的数量：" (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "编号状态：已完成")
    )
    (if (= modifyMsgBtnStatus 2)
      (set_tile "modifyBtnMsg" "刷数据所在图号已完成")
    )
    (if (= numMsgStatus 1)
      (set_tile "msg" (strcat "所刷数据的数量：" (rtos sslen)))
    )
    (if (/= previewList nil)
      (progn
        (start_list "modifiedData" 3)
        (mapcar '(lambda (x) (add_list x)) 
                 previewList)
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
        (setq ss (GetBlockSSBySelectByDataTypeUtils "DrawLabel"))
        ; sort by x cordinate and the by y cordinate - 2021-04-02
        (setq ss (SortSelectionSetByRowColumn ss))
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq previewList (GetDrawNumList entityNameList))
        (setq sslen (length previewList))
        (setq modifyMsgBtnStatus 0)
      )
    )
    ; confirm button
    (if (= 3 status)
      (setq confirmList (GetNumberedListByStartAndLengthUtils replacedSubstring propertyValue (length previewList)))
    )
    ; modify button
    (if (= 4 status)
      (progn 
        (ModifyDrawNum entityNameList confirmList)
        (setq modifyMsgBtnStatus 1)
        (setq previewList nil confirmList nil)
      )
    )
    ; brush drawnum button
    (if (= 5 status)
      (progn 
        (setq sslen (BrushDrawNum))
        (setq modifyMsgBtnStatus 2)
        (setq numMsgStatus 1)
      )
    )
  )
  (unload_dialog dcl_id)
  (princ)
)

(defun ModifyDrawNum (entityNameList drawNumList /)
  (mapcar '(lambda (x y) 
            (ModifyMultiplePropertyForOneBlockUtils x (list "DwgNo") (list y))
          ) 
    entityNameList
    drawNumList      
  )
)

(defun GetDrawNumList (entityNameList / drawNumList)
  (mapcar '(lambda (x) 
             (setq drawNumList 
                (append drawNumList (list (cdr (assoc "dwgno" (GetAllPropertyDictForOneBlock x)))))
             )
           ) 
    entityNameList
  )
  DrawNumList 
)

(defun BrushDrawNum (/ drawNum dataSS entityNameList)
  (prompt "\n选择图签：")
  (setq drawNum 
    (car (GetDrawNumList (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "DrawLabel"))))
  )
  (prompt (strcat "\n所选择的图号：" drawNum))
  (prompt "\n选择要刷的数据（管道、仪表、设备）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetInstrumentPipeEquipSSBySelectUtils)))
  (ModifyDrawNumForData entityNameList drawNum)
  (prompt "\n刷数据所在图号完成！")
  (length entityNameList)
)

(defun ModifyDrawNumForData (entityNameList drawNum /)
  (if (/= drawNum "") 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "DRAWNUM") (list drawNum))
            ) 
      entityNameList
    )
  )
)

; 2021-04-15
(defun c:UpdateDrawGsLcDrawNumData () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateDrawGsLcDrawNumDataMacro '())
)

; 2021-04-15
(defun UpdateDrawGsLcDrawNumDataMacro () 
  (foreach item (GetGsLcDrawNumList) 
    (mapcar '(lambda (x) 
                (UpdateOneDrawGsLcDrawNumData x)
             ) 
      (GetDottedPairValueUtils item (GetAllGsLcDrawNumDictListData))
    ) 
  )
  (alert "流程图数据图号更新成功！")
)

; 2021-04-15
(defun UpdateOneDrawGsLcDrawNumData (entityData /)
  (ModifyMultiplePropertyForOneBlockUtils 
    (cadr entityData) 
    (list "DRAWNUM") 
    (list (car entityData))
  )
)

; 2021-04-15
(defun GetAllGsLcDrawLabelDataUtils () 
  (mapcar '(lambda (x) 
             (list 
               (GetDottedPairValueUtils "dwgno" x)
               (GetGsLcA1DrawPositionRangeUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x)))))
             )
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

; 2021-04-29
; must use cons, the it is valid for function [GetDottedPairValueUtils]
(defun GetAllGsLcDrawLabelPositionDictDataUtils () 
  (mapcar '(lambda (x) 
             (cons 
               (GetDottedPairValueUtils "dwgno" x)
               (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x))))
             )
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

; 2021-04-15
(defun GetGsLcA1DrawPositionRangeUtils (position /)
  (list (+ (car position) -841) (+ (cadr position) 594))
)

; 2021-04-15
(defun GetGsLcDrawNumList ()
  (mapcar '(lambda (x) (car x)) 
    (GetAllGsLcDrawLabelDataUtils)
  )   
)

; 2021-04-15
(defun GetAllGsLcDrawNumDictListData () 
  (ChunkListByColumnIndexUtils (GetAllGsLcDictListData) 0) 
)

; 2021-04-15
(defun GetAllGsLcDictListData () 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils -1 (cadr x))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetGsLcStrategyEntityData (GetAllInstrumentPipeEquipData))
  ) 
)

; 2021-04-15
(defun GetAllInstrumentPipeEquipData () 
  (GetSelectedEntityDataUtils (GetAllInstrumentPipeEquipSSUtils))
)

; 2021-04-15
(defun GetGsLcStrategyEntityData (entityData / resultList) 
  (foreach item (GetAllGsLcDrawLabelDataUtils) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (cadr (assoc 10 x)) (car (cadr item))) 
                    (< (cadr (assoc 10 x)) (+ (car (cadr item)) 841)) 
                    (< (caddr (assoc 10 x)) (cadr (cadr item)))
                    (> (caddr (assoc 10 x)) (- (cadr (cadr item)) 594))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      entityData
    ) 
  ) 
  resultList
)

; Number DrawNum
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; PipeClassChange and PipeDiameterChange

; refactored at 2021-04-09
(defun c:brushPipeClassChangeMacro () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushPipeClassChangeInfoMacro '())
)

; refactored at 2021-04-09
(defun BrushPipeClassChangeInfoMacro (/ sourceData pipeClassChangeData instrumentAndPipeData pipeClassChangeInfo)
  (prompt "\n选择变管道等级块以及要刷的管道或仪表数据（变等级块只能选一个）：")
  (setq sourceData (GetInstrumentAndPipeAndPipeClassChangeData))
  (setq pipeClassChangeData (GetPipeClassChangeDataForBrushPipeClassChange sourceData))
  (setq instrumentAndPipeData (GetInstrumentAndPipeDataForBrushPipeClassChange sourceData))
  (setq pipeClassChangeInfo (GetPipeClassChangeInfo (car pipeClassChangeData)))
  (ExecuteFunctionForOneSourceDataUtils (length pipeClassChangeData) 'BrushOnePropertyDataForInstrumentAndPipe 
    (list instrumentAndPipeData pipeClassChangeInfo "PIPECLASSCHANGE")
  )
)

; refactored at 2021-04-09
(defun c:brushReducerInfoMacro () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushReducerChangeInfoMacro '())
)

; refactored at 2021-04-09
(defun BrushReducerChangeInfoMacro (/ sourceData ReducerData instrumentAndPipeData reducerInfo entityNameList)
  (prompt "\n选择异径管块以及要刷的管道或仪表数据（异径管块只能选一个）：")
  (setq sourceData (GetInstrumentAndPipeAndReducerData))
  (setq ReducerData (GetReducerDataForBrushReducerInfo sourceData))
  (setq instrumentAndPipeData (GetInstrumentAndPipeDataForBrushReducerInfo sourceData))
  (setq reducerInfo (cdr (assoc "REDUCER" (car ReducerData))))
  (ExecuteFunctionForOneSourceDataUtils (length ReducerData) 'BrushOnePropertyDataForInstrumentAndPipe 
    (list instrumentAndPipeData reducerInfo "REDUCERINFO")
  )
)

(defun BrushOnePropertyDataForInstrumentAndPipe (instrumentAndPipeData ChangedInfo propertyName / entityNameList)
  (setq entityNameList (GetEntityNameListByEntityHandleListUtils (GetEntityHandleListByPropertyDictListUtils instrumentAndPipeData)))
  (ModifyMultiplePropertyForBlockUtils entityNameList (list propertyName) (list ChangedInfo))
  (princ "刷数据完成！")(princ)
)

(defun GetInstrumentAndPipeAndPipeClassChangeData ()
  (GetPropertyDictListByPropertyNameList 
    (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "InstrumentAndPipeAndPipeClassChange")) 
    '("FPIPECLASS" "SPIPECLASS" "PIPECLASSCHANGE")
  )
)

(defun GetInstrumentAndPipeAndReducerData ()
  (GetPropertyDictListByPropertyNameList 
    (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "InstrumentAndPipeAndReducer")) 
    '("REDUCER" "REDUCERINFO")
  )
)

(defun GetPipeClassChangeDataForBrushPipeClassChange (sourceData /) 
  (vl-remove-if-not '(lambda (x) 
                       (/= (cdr (assoc "FPIPECLASS" x)) nil)
                    ) 
    sourceData
  )
)

(defun GetInstrumentAndPipeDataForBrushPipeClassChange (sourceData /) 
  (vl-remove-if-not '(lambda (x) 
                       (= (cdr (assoc "FPIPECLASS" x)) nil)
                    ) 
    sourceData
  )
)

(defun GetReducerDataForBrushReducerInfo (sourceData /) 
  (vl-remove-if-not '(lambda (x) 
                       (/= (cdr (assoc "REDUCER" x)) nil)
                    ) 
    sourceData
  )
)

(defun GetInstrumentAndPipeDataForBrushReducerInfo (sourceData /) 
  (vl-remove-if-not '(lambda (x) 
                       (= (cdr (assoc "REDUCER" x)) nil)
                    ) 
    sourceData
  )
)

(defun GetPipeClassChangeInfo (pipeClassChangeData / result) 
  (setq result 
    (strcat (cdr (assoc "FPIPECLASS" pipeClassChangeData)) "-" (cdr (assoc "SPIPECLASS" pipeClassChangeData)))
  )
  (if (= result "-") 
    (setq result "")
  )
  result
)

; PipeClassChange and PipeDiameterChange
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Update from/to Data for PulicPipe

; 2021-04-28
(defun c:UpdateAllPublicPipeFromToData () 
  (ExecuteFunctionAfterVerifyDateUtils 'UpdateAllPublicPipeFromToDataByBox '("UpdateAllPublicPipeFromToDataBox"))
)

; 2021-04-28
; refactored at 2021-05-08
(defun UpdateAllPublicPipeFromToDataMacro (ss fromCodeList toCodeList / allDrawPipeAndEquipData oneDrawPipeAndEquipData allBindedPipedataList) 
  (setq allDrawPipeAndEquipData (GetAllGsLcPipeAndEquipDrawNumDictListData ss))
  (setq allBindedPipedataList (list (GetAllBindedPipeEntityName) (GetAllEquipHandleTagDictDataUtils)))
  (foreach item (mapcar '(lambda (x) (car x)) allDrawPipeAndEquipData) 
    (setq oneDrawPipeAndEquipData (GetDottedPairValueUtils item allDrawPipeAndEquipData))
    (mapcar '(lambda (x) 
                (UpdateOneDrawPublicPipeFromToDataStrategy 
                  x 
                  (GetMinDistanceEquipTagForPublicPipe oneDrawPipeAndEquipData (caddr x)) 
                  fromCodeList 
                  toCodeList 
                  allBindedPipedataList)
             ) 
      (FliterPublicPipeForFromToData oneDrawPipeAndEquipData) 
    ) 
  )
)

; 2021-04-28
(defun GetMinDistanceEquipTagForPublicPipe (oneDrawPipeAndEquipData pipeLocation / resultList entityName)
  (setq resultList 
    (mapcar '(lambda (x) 
              (list 
                (cadr x)
                (distance (caddr x) pipeLocation)
              )
            ) 
      (FliterEquipForFromToData oneDrawPipeAndEquipData)
    )  
  )
  (setq entityName 
    (car (car (vl-sort resultList '(lambda (x y) (< (cadr x) (cadr y)))))) 
  )
  (GetDottedPairValueUtils "tag" (GetAllPropertyDictForOneBlock entityName)) 
)

; 2021-04-28
; refactored at 2021-05-08
(defun UpdateOneDrawPublicPipeFromToDataStrategy (publicPipeData equipTag fromCodeList toCodeList allBindedPipedataList /) 
  (cond 
    ((IsPublicPipeFromByEntityName (cadr publicPipeData) fromCodeList) 
     (UpdateOneDrawPublicPipeFromToData (cadr publicPipeData) equipTag allBindedPipedataList "FROM"))
    ((IsPublicPipeToByEntityName (cadr publicPipeData) toCodeList) 
     (UpdateOneDrawPublicPipeFromToData (cadr publicPipeData) equipTag allBindedPipedataList "TO"))
  )
)

; 2021-04-28
(defun GetGsLcToPublicPipeCode () 
  '("CWS" "LS" "LWS" "HWS" "HOS" "N" "DW" "DNW" "PW")
)

; 2021-04-28
(defun GetGsLcFromPublicPipeCode () 
  '("CWR" "SC" "LWR" "HWR" "HOR" "VT" "VTa" "VTb" "VA" "VAa" "VAb" "BD")
)

; 2021-04-28
(defun IsPublicPipeFromByEntityName (entityName fromCodeList /) 
  (member 
    (GetPipeCodeByPipeNum (GetDottedPairValueUtils "pipenum" (GetAllPropertyDictForOneBlock entityName)))  
    fromCodeList)
)

; 2021-04-28
(defun IsPublicPipeToByEntityName (entityName toCodeList /) 
  (member 
    (GetPipeCodeByPipeNum (GetDottedPairValueUtils "pipenum" (GetAllPropertyDictForOneBlock entityName)))  
    toCodeList)
)

; 2021-04-28
; refactored at 2021-05-08
(defun UpdateOneDrawPublicPipeFromToData (entityName fromData allBindedPipedataList propertyName /) 
  (ModifyMultiplePropertyForOneBlockUtils 
    entityName
    (list propertyName) 
    (list fromData)
  )
  (if (member entityName (car allBindedPipedataList)) 
    (UpdateBindedPublicPipeFromToData entityName (cadr allBindedPipedataList) propertyName)
  )
)

; 2021-05-08
(defun UpdateBindedPublicPipeFromToData (entityName allEquipHandleTagDictData propertyName /) 
  (ModifyMultiplePropertyForOneBlockUtils 
    entityName
    (list propertyName) 
    (list (GetPublicPipeBindedEquipTag entityName allEquipHandleTagDictData))
  )
)

; 2021-05-08
(defun GetPublicPipeBindedEquipTag (entityName allEquipHandleTagDictData /) 
  (GetDottedPairValueUtils 
    (GetDottedPairValueUtils "version" (GetAllPropertyDictForOneBlock entityName))
    allEquipHandleTagDictData
  ) 
)

; 2021-04-28
(defun FliterPublicPipeForFromToData (entityData / publicPipeData) 
  (vl-remove-if-not '(lambda (x) 
                       (IsGsLcPipeByEntityNameUtils (cadr x))
                    ) 
    entityData
  )
)

; 2021-04-28
(defun FliterEquipForFromToData (entityData / publicPipeData) 
  (vl-remove-if-not '(lambda (x) 
                       (not (IsGsLcPipeByEntityNameUtils (cadr x)))
                    ) 
    entityData
  )
)

; 2021-04-28
(defun IsGsLcPipeByEntityNameUtils (entityName / entityData) 
  (if (GetDottedPairValueUtils "pipenum" (GetAllPropertyDictForOneBlock entityName)) 
    T
  )
)

; 2021-04-28
(defun GetAllGsLcPipeAndEquipDrawNumDictListData (ss /) 
  (ChunkListByColumnIndexUtils (GetGsLcPipeAndEquipDictListData ss) 0) 
)

; 2021-04-15
(defun GetGsLcPipeAndEquipDictListData (ss /) 
  (mapcar '(lambda (x) 
             (list (car x) 
                   (GetDottedPairValueUtils -1 (cadr x))
                   (GetDottedPairValueUtils 10 (cadr x))
             )
           ) 
    (GetGsLcStrategyEntityData (GetGsLcPipeAndEquipData ss))
  ) 
)

; 2021-04-28
(defun GetGsLcPipeAndEquipData (ss /) 
  (GetSelectedEntityDataUtils ss)
)

; 2021-05-08
(defun GetAllBindedPipeEntityName () 
  (mapcar '(lambda (x) 
              (handent (GetDottedPairValueUtils "entityhandle" x))
            ) 
    (FilterGsLcBindedPipe)
  ) 
)

; 2021-05-08
(defun FilterGsLcBindedPipe (/ allEquipHandleList) 
  (setq allEquipHandleList (GetAllEquipHandleListUtils))
  (vl-remove-if-not '(lambda (x) 
                       (FilterGsLcBindedPipePredication (GetDottedPairValueUtils "version" x) allEquipHandleList)
                    ) 
    (GetAllPipeDataUtils)
  )
)

; 2021-05-08
(defun FilterGsLcBindedPipePredication (entityHandle allEquipHandleList /)
  (and 
    (/= entityHandle "")
    (RegexpTestUtils entityHandle "\\w+" nil)
    (member entityHandle allEquipHandleList)
  )
)

; 2021-04-28
(defun UpdateAllPublicPipeFromToDataByBox (tileName / dcl_id status sslen modifyStatus fromCodeInput fromCodeList fromCodeListString toCodeInput toCodeList toCodeListString)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\dcl\\" "dataflowGs.dcl")))
  (setq status 2)
  (while (>= status 2)
    ; Create the dialog box
    (new_dialog tileName dcl_id "" '(-1 -1))
    ; Added the actions to the Cancel and Pick Point button
    (action_tile "cancel" "(done_dialog 0)")
    (action_tile "btnSelect" "(done_dialog 2)")
    (action_tile "btnAllSelect" "(done_dialog 3)")
    (action_tile "btnModify" "(done_dialog 4)")
    (action_tile "btnAddFromCode" "(done_dialog 5)")
    (action_tile "btnAddToCode" "(done_dialog 6)")
    (mode_tile "fromCodeInput" 2)
    (action_tile "fromCodeInput" "(setq fromCodeInput $value)")
    (mode_tile "toCodeInput" 2)
    (action_tile "toCodeInput" "(setq toCodeInput $value)") 
    (if (= toCodeList nil) 
      (progn 
        (setq toCodeList (GetGsLcToPublicPipeCode))
        (setq toCodeListString (vl-princ-to-string toCodeList))
      )
    ) 
    (if (= fromCodeList nil)
      (progn 
        (setq fromCodeList (GetGsLcFromPublicPipeCode))
        (setq fromCodeListString (vl-princ-to-string fromCodeList))
      ) 
    ) 
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "选择数据的数量： " (rtos sslen)))
    ) 
    (if (= modifyStatus 2)
      (set_tile "fromCodeMsg" (strcat "可以匹配的【出】设备的公用管道代号： " fromCodeListString))
    ) 
    (if (= modifyStatus 3)
      (set_tile "toCodeMsg" (strcat "可以匹配的【进】设备的公用管道代号： " toCodeListString))
    )  
    (if (= modifyStatus 1)
      (set_tile "modifyStatusMsg" "修改状态：已完成")
    ) 
    (set_tile "fromCodeMsg" (strcat "可以匹配的【出】设备的公用管道代号： " fromCodeListString))
    (set_tile "toCodeMsg" (strcat "可以匹配的【进】设备的公用管道代号： " toCodeListString))
    ; select button
    (if (= 2 (setq status (start_dialog))) 
      (progn 
        (setq ss (GetEquipmentAndPipeSSBySelectUtils))
        (setq sslen (sslength ss)) 
      )
    )
    ; All select button
    (if (= 3 status) 
      (progn 
        (setq ss (GetAllEquipmentAndPipeSSUtils))
        (setq sslen (sslength ss)) 
      )
    ) 
    ; update data button
    (if (= 4 status) 
      (progn 
        (UpdateAllPublicPipeFromToDataMacro ss fromCodeList toCodeList) 
        (setq modifyStatus 1) 
        (setq sslen nil)
      ) 
    )
    ; add from code
    (if (= 5 status) 
      (progn 
        (setq fromCodeList (append fromCodeList (list fromCodeInput)))
        (setq fromCodeListString (vl-princ-to-string fromCodeList))
        (setq modifyStatus 2) 
      ) 
    ) 
    ; add to code
    (if (= 6 status) 
      (progn 
        (setq toCodeList (append toCodeList (list toCodeInput)))
        (setq toCodeListString (vl-princ-to-string toCodeList))
        (setq modifyStatus 3) 
      ) 
    )  
  )
  (unload_dialog dcl_id)
  (princ)
)

; Update from/to Data for PulicPipe
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for Common Function of Little Tools

; refactored at 2021-04-09
(defun c:brushTextEntityContent () 
  (ExecuteFunctionAfterVerifyDateUtils 'BrushTextEntityContentMacro '())
)

; refactored at 2021-04-09
(defun BrushTextEntityContentMacro (/ textContent entityNameList)
  (prompt "\n选择要提取的单行文字：")
  (setq textContent (GetTextEntityContentBySelectUtils))
  (prompt (strcat "\n提取的文字内容：" textContent))
  (prompt "\n选择要刷的单行文字（可批量选择）：")
  (setq entityNameList (GetEntityNameListBySSUtils (GetTextSSBySelectUtils)))
  (ModifyTextEntityContentUtils entityNameList textContent)
  (princ)
)

; refactored at 2021-04-09
(defun c:deleteTextByLayer () 
  (ExecuteFunctionAfterVerifyDateUtils 'DeleteTextByLayerMacro '())
)

; refactored at 2021-04-09
(defun DeleteTextByLayerMacro (/ textLayer)
  (prompt "\n拾取一个要删除的单行文字以获取图层信息：")
  (setq textLayer (GetEntitylayerBySelectUtils))
  (prompt (strcat "\n拾取到的图层名：" textLayer "\n选择要删除的单行文字（可批量选择）："))
  (DeleteEntityBySSUtils (GetTextSSByLayerBySelectUtils textLayer))
  (princ)
)

;| 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------
|; 