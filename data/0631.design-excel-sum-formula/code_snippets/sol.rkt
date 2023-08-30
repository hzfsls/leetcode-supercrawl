(define excel%
  (class object%
    (super-new)

    ; height : exact-integer?

    ; width : char?
    (init-field
      height
      width)
    
    ; set : exact-integer? char? exact-integer? -> void?
    (define/public (set row column val)

      )
    ; get : exact-integer? char? -> exact-integer?
    (define/public (get row column)

      )
    ; sum : exact-integer? char? (listof string?) -> exact-integer?
    (define/public (sum row column numbers)

      )))

;; Your excel% object will be instantiated and called as such:
;; (define obj (new excel% [height height] [width width]))
;; (send obj set row column val)
;; (define param_2 (send obj get row column))
;; (define param_3 (send obj sum row column numbers))