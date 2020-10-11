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
      list = "�ܵ����\n����ͼ��\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n���²���";
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

filterAndModifyPipeProperty : dialog {
  label = "ɸѡƥ���ض��Ĺܵ����޸Ŀ��ڵ�����"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "ƥ��ܵ�";
      key = "filterBox";
      : popup_list { 
        label = "ѡ�����ĸ�����ֵƥ��";
        key = "filterPropertyName"; 
        list = "�ܵ����\n����ͼ��\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n���²���";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "ͨ���ƥ��ģʽ";
        key = "patternValue";
        edit_width = 80;
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        label = "ƥ�䵽�Ľ��";
        key = "matchedResultList"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "ƥ�䵽�Ĺܵ�������";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "ѡ��Ҫƥ��Ĺܵ�"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "ƥ��ͼֽ�е�ȫ���ܵ�"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "�޸Ĺܵ�������ֵ";
      key = "modifyBox";
      : popup_list { 
        label = "ѡ��Ҫ�޸ĵ�����";
        key = "propertyNname"; 
        list = "�ܵ����\n����ͼ��\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n���²���";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "Ҫ�滻������ֵƬ�Σ�Ĭ��ȫ�滻";
        key = "replacedValue";
        edit_width = 80;
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 3; } 
      : edit_box {
        label = "�滻����ֵ";
        key = "propertyValue";
        edit_width = 80;
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnModify"; 
          label = "�����޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}

ex_hidden : dialog
{
  label = "Hide/Show Example";
  key = "dlg_hide";
  : text {
      key = "msg";
      label = "Point: ";
  }
  : row {
    fixed_width = true;
    alignment = right;      
    : button {
        key = "btn_PickPoint";
        action = "pickPoint";
        label = "Pick Point";
        is_default = "true";
        width = 12;
    }
    : spacer { width = 1; }
    cancel_button;
  }
}