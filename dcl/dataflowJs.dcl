calculateVentingAreaBox : dialog {
  label = "�������������һ�廯����רҵV0.1������йѹ�������"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    width = 60;
    : column {
      : row {
        : popup_list { 
          label = "ѡȡйѹ�ȣ�";
          key = "ventingRatio"; 
          list = "";
          value = "";
        }
        : spacer { width = 10; } 
        : popup_list { 
          label = "�ָʽ��";
          key = "ventingSplitMethod"; 
          list = "";
          value = "";
        }
      }
      : spacer { height = 2; } 
      : row {
        : edit_box {
          label = "������ײ�ߣ���λm����";
          edit_width = 20;
          key = "ventingHeight";
          value = "";
          alignment = centered; 
        }
        : spacer { width = 5; }  
        : edit_box {
          label = "�������ײ�ߣ���λm����";
          edit_width = 20;
          key = "ventingUnderBeamHeight";
          value = "";
          alignment = centered; 
        }
      }
      : spacer { height = 2; } 
      : row {
        : popup_list { 
          label = "ģʽ��";
          edit_width = 20;
          key = "ventingSplitMode"; 
          list = "";
          value = "";
        }
        : spacer { width = 5; } 
        : edit_box {
          label = "�и�㣨����������Ͻ�ˮƽ���룬��λm����";
          edit_width = 20;
          key = "ventingSplitPoint";
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
        label = "";
      } 
      : spacer { height = 2; } 
      : text {
        key = "calculateVentingAreaMsg";
        alignment = centered; 
        label = "";
      } 
      : spacer { height = 2; } 
      : text {
        key = "actualVentingAreaMsg";
        alignment = centered; 
        label = "";
      } 
      : spacer { height = 2; } 
      : row {
        : text {
          key = "ventingDrawScaleMsg";
          label = "����йѹ��ͼ��С������С������";
        }
        : edit_box {
          key = "ventingDrawScale";
          edit_width = 41;
          mnemonic = "N";
          value = "";
        }
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