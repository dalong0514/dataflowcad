;冯大龙编于 2020-2021 年
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoKS ()
  (alert "仪表设计流最新版本号 V0.1，更新时间：2021-04-05\n数据流内网地址：192.168.1.38")(princ)
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
(defun GetKSInstallMaterialDictList (/ resultList) 
    (foreach item (GetKSInstallMaterialData) 
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
