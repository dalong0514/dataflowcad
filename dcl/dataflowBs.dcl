// 2021-05-13
UpdateBsGCTBySelectBox : dialog {
  label = "�������������һ�廯����V0.1�����������豸����ͼ����"; 
  key = "UpdateBsGCTBySelect";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 120;
    : text {
      key = "equipTagListMsg";
      label = "��ѡ����豸λ�ţ�";
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