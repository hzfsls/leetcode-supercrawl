(define hit-counter%
  (class object%
    (super-new)
    (init-field)
    
    ; hit : exact-integer? -> void?
    (define/public (hit timestamp)

      )
    ; get-hits : exact-integer? -> exact-integer?
    (define/public (get-hits timestamp)

      )))

;; Your hit-counter% object will be instantiated and called as such:
;; (define obj (new hit-counter%))
;; (send obj hit timestamp)
;; (define param_2 (send obj get-hits timestamp))