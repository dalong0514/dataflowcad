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
  (mapcar '(lambda (x) 
             (cons (cons "position" (GetEntityPositionByEntityNameUtils (handent (cdr (assoc "entityhandle" x))))) 
               x
             )
           ) 
    (GetBlockAllPropertyDictListUtils (GetEntityNameListBySSUtils (GetAllKsInstallMaterialSSUtils)))
  )  
)

; 2021-03-22
(defun GetKSInstallMaterialDictList (/ materialPosition resultList) 
  (foreach item (GetKSInstallMaterialDrawPositionList) 
    (mapcar '(lambda (x) 
              (setq materialPosition (GetDottedPairValueUtils "position" x))
              (if (IsInKSInstallMaterialDrawRegion materialPosition item)
                (setq resultList (append resultList (list (list item x))))
              )
            ) 
      (GetKSInstallMaterialData)
    ) 
  ) 
  resultList
)

; 2021-03-22
(defun IsInKSInstallMaterialDrawRegion (materialPosition drawPosition /)
  (and 
    (< (car materialPosition) (car drawPosition)) 
    (> (car materialPosition) (- (car drawPosition) 180)) 
    (> (cadr materialPosition) (cadr drawPosition))
    (< (cadr materialPosition) (+ (cadr drawPosition) 297))
  )
)

(defun c:foo ()
  (GetKSInstallMaterialDictList)
)
