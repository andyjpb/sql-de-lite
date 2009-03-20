(use srfi-1)
(define selects
  (map (lambda (x) (sprintf "select ~A;" x)) (iota 200)))

(define cache-hash
  (map (lambda (x)
         (cons (hash x)
               (cons x (conc "** " x " **"))))
       selects))

(define cache-string
  (map (lambda (x)
         (cons x (conc "** " x " **")))
       selects))

(define cache-hash-table
  (let ((ht (make-hash-table string=?)))
    (for-each (lambda (x)
                (hash-table-set! ht x (conc "** " x " **")))
              selects)
    ht))

(use miscmacros)

(print "alist lookup by hashed value (end of 50 elt list)")
(print (cdr (alist-ref (hash "select 49;") cache-hash)))
(time (dotimes (i 1000000)
               (let ((s "select 49;"))
                 (and-let* ((cell (alist-ref (hash s) cache-hash)))
                   (and (string=? (car cell) s)
                        (cdr cell))))))

(print "alist lookup by string=? (end of 50 elt list)")
(print (alist-ref "select 49;" cache-string string=?))
(time (dotimes (i 1000000)
               (alist-ref "select 49;" cache-string string=?)))

(print "hash-table lookup by string=?")
(print (hash-table-ref/default cache-hash-table "select 49;" #f))
(time (dotimes (i 1000000)
               (hash-table-ref/default cache-hash-table "select 49;" #f)))

;; Slower than hash table.  How is that possible?
(print "alist lookup by hashed value (first element)")
(print (cdr (alist-ref (hash "select 0;") cache-hash)))
(time (dotimes (i 1000000)
               (let ((s "select 0;"))
                 (and-let* ((cell (alist-ref (hash s) cache-hash)))
                   (and (string=? (car cell) s)
                        (cdr cell))))))

(print "alist lookup by hashed value (200th element)")
(print (cdr (alist-ref (hash "select 199;") cache-hash)))
(time (dotimes (i 1000000)
               (let ((s "select 199;"))
                 (and-let* ((cell (alist-ref (hash s) cache-hash)))
                   (and (string=? (car cell) s)
                        (cdr cell))))))

(print "alist lookup by string=? (200th elt)")
(print (alist-ref "select 199;" cache-string string=?))
(time (dotimes (i 1000000)
               (alist-ref "select 199;" cache-string string=?)))

(print "hash-table lookup by string=? (200th elt)")
(print (hash-table-ref/default cache-hash-table "select 199;" #f))
(time (dotimes (i 1000000)
               (hash-table-ref/default cache-hash-table "select 199;" #f)))
