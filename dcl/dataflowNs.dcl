importNsEquipTableBox : dialog {
  label = "天正设计流数据一体化暖通V0.3———导入设备一览表"; 
  key = "importNsEquipTable";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 80;
    : column {
      : popup_list { 
        label = "设备表生成的方向";
        edit_width = 50;
        key = "sortedType"; 
        list = "";
        value = "";
      }
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnModify"; 
        label = "选择设备表插入点"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

// 2021-07-08
SetNsRoomSystemBox : dialog {
  label = "天正设计流数据一体化工艺V0.3———划分房间系统"; 
  key = "SetNsRoomSystem";
  : boxed_radio_column {
    width = 50;
    : row { 
      : edit_box {
        label = "填写系统编号：";
        edit_width = 15;
        key = "roomSysNum";
        value = "";
        alignment = centered; 
      }
      : spacer { height = 1; }
      : button { 
        key = "btnExtractSysNum"; 
        label = "提取系统编号及颜色"; 
        is_default = "true"; 
      } 
    }
    : spacer { height = 1; }
    : row { 
      : text {
        key = "sysColorMsg";
        label = "系统颜色：";
      } 
      : image {
        key = "sysColor";
        height = 1.0;
        width = 1.0;
        // color = 3;
      }
      : spacer { height = 2; }
      : button { 
        key = "btnSelectColor"; 
        label = "设置系统颜色"; 
        is_default = "true"; 
      } 
    }
    : spacer { width = 1; } 
    : text {
      key = "selectNumMsg";
      label = "选择的数据数量：";
    } 
    : spacer { height = 4; }
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "选取"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}