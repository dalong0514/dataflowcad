      (progn 
        (setq selectedName (nth (atoi propertyName) propertyNameList))
        (if (/= propertyValue "") 
          (progn 
            (if (= replacedSubstring "") 
              (if (/= importedDataList nil) 
                (progn 
                  ; update importedDataList
                  (setq importedDataList (ReplaceAllStrDataListByPropertyName importedDataList selectedName propertyValue))
                  (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName))
                )
                (progn 
                  ; update previewDataList
                  (setq previewDataList (ReplaceAllStrDataListByPropertyName previewDataList selectedName propertyValue))
                  (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName))
                )
              )
              (if (/= importedDataList nil) 
                (progn 
                  ; update importedDataList
                  (setq importedDataList (ReplaceSubStrDataListByPropertyName importedDataList selectedName propertyValue replacedSubstring))
                  (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName))
                )
                (progn 
                  ; update previewDataList
                  (setq previewDataList (ReplaceSubStrDataListByPropertyName previewDataList selectedName propertyValue replacedSubstring))
                  (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName))
                )
              )
            )
          )
          (if (/= importedDataList nil) 
            (setq confirmList (GetImportedPropertyValueByPropertyName importedDataList selectedName))
            (setq confirmList (GetImportedPropertyValueByPropertyName previewDataList selectedName))
          )
        )
      )