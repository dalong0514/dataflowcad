dataflow :dialog {
  label = "工艺专业导出数据的文件名";
  :edit_box {
    label = "拟输出的文件名（无需扩展名），输出文件自动存放在 CAD 文件同一个文件夹内";
    mnemonic = "N";
    key = "filename";
    alignment = centered;
    edit_limit = 50;
    edit_width = 50;
    value = "";
  }
  :button {
    key = "accept";
    label = "导出数据";
    is_default = true;
    fixed_width = true;
    alignment = centered;
  }
  cancel_button;
}

filterAndNumberBox : dialog {
  label = "设计流数据一体化———批量编号"; 
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
          key = "filterPropertyName"; 
          edit_width = 40;
          list = "管道\n集中仪表\n就地仪表\nSIS仪表\n反应釜\n输送泵\n储罐\n换热器\n离心机\n真空泵\n自定义设备";
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
          label = "选择要排序的块数据"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "匹配图纸中的全部数据"; 
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
        key = "resultMsg";
        label = "修改状态：";
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

filterAndModifyPipePropertyBox : dialog {
  label = "设计流数据一体化V1.0———批量修改管道数据"; 
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
          value = "";
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
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "匹配到的管道数量：";
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
          label = "选择管道"; 
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
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

filterAndModifyInstrumentPropertyBox : dialog {
  label = "设计流数据一体化V1.0———批量修改仪表数据"; 
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
          list = "仪表功能代号\n仪表位号\n工作介质\n工作温度\n工作压力\n仪表类型\n相态\n所在位置材质\n控制点名称\n所在管道或设备\n最小值\n最大值\n正常值\n流程图号\n所在位置尺寸\n备注\n安装方向";
          value = "";
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
          label = "选择仪表"; 
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
          list = "仪表功能代号\n仪表位号\n工作介质\n工作温度\n工作压力\n仪表类型\n相态\n所在位置材质\n控制点名称\n所在管道或设备\n最小值\n最大值\n正常值\n流程图号\n所在位置尺寸\n备注\n安装方向";
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
          list = "仪表功能代号\n仪表位号\n工作介质\n工作温度\n工作压力\n仪表类型\n相态\n所在位置材质\n控制点名称\n所在管道或设备\n最小值\n最大值\n正常值\n流程图号\n所在位置尺寸\n备注\n安装方向";
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

filterAndModifyPEquipmentPropertyBox : dialog {
  label = "设计流数据一体化V1.0———批量修改设备数据"; 
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
          value = "";
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
      }
      : spacer { height = 1; } 
      : text {
        key = "msg";
        label = "匹配到的管道数量：";
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
          label = "选择管道"; 
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
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
          list = "管道编号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n流程图号\n保温材料";
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

exportBlockPropertyDataBox : dialog {
  label = "设计流数据一体化V1.0———导出数据"; 
  key = "exportBlockPropertyData";
  : row {
    : boxed_radio_column {
      label = "数据类型";
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