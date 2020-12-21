;;;
;;;    ATTOUT.LSP
;;;    Created 4/24/98 by Randy Kintzley
;;;    EDITED 6/22/2011 by LIWEN Email:liwen@znwl.com
;;;    Copyright ?1999 by Autodesk, Inc.
;;;
;;;    Your use of this software is governed by the terms and conditions of the
;;;    License Agreement you accepted prior to installation of this software.
;;;    Please note that pursuant to the License Agreement for this software,
;;;    "[c]opying of this computer program or its documentation except as
;;;    permitted by this License is copyright infringement under the laws of
;;;    your country.  If you copy this computer program without permission of
;;;    Autodesk, you are violating the law."
;;;
;;;    AUTODESK PROVIDES THIS PROGRAM "AS IS" AND WITH ALL FAULTS.
;;;    AUTODESK SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF
;;;    MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.  AUTODESK, INC.
;;;    DOES NOT WARRANT THAT THE OPERATION OF THE PROGRAM WILL BE
;;;    UNINTERRUPTED OR ERROR FREE.
;;;
;;;    Use, duplication, or disclosure by the U.S. Government is subject to
;;;    restrictions set forth in FAR 52.227-19 (Commercial Computer
;;;    Software - Restricted Rights) and DFAR 252.227-7013(c)(1)(ii)
;;;    (Rights in Technical Data and Computer Software), as applicable.
;;;
;;;  ----------------------------------------------------------------
;; [功能] T
(defun arx_acetutil (/ rundoslib acetutil_r)
  (mapcar '(lambda (x)
              (if (= x "acetutil.arx")
               (setq rundoslib T)
              );;end_if
           );;end_lambda
  (arx)
  );;end_mapcar
  T
)
;写文件
(defun WriteStrem (path text format / fso str file res)
  (setq fso  (vlax-create-object "Scripting.FileSystemObject"))
  (setq str  (vlax-invoke fso 'CreateTextFile path -1 format))
  (setq file (vlax-invoke fso 'getFile path))
  (vlax-invoke str 'Write text)
  (vlax-invoke str 'close)
  (setq res (vlax-get file 'size))
  (if str  (vlax-release-object str))
  (if file (vlax-release-object file))
  (if fso  (vlax-release-object fso))
  res
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ATTOUT -
;Extracts attribute data from selected block inserts to a tab delimited file.
;
(defun c:at ( / ss fna )
(if (arx_acetutil)
(progn

(acet-error-init '(nil 0))
(setq datedata (menucmd "M=$(EDTIME,$(GETVAR,DATE),YYYY.DD.MM.hh.mm.ss)"))
(setq fini (strcat (getvar "dwgprefix") "xls_name.ini"))
(setq fname (acet-filename-path-remove (acet-filename-ext-remove (getvar "dwgname"))))
(cond
 ((not (setq fna (strcat (getvar "dwgprefix")
                         fname
                         "("
                         datedata
                         ")"
                         ".xls"
                 );strcat
       );setq
  );not
  (princ "\nNo output file selected.")
 )
 ((not (setq ss (ssget '((0 . "INSERT") (66 . 1))))
  );not
  (princ "\nNo valid objects selected.")
 )
 (T
  (bns_attout fna ss)
 )
);cond close
 
(acet-error-restore)
);progn #1
;;如果没有加载ACETUTIL.ARX
(alert "请安装Express后使用此插件!")
);if #1
(prin1)
);defun c:at
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function version of ATTOUT takes a filename and a selection set.
(defun bns_attout ( fna ss / lst )
 
(if (and fna
         ss
         (setq lst (bns_attout_get_info ss))
    );and
    (progn 
      (bns_attout_output fna lst)
      (if (findfile fini)
        (acet-ini-set fini fname "XLS" fna)
        (progn
          (WRITESTREM (setq fini (strcat (getvar "dwgprefix") "xls_name.ini")) "" "0")
          (acet-ini-set fini fname "XLS" fna)
        )
      );if_findfile
    );progn
);if
(princ)
);defun bns_attout
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Takes a filename and a list of string data and writes it out.
(defun bns_attout_output ( fna lst / n a fh)
 
(if (setq fh (open fna "w"))
    (progn
 
     (acet-ui-progress-init "Writing output file" (length lst))
     (setq n 0)
     (repeat (length lst)
      (write-line (nth n lst) fh)
      (acet-ui-progress-safe n)
      (setq n (+ n 1));setq
     );repeat
     (close fh)
     (acet-ui-progress-done)
 
     (if (setq a (findfile fna))
         (princ (strcat "\nOutput file: \"" a "\" created."))
         (acet-alert (strcat "\nOutput FAILED for file: \"" fna "\"."))
     );if
    );progn then write the file
    (progn
     (if fna
         (acet-alert (strcat "*Error* could not open file \""
                            fna
                            "\" for write. The file may be currently in use."
                    )
         );acet-alert then
         (acet-alert "*Error* invalid filename.")
     );if
    );progn else print the error.
);if
 
);defun bns_attout_ouput
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;bns_attout_get_info - retrieves the data from the block inserts in
;the selection set provided.
;
(defun bns_attout_get_info ( ss / delim n j a lst lst2 lst3 lst4 na e1 blk hnd str)
 
 (setq delim "\t"); the delimiter for the output file.
 
 (acet-ui-progress-init "Searching for all attribute data" (sslength ss))
 (setq n 0)
 (repeat (sslength ss)
  (setq   na (ssname ss n)
          e1 (entget na)
         lst (acet-insert-attrib-get (list na 1))
         blk (cdr (assoc 2 e1))
         hnd (cdr (assoc 5 e1))
        lst3 (append lst3 (list (list hnd blk lst)))
  );setq
 
   (setq j 0)
   (repeat (length lst)
    (setq a (car (nth j lst)));setq
    (if (not (member a lst2))
        (setq lst2 (append lst2 (list a)));setq
    );if
    (setq j (+ j 1));setq
   );repeat
  (acet-ui-progress-safe n)
  (setq n (+ n 1));setq
 );repeat
 (acet-ui-progress-done)
 
 ;lst2 is now a list w/unique attrib tags
 ;i.e. ("tag" "tag2" "tag3")
 ;lst3 is a list of the form ((handle blockname ((tag value) (tag value)...)
 ;                            (handle blockname ((tag value) (tag value)...)
 ;                            ...
 ;
 ;                           )
 
 (acet-ui-progress-init "Formatting attribute data for output" (length lst3))
 
 (setq str (strcat "HANDLE" delim "BLOCKNAME"));setq
 (setq n 0)
 (repeat (length lst2)                             ;;;;build the header for spread sheet.
  (setq str (strcat str delim (nth n lst2)));setq
  (setq n (+ n 1))
 );repeat
 (setq lst4 (list str))
 
 (setq n 0)
 (repeat (length lst3)
  (setq  lst (nth n lst3)
         str (strcat "'"
                     (car lst)  ;the handle
                     delim
                     (cadr lst) ;the blockname
             );strcat
         lst (caddr lst)
  );setq
 
  (acet-ui-progress-safe n)
 
  (setq j 0)
  (repeat (length lst2)
   (setq a (nth j lst2)
         a (cadr (assoc a lst))
   );setq
   (if (not a)
       (setq a "<>")
   );if
 
   (setq str (strcat str delim a));setq
   (setq j (+ j 1));setq
  );repeat
 
  (setq lst4 (append lst4 (list str)))
 
  (setq n (+ n 1));setq
 );repeat
 (acet-ui-progress-done)
 
lst4
);defun bns_attout_get_info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ATTIN -
;Imports attribute data from selected file. The file must be of
;the same format as created with ATTOUT.
;
(defun c:ai ( / fna lklay )
(if (arx_acetutil)
(progn

(acet-error-init (list
                 (list "cmdecho" 0)
                 0
                 '(progn
                   (if lklay
                       (progn
                        (acet-sysvar-set '("cmdecho" 0))
                        (command "_.layer" "_lock" lklay "")
                        (acet-sysvar-restore)
                       )
                   );if need to re-lock
                   (princ (strcat "\n" (itoa #bns_attin_modified) " Block inserts modified."))
                  );progn
                )
)
 
(acet-autoload '("yes_no.lsp" "(bns_get_yes_no a b)"))
 
(setq #bns_attin_modified 0)

(setq fini (strcat (getvar "dwgprefix") "xls_name.ini"))
(setq fname (acet-filename-path-remove (acet-filename-ext-remove (getvar "dwgname"))))
(setq fname_N (strcat (getvar "dwgprefix") fname ".xls"))
  (if (findfile fini)
    (setq ex_name (acet-ini-get fini fname "XLS"))
    (setq ex_name fname_N)
  );if_findfile

(cond
  ((not
     (setq fna (getfiled "Enter input filename" ex_name "xls" 0))
   )
   (princ "\nNo input file selected.")
);cond #1

 ((setq fna (findfile fna))
  (setq lklay (acet-layer-unlock-all))
  (if (equal 4 (logand 4 (getvar "cmdactive")))
      (bns_attin fna nil);a script is running so no interactive placement
      (bns_attin fna T);Allow interactive placement
  );if
  (if lklay
      (command "_.layer" "_lock" lklay "")
  );if
  (princ (strcat "\n" (itoa #bns_attin_modified) " Block inserts modified."))
 );cond #2
);cond close
 
(acet-error-restore)
);progn #1
;;如果没有加载ACETUTIL.ARX
(alert "请安装Express后使用此插件!")
);if #1
(prin1)
);defun c:ai
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;bns_attin takes a file name and a flag (interact) that specifies
;if the user should be prompted to select block inserts when unmatched
;data is found.
;
(defun bns_attin ( fna interact / fh lst lst2 lst3 lst4 lst5 n j na e1 a delim ans )
 
(setq delim "\t")
(if (setq fh (open fna "r"))
    (progn
 
     (princ "\nReading the input file...")
     (while (setq a (read-line fh))
      (if (not lst)        ;change first record to upper case
          (setq a (xstrcase a))
      );if
      (setq lst (cons (acet-str-to-list delim a) lst));setq
     );while
     (setq fh (close fh))
     (princ " Done.")
 
     (setq  lst (reverse lst)
           lst2 (cdr lst) ;the data
            lst (car lst) ;the column headers
     );setq
 
     (acet-ui-progress-init "Importing data" (length lst2))
     (setq n 0)
     (repeat (length lst2)
     (setq lst3 (nth n lst2)
           lst4 nil
     );setq
 
     (acet-ui-progress-safe n)
 
      (setq j 0)                                 ;match the header row with the current record
      (repeat (min (length lst) (length lst3))
       (setq    a (list (nth j lst)
                        (nth j lst3)
                  );list
             lst4 (cons a lst4)
       );setq
       (setq j (+ j 1));setq
      );repeat
      (setq lst4 (reverse lst4));setq
 
      (if (and (setq a (cadr (assoc "HANDLE" lst4)))
               (equal "'" (substr a 1 1))
          );and
          (setq a (substr a 2))
      );if
      (if (and a
               (setq na (handent a))
               (setq e1 (entget na))
               (equal "INSERT" (cdr (assoc 0 e1)))
               (equal 1 (cdr (assoc 66 e1)))
               (or (not (assoc "BLOCKNAME" lst4))
                   (equal (xstrcase (cadr (assoc "BLOCKNAME" lst4)))
                          (xstrcase (cdr (assoc 2 e1)))
                   );equal
               );or
          );and
          (progn
           (if (not (equal 8 (logand 8 (getvar "undoctl"))))
               (acet-undo-begin)
           );if
           (setq lst4 (vl-remove (assoc "BLOCKNAME" lst4) lst4)
                 lst4 (vl-remove (assoc "HANDLE" lst4) lst4)
           );setq
           (if (acet-insert-attrib-set na lst4 nil)
               (setq #bns_attin_modified (+ #bns_attin_modified 1))
               (progn
                (if interact
                    (setq lst5 (cons lst4 lst5));setq add to interactive list.
                    (princ "\nNo matching attribute tags.")
                );if
               );progn else
           );if
           (acet-undo-end)
          );progn then
          (progn
           ;Print what's going on...
           (if (not interact)
               (cond
                ((not a)
                 (princ "\nNo Handle specification.")
                )
                ((not na)
                 (princ (strcat "\nNo entity with specified handle \"" a "\" exists."))
                )
                (T
                 (princ (strcat "\nSpecified entity: \"" a "\" has been deleted or is invalid. "))
                )
               );cond then non-interactive execution
               (setq lst5 (cons lst4 lst5));setq else gather a list of attribs with
                                           ;no insert home.
           );if
           );progn else no home for this record
      );if
     (setq n (+ n 1));setq
     );repeat
     (acet-ui-progress-done)
 
     (if (and lst5
              interact
              (setq ans (bns_get_yes_no
                         (list "ATTIN - Select blocks?"
                               (strcat
                                ""
                                "\n    One or more records of data could not be"
                                "\n   matched to block inserts within this drawing."
                                "\n"
                                "\n    Do you want to select the block inserts "
                                "\n   and assign this data interactively?"
                               );strcat
                         );list
                         (list 40 10)
                        );bns_get_yes_no
              );setq
              (equal ans 1)
         );and
         (progn
          (princ "\nSelect the desired blocks to assign the data to and press ENTER when done.")
          (bns_attin_interactive (reverse lst5))
         );progn then
     );if
 
    );progn then
    (acet-alert "\nError opening input file for read.")
);if
 
);defun bns_attin
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bns_attin_interactive ( lst / na e1 )
 
(while lst
 
 (if (not (equal 8 (logand 8 (getvar "undoctl"))))
     (acet-undo-begin)
 );if
 (bns_print_att_list (car lst))
 (princ "\nPress [Enter] to skip or [Esc] to finish.")
 (if (and (setq na (acet-ui-single-select '((0 . "INSERT") (66 . 1)) nil))
          (setq e1 (entget na))
     );and
     (progn
      (if (acet-insert-attrib-set na (car lst) nil)
          (setq #bns_attin_modified (+ #bns_attin_modified 1)
                                lst (cdr lst)
          );setq
          (acet-alert (strcat "\nNo matching attribute tags were found on that "
                             "block insert. \nTry another block insert."
                     );strcat
          );acet-alert
      );if
     );progn then
     (setq lst (cdr lst));setq
 );if
 (acet-undo-end)
);while
 
);defun bns_attin_interactive
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bns_print_att_list ( lst / sp n a b j k)
 
(setq lst (cons (list "---" "-----") lst)
      lst (cons (list "TAG" "VALUE") lst)
       sp "    "
       sp (strcat sp sp sp sp sp sp sp sp)
       sp (strcat sp sp sp sp sp sp sp sp)
        j 0
        k 0
        n 0
);setq
(repeat (length lst)
 (setq a (nth n lst)
       b (cadr a)
       a (car a)
       j (max (strlen a) j)
       k (max (strlen b) k)
 );setq
(setq n (+ n 1));setq
);repeat
 
(princ "\n")
(setq j (+ j 2)
      k (+ k 2)
);setq
(setq n 0)
(repeat (length lst)
 (setq a (nth n lst)
       b (cadr a)
       a (car a)
 );setq
 (if (not (equal b "<>"))
     (progn
      (setq a (strcat a
                      (substr sp 1 (max 0 (- j (strlen a))))
              );strcat
            b (strcat b
                      (substr sp 1 (max 0 (- k (strlen b))))
              );strcat
           a (strcat "\n " a b)
      );setq
      (princ a)
     );progn then
 );if
(setq n (+ n 1));setq
);repeat
n
);defun bns_print_att_list
 

(acet-autoload2	'("Yes_no.lsp"	(bns_get_yes_no lst size)))
(princ)

;open excel file 
(defun c:as (/ fna)
(if (arx_acetutil)
(progn

(setq fini (strcat (getvar "dwgprefix") "xls_name.ini"))
(setq fname (acet-filename-path-remove (acet-filename-ext-remove (getvar "dwgname"))))
(setq fname_N (strcat (getvar "dwgprefix") fname ".xls"))
  (if (findfile fini)
    (setq ex_name (acet-ini-get fini fname "XLS"))
    (setq ex_name fname_N)
  );if_findfile
  (vl-cmdf "_ai_editcustfile" fna)
  (princ)
);progn #1
;;如果没有加载ACETUTIL.ARX
(alert "请安装Express后使用此插件!")
);if #1
(prin1)
)
(princ)
