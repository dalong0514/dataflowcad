calculateVentingAreaBox : dialog {
  label = "�������������һ�廯����רҵV0.1������йѹ�������"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    key = "updateMethond";
    width = 80;
    : column {
      : popup_list { 
        label = "ѡȡйѹ�ȣ�";
        edit_width = 50;
        key = "ventingRatio"; 
        list = "";
        value = "";
      }
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioMsg";
        label = "�����ȣ�";
      } 
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "ʰȡ����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnCalculate"; 
        label = "йѹ����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}