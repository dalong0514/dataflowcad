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

filterAndModifyPipeProperty : dialog {
  label = "ɸѡƥ���ض��Ĺܵ����޸Ŀ�������"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "ƥ��ܵ�";
      key = "filterBox";
      width = 60;
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
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 20;
        label = "ƥ�䵽�Ľ��";
        key = "matchedResult"; 
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
      label = "ԭʼ����";
      key = "showOriginDataBox";
      width = 60;
      : popup_list { 
        label = "ѡ��Ҫ�޸ĵ�����";
        key = "propertyName"; 
        list = "�ܵ����\n����ͼ��\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n���²���";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "�����޸����ݻ��Զ����";
        key = "modifyDataType"; 
        list = "�޸�����\n�Զ����";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 25;
        key = "originData"; 
        list = "";
        value = "";
      }
      : spacer { height = 6; } 
      : button { 
        key = "btnShowOriginData"; 
        label = "��ʾԭʼ����"; 
        is_default = "true"; 
        fixed_width = true; 
        alignment = centered; 
      } 
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "�޸ĺ������";
      key = "modifyBox";
      width = 60;
      : list_box { 
        height = 20;
        key = "modifiedData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "resultMsg";
        label = "�޸�״̬��";
      }
      : spacer { height = 2; }
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "�ֲ��ַ���Ĭ�������滻";
        }
        : edit_box {
          key = "replacedSubstring";
          width = 15;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 3; } 
      : row {
        : text {
          key = "propertyValueMsg";
          label = "�滻�����ַ�";
        }
        : edit_box {
          key = "propertyValue";
          width = 15;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnPreviewModify"; 
          label = "Ԥ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnModify"; 
          label = "ȷ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}

filterAndModifyInstrumentProperty : dialog {
  label = "ɸѡƥ���ض����Ǳ��޸Ŀ�������"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "ƥ���Ǳ�";
      key = "filterBox";
      width = 60;
      : popup_list { 
        label = "ѡ�����ĸ�����ֵƥ��";
        key = "filterPropertyName"; 
        list = "�Ǳ�λ��\n�Ǳ��ܴ���\n���Ƶ�����\n����ͼ��\n�Ǳ����ڹܵ����豸\n��������\n�����¶�\n����ѹ��\n��ע\n��̬\n�Ǳ�����\n����λ�ò���\n����λ�óߴ�\n��Сֵ\n����ֵ\n���ֵ\n�Ǳ�װ����";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "ͨ���ƥ��ģʽ";
        key = "patternValue";
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 20;
        label = "ƥ�䵽�Ľ��";
        key = "matchedResult"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "ƥ�䵽���Ǳ�������";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "ѡ��Ҫƥ����Ǳ�"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "ƥ��ͼֽ�е�ȫ���Ǳ�"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "ԭʼ����";
      key = "showOriginDataBox";
      width = 60;
      : popup_list { 
        label = "ѡ��Ҫ�޸ĵ�����";
        key = "propertyName"; 
        list = "�Ǳ�λ��\n�Ǳ��ܴ���\n���Ƶ�����\n����ͼ��\n�Ǳ����ڹܵ����豸\n��������\n�����¶�\n����ѹ��\n��ע\n��̬\n�Ǳ�����\n����λ�ò���\n����λ�óߴ�\n��Сֵ\n����ֵ\n���ֵ\n�Ǳ�װ����";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "�����޸����ݻ��Զ����";
        key = "modifyDataType"; 
        list = "�޸�����\n�Զ����";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 25;
        key = "originData"; 
        list = "";
        value = "";
      }
      : spacer { height = 6; } 
      : button { 
        key = "btnShowOriginData"; 
        label = "��ʾԭʼ����"; 
        is_default = "true"; 
        fixed_width = true; 
        alignment = centered; 
      } 
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "�޸ĺ������";
      key = "modifyBox";
      width = 60;
      : list_box { 
        height = 20;
        key = "modifiedData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "resultMsg";
        label = "�޸�״̬��";
      }
      : spacer { height = 2; }
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "�ֲ��ַ���Ĭ�������滻";
        }
        : edit_box {
          key = "replacedSubstring";
          width = 15;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 3; } 
      : row {
        : text {
          key = "propertyValueMsg";
          label = "�滻�����ַ�";
        }
        : edit_box {
          key = "propertyValue";
          width = 15;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnPreviewModify"; 
          label = "Ԥ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnModify"; 
          label = "ȷ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}