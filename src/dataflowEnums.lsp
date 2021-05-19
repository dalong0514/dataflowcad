;����������� 2020-2021 ��
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
    ((= dataType "Pipe") (setq dataTypeMsg "�����޸Ĺܵ�����"))
    ((= dataType "Instrument") (setq dataTypeMsg "�����޸��Ǳ�����"))
    ((= dataType "Reactor") (setq dataTypeMsg "�����޸ķ�Ӧ������"))
    ((= dataType "Tank") (setq dataTypeMsg "�����޸Ĵ�������"))
    ((= dataType "Heater") (setq dataTypeMsg "�����޸Ļ���������"))
    ((= dataType "Pump") (setq dataTypeMsg "�����޸����ͱ�����"))
    ((= dataType "Vacuum") (setq dataTypeMsg "�����޸���ձ�����"))
    ((= dataType "Centrifuge") (setq dataTypeMsg "�����޸����Ļ�����"))
    ((= dataType "CustomEquip") (setq dataTypeMsg "�����޸��Զ����豸����"))
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
  '("�Ǳ��ܴ���" "�Ǳ�λ��" "��������" "�����¶�" "����ѹ��" "�Ǳ�����" "��̬" "����λ�ò���" "���Ƶ�����" "���ڹܵ����豸" "��Сֵ" "���ֵ" "����ֵ" "����ͼ��" "����λ�óߴ�" "��ע" "��װ����"  "��ȼ���Ϣ" "��ܾ���Ϣ")
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
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "TEMP_PRECISION" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT" "SYSTEM_NUM" "FLOOR_HEIGHT" "EXPLOSION_PROOF_STATUS")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("��������" "������" "�ྻ�ȼ�" "��������߶�" "�������" "��ѹ" "��������" "�¶ȿ��ƾ���" "ʪ�ȿ��ƾ���" "ְҵ��¶�ȼ�" "�����豸����" "�����豸�����ŷ�" "�����豸���ޱ���" "�綯�豸����" "�綯�豸Ч��" "�����豸�������" "�����豸�����¶�" "����ˮ��������" "����ˮ������¶�" "�豸�Ƿ������ŷ�" "�豸�ŷ���" "�Ƿ�������ʪ��ζ" "��ʪ��ζ�ŷ���" "�����ŷ�۳���" "�����ŷ��ŷ���" "�Ƿ��¹��ŷ�" "�¹�ͨ�����" "������������" "�����������" "����¶�" "������ʪ��" "���ѹ��" "��ע" "ϵͳ���" "����¥��" "�Ƿ������")
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