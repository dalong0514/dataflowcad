// DCL code
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

filterAndModifyPipeProperty : dialog {
  label = "筛选匹配特定的管道并修改块内数据"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "匹配管道";
      key = "filterBox";
      width = 60;
      : popup_list { 
        label = "选择用哪个属性值匹配";
        key = "filterPropertyName"; 
        list = "管道编号\n流程图号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n保温材料";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "通配符匹配模式";
        key = "patternValue";
        mnemonic = "N";
        value = "";
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
        label = "匹配到的管道数量：";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "选择要匹配的管道"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "匹配图纸中的全部管道"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "原始数据";
      key = "showOriginDataBox";
      width = 60;
      : popup_list { 
        label = "选择要修改的属性";
        key = "propertyName"; 
        list = "管道编号\n流程图号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n保温材料";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "批量修改数据或自动编号";
        key = "modifyDataType"; 
        list = "修改数据\n自动编号";
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
        label = "显示原始数据"; 
        is_default = "true"; 
        fixed_width = true; 
        alignment = centered; 
      } 
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "修改后的数据";
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
        label = "修改状态：";
      }
      : spacer { height = 2; }
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "局部字符，默认整体替换";
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
          label = "替换的新字符";
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

filterAndModifyInstrumentProperty : dialog {
  label = "筛选匹配特定的仪表并修改块内数据"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "匹配仪表";
      key = "filterBox";
      width = 60;
      : popup_list { 
        label = "选择用哪个属性值匹配";
        key = "filterPropertyName"; 
        list = "仪表位号\n仪表功能代号\n控制点名称\n流程图号\n仪表所在管道或设备\n工作介质\n工作温度\n工作压力\n备注\n相态\n仪表类型\n所在位置材质\n所在位置尺寸\n最小值\n正常值\n最大值\n仪表安装方向";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "通配符匹配模式";
        key = "patternValue";
        mnemonic = "N";
        value = "";
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
        label = "匹配到的仪表数量：";
      }
      : spacer { height = 3; } 
      : row { 
        fixed_width = true; 
        alignment = centered; 
        : button { 
          key = "btnSelect"; 
          label = "选择要匹配的仪表"; 
          is_default = "true"; 
        } 
        : spacer { width = 3; } 
        : button { 
          key = "btnAll"; 
          label = "匹配图纸中的全部仪表"; 
          is_default = "true"; 
        }
      }
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "原始数据";
      key = "showOriginDataBox";
      width = 60;
      : popup_list { 
        label = "选择要修改的属性";
        key = "propertyName"; 
        list = "仪表位号\n仪表功能代号\n控制点名称\n流程图号\n仪表所在管道或设备\n工作介质\n工作温度\n工作压力\n备注\n相态\n仪表类型\n所在位置材质\n所在位置尺寸\n最小值\n正常值\n最大值\n仪表安装方向";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "批量修改数据或自动编号";
        key = "modifyDataType"; 
        list = "修改数据\n自动编号";
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
        label = "显示原始数据"; 
        is_default = "true"; 
        fixed_width = true; 
        alignment = centered; 
      } 
      : spacer { height = 3; } 
    }

    : boxed_radio_column {
      label = "修改后的数据";
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
        label = "修改状态：";
      }
      : spacer { height = 2; }
      : row {
        : text {
          key = "replacedSubstringMsg";
          label = "局部字符，默认整体替换";
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
          label = "替换的新字符";
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