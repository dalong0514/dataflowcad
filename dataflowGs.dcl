importGsBzEquipTagBox : dialog {
  label = "�������������һ�廯����V2.0���������²���ͼ�豸ͼ��"; 
  key = "importGsBzEquipTag";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : column {
      : popup_list { 
        label = "������豸����";
        edit_width = 80;
        key = "exportDataType"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "�豸λ������˳��";
        edit_width = 80;
        key = "sortedType"; 
        list = "";
        value = "";
      } 
    }
    : spacer { height = 1; } 
    : text {
      key = "importBtnMsg";
      label = "�����豸����״̬��";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnImportData"; 
        label = "��������"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "ѡ��λ�Ų����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

updateGsBzEquipGraphBox : dialog {
  label = "�������������һ�廯����V2.0���������²���ͼ�豸ͼ��"; 
  key = "updateGsBzEquipGraph";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : spacer { height = 1; } 
    : text {
      key = "exportBtnMsg";
      label = "������ʱ�ļ�״̬��";
    }
    : spacer { height = 1; } 
    : text {
      key = "importBtnMsg";
      label = "������ʱ�ļ�״̬��";
    }
    : spacer { height = 1; } 
    : text {
      key = "modifyBtnMsg";
      label = "���ݸ���״̬��";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnExportData"; 
        label = "��������"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; }  
      : button { 
        key = "btnImportData"; 
        label = "��������"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "ȷ���޸�"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}