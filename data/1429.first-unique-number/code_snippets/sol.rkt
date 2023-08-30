(define first-unique%
  (class object%
    (super-new)

    ; nums : (listof exact-integer?)
    (init-field
      nums)
    
    ; show-first-unique : -> exact-integer?
    (define/public (show-first-unique)

      )
    ; add : exact-integer? -> void?
    (define/public (add value)

      )))

;; Your first-unique% object will be instantiated and called as such:
;; (define obj (new first-unique% [nums nums]))
;; (define param_1 (send obj show-first-unique))
;; (send obj add value)