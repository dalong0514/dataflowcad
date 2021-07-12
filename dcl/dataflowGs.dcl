importGsEquipDataBox : dialog {
  label = "�������������һ�廯����V2.3�����������豸λ�ż��豸ͼ��"; 
  key = "importGsEquipData";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : text {
      key = "importDataTypeMsg";
      label = "";
      alignment = centered; 
    } 
    : spacer { height = 2; } 
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
  label = "�������������һ�廯����V2.3���������²���ͼ�豸ͼ��"; 
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
      label = "�豸ͼ�θ���״̬��";
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
        label = "ȷ�ϸ���"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

UpdateAllPublicPipeFromToDataBox : dialog {
  label = "�������������һ�廯����V2.3������һ����ȡ�������̹ܵ���ȥ������"; 
  key = "UpdateAllPublicPipeFromToData";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : text {
      key = "fromCodeMsg";
      label = "����ƥ��ġ������豸�Ĺ��ùܵ����ţ�";
    }
    : spacer { height = 1; } 
    : row {
      fixed_width = true; 
      alignment = left;  
      : edit_box {
        key = "fromCodeInput";
        edit_width = 50;
        mnemonic = "N";
        value = "";
      }
      : spacer { width = 2; }  
      : button { 
        key = "btnAddFromCode"; 
        label = "����"; 
        is_default = "true"; 
      }  
    }
    : spacer { height = 1; }  
    : text {
      key = "toCodeMsg";
      label = "����ƥ��ġ������豸�Ĺ��ùܵ����ţ�";
    }
    : spacer { height = 1; } 
    : row {
      fixed_width = true; 
      alignment = left;  
      : edit_box {
        key = "toCodeInput";
        edit_width = 50;
        mnemonic = "N";
        value = "";
      }
      : spacer { width = 2; }  
      : button { 
        key = "btnAddToCode"; 
        label = "����"; 
        is_default = "true"; 
      }  
    }
    : spacer { height = 1; }   
    : text {
      key = "exportDataNumMsg";
      label = "ѡ�����ݵ�������";
    } 
    : spacer { height = 2; }  
    : text {
      key = "modifyStatusMsg";
      label = "�޸�״̬��";
    } 
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "��ѡ"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAllSelect"; 
        label = "ȫѡ"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; }  
      : button { 
        key = "btnModify"; 
        label = "����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

// 2021-07-12
ModifyBlockPropertyWidthByBox : dialog {
  label = "�������������һ�廯����V2.3�������޸��������������ֿ�"; 
  key = "modifyBlockPropertyWidth";
  : row {
    : boxed_radio_column {
      width = 80;
      height = 2;
      : popup_list { 
        label = "ѡ��Ҫ�޸ĵ��������ͣ�";
        edit_width = 29;
        key = "exportDataType"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; }
      : popup_list { 
        label = "����������";
        edit_width = 29;
        key = "blockPropertyName"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; }
      : row {
        : text {
          key = "propertyWidthText";
          label = "�������������ȣ�";
        }
        : edit_box {
          key = "propertyTextWidth";
          edit_width = 30;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 1; }

      : text {
        key = "exportDataNumMsg";
        label = "ѡ������������";
      } 
      : spacer { height = 1; }
      : text {
        key = "exportBtnMsg";
        label = "�޸�����״̬��";
      } 
      : spacer { height = 4; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "ѡȡ"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnAllSelect"; 
          label = "ȫѡ"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnExportData"; 
          label = "�޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; }  
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}