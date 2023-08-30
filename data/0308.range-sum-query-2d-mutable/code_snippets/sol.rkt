(define num-matrix%
  (class object%
    (super-new)

    ; matrix : (listof (listof exact-integer?))
    (init-field
      matrix)
    
    ; update : exact-integer? exact-integer? exact-integer? -> void?
    (define/public (update row col val)

      )
    ; sum-region : exact-integer? exact-integer? exact-integer? exact-integer? -> exact-integer?
    (define/public (sum-region row1 col1 row2 col2)

      )))

;; Your num-matrix% object will be instantiated and called as such:
;; (define obj (new num-matrix% [matrix matrix]))
;; (send obj update row col val)
;; (define param_2 (send obj sum-region row1 col1 row2 col2))