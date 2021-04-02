updateKsInstallMaterialBox : dialog {
  label = "天正设计流数据一体化仪表V0.1———更新仪表安装材料数据"; 
  key = "updateKsKsInstallMaterial";
  : boxed_radio_column {
    key = "updateMethond";
    width = 80;
    : column {
      : popup_list { 
        label = "仪表文字类型";
        edit_width = 50;
        key = "textType"; 
        list = "";
        value = "";
      }
      : spacer { height = 2; } 
      : text {
        key = "updateBtnMsg";
        label = "更新数据状态：";
      } 
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnModify"; 
        label = "更新数据"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}