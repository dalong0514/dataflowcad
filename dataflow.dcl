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

filterAndNumberBox : dialog {
  label = "���������һ�廯�������������"; 
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
          key = "filterPropertyName"; 
          edit_width = 40;
          list = "�ܵ�\n�����Ǳ�\n�͵��Ǳ�\nSIS�Ǳ�\n��Ӧ��\n���ͱ�\n����\n������\n���Ļ�\n��ձ�\n�Զ����豸";
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
          label = "ѡ��Ҫ����Ŀ�����"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "ƥ��ͼֽ�е�ȫ������"; 
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
        key = "resultMsg";
        label = "�޸�״̬��";
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

filterAndModifyPipePropertyBox : dialog {
  label = "���������һ�廯V1.0�����������޸Ĺܵ�����"; 
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
          value = "";
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
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "ƥ�䵽�Ĺܵ�������";
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
          label = "ѡ��ܵ�"; 
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
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

filterAndModifyInstrumentPropertyBox : dialog {
  label = "���������һ�廯V1.0�����������޸��Ǳ�����"; 
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
          list = "�Ǳ��ܴ���\n�Ǳ�λ��\n��������\n�����¶�\n����ѹ��\n�Ǳ�����\n��̬\n����λ�ò���\n���Ƶ�����\n���ڹܵ����豸\n��Сֵ\n���ֵ\n����ֵ\n����ͼ��\n����λ�óߴ�\n��ע\n��װ����";
          value = "";
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
          label = "ѡ���Ǳ�"; 
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
          list = "�Ǳ��ܴ���\n�Ǳ�λ��\n��������\n�����¶�\n����ѹ��\n�Ǳ�����\n��̬\n����λ�ò���\n���Ƶ�����\n���ڹܵ����豸\n��Сֵ\n���ֵ\n����ֵ\n����ͼ��\n����λ�óߴ�\n��ע\n��װ����";
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
          list = "�Ǳ��ܴ���\n�Ǳ�λ��\n��������\n�����¶�\n����ѹ��\n�Ǳ�����\n��̬\n����λ�ò���\n���Ƶ�����\n���ڹܵ����豸\n��Сֵ\n���ֵ\n����ֵ\n����ͼ��\n����λ�óߴ�\n��ע\n��װ����";
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

filterAndModifyPEquipmentPropertyBox : dialog {
  label = "���������һ�廯V1.0�����������޸��豸����"; 
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
          value = "";
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
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "ƥ�䵽�Ĺܵ�������";
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
          label = "ѡ��ܵ�"; 
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
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
          list = "�ܵ����\n��������\n�����¶�\n����ѹ��\n��̬\n�ܵ����\n�ܵ��յ�\n����ͼ��\n���²���";
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

exportBlockPropertyDataBox : dialog {
  label = "���������һ�廯V1.0��������������"; 
  key = "exportBlockPropertyData";
  : row {
    : boxed_radio_column {
      label = "��������";
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