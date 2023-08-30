(define mru-queue%
  (class object%
    (super-new)

    ; n : exact-integer?
    (init-field
      n)
    
    ; fetch : exact-integer? -> exact-integer?
    (define/public (fetch k)

      )))

;; Your mru-queue% object will be instantiated and called as such:
;; (define obj (new mru-queue% [n n]))
;; (define param_1 (send obj fetch k))