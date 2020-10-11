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

modifyInstrumentProperty : dialog {
  label = "批量修改仪表块内的属性"; 
  key = "dlg_layer";
  : boxed_radio_column {
    : popup_list { 
      // Drop-down list 
      key = "property_name"; 
      label = "选择要修改的属性";
      list = "流程图号\n仪表所在管道或设备\n工作介质\n工作温度\n工作压力\n备注\n相态\n仪表功能代号\n仪表位号\n控制点名称\n仪表类型\n所在位置材质\n所在位置尺寸\n最小值\n正常值\n最大值\n仪表安装方向";
      value = "";
    }
    : spacer { height = 3; } 
    :edit_box {
      edit_width = 80;
      label = "修改后的属性值";
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
        label = "选择要修改的块"; 
        is_default = "true"; 
      } 
      : spacer { width = 3; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

modifyPipeProperty : dialog {
  label = "批量修改管道块内的属性"; 
  key = "dlg_layer";
  : boxed_radio_column {
    : popup_list { 
      // Drop-down list 
      key = "property_name"; 
      label = "选择要修改的属性";
      list = "管道编号\n流程图号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n保温材料";
      value = "";
    }
    : spacer { height = 3; } 
    :edit_box {
      edit_width = 80;
      label = "修改后的属性值";
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
        label = "选择要修改的块"; 
        is_default = "true"; 
      } 
      : spacer { width = 3; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

filterAndModifyPipeProperty : dialog {
  label = "筛选匹配特定的管道并修改块内的属性"; 
  key = "filter_modify_property";
  : row {
    : boxed_radio_column {
      label = "匹配管道";
      key = "filterBox";
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
        edit_width = 80;
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 1; } 
      : list_box { 
        label = "匹配到的结果";
        key = "matchedResultList"; 
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
      label = "修改管道的属性值";
      key = "modifyBox";
      : popup_list { 
        label = "选择要修改的属性";
        key = "propertyNname"; 
        list = "管道编号\n流程图号\n工作介质\n工作温度\n工作压力\n相态\n管道起点\n管道终点\n保温材料";
        value = "";
      }
      : spacer { height = 1; } 
      : edit_box {
        label = "要替换的属性值片段，默认全替换";
        key = "replacedValue";
        edit_width = 80;
        mnemonic = "N";
        value = "";
      }
      : spacer { height = 3; } 
      : edit_box {
        label = "替换的新值";
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
          label = "批量修改"; 
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