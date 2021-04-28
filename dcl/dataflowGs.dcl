importGsEquipDataBox : dialog {
  label = "天正设计流数据一体化工艺V2.0———导入设备位号及设备图形"; 
  key = "importGsEquipData";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : text {
      key = "importDataTypeMsg";
      label = "";
      alignment = centered; 
    } 
    : spacer { height = 2; } 
    : column {
      : popup_list { 
        label = "导入的设备类型";
        edit_width = 80;
        key = "exportDataType"; 
        list = "";
        value = "";
      }
      : spacer { height = 1; } 
      : popup_list { 
        label = "设备位号排序顺序";
        edit_width = 80;
        key = "sortedType"; 
        list = "";
        value = "";
      } 
    }
    : spacer { height = 1; } 
    : text {
      key = "importBtnMsg";
      label = "导入设备数据状态：";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnImportData"; 
        label = "导入数据"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "选择位号插入点"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

updateGsBzEquipGraphBox : dialog {
  label = "天正设计流数据一体化工艺V2.0———更新布置图设备图形"; 
  key = "updateGsBzEquipGraph";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : spacer { height = 1; } 
    : text {
      key = "exportBtnMsg";
      label = "导出临时文件状态：";
    }
    : spacer { height = 1; } 
    : text {
      key = "importBtnMsg";
      label = "导入临时文件状态：";
    }
    : spacer { height = 1; } 
    : text {
      key = "modifyBtnMsg";
      label = "设备图形更新状态：";
    }
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnExportData"; 
        label = "导出数据"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; }  
      : button { 
        key = "btnImportData"; 
        label = "导入数据"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      : button { 
        key = "btnModify"; 
        label = "确认更新"; 
        is_default = "true"; 
      } 
      : spacer { width = 2; } 
      cancel_button; 
    }
    : spacer { height = 3; } 
  }
}

UpdateAllPublicPipeFromToDataBox : dialog {
  label = "天正设计流数据一体化工艺V2.0———一键获取公共工程管道来去向数据"; 
  key = "UpdateAllPublicPipeFromToData";
  : boxed_radio_column {
    key = "showOriginDataBox";
    width = 100;
    : text {
      key = "exportDataNumMsg";
      label = "选择数据的数量：";
    } 
    : spacer { height = 3; } 
    : row { 
      fixed_width = true; 
      alignment = centered; 
      : button { 
        key = "btnSelect"; 
        label = "选取"; 
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