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
  '("InstrumentL" "InstrumentP" "InstrumentSIS" "Centrifuge" "CustomEquip" "Heater" "Pump" "Reactor" "Tank" "Vacuum" "OuterPipeLeft" "OuterPipeRight" "OuterPipeDoubleArrow" "GsCleanAir" "GsComfortAir")
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
  '("ROOM_NAME" "ROOM_NUM" "CLEAN_GRADE" "ROOM_HEIGHT" "ROOM_AREA" "ROOM_PRESSURE" "ROOM_PERSON_NUM" "SUMMER_TEMP" "WINTER_TEMP" "TEMP_PRECISION" "SUMMER_REHUMIDITY" "WINTER_REHUMIDITY" "HUMIDITY_PRECISION" "OCCUPATION_EXPOSURE_GRADE" "ELECTRO_THERMAL_POWER" "ELECTRO_THERMAL_IS_EXHAUST" "ELECTRO_THERMAL_IS_INSULATION" "ELECTRO_MOTOR_POWER" "ELECTRO_MOTOR_EFFICIENCY" "EQUIP_SURFACE_AREA" "EQUIP_SURFACE_TEMP" "WATER_SURFACE_AREA" "WATER_SURFACE_TEMP" "IS_EQUIP_EXHAUST" "EQUIP_EXHAUST_AIR" "IS_DEHUMIDITY" "DEHUMIDITY_EXHAUST_EFFICIENCY" "DEDUST_AMOUNT" "DEDUST_EXHAUST_EFFICIENCY" "IS_ACCIDENT_EXHAUST" "ACCIDENT_EXHAUST_SUBSTANCE" "LAMINAR_PROTECTION" "LAMINAR_PROTECTION_AREA" "MONITOR_TEMP" "MONITOR_REHUMIDITY" "MONITOR_DIFFPRESSURE" "COMMENT" "SYSTEM_NUM" "FLOOR_HEIGHT" "EXPLOSION_PROOF_STATUS")
)

(defun GetGsCleanAirPropertyChNameList ()
  '("��������" "������" "�ྻ�ȼ�" "��������߶�" "�������" "��ѹ" "��������" "�����ļ��¶�" "���䶬���¶�" "�¶ȿ��ƾ���" "�����ļ����ʪ��" "���䶬�����ʪ��" "ʪ�ȿ��ƾ���" "ְҵ��¶�ȼ�" "�����豸����" "�����豸�����ŷ�" "�����豸���ޱ���" "�綯�豸����" "�綯�豸Ч��" "�����豸�������" "�����豸�����¶�" "����ˮ��������" "����ˮ������¶�" "�豸�Ƿ������ŷ�" "�豸�ŷ���" "�Ƿ�������ʪ��ζ" "��ʪ��ζ�ŷ���" "�����ŷ�۳���" "�����ŷ��ŷ���" "�Ƿ��¹��ŷ�" "�¹�ͨ�����" "������������" "�����������" "����¶�" "������ʪ��" "���ѹ��" "��ע" "ϵͳ���" "����¥��" "�Ƿ������")
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
  '("������" "��������" "�������" "�����ȼ�" "�������" "��������" "ÿ���������" "�����ļ��¶�" "���䶬���¶�" "�����ļ����ʪ��" "���䶬�����ʪ��" "�����豸�����" "�����豸�����¶�" "�豸������" "�豸ͬʱ��ת����ܹ���" "�к�������ҳ�����" "�к�������ҳ�������" "ɢʪ��" "�¹��ŷ��豸λ��" "����ѹҪ��" "��ע")
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
; ��׼��ͷ��ֱ�߶θ߶ȣ�С�ڵ��� 2000 ֱ������ 25mm������ 2000 ֱ������ 40mm
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
    ((= chUnitName "�·��") "NsCAH-AHU-OutdoorAir")
    ((= chUnitName "�ط��") "NsCAH-AHU-ReturnAir")
    ((= chUnitName "�ͷ��") "NsCAH-AHU-SupplyAir")
    ((= chUnitName "��϶�") "NsCAH-AHU-MixAir")
    ((= chUnitName "�ն�") "NsCAH-AHU-EmptyAir")
    ((= chUnitName "������") "NsCAH-AHU-MeanFlowAir")
    ((= chUnitName "������") "NsCAH-AHU-MuffledAir")
    ((= chUnitName "���ŷ��") "NsCAH-AHU-NewExhaustAir")
    ; filter unit
    ((= chUnitName "��ʽ��Ч��") "NsCAH-AHU-PlateRough")
    ((= chUnitName "��ʽ��Ч��") "NsCAH-AHU-FabricRough")
    ((= chUnitName "��Ч��") "NsCAH-AHU-MediumEfficiency")
    ((= chUnitName "����Ч��") "NsCAH-AHU-HighMediumEfficiency")
    ((= chUnitName "�Ǹ�Ч��") "NsCAH-AHU-SubHighEfficiency")
    ((= chUnitName "��Ч��") "NsCAH-AHU-HighEfficiency")
    ; heat and cool unit
    ((= chUnitName "�����") "NsCAH-AHU-SurfaceCooler")
    ((= chUnitName "���䵲ˮ��") "NsCAH-AHU-SurfaceCoolerEliminator")
    ((= chUnitName "��ˮ���ȶ�") "NsCAH-AHU-HotWaterHeat")
    ((= chUnitName "����Ԥ�ȶ�") "NsCAH-AHU-SteamPreHeat")
    ((= chUnitName "�������ȶ�") "NsCAH-AHU-SteamHeat")
    ((= chUnitName "������ʪ��") "NsCAH-AHU-SteamHumidify")
    ((= chUnitName "����ȶ�") "NsCAH-AHU-ElectricHeat")
    ((= chUnitName "���ʪ��") "NsCAH-AHU-ElectricHumidify")
    ; FanSection
    ((= chUnitName "ˮƽ��������") "NsCAH-AHU-FanSection-Level")
    ((= chUnitName "������������") "NsCAH-AHU-FanSection-Top")
  )
)

; 2021-06-10
(defun GetNsCAHAirValveBlockNameEnums (chUnitName /)
  (cond 
    ((= chUnitName "�Կ���Ҷ�������ڷ�") "NsCAH-RE-OMD")
    ((= chUnitName "�綯�Կ���Ҷ�������ڷ�") "NsCAH-RE-EOMD")
    ((= chUnitName "�����ﶨ������") "NsCAH-RE-CAV-Venturi")
    ((= chUnitName "������˫��̬��������") "NsCAH-RE-CAV-Venturi")
    ((= chUnitName "EN��������") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "EN˫��̬��������") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "RN��������") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "RN˫��̬��������") "NsCAH-RE-CAV-TROX")
    ((= chUnitName "������������") "NsCAH-RE-VAV-Venturi")
    ((= chUnitName "TVT�������") "NsCAH-RE-VAV-TROX")
    ((= chUnitName "TVR�������") "NsCAH-RE-VAV-TROX")
  )
)