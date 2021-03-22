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

(defun GetKsInstallMaterialDrawBasePositionList ()
  ;(GetStrategyJSDrawColumnPositionData)
  (GetAllJSDrawLabelData)
)

; 2021-03-22
(defun GetKSInstallMaterialDrawPositionRangeUtils ()
  (mapcar '(lambda (x) 
             (list (+ (car x) -180) (+ (cadr x) 297))
           ) 
    (GetAllDrawLabelPositionListUtils)
  ) 
)


(defun c:foo ()
  (GetKSInstallMaterialDrawPositionRangeUtils)
)