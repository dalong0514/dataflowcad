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

