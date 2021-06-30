calculateVentingAreaBox : dialog {
  label = "天正设计流数据一体化建筑专业V0.1———泄压面积计算"; 
  key = "calculateVentingArea";
  : boxed_radio_column {
    width = 60;
    : column {
      : row {
        : popup_list { 
          label = "选取泄压比：";
          key = "ventingRatio"; 
          list = "";
          value = "";
        }
        : spacer { width = 10; } 
        : popup_list { 
          label = "分割方式：";
          key = "ventingSplitMethod"; 
          list = "";
          value = "";
        }
      }
      : spacer { height = 2; } 
      : row {
        : edit_box {
          label = "分区板底层高（单位m）：";
          edit_width = 20;
          key = "ventingHeight";
          value = "";
          alignment = centered; 
        }
        : spacer { width = 5; }  
        : edit_box {
          label = "分区梁底层高（单位m）：";
          edit_width = 20;
          key = "ventingUnderBeamHeight";
          value = "";
          alignment = centered; 
        }
      }
      : spacer { height = 2; } 
      : row {
        : popup_list { 
          label = "模式：";
          edit_width = 20;
          key = "ventingSplitMode"; 
          list = "";
          value = "";
        }
        : spacer { width = 5; } 
        : edit_box {
          label = "切割点（距离分区左上角水平距离，单位m）：";
          edit_width = 20;
          key = "ventingSplitPoint";
          value = "";
        }
      }
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioMsg";
        label = "初始长径比：";
      } 
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioOneMsg";
        label = "分区一长径比：";
      } 
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioTwoMsg";
        label = "分区二长径比：";
      } 
      : spacer { height = 2; } 
      : text {
        key = "aspectRatioThreeMsg";
        label = "";
      } 
      : spacer { height = 2; } 
      : text {
        key = "calculateVentingAreaMsg";
        alignment = centered; 
        label = "";
      } 
      : spacer { height = 2; } 
      : text {
        key = "actualVentingAreaMsg";
        alignment = centered; 
        label = "";
      } 
      : spacer { height = 2; } 
      : row {
        : text {
          key = "ventingDrawScaleMsg";
          label = "设置泄压简图缩小比例（小数）：";
        }
        : edit_box {
          key = "ventingDrawScale";
          edit_width = 41;
          mnemonic = "N";
          value = "";
        }
      }
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "拾取泄压分区"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnCalculate"; 
        label = "计算实际泄压"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnInsert"; 
        label = "生成泄压简图"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}