;��������� 2020-2021 ��
(princ "\n������һ�廯�����ߣ��������л�궫�����ס�����������ҡ�֣�ɺꡢ�������汾��V2.0")
(vl-load-com)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; basic Function

(defun c:printVersionInfo ()
  (alert "���°汾�� V2.0������ʱ�䣺2021-03-08\n������������ַ��192.168.1.38")(princ)
)

(defun c:printVersionInfoSS ()
  (alert "���°汾�� V0.1������ʱ�䣺2021-03-08\n������������ַ��192.168.1.38")(princ)
)

(defun c:syncAllDataFlowBlock (/ item) 
    (foreach item (GetSyncFlowBlockNameList) 
    (command "._attsync" "N" item)
  )
  (alert "��������ؿ�ͬʱ��ɣ�")(princ)
)

(defun c:GetEntityData ()
  (GetEntityDataUtils)
)

; basic Function
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Redefining AutoCAD Commands

(defun CADLispMove (ss firstPoint secondPoint /)
  (command "_.move" ss firstPoint "" secondPoint "")
)

(defun CADLispCopy (ss firstPoint secondPoint /)
  (command "_.copy" ss firstPoint "" secondPoint "")
)

; Redefining AutoCAD Commands
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Steal AutoCAD Modules

(defun GetGsLcModulesPath (/ result)
  (setq result "D:\\dataflowcad\\allBlocks\\GsLcBlocks.dwg")
)

; 2021-03-03
(defun StealAllGsLcBlocks ()
  (Steal (GetGsLcModulesPath) 
    '(
      ("Blocks" ("*"))
    )
  ) 
)

; 2021-03-03
(defun StealAllGsLcLayers ()
  (Steal (GetGsLcModulesPath) 
    '(
      ("Layers" ("*"))
    )
  ) 
)

; 2021-03-03
(defun StealGsLcBlockByNameList (blockNameList /)
  (Steal (GetGsLcModulesPath) 
    (list 
      (list "Blocks" blockNameList)
    )
  ) 
)

; 2021-03-03
(defun StealGsLcLayerByNameList (layerNameList /)
  (Steal (GetGsLcModulesPath) 
    (list 
      (list "Layers" layerNameList)
    )
  ) 
)

; 2021-03-03
(defun VerifyGsLcBlockByName (blockName /) 
  (if (= (tblsearch "BLOCK" blockName) nil) 
    (StealGsLcBlockByNameList (list blockName))
  )
)

; 2021-03-03
(defun VerifyGsLcLayerByName (layerName /) 
  (if (= (tblsearch "LAYER" layerName) nil) 
    (StealGsLcLayerByNameList (list layerName))
  )
)

; 2021-03-05
(defun VerifyGsLcBlockPublicPipe () 
  (VerifyGsLcBlockByName "PublicPipeDownPipeLine")
  (VerifyGsLcBlockByName "PublicPipeDownArrow")
  (VerifyGsLcBlockByName "PublicPipeUpPipeLine")
  (VerifyGsLcBlockByName "PublicPipeUpArrow") 
  (VerifyGsLcLayerByName "DataFlow-PublicPipe")
  (VerifyGsLcLayerByName "DataFlow-PublicPipeLine")
)

; Steal AutoCAD Modules
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Get Constant Data

(defun GetSyncFlowBlockNameList ()
  '("InstrumentL" "InstrumentP" "InstrumentSIS" "Centrifuge" "CustomEquip" "Heater" "Pump" "Reactor" "Tank" "Vacuum" "OuterPipeLeft" "OuterPipeRight" "GsCleanAir")
)

(defun GetDataTypeMsgStrategy (dataType / dataTypeMsg)
  (if (= dataType "Pipe") 
    (setq dataTypeMsg "�����޸Ĺܵ�����")
  )
  (if (= dataType "Instrument") 
    (setq dataTypeMsg "�����޸��Ǳ�����")
  )
  (if (= dataType "Reactor") 
    (setq dataTypeMsg "�����޸ķ�Ӧ������")
  )
  (if (= dataType "Tank") 
    (setq dataTypeMsg "�����޸Ĵ�������")
  )
  (if (= dataType "Heater") 
    (setq dataTypeMsg "�����޸Ļ���������")
  )
  (if (= dataType "Pump") 
    (setq dataTypeMsg "�����޸����ͱ�����")
  )
  (if (= dataType "Vacuum") 
    (setq dataTypeMsg "�����޸���ձ�����")
  )
  (if (= dataType "Centrifuge") 
    (setq dataTypeMsg "�����޸����Ļ�����")
  )
  (if (= dataType "CustomEquip") 
    (setq dataTypeMsg "�����޸��Զ����豸����")
  )
  ; must give the return
  dataTypeMsg
)

(defun GetPropertyNameListStrategy (dataType / propertyNameList)
  (if (= dataType "Pipe") 
    (setq propertyNameList (GetPipePropertyNameList))
  )
  (if (= dataType "OuterPipe") 
    (setq propertyNameList (GetOuterPipePropertyNameList))
  )
  (if (= dataType "PublicPipe") 
    (setq propertyNameList (GetPublicPipePropertyNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
  )
  (if (= dataType "InstrumentL") 
    (setq propertyNameList (GetInstrumentPropertyNameList))
  )
  (if (= dataType "InstrumentP") 
    (setq propertyNameList (GetInstrumentPPropertyNameList))
  )
  (if (= dataType "InstrumentSIS") 
    (setq propertyNameList (GetInstrumentPPropertyNameList))
  )
  (if (= dataType "Reactor") 
    (setq propertyNameList (GetReactorPropertyNameList))
  )
  (if (= dataType "Tank") 
    (setq propertyNameList (GetTankPropertyNameList))
  )
  (if (= dataType "Heater") 
    (setq propertyNameList (GetHeaterPropertyNameList))
  )
  (if (= dataType "Pump") 
    (setq propertyNameList (GetPumpPropertyNameList))
  )
  (if (= dataType "Vacuum") 
    (setq propertyNameList (GetVacuumPropertyNameList))
  )
  (if (= dataType "Centrifuge") 
    (setq propertyNameList (GetCentrifugePropertyNameList))
  )
  (if (= dataType "CustomEquip") 
    (setq propertyNameList (GetCustomEquipPropertyNameList))
  )
  (if (= dataType "GsCleanAir") 
    (setq propertyNameList (GetGsCleanAirPropertyNameList))
  ) 
  ; must give the return
  propertyNameList
)

(defun GetPropertyChNameListStrategy (dataType / propertyChNameList)
  (if (= dataType "Pipe") 
    (setq propertyChNameList (GetPipePropertyChNameList))
  )
  (if (= dataType "PublicPipe") 
    (setq propertyChNameList (GetPublicPipePropertyChNameList))
  )
  (if (= dataType "Instrument") 
    (setq propertyChNameList (GetInstrumentPropertyChNameList))
  )
  (if (= dataType "Reactor") 
    (setq propertyChNameList (GetReactorPropertyChNameList))
  )
  (if (= dataType "Tank") 
    (setq propertyChNameList (GetTankPropertyChNameList))
  )
  (if (= dataType "Heater") 
    (setq propertyChNameList (GetHeaterPropertyChNameList))
  )
  (if (= dataType "Pump") 
    (setq propertyChNameList (GetPumpPropertyChNameList))
  )
  (if (= dataType "Vacuum") 
    (setq propertyChNameList (GetVacuumPropertyChNameList))
  )
  (if (= dataType "Centrifuge") 
    (setq propertyChNameList (GetCentrifugePropertyChNameList))
  )
  (if (= dataType "CustomEquip") 
    (setq propertyChNameList (GetCustomEquipPropertyChNameList))
  )
  (if (= dataType "GsCleanAir") 
    (setq propertyChNameList (GetGsCleanAirPropertyChNameList))
  ) 
  ; must give the return
  propertyChNameList
)

(defun GetPipePropertyNameList ()
  '("PIPENUM" "SUBSTANCE" "TEMP" "PRESSURE" "PHASE" "FROM" "TO" "DRAWNUM" "INSULATION" "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetPipePropertyChNameList ()
  '("�ܵ����" "��������" "�����¶�" "����ѹ��" "��̬" "�ܵ����" "�ܵ��յ�" "����ͼ��" "���²���" "��ȼ���Ϣ" "��ܾ���Ϣ")
)

(defun GetOuterPipePropertyNameList ()
  '("PIPENUM" "FROMTO" "DRAWNUM" "DESIGNFLOW" "OPERATESPEC" "INSULATION" "PROTECTION")
)

(defun GetPublicPipePropertyNameList ()
  '("PIPENUM" "FROM" "TO" "DRAWNUM")
)

(defun GetPublicPipePropertyChNameList ()
  '("�ܵ����" "�ܵ����" "�ܵ��յ�" "����ͼ��")
)

(defun GetInstrumentPropertyNameList ()
  '("FUNCTION" "TAG" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION"  "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetInstrumentPPropertyNameList ()
  '("FUNCTION" "TAG" "HALARM" "LALARM" "SUBSTANCE" "TEMP" "PRESSURE" "SORT" "PHASE" "MATERIAL" "NAME" "LOCATION" "MIN" "MAX" "NOMAL" "DRAWNUM" "INSTALLSIZE" "COMMENT" "DIRECTION"  "PIPECLASSCHANGE" "REDUCERINFO")
)

(defun GetInstrumentPropertyChNameList ()
  '("�Ǳ����ܴ���" "�Ǳ�λ��" "��������" "�����¶�" "����ѹ��" "�Ǳ�����" "��̬" "����λ�ò���" "���Ƶ�����" "���ڹܵ����豸" "��Сֵ" "���ֵ" "����ֵ" "����ͼ��" "����λ�óߴ�" "��ע" "��װ����"  "��ȼ���Ϣ" "��ܾ���Ϣ")
)

(defun GetReactorPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SPEED" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM" "EXTEMP" "EXPRESSURE")
)

(defun GetReactorPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "�豸���" "��������" "�����¶�" "����ѹ��" "�������" "����Ƿ����" "�������" "��Ӧ��ת��" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "����ͼ��" "�Զ���ؼ�����1" "�Զ���ؼ�����2")
)

(defun GetTankPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "VOLUME" "SUBSTANCE" "TEMP" "PRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM" "EXTEMP" "EXPRESSURE")
)

(defun GetTankPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "�豸���" "��������" "�����¶�" "����ѹ��" "�������" "����Ƿ����" "�������" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "����ͼ��" "�Զ���ؼ�����1" "�Զ���ؼ�����2")
)

(defun GetHeaterPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "AREA" "SIZE" "ELEMENT" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM")
)

(defun GetHeaterPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�������" "�豸�ߴ�" "����Ԫ�����" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "����ͼ��")
)

(defun GetPumpPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "FLOW" "HEAD" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "NUMBER" "TYPE" "DRAWNUM")
)

(defun GetPumpPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "����" "���" "�������" "����Ƿ����" "�������" "�豸����" "�豸����" "�豸����" "�豸�ͺ�" "����ͼ��")
)

(defun GetVacuumPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "CAPACITY" "EXPRESSURE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "SIZE" "MATERIAL" "WEIGHT" "TYPE" "NUMBER" "DRAWNUM")
)

(defun GetVacuumPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "������" "����ѹ��" "�������" "����Ƿ����" "�������" "�豸�ߴ�" "�豸����" "�豸����" "�豸�ͺ�" "�豸����" "����ͼ��")
)

(defun GetCentrifugePropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "VOLUME" "CAPACITY" "DIAMETER" "SPEED" "FACTOR" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "MATERIAL" "WEIGHT" "TYPE" "NUMBER" "DRAWNUM")
)

(defun GetCentrifugePropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�豸���" "װ������" "ת��ֱ��" "ת��ת��" "����������" "�豸�ߴ�" "�������" "����Ƿ����" "�������" "�豸����" "�豸����" "�豸�ͺ�" "�豸����" "����ͼ��")
)

(defun GetCustomEquipPropertyNameList ()
  '("TAG" "NAME" "SPECIES" "SUBSTANCE" "TEMP" "PRESSURE" "SIZE" "POWER" "ANTIEXPLOSIVE" "MOTORSERIES" "PARAM1" "PARAM2" "PARAM3" "PARAM4" "MATERIAL" "WEIGHT" "TYPE" "INSULATIONTHICK" "NUMBER" "DRAWNUM")
)

(defun GetCustomEquipPropertyChNameList ()
  '("�豸λ��" "�豸����" "�豸����" "��������" "�����¶�" "����ѹ��" "�豸�ߴ�" "�������" "����Ƿ����" "�������" "�ؼ�����1" "�ؼ�����2" "�ؼ�����3" "�ؼ�����4" "�豸����" "�豸����" "�豸�ͺ�" "���º��" "�豸����" "����ͼ��")
)

(defun GetJoinDrawArrowPropertyNameList ()
  '("FROMTO" "DRAWNUM" "RELATEDID")
)

(defun GetGsCleanAirPropertyNameList ()
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "TEMP_PRECISION" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("��������" "������" "�ྻ�ȼ�" "��������߶�" "�������" "��ѹ" "��������" "�¶ȿ��ƾ���" "ʪ�ȿ��ƾ���" "ְҵ��¶�ȼ�" "�����豸����" "�����豸�����ŷ�" "�����豸���ޱ���" "�綯�豸����" "�綯�豸Ч��" "�����豸�������" "�����豸�����¶�" "����ˮ��������" "����ˮ������¶�" "�豸�Ƿ������ŷ�" "�豸�ŷ���" "�Ƿ�������ʪ��ζ" "��ʪ��ζ�ŷ���" "�����ŷ�۳���" "�����ŷ��ŷ���" "�Ƿ��¹��ŷ�" "�¹�ͨ�����" "������������" "�����������" "����¶�" "������ʪ��" "���ѹ��" "��ע")
)

; Get Constant Data
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

(defun WriteCommonDataToCSVByEntityNameListUtils (entityNameList / fileDir propertyNameList firstRow)
  (setq fileDir "D:\\dataflowcad\\data\\commonData.csv")
  (setq propertyNameList (GetBlockPropertyNameListByEntityName (car entityNameList)))
  (setq firstRow (GetCSVPropertyStringByDataListUtils propertyNameList))
  ; note: (cdr propertyNameList) - delete the entityhandle frist
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow (cdr propertyNameList) "1")
)

(defun GetBlockPropertyNameListByEntityName (entityName / allPropertyValue)
  (setq allPropertyValue (GetAllPropertyDictForOneBlock entityName))
  (mapcar '(lambda (x) 
             (car x)
           )
    allPropertyValue
  )
)

(defun WritePipeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\pipeData.csv")
  (setq firstRow "����ID,�ܵ����,��������,�����¶�,����ѹ��,��̬,�ܵ����,�ܵ��յ�,����ͼ��,���²���,��ȼ���Ϣ,��ܾ���Ϣ,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPipePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteInstrumentDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\instrumentData.csv")
  (setq firstRow "����ID,�Ǳ����ܴ���,�Ǳ�λ��,��������,�����¶�,����ѹ��,�Ǳ�����,��̬,����λ�ò���,���Ƶ�����,���ڹܵ����豸,��Сֵ,���ֵ,����ֵ,����ͼ��,����λ�óߴ�,��ע,��װ����,��ȼ���Ϣ,��ܾ���Ϣ,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetInstrumentPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteReactorDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\reactorData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,�豸���,��������,�����¶�,����ѹ��,�������,����Ƿ����,�������,��Ӧ��ת��,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,����ͼ��,�Զ���ؼ�����1,�Զ���ؼ�����2,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetReactorPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteTankDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\tankData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,�豸���,��������,�����¶�,����ѹ��,�������,����Ƿ����,�������,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,����ͼ��,�Զ���ؼ�����1,�Զ���ؼ�����2,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetTankPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteHeaterDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\heaterData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�������,�豸�ߴ�,����Ԫ�����,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,����ͼ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetHeaterPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WritePumpDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\pumpData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,����,���,�������,����Ƿ����,�������,�豸����,�豸����,�豸����,�豸�ͺ�,����ͼ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetPumpPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteVacuumDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\vacuumData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,������,����ѹ��,�������,����Ƿ����,�������,�豸�ߴ�,�豸����,�豸����,�豸�ͺ�,�豸����,����ͼ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetVacuumPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteCentrifugeDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\centrifugeData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�豸���,װ������,ת��ֱ��,ת��ת��,����������,�豸�ߴ�,�������,����Ƿ����,�������,�豸����,�豸����,�豸�ͺ�,�豸����,����ͼ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCentrifugePropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteCustomEquipDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\customEquipData.csv")
  (setq firstRow "����ID,�豸λ��,�豸����,�豸����,��������,�����¶�,����ѹ��,�豸�ߴ�,�������,����Ƿ����,�������,�ؼ�����1,�ؼ�����2,�ؼ�����3,�ؼ�����4,�豸����,�豸����,�豸�ͺ�,���º��,�豸����,����ͼ��,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetCustomEquipPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteGsCleanAirDataToCSVByEntityNameListUtils (entityNameList / fileDir firstRow propertyNameList)
  (setq fileDir "D:\\dataflowcad\\data\\gsCleanAirData.csv")
  (setq firstRow "����ID,��������,������,�ྻ�ȼ�,��������߶�,�������,��ѹ,��������,�¶ȿ��ƾ���,ʪ�ȿ��ƾ���,ְҵ��¶�ȼ�,�����豸����,�����豸�����ŷ�,�����豸���ޱ���,�綯�豸����,�綯�豸Ч��,�����豸�������,�����豸�����¶�,����ˮ��������,����ˮ������¶�,�豸�Ƿ������ŷ�,�豸�ŷ���,�Ƿ�������ʪ��ζ,��ʪ��ζ�ŷ���,�����ŷ�۳���,�����ŷ��ŷ���,�Ƿ��¹��ŷ�,�¹�ͨ�����,������������,�����������,����¶�,������ʪ��,���ѹ��,��ע,")
  ; the sort of  property must be consistency with the sort of block in CAD
  (setq propertyNameList (GetGsCleanAirPropertyNameList))
  (WriteDataToCSVByEntityNameListUtils entityNameList fileDir firstRow propertyNameList "0")
)

(defun WriteDataToCSVByEntityNameListStrategy (entityNameList dataType /)
  (cond 
    ((= dataType "Pipe") (WritePipeDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Instrument") (WriteInstrumentDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Reactor") (WriteReactorDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Tank") (WriteTankDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Heater") (WriteHeaterDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Pump") (WritePumpDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Vacuum") (WriteVacuumDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "Centrifuge") (WriteCentrifugeDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
    ((= dataType "CustomEquip") (WriteCustomEquipDataToCSVByEntityNameListUtils entityNameList))
  )
  (cond 
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
  (cond 
    ((= dataType "GsCleanAir") (WriteGsCleanAirDataToCSVByEntityNameListUtils entityNameList))
  ) 
  (princ)
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
  (ReadDataFromCSVUtils fileDir)
)
; Read and Write Utils
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Gs Field
; the macro for extract data

(defun c:exportBlockPropertyDataV2 (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("Pipe" "Equipment" "Instrument" "Electric" "OuterPipe" "GsCleanAir"))
  (setq dataTypeChNameList '("�ܵ�����" "�豸����" "�Ǳ�����" "��������" "�������" "�ྻ�յ�����"))
  (ExportBlockPropertyV2 dataTypeList dataTypeChNameList)  ; ready for refactor, the key is [ss] - 2020-12-14
)

(defun c:exportBlockPropertyData (/ dataTypeList dataTypeChNameList)
  (setq dataTypeList '("Pipe" "Equipment" "Instrument" "Electric" "OuterPipe" "GsCleanAir"))
  (setq dataTypeChNameList '("�ܵ�����" "�豸����" "�Ǳ�����" "��������" "�������" "�ྻ�յ�����"))
  (ExportBlockProperty dataTypeList dataTypeChNameList)
)

(defun ExportBlockProperty (dataTypeList dataTypeChNameList / dcl_id fileName currentDir fileDir exportDataType exportMsgBtnStatus ss sslen)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= exportMsgBtnStatus 2)
      (set_tile "exportBtnMsg" "�ļ�������Ϊ��")
    )
    (if (/= sslen nil)
      (set_tile "exportDataNumMsg" (strcat "�������������� " (rtos sslen)))
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
; Gs Field
; Generate Entity Object in CAD

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
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "�ܵ����") (cons 100 "AcDbText") 
                  (cons 10 insPt) (cons 11 '(0.0 0.0 0.0)) (cons 40 3.0) (cons 1 textContent) (cons 50 1.5708) (cons 41 0.7) (cons 51 0.0) 
                  (cons 7 "Standard") (cons 71 0) (cons 72 0) (cons 73 0) (cons 210 '(0.0 0.0 1.0)) (cons 100 "AcDbText") 
             )
  )(princ)
)

(defun GenerateEquipTagText (insPt textContent /)
  (entmake (list (cons 0 "TEXT") (cons 100 "AcDbEntity") (cons 67 0) (cons 410 "Model") (cons 8 "�豸λ��") (cons 100 "AcDbText") 
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

; directionStatus: dxfcode 50; 0 ˮƽ���� - 1.57 ��ֱ����
; hiddenStatus dxfcode 70; 0 �ɼ� - 1 ����
; moveStatus: dxfcode 280; 1 �̶� - 0 ���ƶ�
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

(defun GenerateJoinDrawArrowToElement (insPt fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowTo" "DataFlow-JoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue "DataFlow-JoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateJoinDrawArrowFromElement (insPt pipenumValue fromtoValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "JoinDrawArrowFrom" "DataFlow-JoinDrawArrow")
  (GenerateBlockAttribute (MoveInsertPosition insPt 30 2) "PIPENUM" pipenumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 4) "FROMTO" fromtoValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockAttribute (MoveInsertPosition insPt 1 -1.5) "DRAWNUM" drawnumValue "DataFlow-JoinDrawArrow" 3)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 1 -7) "RELATEDID" relatedIDValue "DataFlow-JoinDrawArrow" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownArrow" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -3.5 -10) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt 1.2 -10) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt 7 -10) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpArrow (insPt tagValue drawnumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpArrow" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -3.5 -11.5) "TAG" tagValue "0" 3)
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt 1.2 -11.5) "DRAWNUM" drawnumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt 7 -11.5) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeUpPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeUpPipeLine" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt -5 -16) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOnePublicPipeDownPipeLine (insPt pipenumValue relatedIDValue /)
  (GenerateBlockReference insPt "PublicPipeDownPipeLine" "DataFlow-PublicPipe")
  (GenerateVerticallyBlockAttribute (MoveInsertPosition insPt -1 -16) "PIPENUM" pipenumValue "0" 3)
  (GenerateVerticallyBlockHiddenAttribute (MoveInsertPosition insPt -5 -16) "RELATEDID" relatedIDValue "DataFlow-PublicPipe" 3)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; refactored at 2021-02-07
(defun GenerateOneFireFightHPipe (insPt pipenum pipeDiameter relatedIDValue textHeight /) 
  (GenerateBlockReference insPt "FireFightHPipe" "DataflowFireFightPipe")
  (GenerateBlockAttribute (MoveInsertPosition insPt 150 60) "PIPENUM" pipenum "0" textHeight)
  (GenerateBlockAttribute (MoveInsertPosition insPt 150 -420) "PIPEDIAMETER" pipeDiameter "0" textHeight)
  (GenerateBlockHiddenAttribute (MoveInsertPosition insPt 150 -720) "RELATEDID" relatedIDValue "DataflowFireFightPipe" 150)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; 2021-02-03
(defun GenerateOneFireFightVPipe (insPt pipenum relatedIDValue /) 
  (GenerateBlockReference insPt "FireFightVPipe" "DataflowFireFightPipe")
  (GenerateVerticallyBlockAttribute (AddPositonOffSetUtils insPt '(-60 150 0)) "PIPENUM" pipenum "0" 350)
  (GenerateBlockHiddenAttribute (AddPositonOffSetUtils insPt '(200 0 0)) "RELATEDID" relatedIDValue "DataflowFireFightPipe" 150)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; 2021-02-07
(defun GenerateOneFireFightElevation (insPt elevation textHeight /) 
  (GenerateBlockReference insPt "FireFightElevation" "DataflowFireFightElevation")
  (GenerateBlockAttribute (AddPositonOffSetUtils insPt '(-950 300 0)) "ELEVATION" elevation "0" textHeight)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateOneEntityObjectElement (insPt textDataList blockName /) 
  (cond 
    ((= blockName "EquipTagV2") 
      (entmake (list (cons 0 "INSERT") (cons 100 "AcDbEntity") (cons 100 "AcDbBlockReference") 
                    (cons 2 blockName) (cons 10 insPt) 
              )
      )
      (GenerateEquipTagText (MoveInsertPosition insPt 0 1) (nth 0 textDataList))
      (GenerateEquipTagText (MoveInsertPosition insPt 0 -4.5) (nth 1 textDataList))
    )
  )
)

(defun GenerateEntityObjectElement (blockName insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOneEntityObjectElement x y blockName)
          ) 
          insPtList
          dataList
  )
)

; Unit Test Completed
(defun ExtractDrawNum (str / result) 
  (if (> (strlen str) 2) 
    (setq result (substr str (- (strlen str) 4)))
    (setq result "��ͼ��")
  )
)

(defun c:EquipTag (/ ss equipInfoList insPt insPtList)
  (setq ss (GetEquipmentSSBySelectUtils))
  (setq equipInfoList (GetEquipTagList ss))
  ; merge equipInfoList by equipTag
  (setq equipInfoList (vl-sort equipInfoList '(lambda (x y) (< (car x) (car y)))))
  (setq insPt (getpoint "\nѡȡ�豸λ�ŵĲ���㣺"))
  (setq insPtList (GetInsertPtList insPt (GenerateSortedNumByList equipInfoList 0) 30))
  (GenerateEntityObjectElement "EquipTagV2" insPtList equipInfoList)
)

; Unit Test Completed
(defun GenerateSortedNumByList (originList i / resultList)
  (repeat (length originList) 
    (setq resultList (append resultList (list i)))
    (setq i (+ i 1))
  )
  resultList
)

; Unit Test Compeleted
(defun MoveInsertPosition (insPt xOffset yOffset / result)
  (setq result (ReplaceListItemByindexUtils (+ (car insPt) xOffset) 0 insPt))
  (setq result (ReplaceListItemByindexUtils (+ (nth 1 result) yOffset) 1 result))
  result
)

; get the new inserting position
; Unit Test Compeleted
(defun GetInsertPt (insPt i removeDistance /)
  (ReplaceListItemByindexUtils (+ (car insPt) (* i removeDistance)) 0 insPt)
)

; Unit Test Compeleted
(defun GetInsertPtList (insPt SortedNumByList removeDistance / resultList)
  (mapcar '(lambda (x) (GetInsertPt insPt x removeDistance)) 
    SortedNumByList
  )
)

(defun GetEquipTagList (ss / i ent blk entx value equipInfoList equipTag equipName)
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
  (setq equipInfoList (mapcar '(lambda (x y) (list x y)) equipTag equipName))
)

; Generate Entity Object in CAD
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate GsLcBlocks


; logic for generate Instrument
(defun c:InsertBlockInstrumentP (/ insPt) 
  (setq insPt (getpoint "\nѡȡ�����Ǳ�����㣺"))
  (VerifyGsLcBlockByName "InstrumentP")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentP")
)

(defun c:InsertBlockInstrumentL (/ insPt) 
  (setq insPt (getpoint "\nѡȡ�͵��Ǳ�����㣺"))
  (VerifyGsLcBlockByName "InstrumentL")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentL")
)

(defun c:InsertBlockInstrumentSIS (/ insPt) 
  (setq insPt (getpoint "\nѡȡSIS�Ǳ�����㣺"))
  (VerifyGsLcBlockByName "InstrumentSIS")
  (VerifyGsLcLayerByName "DataFlow-Instrument")
  (VerifyGsLcLayerByName "DataFlow-InstrumentComment")
  (GenerateBlockInstrumentP insPt "InstrumentSIS")
)

(defun GenerateBlockInstrumentP (insPt blockName /) 
  (GenerateBlockReference insPt blockName "DataFlow-Instrument") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 4) "VERSION" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 0.5) "FUNCTION" "xxxx" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -3.5) "TAG" "xxxx" "0" 3 0 0 1)
  (if (/= blockName "InstrumentL") 
    (progn 
      (GenerateLeftBlockAttribute (MoveInsertPosition insPt 6.5 2.4) "HALARM" "" "0" 3 0 0 0)
      (GenerateLeftBlockAttribute (MoveInsertPosition insPt 6.5 -5) "LALARM" "" "0" 3 0 0 0) 
    )
  )
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 2) "SUBSTANCE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 0) "TEMP" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -2) "PRESSURE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -6) "SORT" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -12) "PHASE" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -14) "MATERIAL" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -16) "NAME" "" "DataFlow-InstrumentComment" 1.5 0 1 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -4) "LOCATION" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -18) "MIN" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -20) "MAX" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -22) "NOMAL" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -24) "DRAWNUM" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -26) "INSTALLSIZE" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -28) "COMMENT" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -30) "DIRECTION" "" "DataFlow-InstrumentComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -8) "PIPECLASSCHANGE" "" "DataFlow-InstrumentComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8.5 -10) "REDUCERINFO" "" "DataFlow-InstrumentComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

; logic for generate Pipe
(defun c:InsertBlockPipeArrowLeft (/ insPt) 
  (setq insPt (getpoint "\nѡȡˮƽ�ܵ�����㣺"))
  (VerifyGsLcBlockByName "PipeArrowLeft")
  (VerifyGsLcLayerByName "DataFlow-Pipe")
  (VerifyGsLcLayerByName "DataFlow-PipeComment")
  (GenerateBlockPipeArrowLeft insPt)
)

(defun c:InsertBlockPipeArrowUp (/ insPt) 
  (setq insPt (getpoint "\nѡȡˮƽ�ܵ�����㣺"))
  (VerifyGsLcBlockByName "PipeArrowUp")
  (VerifyGsLcLayerByName "DataFlow-Pipe")
  (VerifyGsLcLayerByName "DataFlow-PipeComment")
  (GenerateBlockPipeArrowUp insPt)
)

(defun GenerateBlockPipeArrowLeft (insPt /) 
  (GenerateBlockReference insPt "PipeArrowLeft" "DataFlow-Pipe") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -1) "VERSION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 2) "PIPENUM" "xxxx" "0" 3 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 6) "SUBSTANCE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -10 6) "TEMP" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -6.5 6) "PRESSURE" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -5) "PHASE" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -1 6) "FROM" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 8 6) "TO" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -9) "DRAWNUM" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -7) "INSULATION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -20 -3) "PIPECLASSCHANGE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -12 -3) "REDUCERINFO" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateBlockPipeArrowUp (insPt /) 
  (GenerateBlockReference insPt "PipeArrowUp" "DataFlow-Pipe") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 4) "VERSION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -2 -20) "PIPENUM" "xxxx" "0" 3 1.57 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 2) "SUBSTANCE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 0) "TEMP" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -2) "PRESSURE" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -12) "PHASE" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -4) "FROM" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -6) "TO" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -14) "DRAWNUM" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -16) "INSULATION" "" "DataFlow-PipeComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -8) "PIPECLASSCHANGE" "" "DataFlow-PipeComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 2 -10) "REDUCERINFO" "" "DataFlow-PipeComment" 1.5 0 0 0) 
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)


; logic for generate EquipTag
(defun c:InsertBlockGsLcReactor (/ insPt) 
  (setq insPt (getpoint "\nѡȡ��Ӧ��λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Reactor")
  (VerifyGsLcLayerByName "DataFlow-EquipTag")
  (VerifyGsLcLayerByName "DataFlow-EquipTagComment")
  (GenerateBlockGsLcReactor insPt)
)

(defun c:InsertBlockGsLcTank (/ insPt) 
  (setq insPt (getpoint "\nѡȡ����λ�Ų���㣺"))
  (VerifyGsLcBlockByName "Tank")
  (VerifyGsLcLayerByName "DataFlow-EquipTag")
  (VerifyGsLcLayerByName "DataFlow-EquipTagComment")
  (GenerateBlockGsLcTank insPt)
)

(defun GenerateBlockGsLcReactor (insPt /) 
  (GenerateBlockReference insPt "Reactor" "DataFlow-EquipTag") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 0 5) "VERSION" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 1) "TAG" "R" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -4.5) "NAME" "xxxx" "DataFlow-EquipTagComment" 3 0 0 1)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -7.5) "SPECIES" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -9.5) "VOLUME" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -13.5) "SUBSTANCE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -15.5) "TEMP" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -17.5) "PRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -11.5) "POWER" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -21.5) "ANTIEXPLOSIVE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -23.5) "MOTORSERIES" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -25.5) "SPEED" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -19.5) "SIZE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -27.5) "MATERIAL" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -29.5) "WEIGHT" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -31.5) "TYPE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -33.5) "INSULATIONTHICK" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -35.5) "NUMBER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -37.5) "DRAWNUM" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -39.5) "EXTEMP" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -41.5) "EXPRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)

(defun GenerateBlockGsLcTank (insPt /) 
  (GenerateBlockReference insPt "Tank" "DataFlow-EquipTag") 
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt 0 5) "VERSION" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 1) "TAG" "V" "0" 3 0 0 1)
  (GenerateCenterBlockAttribute (MoveInsertPosition insPt 0 -4.5) "NAME" "xxxx" "DataFlow-EquipTagComment" 3 0 0 1)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -7.5) "SPECIES" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -9.5) "VOLUME" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -11.5) "SUBSTANCE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -13.5) "TEMP" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -15.5) "PRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -19.5) "POWER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -21.5) "ANTIEXPLOSIVE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -23.5) "MOTORSERIES" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -17.5) "SIZE" "" "DataFlow-EquipTagComment" 1.5 0 0 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -25.5) "MATERIAL" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -27.5) "WEIGHT" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -29.5) "TYPE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -31.5) "INSULATIONTHICK" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -33.5) "NUMBER" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -35.5) "DRAWNUM" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -37.5) "EXTEMP" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (GenerateLeftBlockAttribute (MoveInsertPosition insPt -4.25 -39.5) "EXPRESSURE" "" "DataFlow-EquipTagComment" 1.5 0 1 0)
  (entmake 
    (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
  )
  (princ)
)



; logic for generate PublicPipe
(defun InsertPublicPipe (dataList pipeSourceDirection / lastEntityName insPt insPtList) 
  (VerifyGsLcBlockPublicPipe)
  (setq lastEntityName (entlast))
  (setq insPt (getpoint "\nѡȡ���������������㣺"))
  (setq dataList (ProcessPublicPipeElementData dataList))
  ; sort data by drawnum
  (setq dataList (vl-sort dataList '(lambda (x y) (< (nth 4 x) (nth 4 y)))))
  (setq insPtList (GetInsertPtList insPt (GenerateSortedNumByList dataList 0) 10))
  (cond 
    ((= pipeSourceDirection "0") (GenerateDownPublicPipe insPtList dataList))
    ((= pipeSourceDirection "1") (GenerateUpPublicPipe insPtList dataList))
  )
)

(defun GenerateUpPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeUpArrow x (nth 2 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeUpPipeLine (MoveInsertPosition x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "DataFlow-PublicPipeLine" 0.6)
          ) 
          insPtList
          dataList
  )
)

(defun GenerateDownPublicPipe (insPtList dataList /)
  (mapcar '(lambda (x y) 
             (GenerateOnePublicPipeDownArrow x (nth 3 y) (nth 4 y) (nth 0 y))
             (GenerateOnePublicPipeDownPipeLine (MoveInsertPosition x 0 20) (nth 1 y) (nth 0 y))
             (GenerateVerticalPolyline x "DataFlow-PublicPipeLine" 0.6)
          ) 
          insPtList
          dataList
  )
)

(defun ProcessPublicPipeElementData (dataList /) 
  (mapcar '(lambda (x) 
             ; the property value of drawnum may be null
             (if (< (strlen (nth 4 x)) 3) 
               (ReplaceListItemByindexUtils "XXXXX" 4 x)
               (ReplaceListItemByindexUtils (ExtractDrawNum (nth 4 x)) 4 x)
             )
           ) 
    dataList
  )
)

(defun c:UpdatePublicPipe ()
  (UpdatePublicPipeByDataType "PublicPipeUpArrow")
  (UpdatePublicPipeByDataType "PublicPipeDownArrow")
  (UpdatePublicPipeByDataType "PublicPipeLine")
  (alert "�������")(princ)
)

(defun UpdatePublicPipeByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  )
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; repair bug - relatedid may be not in the allPipeHandleList - 2021-01-30
                        (and (/= (cdr (assoc "relatedid" x)) "") (/= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetAllPropertyValueListByEntityNameList entityNameList)
    )
  )
  (PrintErrorLogForUpdatePublicPipe dataType entityNameList allPipeHandleList) 
  (UpdatePublicPipeStrategy dataType entityNameList relatedPipeData)
)

(defun PrintErrorLogForUpdatePublicPipe (dataType entityNameList allPipeHandleList /)
  (if (= dataType "PublicPipeLine") 
    (mapcar '(lambda (x) 
              (prompt "\n")
              (prompt (strcat "ԭ�������еĹܵ�" (cdr (assoc "pipenum" x)) "���Կ鱻ͬ����ɾ���ˣ��޷�ͬ�����ݣ�"))
            ) 
      ; refactor at 2021-01-30
      (vl-remove-if-not '(lambda (x) 
                          (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                        ) 
        (GetAllPropertyValueListByEntityNameList entityNameList)
      )
    ) 
  )
)

(defun UpdatePublicPipeStrategy (dataType entityNameList relatedPipeData /) 
  (cond 
    ((= dataType "PublicPipeLine") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "PIPENUM") 
                  (list (cdr (assoc "pipenum" y)))
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "PublicPipeUpArrow") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "TAG" "DRAWNUM") 
                  (list 
                    (cdr (assoc "from" y)) 
                    (ExtractDrawNum (cdr (assoc "drawnum" y)))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "PublicPipeDownArrow") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "TAG" "DRAWNUM") 
                  (list 
                    (cdr (assoc "to" y)) 
                    (ExtractDrawNum (cdr (assoc "drawnum" y)))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
)

; logic for generate PublicPipe
;;;-------------------------------------------------------------------------;;;

;;;-------------------------------------------------------------------------;;;
; logic for generate joinDrawArrow

(defun c:UpdateJoinDrawArrow ()
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowTo")
  (UpdateJoinDrawArrowByDataType "JoinDrawArrowFrom")
  (alert "�������")(princ)
)

(defun GetAllPipeHandleListUtils (/ pipeData) 
  (setq pipeData (GetAllPipeDataUtils)) 
  (mapcar '(lambda (x) 
             (cdr (assoc "entityhandle" x))
           ) 
    pipeData
  )
)

(defun UpdateJoinDrawArrowByDataType (dataType / entityNameList relatedPipeData allPipeHandleList) 
  (setq entityNameList 
    (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType))
  )
  (setq allPipeHandleList (GetAllPipeHandleListUtils))
  (mapcar '(lambda (x) 
             (setq relatedPipeData (append relatedPipeData 
                                     (list (GetAllPropertyDictForOneBlock (handent (cdr (assoc "relatedid" x)))))
                                   ))
           ) 
    ; relatedid value maybe null
    (vl-remove-if-not '(lambda (x) 
                        ; repair bug - JoinDrawArrow's relatedid may be not in the allPipeHandleList - 2020.12.22
                        ; refactor at 2021-01-27
                        (and (/= (cdr (assoc "relatedid" x)) "") (/= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetAllPropertyValueListByEntityNameList entityNameList)
    )
  )
  (mapcar '(lambda (x) 
             (prompt "\n")
             (prompt (strcat (cdr (assoc "fromto" x)) "��" (cdr (assoc "drawnum" x)) "��" "�����Ĺܵ�����id�ǲ����ڵģ�"))
           ) 
    ; refactor at 2021-01-27
    (vl-remove-if-not '(lambda (x) 
                        (or (= (cdr (assoc "relatedid" x)) "") (= (member (cdr (assoc "relatedid" x)) allPipeHandleList) nil)) 
                      ) 
      (GetAllPropertyValueListByEntityNameList entityNameList)
    )
  ) 
  (UpdateJoinDrawArrowStrategy dataType entityNameList relatedPipeData)
)

(defun UpdateJoinDrawArrowStrategy (dataType entityNameList relatedPipeData /) 
  (cond 
    ((= dataType "JoinDrawArrowFrom") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "PIPENUM" "FROMTO" "DRAWNUM") 
                  (list 
                    (cdr (assoc "pipenum" y)) 
                    ; add the Equip ChName - 2021-01-27
                    (strcat "��" (cdr (assoc "from" y)) (GetEquipChNameByEquipTag (cdr (assoc "from" y))))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
  (cond 
    ((= dataType "JoinDrawArrowTo") 
      (mapcar '(lambda (x y) 
                (ModifyMultiplePropertyForOneBlockUtils x 
                  (list "FROMTO" "DRAWNUM") 
                  (list 
                    (strcat "ȥ" (cdr (assoc "to" y)) (GetEquipChNameByEquipTag (cdr (assoc "to" y))))
                    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" y))))
                  )
                )
              ) 
        entityNameList
        relatedPipeData 
      )
    )
  )
)

(defun c:GenerateJoinDrawArrow (/ pipeSS pipeData insPt entityNameList)
  (VerifyGsLcBlockByName "JoinDrawArrowTo")
  (VerifyGsLcBlockByName "JoinDrawArrowFrom")
  (VerifyGsLcLayerByName "DataFlow-JoinDrawArrow")
  (prompt "\nѡ�����ɽ�ͼ��ͷ�ı߽�ܵ���")
  (setq pipeSS (GetPipeSSBySelectUtils))
  (setq pipeData (GetAllPropertyDictForOneBlock (car (GetEntityNameListBySSUtils pipeSS))))
  (setq insPt (getpoint "\nѡȡ��ͼ��ͷ�Ĳ���㣺"))
  (GenerateJoinDrawArrowToElement insPt
    (strcat "ȥ" (cdr (assoc "to" pipeData))) 
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "to" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  )
  (GenerateJoinDrawArrowFromElement (MoveInsertPosition insPt 20 0)
    (cdr (assoc "pipenum" pipeData)) 
    (strcat "��" (cdr (assoc "from" pipeData)))
    (GetRelatedEquipDrawNum (GetRelatedEquipDataByTag (cdr (assoc "from" pipeData))))
    (cdr (assoc "entityhandle" pipeData)) 
  ) 
  (princ)
)

(defun GetRelatedEquipDataByTag (tag / equipData) 
  ; repair bug - the tag may contain space, trim the space frist - 2020.12.21
  (setq tag (StringSubstUtils "" " " tag))
  (setq equipData (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllEquipmentSSUtils))))
  (car 
    (vl-remove-if-not '(lambda (x) 
                        (= (cdr (assoc "tag" x)) tag)
                      ) 
      equipData
    ) 
  )
)

(defun GetRelatedEquipDrawNum (equipData / result) 
  (if (/= equipData nil) 
    (setq result (ExtractDrawNum (cdr (assoc "drawnum" equipData))))
    (setq result "�޴��豸")
  )
  result
)

; logic for generate joinDrawArrow
;;;-------------------------------------------------------------------------;;;

; Generate GsLcBlocks
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;


;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; logic for brushBlockPropertyValue

(defun c:brushTextEntityContent (/ textContent entityNameList)
  (prompt "\nѡ��Ҫ��ȡ�ĵ������֣�")
  (setq textContent (GetTextEntityContentBySelectUtils))
  (prompt (strcat "\n��ȡ���������ݣ�" textContent))
  (prompt "\nѡ��Ҫˢ�ĵ������֣�������ѡ�񣩣�")
  (setq entityNameList (GetEntityNameListBySSUtils (GetTextSSBySelectUtils)))
  (ModifyTextEntityContent entityNameList textContent)
  (princ)
)

(defun ModifyTextEntityContent (entityNameList textContent /)
  (mapcar '(lambda (x) 
            (SetDXFValueByEntityDataUtils (entget x) 1 textContent)
          ) 
    entityNameList
  ) 
)

(defun c:brushLocationForInstrument (/ locationData entityNameList)
  (prompt "\nѡ���Ǳ�����λ�ã��ܵ����豸����")
  (setq locationData (GetPipenumOrTag))
  (prompt "\nѡ��Ҫˢ����λ�õ��Ǳ���������ѡ�񣩣�")
  (setq entityNameList (GetEntityNameListBySSUtils (GetInstrumentSSBySelectUtils)))
  (ModifyLocatonForInstrument entityNameList locationData)
  (princ)
)

(defun ModifyLocatonForInstrument (entityNameList locationData /)
  (if (/= locationData "") 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "LOCATION") (list locationData))
            ) 
      entityNameList
    )
  )
)

(defun c:brushStartEndForPipe (/ startData endData entityNameList)
  (prompt "\nѡ��ܵ���㣨ֱ�ӿո��ʾ���޸ģ���")
  (setq startData (GetPipenumOrTag))
  (prompt "\nѡ��ܵ��յ㣨ֱ�ӿո��ʾ���޸ģ���")
  (setq endData (GetPipenumOrTag))
  (prompt "\nѡ��Ҫˢ�Ĺܵ���������ѡ�񣩣�")
  (setq entityNameList (GetEntityNameListBySSUtils (GetEquipmentAndPipeSSBySelectUtils)))
  (ModifyStartEndForPipes entityNameList startData endData)
  (princ)
)

(defun ModifyStartEndForPipes (entityNameList startData endData /)
  (if (and (/= startData "") (/= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "FROM" "TO") (list startData endData))
            ) 
      entityNameList
    )
  )
  (if (and (/= startData "") (= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "FROM") (list startData))
            ) 
      entityNameList
    )
  )
  (if (and (= startData "") (/= endData "")) 
    (mapcar '(lambda (x) 
              (ModifyMultiplePropertyForOneBlockUtils x (list "TO") (list endData))
            ) 
      entityNameList
    )
  )
)

(defun GetPipenumOrTagList (dataSS /)
  (GetAllPropertyDictForOneBlock 
    (car (GetEntityNameListBySSUtils dataSS))
  )
)

(defun GetPipenumOrTag (/ dataSS dataList result)
  (setq dataSS (GetEquipmentAndPipeSSBySelectUtils))
  (if (/= dataSS nil) 
    (progn 
      (setq dataList (GetPipenumOrTagList dataSS))
      (if (/= (cdr (assoc "tag" dataList)) nil) 
        (setq result (cdr (assoc "tag" dataList)))
      )
      (if (/= (cdr (assoc "pipenum" dataList)) nil) 
        (setq result (cdr (assoc "pipenum" dataList)))
      )
    )
    (setq result "")
  )
  result
)

(defun c:brushBlockPropertyValueByCommand (/ sourceEntityNameList sourceEntityPropertyDict sourceEntityPropertyNameList sourceEntityPropertyValueList targetEntityNameList targetEntityPropertyDict) 
  (prompt "\nѡ��Ҫ��ȡ���Ե�����Դ������Դֻ��ѡһ������") 
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
  (prompt "\nѡ��Ҫˢ�����ݣ�������ѡ�񣩣�")
  (setq targetEntityNameList (GetEntityNameListBySSUtils (ssget '((0 . "INSERT")))))
  (ModifyMultiplePropertyForBlockUtils targetEntityNameList sourceEntityPropertyNameList sourceEntityPropertyValueList)
  (princ "ˢ������ɣ�")(princ)
)

(defun c:brushBlockPropertyValue ()
  (brushBlockPropertyValueByBox "brushBlockPropertyValueBox")
)

(defun brushBlockPropertyValueByBox (tileName / dcl_id selectedProperty selectedPropertyIndexList selectedPropertyNameList 
                                     status ss entityNameList brushedPropertyDict matchedList modifiedDataType modifiedSS modifiedEntityNameList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
                '("��������" "�����¶�" "����ѹ��" "��̬" "����ͼ��" "�ܵ����"))
      (end_list)
    )
    (progn
      (start_list "modifiedDataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("ȫ��" "�Ǳ��͹ܵ�" "�ܵ�" "�Ǳ�" "�豸"))
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

(defun c:generatePublicProcessElement ()
  (generatePublicProcessElementByBox "generatePublicProcessElementBox" "Pipe")
)

(defun generatePublicProcessElementByBox (tileName dataType / dcl_id pipeSourceDirection patternValue status ss sslen matchedList blockDataList entityNameList previewDataList)
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
    
    ; optional setting for the popup_list tile
    (set_tile "pipeSourceDirection" "0")
    ; the default value of input box
    (mode_tile "pipeSourceDirection" 2)
    (action_tile "pipeSourceDirection" "(setq pipeSourceDirection $value)")
    (action_tile "patternValue" "(setq patternValue $value)")
    
    (progn
      (start_list "pipeSourceDirection" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("���ܹ�" "ȥ�ܹ�"))
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
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

(defun c:modifyCommonBlockProperty ()
  (modifyCommonBlockPropertyByBox "modifyBlockPropertyBox")
)

(defun c:modifyAllBlockProperty ()
  (filterAndModifyBlockPropertyByBoxV2 "filterAndModifyPropertyBox")
)

(defun c:modifyPipeProperty (/ pipePropertyNameList)
  (setq pipePropertyNameList (GetPipePropertyNameList))
  (filterAndModifyBlockPropertyByBox pipePropertyNameList "filterAndModifyEquipmentPropertyBox" "Pipe")
)

(defun c:modifyKsProperty (/ instrumentPropertyNameList)
  (setq instrumentPropertyNameList (GetInstrumentPropertyNameList))
  (filterAndModifyBlockPropertyByBox instrumentPropertyNameList "filterAndModifyEquipmentPropertyBox" "Instrument")
)

(defun c:modifyReactorProperty (/ reactorPropertyNameList dataTypeList)
  (setq reactorPropertyNameList (GetReactorPropertyNameList))
  (filterAndModifyBlockPropertyByBox reactorPropertyNameList "filterAndModifyEquipmentPropertyBox" "Reactor")
)

(defun c:modifyTankProperty (/ tankPropertyNameList dataTypeList)
  (setq tankPropertyNameList (GetTankPropertyNameList))
  (filterAndModifyBlockPropertyByBox tankPropertyNameList "filterAndModifyEquipmentPropertyBox" "Tank")
)

(defun c:modifyHeaterProperty (/ heaterPropertyNameList dataTypeList)
  (setq heaterPropertyNameList (GetHeaterPropertyNameList))
  (filterAndModifyBlockPropertyByBox heaterPropertyNameList "filterAndModifyEquipmentPropertyBox" "Heater")
)

(defun c:modifyPumpProperty (/ pumpPropertyNameList dataTypeList)
  (setq pumpPropertyNameList (GetPumpPropertyNameList))
  (filterAndModifyBlockPropertyByBox pumpPropertyNameList "filterAndModifyEquipmentPropertyBox" "Pump")
)

(defun c:modifyVacuumProperty (/ vacuumPropertyNameList dataTypeList)
  (setq vacuumPropertyNameList (GetVacuumPropertyNameList))
  (filterAndModifyBlockPropertyByBox vacuumPropertyNameList "filterAndModifyEquipmentPropertyBox" "Vacuum")
)

(defun c:modifyCentrifugeProperty (/ centrifugePropertyNameList dataTypeList)
  (setq centrifugePropertyNameList (GetCentrifugePropertyNameList))
  (filterAndModifyBlockPropertyByBox centrifugePropertyNameList "filterAndModifyEquipmentPropertyBox" "Centrifuge")
)

(defun c:modifyCustomEquipProperty (/ customEquipPropertyNameList dataTypeList)
  (setq customEquipPropertyNameList (GetCustomEquipPropertyNameList))
  (filterAndModifyBlockPropertyByBox customEquipPropertyNameList "filterAndModifyEquipmentPropertyBox" "CustomEquip")
)

; the macro for modify data
; Gs Field
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;

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

(defun GetIncreasedNumberStringListUtilsV2 (startNumer listLength / minIncreasedNumberList maxIncreasedNumberList) 
  (cond 
    ((< listLength 100) 
     (GetIncreasedNumberStringListHundredUtils startNumer listLength)) 
    ((and (>= listLength 100) (< listLength 1000)) 
     (GetIncreasedNumberStringListThousandUtils startNumer listLength))
  )
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

(defun testDoubleClick (index /)
  (alert index)(princ)
)

(defun modifyCommonBlockPropertyByBox (tileName / dcl_id status ss sslen entityNameList importedDataList entityHandle propertyNameList exportMsgBtnStatus importMsgBtnStatus modifyMsgBtnStatus blockName)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "���ȵ������ݣ�")
    )  
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "�޸�CAD����״̬�������")
    )
    (if (/= sslen nil)
      (set_tile "selectDataNumMsg" (strcat "ѡ�����ݿ�������� " (rtos sslen)))
    )
    (if (/= blockName nil)
      (set_tile "getBlockTypeMsg" (strcat "��ȡ���ݿ�����ƣ�" blockName))
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
        (setq importedDataList (StrListToListListUtils (ReadDataFromCSVStrategy "commonBlock")))
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
            (setq propertyNameList (GetBlockPropertyNameListByEntityName (handent entityHandle)))
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
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 2)
      (set_tile "importBtnMsg" "��������״̬�����������豸һ����")
    ) 
    (if (= importMsgBtnStatus 3)
      (set_tile "importBtnMsg" "���ȵ������ݣ�")
    )  
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "�޸�CAD����״̬�������")
    )
    (if (= modifyMsgBtnStatus 2)
      (set_tile "modifyBtnMsg" "����Ԥ��ȷ��һ�����ݣ�һ��д�� CAD ����ȫ�٣�")
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
            (setq importedDataList (StrListToListListUtils (ReadDataFromCSVStrategy dataType)))
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
      (if (= comfirmMsgBtnStatus 1) 
        (progn 
          (if (/= importedDataList nil) 
            (progn 
              (ModifyPropertyValueByEntityHandleUtils importedDataList (GetPropertyNameListStrategy dataType))
              (setq modifyMsgBtnStatus 1)
            )
            (setq importMsgBtnStatus 3)
          )
        ) 
        (setq modifyMsgBtnStatus 2)
      )
    )
  )
  (setq importedList nil)
  (unload_dialog dcl_id)
  (princ)
)

(defun GetTempExportedDataTypeChNameList ()
  '("�ܵ�" "�Ǳ�" "�����豸" "��Ӧ��" "���ͱ�" "����" "������" "���Ļ�" "��ձ�" "�Զ����豸" "�ྻ�յ�����")
)

; unit test compeleted
(defun GetTempExportedDataTypeByindex (index / result)
  (setq result (nth (atoi index) '("Pipe" "Instrument" "Equipment" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip" "GsCleanAir")))
  result
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= exportMsgBtnStatus 1)
      (set_tile "exportBtnMsg" "��������״̬�������")
    )
    (if (= importMsgBtnStatus 1)
      (set_tile "importBtnMsg" "��������״̬�������")
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "�޸�CAD����״̬�������")
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
        (setq importedDataList (StrListToListListUtils (ReadDataFromCSVStrategy dataType)))
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

(defun GetAllPropertyValueListByEntityNameList (entityNameList / resultList)
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
  '("�ܵ�" "�Ǳ�" "��Ӧ��" "���ͱ�" "����" "������" "���Ļ�" "��ձ�" "�Զ����豸")
)

(defun GetNumberDataTypeList ()
  '("Pipe" "Instrument" "Reactor" "Pump" "Tank" "Heater" "Centrifuge" "Vacuum" "CustomEquip")
)

(defun GetNumberdataChildrenTypeChNameList ()
  '("�¶�" "ѹ��" "Һλ" "����" "����" "���" "���ط�" "�¶ȵ��ڷ�" "ѹ�����ڷ�" "Һλ���ڷ�" "�������ڷ�")
)

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

(defun c:numberPipelineAndTag (/ dataTypeList)
  (setq dataTypeList (GetNumberDataTypeList))
  (numberPipelineAndTagByBox dataTypeList "filterAndNumberBox")
)

(defun numberPipelineAndTagByBox (propertyNameList tileName / dcl_id dataType dataChildrenType patternValue propertyValue replacedSubstring status selectedPropertyName selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList modifyMessageStatus modifyMsgBtnStatus numberedList)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "���״̬�������")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "resultMsg" "����Ԥ���޸�")
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
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType dataChildrenType))
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
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType dataChildrenType))
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
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType dataChildrenType))
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

(defun GetNumberedPropertyValueList (dictList dataType dataChildrenType /) 
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
    (mapcar '(lambda (x) 
              (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x))
            ) 
      dictList
    ) 
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

;;;----------------------------Enhanced Number Data------------------------;;;

(defun c:enhancedNumber (/ dataTypeList)
  (setq dataTypeList (GetEnhancedNumberDataTypeList))
  (enhancedNumberByBox dataTypeList "enhancedNumberBox")
)

(defun GetEnhancedNumberDataTypeList ()
  '("Pipe" "Instrument" "Equipment")
)

(defun GetEnhancedNumberDataTypeChNameList ()
  '("�ܵ�" "�Ǳ�" "�豸")
)

(defun enhancedNumberByBox (dataTypeList tileName / dcl_id dataType numberMode status selectedPropertyName 
                            selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList 
                            modifyMessageStatus numberedDataList numberedList codeNameList startNumberString)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
    (action_tile "dataType" "(setq dataType $value)")
    (action_tile "numberMode" "(setq numberMode $value)")
    (action_tile "startNumberString" "(setq startNumberString $value)")
    ; init the default data of text
    (progn 
      (start_list "dataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetEnhancedNumberDataTypeChNameList)
      )
      (end_list)
      (start_list "numberMode" 3)
      (mapcar '(lambda (x) (add_list x)) 
                '("������ͼ��" "��������ͼ��" "���豸λ��")
      )
      (end_list)
    )  
    (if (= nil dataType)
      (setq dataType "0")
    )
    (if (= nil numberMode)
      (setq numberMode "0")
    )
    (if (= nil startNumberString)
      (setq startNumberString "")
    ) 
    ; setting for saving the existed value of a box
    (set_tile "dataType" dataType)
    (set_tile "numberMode" numberMode)
    (set_tile "startNumberString" startNumberString)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= modifyMessageStatus 1)
      (set_tile "modifyBtnMsg" "���״̬�������")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "modifyBtnMsg" "����Ԥ���޸�")
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
        (setq ss (SortSelectionSetByXYZ ss))  ; sort by x cordinate
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType "Instrument"))
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

(defun GetNumberedDataListStrategy (propertyValueDictList dataType codeNameList numberMode startNumberString / childrenData childrenDataList numberedList) 
  (cond 
    ((or (= dataType "Pipe") (= dataType "Equipment") ) 
      (GetPipeAndEquipChildrenDataList propertyValueDictList dataType codeNameList numberMode startNumberString)
    )
    ((= dataType "Instrument") 
      (GetInstrumentChildrenDataList propertyValueDictList dataType numberMode startNumberString)
    )
    ((or (= dataType "GsCleanAir") (= dataType "FireFightHPipe")) 
      (GetGsCleanAirRoomNumDataList propertyValueDictList dataType codeNameList numberMode startNumberString)
    )
  )
)

(defun GetGsCleanAirRoomNumDataList (propertyValueDictList dataType codeNameList numberMode startNumberString / childrenData childrenDataList numberedList) 
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
                        (append xx (list (cons "numberedString" (GetGsCleanAirCodeNameByNumberMode yy numberMode startNumberString))))
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
(defun GetNewEquipTagLocation (oneKsDataOnPipe pipeFromAndToDictList equipPositionDictList / pipeLine pipeFromToPair)
  (setq pipeLine (GetPipeLineByPipeNum (cdr (assoc "LOCATION" oneKsDataOnPipe))))
  (setq pipeFromToPair (cdr (assoc pipeLine pipeFromAndToDictList)))
  (GetEquipTagLinkedPipe (car pipeFromToPair) (cadr pipeFromToPair) oneKsDataOnPipe equipPositionDictList)
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
  (setq drawNum (RegExpReplace (ExtractDrawNum drawNum) "0(\\d)-(\\d*)" (strcat "$1" "$2") nil nil))
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
                                  (= drawNum (ExtractDrawNum (cdr (assoc "DRAWNUM" x))))
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

(defun GetPipeAndEquipChildrenDataListByNoDrawNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (foreach item codeNameList 
    (setq childrenData 
      (vl-remove-if-not '(lambda (x) 
                           ; sort data by codeName
                          (wcmatch (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x)) (strcat item "*"))
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

(defun GetPipeAndEquipChildrenDataListByDrawNum (propertyValueDictList dataType codeNameList / childrenData childrenDataList numberedList) 
  (mapcar '(lambda (drawNum) 
            (foreach item codeNameList 
              (setq childrenData 
                (vl-remove-if-not '(lambda (x) 
                                      ; sort data by codeName
                                      (and 
                                        (wcmatch (cdr (assoc (car (numberedPropertyNameListStrategy dataType)) x)) (strcat item "*")) 
                                        (= drawNum (ExtractDrawNum (cdr (assoc "DRAWNUM" x))))
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

(defun GetGsCleanAirCodeNameByNumberMode (originString numberMode startNumberString /) 
  (cond 
    ((= numberMode "0") (RegExpReplace originString "(.*[A-Za-z]+)(\\d*).*" (strcat startNumberString "$1" "$2") nil nil))
    ((= numberMode "1") (RegExpReplace originString "(\\d*).*" (strcat startNumberString "$1") nil nil))
  ) 
)

; ready for refactor - 2021-03-05
(defun GetPipeCodeNameByNumberMode (originString numberMode drawNum startNumberString dataType /) 
  (setq drawNum (RegExpReplace (ExtractDrawNum drawNum) "0(\\d)-(\\d*)" (strcat "$1" "$2") nil nil))
  (cond 
    ((= numberMode "0") (RegExpReplace originString "([A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString drawNum "$2") nil nil))
    ; bug ��������ͼ�࣬������ţ�1A3�������⣬��ȡ�߼������޸� - 2021-03-02
    ; ���䣺��Ϊ�ú����봦���豸λ�ű�Ź��ã���֮ǰ�߼��ĺ��豸λ�ű���ֲ����ˣ�Ŀǰ���˷�֧���� - 2021-03-05
     ((= numberMode "1") 
      (if (= dataType "Pipe") 
        (RegExpReplace originString "([A-Za-z]+[0-9]?[A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString "$2") nil nil)
        (RegExpReplace originString "([A-Za-z]+)(\\d*).*" (strcat "$1" startNumberString "$2") nil nil)
      )
     )
  ) 
)

(defun GetNumberedListStrategy (numberedDataList dataType / resultList) 
  (cond 
    ((or (= dataType "Pipe") (= dataType "Equipment") (= dataType "GsCleanAir") (= dataType "FireFightHPipe"))
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
              (ExtractDrawNum x)
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

(defun IsKsLocationOnEquip (ksLocation /) 
  (RegexpTestUtils ksLocation "^[A-Z]+[0-9]+$" nil)
)

(defun GetCodeNameListStrategy (propertyValueDictList dataType / propertyName dataList resultList) 
  (if (= dataType "Pipe") 
    (progn 
      (setq propertyName (car (numberedPropertyNameListStrategy dataType)))
      (setq dataList 
        (GetValueListByOneKeyUtils propertyValueDictList propertyName)
      ) 
      (setq resultList (GetPipeCodeNameList dataList))
    )
  ) 
  (if (= dataType "Equipment") 
    (progn 
      (setq propertyName (car (numberedPropertyNameListStrategy dataType)))
      (setq dataList 
        (GetValueListByOneKeyUtils propertyValueDictList propertyName)
      ) 
      (setq resultList (GetEquipmentCodeNameList dataList))
    )
  ) 
  (if (= dataType "Instrument") 
    (progn 
      (setq propertyName (cadr (numberedPropertyNameListStrategy dataType)))
      (setq dataList 
        (GetValueListByOneKeyUtils propertyValueDictList propertyName)
      ) 
      (setq resultList (GetEquipmentCodeNameList dataList)) 
    )
  )
  (if (or (= dataType "GsCleanAir") (= dataType "FireFightHPipe")) ; 2021-02-03
    (progn 
      (setq propertyName (car (numberedPropertyNameListStrategy dataType)))
      (setq dataList 
        (GetValueListByOneKeyUtils propertyValueDictList propertyName)
      ) 
      (setq resultList (GetGsCleanAirCodeNameList dataList))
    )
  )
  (DeduplicateForListUtils resultList)
)

(defun GetPipeCodeNameList (pipeNumList /) 
  (mapcar '(lambda (x) 
            (RegExpReplace x "([A-Za-z]+)\\d*-.*" "$1" nil nil)
          ) 
    pipeNumList
  )
)

(defun GetEquipmentCodeNameList (tagList /) 
  (mapcar '(lambda (x) 
            (RegExpReplace x "([A-Za-z]+).*" "$1" nil nil)
          ) 
    tagList
  )
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

(defun c:numberDrawNum () 
  (NumberDrawNumByBox "numberDrawNumBox")
)

(defun c:brushDataDrawNum () 
  (BrushDrawNum)
)

(defun NumberDrawNumByBox (tileName / dcl_id propertyValue replacedSubstring status ss sslen previewList 
                           confirmList entityNameList modifyMsgBtnStatus numMsgStatus)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "msg" (strcat "ƥ�䵽��������" (rtos sslen)))
    )
    (if (= modifyMsgBtnStatus 1)
      (set_tile "modifyBtnMsg" "���״̬�������")
    )
    (if (= modifyMsgBtnStatus 2)
      (set_tile "modifyBtnMsg" "ˢ��������ͼ�������")
    )
    (if (= numMsgStatus 1)
      (set_tile "msg" (strcat "��ˢ���ݵ�������" (rtos sslen)))
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
        ; sort by x cordinate
        (setq entityNameList (GetEntityNameListByXPositionSortedUtils ss))
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
  (prompt "\nѡ��ͼǩ��")
  (setq drawNum 
    (car (GetDrawNumList (GetEntityNameListBySSUtils (GetBlockSSBySelectByDataTypeUtils "DrawLabel"))))
  )
  (prompt (strcat "\n��ѡ���ͼ�ţ�" drawNum))
  (prompt "\nѡ��Ҫˢ�����ݣ��ܵ����Ǳ����豸����")
  (setq entityNameList (GetEntityNameListBySSUtils (GetInstrumentPipeEquipSSBySelectUtils)))
  (ModifyDrawNumForData entityNameList drawNum)
  (prompt "\nˢ��������ͼ����ɣ�")
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

; Number DrawNum
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;



;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; PipeClassChange and PipeDiameterChange

(defun c:brushPipeClassChangeMacro (/ sourceData pipeClassChangeData instrumentAndPipeData pipeClassChangeInfo)
  (prompt "\nѡ���ܵ��ȼ����Լ�Ҫˢ�Ĺܵ����Ǳ����ݣ���ȼ���ֻ��ѡһ������")
  (setq sourceData (GetInstrumentAndPipeAndPipeClassChangeData))
  (setq pipeClassChangeData (GetPipeClassChangeDataForBrushPipeClassChange sourceData))
  (setq instrumentAndPipeData (GetInstrumentAndPipeDataForBrushPipeClassChange sourceData))
  (setq pipeClassChangeInfo (GetPipeClassChangeInfo (car pipeClassChangeData)))
  (ExecuteFunctionForOneSourceDataUtils (length pipeClassChangeData) 'BrushOnePropertyDataForInstrumentAndPipe 
    (list instrumentAndPipeData pipeClassChangeInfo "PIPECLASSCHANGE")
  )
)

(defun c:brushReducerInfoMacro (/ sourceData ReducerData instrumentAndPipeData reducerInfo entityNameList)
  (prompt "\nѡ���쾶�ܿ��Լ�Ҫˢ�Ĺܵ����Ǳ����ݣ��쾶�ܿ�ֻ��ѡһ������")
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
  (princ "ˢ������ɣ�")(princ)
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
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; GS ���� Equipemnt Layout

(defun c:numberLayoutData (/ dataTypeList)
  (setq dataTypeList (GetNumberLayoutDataTypeList))
  (numberLayoutDataByBox dataTypeList "enhancedNumberBox")
)

(defun GetNumberLayoutDataTypeList ()
  '("GsCleanAir" "FireFightHPipe")
)

(defun GetNumberLayoutDataTypeChNameList ()
  '("�ྻ�յ�" "����ˮ��������")
)

(defun GetNumberLayoutDataModeChNameList ()
  '("�������Զ�����" "���������Զ����")
)

(defun numberLayoutDataByBox (dataTypeList tileName / dcl_id dataType numberMode status selectedPropertyName 
                            selectedDataType ss sslen matchedList confirmList propertyValueDictList entityNameList 
                            modifyMessageStatus numberedDataList numberedList codeNameList startNumberString)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
    (action_tile "dataType" "(setq dataType $value)")
    (action_tile "numberMode" "(setq numberMode $value)")
    (action_tile "startNumberString" "(setq startNumberString $value)")
    ; init the default data of text
    (progn 
      (start_list "dataType" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberLayoutDataTypeChNameList)
      )
      (end_list)
      (start_list "numberMode" 3)
      (mapcar '(lambda (x) (add_list x)) 
                (GetNumberLayoutDataModeChNameList)
      )
      (end_list)
    )  
    (if (= nil dataType)
      (setq dataType "0")
    )
    (if (= nil numberMode)
      (setq numberMode "0")
    )
    (if (= nil startNumberString)
      (setq startNumberString "")
    ) 
    ; setting for saving the existed value of a box
    (set_tile "dataType" dataType)
    (set_tile "numberMode" numberMode)
    (set_tile "startNumberString" startNumberString)
    ; Display the number of selected pipes
    (if (/= sslen nil)
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= modifyMessageStatus 1)
      (set_tile "modifyBtnMsg" "���״̬�������")
    )
    (if (= modifyMessageStatus 0)
      (set_tile "modifyBtnMsg" "����Ԥ���޸�")
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
        (setq ss (SortSelectionSetByXYZ ss))  ; sort by x cordinate
        (setq entityNameList (GetEntityNameListBySSUtils ss))
        (setq propertyValueDictList (GetPropertyDictListByPropertyNameList entityNameList (numberedPropertyNameListStrategy selectedDataType)))
        (setq matchedList (GetNumberedPropertyValueList propertyValueDictList selectedDataType "Instrument"))
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



; 2021-03-05
(defun c:purgeJSDrawData () 
  (DeleteEntityBySSUtils (GetAllCopySS))
  (alert "������ͼ�����ɹ�")
)

; 2021-02-28
(defun c:extractJSDrawData () 
  (vl-bb-set 'architectureDraw (list (GetJSDrawBasePositionList) (GetAllStrategyCopyEntityData)))
  (alert "������ͼ��ȡ�ɹ�")
)

; 2021-02-28
(defun c:migrateJSDraw (/ GSDrawBasePositionList JSDrawBasePositionList newDrawBasePositionList JSDrawData resultList)
  (if (/= (vl-bb-ref 'architectureDraw) nil) 
    (progn 
      (setq GSDrawBasePositionList (GetJSDrawBasePositionList))
      (setq JSDrawBasePositionList (car (vl-bb-ref 'architectureDraw))) 
      (setq newDrawBasePositionList (GetNewDrawBasePositionList GSDrawBasePositionList JSDrawBasePositionList))
      (setq JSDrawData (car (cdr (vl-bb-ref 'architectureDraw)))) ; why have car? - 2021-02-28
      (DeleteEntityBySSUtils (GetAllCopySS))
      (GenerateNewJSEntityData newDrawBasePositionList JSDrawData)
      (alert "������ͼ���³ɹ�") 
    )
    (alert "������ȡ������ͼ��") 
  )
)

; 2021-02-26
(defun c:moveJSDraw ()
  (generateJSDraw (MoveCopyEntityData))
  (CADLispMove (GetAllMoveDrawLabelSS) '(0 0 0) '(200000 0 0))
  (CADLispCopy (GetAllCopyDrawLabelSS) '(0 0 0) '(200000 0 0)) 
  (alert "�Ƴ�������ͼ�ɹ���") 
)

; 2021-03-02
(defun GetAllMoveDrawLabelSS () 
    (ssget "X" '( (0 . "INSERT")
        (-4 . "<OR")
          (8 . "titan-title")
          (8 . "titan-title2")
        (-4 . "OR>")
      )
    )
)

; 2021-03-02
(defun GetAllCopyDrawLabelSS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "LWPOLYLINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "titan-title")
          (8 . "titan-title2")
        (-4 . "OR>")
      )
    )
)

; 2021-03-01
(defun c:switchLayerLock(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Toggle the status of the Lock property for the layer
              (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  (setq lockStatus 0)
                  (setq lockStatus 1)
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (setq lockStatusMsg '("������ͼ����" "������ͼ����"))
  (alert (nth lockStatus lockStatusMsg))
)

; 2021-03-01
(defun c:lockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (/= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "������ͼ����")
)

; 2021-03-01
(defun c:unlockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "������ͼ����")
)

; 2021-02-26
(defun generateJSDraw (JSEntityData /)
  (mapcar '(lambda (x) 
              (entmake x)
             ; for block - AcDbBlockReference
              (entmake 
                (list (cons 0 "SEQEND") (cons 100 "AcDbEntity"))
              ) 
           ) 
    JSEntityData
  )
  (princ)
)

; 2021-02-28
(defun MoveCopyEntityData () 
  (MoveCopyEntityDataByBasePosition (GetAllCopyEntityData) '(200000 0))
)

; 2021-02-26
(defun GetCopyEntityData () 
  (GetJSEntityData (GetCopySS))
)

; 2021-02-28
(defun GetAllCopyEntityData () 
  (GetJSEntityData (GetAllCopySS))
)

; 2021-02-28
(defun GetJSEntityData (ss /) 
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

; 2021-03-01
(defun GetCopySS () 
    (ssget '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WINDOW")
          (8 . "WALL")
          (8 . "COLUMN")
          (8 . "WALL-MOVE") 
          (8 . "STAIR") 
          (8 . "EVTR") 
          (8 . "DOOR_FIRE")
        (-4 . "OR>")
      )
    )
)

; 2021-03-01
(defun GetAllCopySS () 
    (ssget "X" '( 
        (-4 . "<OR")
          (0 . "LINE")
          (0 . "INSERT")
          (0 . "LWPOLYLINE")
        (-4 . "OR>") 
        (-4 . "<OR")
          (8 . "WINDOW")
          (8 . "WALL")
          (8 . "COLUMN")
          (8 . "WALL-MOVE") 
          (8 . "STAIR") 
          (8 . "EVTR") 
          (8 . "DOOR_FIRE")
        (-4 . "OR>")
      )
    )
)

; 2021-02-26
(defun GetJSDrawColumnSS () 
  (ssget '((0 . "INSERT") (8 . "COLUMN")))
)

; 2021-02-27
(defun GetAllJSDrawColumnSS () 
  (ssget "X" '((0 . "INSERT") (8 . "COLUMN")))
)

; 2021-02-27
(defun GetAllJSDrawColumnPosition () 
  (mapcar '(lambda (x) 
             (GetEntityPositionByEntityNameUtils x)
           ) 
    (GetEntityNameListBySSUtils (GetAllJSDrawColumnSS))
  ) 
)

; 2021-02-27
(defun GetStrategyJSDrawColumnPositionData (/ allJSDrawColumnPosition resultList) 
  ; set a temp variable first, ss in the foreach
  (setq allJSDrawColumnPosition (GetAllJSDrawColumnPosition))
    (foreach item (FilterJSDrawLabelData) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (car x) (car (cadr item))) 
                    (< (car x) (+ (car (cadr item)) 126150)) 
                    (< (cadr x) (cadr (cadr item)))
                    (> (cadr x) (- (cadr (cadr item)) 89100))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      allJSDrawColumnPosition
    ) 
  ) 
  resultList
)

(defun GetJSDrawBasePositionList (/ allJSDrawColumnPositionData tempPositionList resultList)
  ; set a temp variable first, ss in the foreach
  (setq allJSDrawColumnPositionData (GetStrategyJSDrawColumnPositionData))
    (foreach item (FilterJSDrawLabelData) 
    (setq tempPositionList (SortPositionListByMinxMinyUtils 
                              (mapcar '(lambda (x) (cadr x)) 
                                (vl-remove-if-not '(lambda (x) 
                                                    (= (car x) (car item)) 
                                                  ) 
                                  allJSDrawColumnPositionData
                                ) 
                              )  
                       )
    )
    (setq resultList (append resultList (list (list (car item) (car tempPositionList)))))
  ) 
  (setq resultList (vl-sort resultList '(lambda (x y) (< (atof (car x)) (atof (car y))))))
)

; 2021-02-26
(defun GetAllJSDrawLabelData () 
  (mapcar '(lambda (x) 
             (list 
               (StringSubstUtils "" "%%p" (strcat (cdr (assoc "dwgname1" x)) (cdr (assoc "dwgname2l1" x)) (cdr (assoc "dwgname2l2" x))))
               (GetJSDrawPositionRangeUtils (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x)))))
             )
           ) 
    (GetAllPropertyValueListByEntityNameList (GetEntityNameListBySSUtils (GetAllDrawLabelSSUtils)))
  ) 
)

(defun GetJSDrawPositionRangeUtils (position /)
  (list (+ (car position) -126150) (+ (cadr position) 89100))
)

; 2021-02-27
(defun FilterJSDrawLabelData ()
  (mapcar '(lambda (x) 
             (list 
               (RegExpReplace (car x) "([^0-9]*)(\\d+\\.\\d).*" "$2" nil T)
               (cadr x)
             )
           ) 
    (vl-remove-if-not '(lambda (x) 
                        (/= (wcmatch (car x) "*`.*") nil) 
                      ) 
      (GetAllJSDrawLabelData)
    ) 
  ) 
)

; 2021-02-28
(defun GetAllStrategyCopyEntityData () 
  (GetStrategyEntityData (GetAllCopyEntityData))
)

; 2021-02-28
(defun GetStrategyCopyEntityData () 
  (GetStrategyEntityData (GetCopyEntityData))
)

; 2021-02-27
(defun GetStrategyEntityData (copyEntityData / resultList) 
    (foreach item (FilterJSDrawLabelData) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (cadr (assoc 10 x)) (car (cadr item))) 
                    (< (cadr (assoc 10 x)) (+ (car (cadr item)) 126150)) 
                    (< (caddr (assoc 10 x)) (cadr (cadr item)))
                    (> (caddr (assoc 10 x)) (- (cadr (cadr item)) 89100))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      copyEntityData
    ) 
  ) 
  resultList
)

; 2021-02-28
(defun MoveCopyEntityDataByBasePosition (entityData basePosition /)
  (mapcar '(lambda (x) 
             ; ready for refactor
             (if (= (cdr (assoc 0 x)) "INSERT") 
               (MoveBlockDataByBasePosition x basePosition)
               (progn 
                 (if (= (cdr (assoc 0 x)) "LINE") 
                   (MoveLineDataByBasePosition x basePosition)
                   (MovePolyLineDataByBasePosition x basePosition)
                 )
               )
             )  
           ) 
    entityData
  )
)

(defun MoveLineDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10 11)
    (list (MoveInsertPosition (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
          (MoveInsertPosition (cdr (assoc 11 x)) (car basePosition) (cadr basePosition))
    )
  )
)

(defun MoveBlockDataByBasePosition (entityData basePosition /)
  (ReplaceDXFValueByEntityDataUtils 
    entityData 
    '(10)
    (list (MoveInsertPosition (cdr (assoc 10 x)) (car basePosition) (cadr basePosition)) 
    )
  )
)

(defun MovePolyLineDataByBasePosition (entityData basePosition / resultList)
  (mapcar '(lambda (x) 
             (if (= (car x) 10) 
               (setq resultList (append resultList (list (cons 10 (MoveInsertPosition (cdr x) (car basePosition) (cadr basePosition))))))
               (setq resultList (append resultList (list x)))
             ) 
             
           ) 
    entityData
  )
  resultList
)

; 2021-02-28
(defun MoveJSEntityDataToBasePosition (drawBasePositionList / strategyCopyEntityData tempDataList resultList)
  ; set a temp variable first, ss in the foreach
  (setq strategyCopyEntityData (GetStrategyCopyEntityData))
    (foreach item drawBasePositionList
    (setq tempDataList (MoveCopyEntityDataByBasePosition 
                              (mapcar '(lambda (x) (cadr x)) 
                                (vl-remove-if-not '(lambda (x) 
                                                    (= (car x) (car item)) 
                                                  ) 
                                  strategyCopyEntityData
                                ) 
                              ) 
                              (list (- 0 (car (cadr item))) (- 0 (cadr (cadr item))))
                           )
    )
    (setq resultList (append resultList (list (list (car item) tempDataList))))
  ) 
  resultList
)

; 2021-02-28
(defun GenerateNewJSEntityData (drawBasePositionList strategyCopyEntityData /)
  ; set a temp variable first, ss in the foreach
    (foreach item drawBasePositionList
    (generateJSDraw (MoveCopyEntityDataByBasePosition 
                      (mapcar '(lambda (x) (cadr x)) 
                        (vl-remove-if-not '(lambda (x) 
                                            (= (car x) (car item)) 
                                          ) 
                          strategyCopyEntityData
                        ) 
                      ) 
                      (list (- 0 (car (cadr item))) (- 0 (cadr (cadr item))))
                    )
    )
  ) 
)

(defun GetNewDrawBasePositionList (GSDrawBasePositionList JSDrawBasePositionList /)
  (mapcar '(lambda (x y) 
             (list 
               (car x) 
               (MoveInsertPosition (cadr y) (- 0 (car (cadr x))) (- 0 (cadr (cadr x))))
             )
           ) 
    GSDrawBasePositionList
    JSDrawBasePositionList
  )  
)

; GS ���� Equipemnt Layout
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;





;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; SS

; Macro 

; 2021-02-02
(defun c:GenerateFireFightVPipeText (/ insPt) 
  (princ "\n��ѡ������˨ƽ��ͼ�е��������ܣ�")
  (mapcar '(lambda (x) 
             (GenerateLineByPosition (cadr x) (AddPositonOffSetUtils (cadr x) '(500 -1300 0)) "DataflowFireFightPipe")
             (GenerateOneFireFightHPipe (AddPositonOffSetUtils (cadr x) '(500 -1300 0)) "XHL" (GetFireFightPipeDiameter x) (car x) 350)
          ) 
    (GetRawFireFightPipeDataListBySelect)
  ) 
  (alert "�Զ�����ƽ���������ܱ�ע��ɣ�")(princ)
)

; 2021-02-03
(defun GetFireFightPipeDiameter (dataList /)
  (strcat "DN" (RemoveDecimalForStringUtils (rtos (caddr dataList))))
)

(defun RemoveDecimalForStringUtils (rawString /)
  (RegExpReplace rawString "(\\d+)\..*" "$1" nil nil)
)

; 2021-02-07
(defun c:GenerateFireFightVPipe (/ firstPt ss insPt linePoint textHeight elevation) 
  (princ "\n")
  (initget (+ 1 2 4))
  (setq textHeight (getint "\n����������߶ȣ�"))
  (setq elevation (getstring "\n�������Զ����ɵı��ֵ��"))
  (setq firstPt (getpoint "ʰȡƽ��ͼ������ˮ�������½ǵĹܵ��㣺"))
  (princ "\nʰȡƽ��ͼ�е�����ˮ�ܣ�")
  (setq ss (GetFireFightVPipeSSBySelectUtils))
  (setq insPt (getpoint "ʰȡ���ͼ������ˮ�������½ǵĹܵ��㣺"))
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

; 2021-02-07
(defun c:GenerateFireFightPipeByBox ()
  (labelFireFightPipeByBox "labelFireFightPipeBox")
)

; 2021-02-07
(defun labelFireFightPipeByBox (tileName / dcl_id status textHeight elevationValue firstPt insPt floorDrawMsgStatus axialDrawMsgStatus ss sslen)
  (setq dcl_id (load_dialog (strcat "D:\\dataflowcad\\" "dataflow.dcl")))
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
      (set_tile "msg" (strcat "ƥ�䵽�������� " (rtos sslen)))
    )
    (if (= floorDrawMsgStatus 1) 
      (set_tile "floorDrawMsg" "ƽ��ͼʰȡ״̬�������")
    )
    (if (= axialDrawMsgStatus 1) 
      (set_tile "axialDrawMsg" "ƽ��ͼʰȡ״̬�������")
    )
    (if (= infoMsgStatus 1) 
      (set_tile "infoMsg" "״̬���������벻����")
    ) 
    (if (= infoMsgStatus 2) 
      (set_tile "infoMsg" "״̬�������")
    ) 
    (if (= infoMsgStatus 0) 
      (set_tile "infoMsg" "״̬��")
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
        (setq firstPt (getpoint "ʰȡƽ��ͼ������ˮ�������½ǵĹܵ��㣺"))
        (setq floorDrawMsgStatus 1)
      )
    )
    ; axialDraw button
    (if (= 4 status)
      (progn 
        (setq insPt (getpoint "ʰȡ���ͼ������ˮ�������½ǵĹܵ��㣺"))
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
      (GetAllPropertyValueListByEntityNameList entityNameList)
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
  (alert "�������")(princ)
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
;;;-------------------------------------------------------------------------;;;

;| 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------
|; 