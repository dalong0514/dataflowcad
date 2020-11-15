exportBlockPropertyDataBox : dialog {
  label = "设计流数据一体化V1.1———导出数据"; 
  key = "exportBlockPropertyData";
  : row {
    : boxed_radio_column {
      key = "exportDataTypeBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "选择要导出的数据类型";
          edit_width = 29;
          key = "exportDataType"; 
          list = "管道数据\n设备数据\n仪表数据\n电气数据\n外管数据";
          value = "";
        }
        : spacer { height = 0.5; } 
        : row {
          : text {
            key = "fileNameMsg";
            label = "文件名（无需扩展名）";
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
        label = "输出文件自动存放在 CAD 文件同一个文件夹内";
      }
      : spacer { height = 1; }
      : text {
        key = "exportBtnMsg";
        label = "导出数据状态：";
      }
      : spacer { height = 6; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnExportData"; 
          label = "导出"; 
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
  label = "设计流数据一体化V1.1———批量编号"; 
  key = "filterAndNumber";
  : row {
    : boxed_radio_column {
      label = "匹配数据";
      key = "filterBox";
      width = 60;
      : column {
        height = 10;
        : popup_list { 
          label = "数据大类";
          key = "dataType"; 
          edit_width = 40;
          list = "";
          value = "";
        }
        : spacer { height = 1; } 
        : popup_list { 
          label = "仪表子类型";
          key = "dataChildrenType"; 
          edit_width = 40;
          list = "温度\n压力\n液位\n流量\n称重\n检测\n开关阀\n温度调节阀\n压力调节阀\n液位调节阀\n流量调节阀";
          value = "";
        }
        : spacer { height = 1; } 
        : edit_box {
          label = "管道的通配符匹配";
          key = "patternValue";
          edit_width = 41;
          mnemonic = "N";
          value = "";
        }
      }
      : spacer { height = 1; } 
      : list_box { 
        height = 20;
        label = "匹配到的结果";
        key = "matchedResult"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "匹配到的数量：";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "批量选择"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnClickSelect"; 
          label = "点选数据"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnAll"; 
          label = "匹配全部"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "自动编号";
      key = "modifyBox";
      width = 60;
      : column {
        height = 10;
        : row {
          : text {
            key = "replacedSubstringMsg";
            label = "物料代号";
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
            label = "编号起点";
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
        label = "编号后的数据";
        key = "modifiedData"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : text {
        key = "modifyBtnMsg";
        label = "编号状态：";
      }
      : spacer { height = 2; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnPreviewModify"; 
          label = "预览修改"; 
          is_default = "true"; 
        } 
        : spacer { width = 2; } 
        : button { 
          key = "btnModify"; 
          label = "确认修改"; 
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
  label = "设计流数据一体化V1.1———批量修改数据"; 
  key = "filterModifyProperty";
  : row {
    : boxed_radio_column {
      label = "匹配数据";
      key = "filterBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "选择要筛选的属性";
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
          label = "通配符匹配模式";
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
        label = "匹配到的数量：";
      }
      : spacer { height = 1; } 
      : text {
        key = "exportBtnMsg";
        label = "导出数据状态：";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "选择数据"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnAll"; 
          label = "匹配全部"; 
          is_default = "true"; 
        }
        : spacer { width = 1; } 
        : button { 
          key = "btnExportData"; 
          label = "导出数据"; 
          is_default = "true"; 
        } 
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "原始数据";
      key = "showOriginDataBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "选择要查看的属性";
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
          label = "导入数据状态：";
        }
      : spacer { height = 6; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnImportData"; 
          label = "导入数据"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnShowOriginData"; 
          label = "显示数据"; 
          is_default = "true"; 
          fixed_width = true; 
        } 
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "修改后的数据";
      key = "modifyBox";
      width = 50;
      : column {
        height = 10;
        : popup_list { 
          label = "选择要修改的属性";
          edit_width = 29;
          key = "propertyName"; 
          list = "";
          value = "";
        }
        : spacer { height = 0.5; } 
        : row {
          : text {
            key = "replacedSubstringMsg";
            label = "局部字符（默认整体替换）";
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
            label = "替换的新字符：";
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
        label = "修改CAD数据状态：";
      }
      : spacer { height = 6; }
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnPreviewModify"; 
          label = "预览修改"; 
          is_default = "true"; 
        } 
        : spacer { width = 1; } 
        : button { 
          key = "btnModify"; 
          label = "确认修改"; 
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
  label = "设计流数据一体化V1.1———自动生成单回路辅助流程组件"; 
  key = "generatePublicProcessElement";
  : boxed_radio_column {
    key = "filterBox";
    width = 80;
    : column {
      height = 10;
      : popup_list { 
        label = "来自总管还是去总管";
        edit_width = 30;
        key = "pipeSourceDirection"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "管道号通配符匹配";
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
      label = "匹配到的数量：";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "选择数据"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAll"; 
        label = "匹配全部"; 
        is_default = "true"; 
      }
      : spacer { width = 1; } 
      : button { 
        key = "btnShowOriginData"; 
        label = "选择插入点"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

brushBlockPropertyValueBox : dialog {
  label = "设计流数据一体化V1.1———刷块属性数据"; 
  key = "brushBlockPropertyValue";
  : boxed_radio_column {
    key = "filterBox";
    width = 80;
    : column {
      height = 10;
      : popup_list { 
        label = "要刷的数据大类";
        key = "modifiedDataType"; 
        edit_width = 40;
        list = "";
        value = "";
      }
      : spacer { height = 1; }
      : list_box { 
        label = "选择要提取的属性（可多选）";
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
      label = "提取出的数据";
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
        label = "选择提取的块"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAll"; 
        label = "选择要刷的块"; 
        is_default = "true"; 
      }
      : spacer { width = 1; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

numberDrawNumBox : dialog {
  label = "设计流数据一体化V1.1———批量编图签流程图号"; 
  key = "numberDrawNum";
  : boxed_radio_column {
    key = "modifyBox";
    width = 80;
    : column {
      height = 10;
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "图号前面部分（比如 S20C14-23-04-）";
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
          label = "编号起点（比如 01）";
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
      label = "编号后的数据";
      key = "modifiedData"; 
      list = "";
      value = "";
    }
    : spacer { height = 1; } 
    : text {
      key = "msg";
      label = "图签数量：";
    }
    : spacer { height = 1; } 
    : text {
      key = "modifyBtnMsg";
      label = "编号状态：";
    }
    : spacer { height = 2; }
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "选择图签"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnPreviewModify"; 
        label = "预览编号"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "确认编号"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnBrushDrawNum"; 
        label = "刷数据所在图号"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}