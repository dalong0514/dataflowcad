updateKsInstallMaterialBox : dialog {
  label = "�������������һ�廯�Ǳ�V0.1�����������Ǳ�װ��������"; 
  key = "updateKsKsInstallMaterial";
  : boxed_radio_column {
    key = "updateMethond";
    width = 80;
    : column {
      : popup_list { 
        label = "�Ǳ���������";
        edit_width = 50;
        key = "textType"; 
        list = "";
        value = "";
      }
      : spacer { height = 2; } 
      : text {
        key = "updateBtnMsg";
        label = "��������״̬��";
      } 
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnModify"; 
        label = "��������"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}