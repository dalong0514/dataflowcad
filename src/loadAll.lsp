(setq *dataflowLispNums* 0)
(vl-load-all "D:\\dataflowcad\\src\\dataflowUtils.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\stealUtils.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowUnitTest.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\generateGraph.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowGs.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowGsLc.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowGsBz.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowNs.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowKs.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(vl-load-all "D:\\dataflowcad\\src\\dataflowSs.lsp")
(setq *dataflowLispNums* (1+ *dataflowLispNums*))
(princ (strcat "\n加载的 lisp 文件数量：" (vl-princ-to-string *dataflowLispNums*)))
(setq *dataflowLispNums* 0)(princ)