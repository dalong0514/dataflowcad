calculateVentingAreaBox : dialog {
  label = "�������������һ�廯����רҵV0.1������йѹ�������"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    key = "updateMethond";
    width = 80;
    : column {
      : popup_list { 
        label = "ѡȡйѹ�ȣ�";
        edit_width = 40;
        key = "ventingRatio"; 
        list = "";
        value = "";
      }
      : spacer { height = 2; } 
      : row {
        : text {
          key = "ventingHeightMsg";
          label = "йѹ������ߣ���λm����";
        }
        : edit_box {
          key = "ventingHeight";
          edit_width = 41;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioMsg";
        label = "��ʼ�����ȣ�";
      } 
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioOneMsg";
        label = "����һ�����ȣ�";
      } 
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioTwoMsg";
        label = "�����������ȣ�";
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