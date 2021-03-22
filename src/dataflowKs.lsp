;��������� 2020-2021 ��
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoKS ()
  (alert "�Ǳ���������°汾�� V0.1������ʱ�䣺2021-04-05\n������������ַ��192.168.1.38")(princ)
)

; 2021-03-22
(defun GetKSInstallMaterialDrawPositionList () 
  (GetAllDrawLabelPositionListUtils)
)

; 2021-03-22
(defun GetKSInstallMaterialData () 
  (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllKsInstallMaterialSSUtils)))
)

; 2021-03-22
(defun GetKSInstallMaterialDictList (/ resultList) 
  ; set a temp variable first, ss in the foreach
    (foreach item (FilterJSDrawLabelData) 
    (mapcar '(lambda (x) 
              (if (and 
                    (> (car x) (car (cadr item))) 
                    (< (car x) (+ (car (cadr item)) 126150)) 
                    (< (cadr x) (cadr (cadr item)))
                    (> (cadr x) (- (cadr (cadr item)) 89100))
                  )
                (setq resultList (append resultList (list (list (car item) x))))
              )
            ) 
      (GetKSInstallMaterialDrawPositionList)
    ) 
  ) 
  resultList
)




(defun c:foo ()
  (GetKSInstallMaterialData)
)
