importNsEquipTableBox : dialog {
  label = "�������������һ�廯ůͨV0.1�����������豸һ����"; 
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
        label = "ѡ��λ�Ų����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}