// DCL code
dataflow :dialog {
  label = "����רҵ�������ݵ��ļ���";
  :edit_box {
    label = "��������ļ�����������չ����������ļ��Զ������ CAD �ļ�ͬһ���ļ�����";
    mnemonic = "N";
    key = "filename";
    alignment = centered;
    edit_limit = 50;
    edit_width = 50;
    value = "";
  }
  :button {
    key = "accept";
    label = "��������";
    is_default = true;
    fixed_width = true;
    alignment = centered;
  }
  cancel_button;
}

modifyInstrumentProperty : dialog {
  label = "�����޸��Ǳ���ڵ�����"; 
  key = "dlg_layer";
  : boxed_radio_column {
    : popup_list { 
      // Drop-down list 
      key = "property_name"; 
      label = "ѡ��Ҫ�޸ĵ�����";
      list = "����ͼ��\n�Ǳ����ڹܵ����豸\n��������\n�����¶�\n����ѹ��\n��ע\n��̬\n�Ǳ��ܴ���\n�Ǳ�λ��\n���Ƶ�����\n�Ǳ�����\n����λ�ò���\n����λ�óߴ�\n��Сֵ\n����ֵ\n���ֵ\n�Ǳ�װ����";
      value = "";
    }
    : spacer { height = 3; } 
    :edit_box {
      edit_width = 80;
      label = "�޸ĺ������ֵ";
      mnemonic = "N";
      key = "property_value";
      value = "";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        // Create object button 
        key = "btn_select"; 
        // action = "(testfunc)"; 
        label = "ѡ��Ҫ�޸ĵĿ�"; 
        is_default = "true"; 
      } 
      : spacer { width = 3; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

modifyPipeProperty : dialog {
  label = "�����޸Ĺܵ����ڵ�����"; 
  key = "dlg_layer";
  : boxed_radio_column {
    : popup_list { 
      // Drop-down list 
      key = "property_name"; 
      label = "ѡ��Ҫ�޸ĵ�����";
      list = "����ͼ��\n�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n���²���";
      value = "";
    }
    : spacer { height = 3; } 
    :edit_box {
      edit_width = 80;
      label = "�޸ĺ������ֵ";
      mnemonic = "N";
      key = "property_value";
      value = "";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        // Create object button 
        key = "btn_select"; 
        // action = "(testfunc)"; 
        label = "ѡ��Ҫ�޸ĵĿ�"; 
        is_default = "true"; 
      } 
      : spacer { width = 3; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}