calculateVentingAreaBox : dialog {
  label = "�������������һ�廯����רҵV0.1������йѹ�������"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    key = "updateMethond";
    width = 100;
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
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioThreeMsg";
        alignment = centered; 
        label = "";
      } 
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "ʰȡйѹ����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnCalculate"; 
        label = "����ʵ��йѹ"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnInsert"; 
        label = "����йѹ��ͼ"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}