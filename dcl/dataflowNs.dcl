importNsEquipTableBox : dialog {
  label = "�������������һ�廯ůͨV0.3�����������豸һ����"; 
  key = "importNsEquipTable";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 80;
    : column {
      : popup_list { 
        label = "�豸�����ɵķ���";
        edit_width = 50;
        key = "sortedType"; 
        list = "";
        value = "";
      }
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnModify"; 
        label = "ѡ���豸������"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

// 2021-07-08
SetNsRoomSystemBox : dialog {
  label = "�������������һ�廯����V0.3���������ַ���ϵͳ"; 
  key = "SetNsRoomSystem";
  : boxed_radio_column {
    width = 50;
    : edit_box {
      label = "��дϵͳ��ţ�";
      edit_width = 20;
      key = "roomSysNum";
      value = "";
      alignment = centered; 
    }
    : spacer { height = 1; }
    : row { 
      : text {
        key = "sysColorMsg";
        label = "ϵͳ��ɫ��";
      } 
      : image {
        key = "sysColor";
        height = 1.0;
        width = 1.0;
        // color = 3;
      }
      : button { 
        key = "btnSelectColor"; 
        label = "ѡ����ɫ"; 
        is_default = "true"; 
      } 
    }
    : spacer { width = 1; } 
    : text {
      key = "selectNumMsg";
      label = "ѡ�������������";
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
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}