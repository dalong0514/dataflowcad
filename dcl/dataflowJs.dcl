calculateVentingAreaBox : dialog {
  label = "天正设计流数据一体化建筑专业V0.1———泄压面积计算"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    key = "updateMethond";
    width = 80;
    : column {
      : popup_list { 
        label = "选取泄压比：";
        edit_width = 50;
        key = "ventingRatio"; 
        list = "";
        value = "";
      }
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioMsg";
        label = "长径比：";
      } 
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "拾取分区"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnCalculate"; 
        label = "泄压计算"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}