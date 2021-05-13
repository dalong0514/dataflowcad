// 2021-05-13
UpdateBsGCTBySelectBox : dialog {
  label = "天正设计流数据一体化工艺V0.1———更新设备工程图数据"; 
  key = "UpdateBsGCTBySelect";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 120;
    : text {
      key = "equipTagListMsg";
      label = "已选择的设备位号：";
    }
    : spacer { height = 1; }  
    : text {
      key = "exportDataNumMsg";
      label = "选择数据的数量：";
    } 
    : spacer { height = 2; }  
    : text {
      key = "modifyStatusMsg";
      label = "修改状态：";
    } 
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "框选"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; } 
      : button { 
        key = "btnAllSelect"; 
        label = "全选"; 
        is_default = "true"; 
      } 
      : spacer { width = 1; }  
      : button { 
        key = "btnModify"; 
        label = "更新"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}