(define string-iterator%
  (class object%
    (super-new)

    ; compressed-string : string?
    (init-field
      compressed-string)
    
    ; next : -> char?
    (define/public (next)

      )
    ; has-next : -> boolean?
    (define/public (has-next)

      )))

;; Your string-iterator% object will be instantiated and called as such:
;; (define obj (new string-iterator% [compressed-string compressed-string]))
;; (define param_1 (send obj next))
;; (define param_2 (send obj has-next))