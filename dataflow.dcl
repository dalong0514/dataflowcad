exportBlockPropertyDataBox : dialog {
  label = "���������һ�廯V1.1��������������"; 
  key = "exportBlockPropertyData";
  : row {
    : boxed_radio_column {
      key = "exportDataTypeBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "ѡ��Ҫ��������������";
          edit_width = 29;
          key = "exportDataType"; 
          list = "�ܵ�����\n�豸����\n�Ǳ�����\n��������\n�������";
          value = "";
        }
        : spacer { height = 0.5; } 
        : row {
          : text {
            key = "fileNameMsg";
            label = "�ļ�����������չ����";
          }
          : edit_box {
            key = "fileName";
            edit_width = 30;
            mnemonic = "N";
            value = "";
          }
        }
        : spacer { height = 1; }
      }
      : text {
        key = "fileDirMsg";
        label = "����ļ��Զ������ CAD �ļ�ͬһ���ļ�����";
      }
      : spacer { height = 1; }
      : text {
        key = "exportBtnMsg";
        label = "��������״̬��";
      }
      : spacer { height = 6; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnExportData"; 
          label = "����"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}

filterAndNumberBox : dialog {
  label = "���������һ�廯V1.1�������������"; 
  key = "filterAndNumber";
  : row {
    : boxed_radio_column {
      label = "ƥ������";
      key = "filterBox";
      width = 60;
      : column {
        height = 10;
        : popup_list { 
          label = "���ݴ���";
          key = "dataType"; 
          edit_width = 40;
          list = "";
          value = "";
        }
        : spacer { height = 1; } 
        : popup_list { 
          label = "�Ǳ�������";
          key = "dataChildrenType"; 
          edit_width = 40;
          list = "�¶�\nѹ��\nҺλ\n����\n����\n���\n���ط�\n�¶ȵ��ڷ�\nѹ�����ڷ�\nҺλ���ڷ�\n�������ڷ�";
          value = "";
        }
        : spacer { height = 1; } 
        : edit_box {
          label = "�ܵ���ͨ���ƥ��";
          key = "patternValue";
          edit_width = 41;
          mnemonic = "N";
          value = "";
        }
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
        label = "ƥ�䵽��������";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "����ѡ��"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnClickSelect"; 
          label = "��ѡ����"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnAll"; 
          label = "ƥ��ȫ��"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "�Զ����";
      key = "modifyBox";
      width = 60;
      : column {
        height = 10;
        : row {
          : text {
            key = "replacedSubstringMsg";
            label = "���ϴ���";
          }
          : edit_box {
            key = "replacedSubstring";
            edit_width = 40;
            edit_width = 40;
            mnemonic = "N";
            value = "";
          }
        }
        : spacer { height = 3; } 
        : row {
          : text {
            key = "propertyValueMsg";
            label = "������";
          }
          : edit_box {
            key = "propertyValue";
            edit_width = 40;
            mnemonic = "N";
            value = "";
          }
        }
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 20;
        label = "��ź������";
        key = "modifiedData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "modifyBtnMsg";
        label = "���״̬��";
      }
      : spacer { height = 2; }
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

filterAndModifyEquipmentPropertyBox : dialog {
  label = "���������һ�廯V1.1�����������޸�����"; 
  key = "filterModifyProperty";
  : row {
    : boxed_radio_column {
      label = "ƥ������";
      key = "filterBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "ѡ��Ҫɸѡ������";
          edit_width = 30;
          key = "filterPropertyName"; 
          list = "";
          value = "";
        }
        : spacer { height = 1; } 
        : text {
          key = "dataTypeMsg";
        }
        : spacer { height = 1; } 
        : edit_box {
          label = "ͨ���ƥ��ģʽ";
          edit_width = 31;
          key = "patternValue";
          mnemonic = "N";
          value = "";
        }
        : spacer { height = 1; } 
      }
      : list_box { 
        height = 25;
        key = "matchedResult"; 
        list = "";
        value = "";
        // action = true;
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "ƥ�䵽��������";
      }
      : spacer { height = 1; } 
      : text {
        key = "exportBtnMsg";
        label = "��������״̬��";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "ѡ������"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnAll"; 
          label = "ƥ��ȫ��"; 
          is_default = "true"; 
        }
        : spacer { width = 1; } 
        : button { 
          key = "btnExportData"; 
          label = "��������"; 
          is_default = "true"; 
        } 
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "ԭʼ����";
      key = "showOriginDataBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "ѡ��Ҫ�鿴������";
          edit_width = 30;
          key = "viewPropertyName"; 
          list = "";
          value = "";
        }
      }
      : list_box { 
        height = 25;
        key = "originData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
        : text {
          key = "importBtnMsg";
          label = "��������״̬��";
        }
      : spacer { height = 6; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnImportData"; 
          label = "��������"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnShowOriginData"; 
          label = "��ʾ����"; 
          is_default = "true"; 
          fixed_width = true; 
        } 
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "�޸ĺ������";
      key = "modifyBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "ѡ��Ҫ�޸ĵ�����";
          edit_width = 29;
          key = "propertyName"; 
          list = "";
          value = "";
        }
        : spacer { height = 0.5; } 
        : row {
          : text {
            key = "replacedSubstringMsg";
            label = "�ֲ��ַ���Ĭ�������滻��";
          }
          : edit_box {
            key = "replacedSubstring";
            edit_width = 30;
            mnemonic = "N";
            value = "";
          }
        }
        : spacer { height = 0.5; }
        : row {
          : text {
            key = "propertyValueMsg";
            label = "�滻�����ַ���";
          }
          : edit_box {
            key = "propertyValue";
            edit_width = 30;
            mnemonic = "N";
            value = "";
          }
        }
        : spacer { height = 1; }
      }
      : list_box { 
        height = 25;
        key = "modifiedData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "modifyBtnMsg";
        label = "�޸�CAD����״̬��";
      }
      : spacer { height = 6; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnPreviewModify"; 
          label = "Ԥ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnModify"; 
          label = "ȷ���޸�"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        cancel_button; 
      }
      : spacer { height = 3; } 
    }
  }
}

generatePublicProcessElementBox : dialog {
  label = "���������һ�廯V1.1�������Զ����ɵ���·�����������"; 
  key = "generatePublicProcessElement";
  : boxed_radio_column {
    key = "filterBox";
    width = 80;
    : column {
      height = 10;
      : popup_list { 
        label = "�����ܹܻ���ȥ�ܹ�";
        edit_width = 30;
        key = "pipeSourceDirection"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "�ܵ���ͨ���ƥ��";
        edit_width = 31;
        key = "patternValue";
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 1; } 
    }
    : list_box { 
      height = 25;
      key = "matchedResult"; 
      list = "";
      value = "";
    }
    : spacer { height = 1; } 
    : text {
      key = "msg";
      label = "ƥ�䵽��������";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "ѡ������"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAll"; 
        label = "ƥ��ȫ��"; 
        is_default = "true"; 
      }
      : spacer { width = 1; } 
      : button { 
        key = "btnShowOriginData"; 
        label = "ѡ������"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

brushBlockPropertyValueBox : dialog {
  label = "���������һ�廯V1.1������ˢ����������"; 
  key = "brushBlockPropertyValue";
  : boxed_radio_column {
    key = "filterBox";
    width = 80;
    : column {
      height = 10;
      : popup_list { 
        label = "Ҫˢ�����ݴ���";
        key = "modifiedDataType"; 
        edit_width = 40;
        list = "";
        value = "";
      }
      : spacer { height = 1; }
      : list_box { 
        label = "ѡ��Ҫ��ȡ�����ԣ��ɶ�ѡ��";
        height = 15;
        edit_width = 30;
        key = "selectedProperty"; 
        multiple_select = true;
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
    } 
    : list_box { 
      label = "��ȡ��������";
      height = 15;
      key = "matchedResult"; 
      list = "";
      value = "";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "ѡ����ȡ�Ŀ�"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAll"; 
        label = "ѡ��Ҫˢ�Ŀ�"; 
        is_default = "true"; 
      }
      : spacer { width = 1; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

numberDrawNumBox : dialog {
  label = "���������һ�廯V1.1������������ͼǩ����ͼ��"; 
  key = "numberDrawNum";
  : boxed_radio_column {
    key = "modifyBox";
    width = 80;
    : column {
      height = 10;
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "ͼ��ǰ�沿�֣����� S20C14-23-04-��";
        }
        : edit_box {
          key = "replacedSubstring";
          edit_width = 40;
          edit_width = 40;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 3; } 
      : row {
        : text {
          key = "propertyValueMsg";
          label = "�����㣨���� 01��";
        }
        : edit_box {
          key = "propertyValue";
          edit_width = 40;
          mnemonic = "N";
          value = "";
        }
      }
    }
    : spacer { height = 1; } 
    : list_box { 
      height = 20;
      label = "��ź������";
      key = "modifiedData"; 
      list = "";
      value = "";
    }
    : spacer { height = 1; } 
    : text {
      key = "msg";
      label = "ͼǩ������";
    }
    : spacer { height = 1; } 
    : text {
      key = "modifyBtnMsg";
      label = "���״̬��";
    }
    : spacer { height = 2; }
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "ѡ��ͼǩ"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnPreviewModify"; 
        label = "Ԥ�����"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "ȷ�ϱ��"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnBrushDrawNum"; 
        label = "ˢ��������ͼ��"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}