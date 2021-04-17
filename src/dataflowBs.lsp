;��������� 2020-2021 ��
(if (= *comLibraryStatus* nil) 
  (progn 
    (vl-load-com)
    (setq *comLibraryStatus* T) 
  )
)

(defun c:printVersionInfoNS ()
  (alert "�豸��������°汾�� V0.1������ʱ�䣺2021-03-22\n������������ַ��192.168.1.38")(princ)
)

;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
; Generate BsGCT

; 2021-04-17
(defun VerifyBsBlockLayerText ()
  (VerifyBsTextStyleByName "DataFlow")
  (VerifyBsTextStyleByName "TitleText")
  (VerifyBsLayerByName "0DataFlow-BsText")
  (VerifyBsLayerByName "0DataFlow-BsGCT")
  (VerifyBsLayerByName "0DataFlow-BsFrame")
  (VerifyBsBlockByName "BsGCT*")
  (VerifyBsBlockByName "*\.2017")
)

; 2021-04-17
(defun InsertBsGCTStrategy (dataType /) 
  (cond 
    ((= dataType "Tank") (InsertBsTankGCT))
  )
)

; 2021-04-17
(defun InsertBsTankGCT (/ insPt) 
  (VerifyBsBlockLayerText)
  (setq insPt (getpoint "\nʰȡ�豸һ�������㣺"))
  (InsertBsGCTDataHeader insPt)
  (princ)
)

; 2021-04-17
(defun InsertBsGCTDataHeader (insPt /) 
  (InsertBlockUtils insPt "BsGCTDataHeader" "0DataFlow-BsGCT" (list (cons 0 "Tank")))
)

(defun c:foo ()
  (InsertBsGCTStrategy "Tank")
)


; Generate BsGCT
;;;-------------------------------------------------------------------------;;;
;;;-------------------------------------------------------------------------;;;
