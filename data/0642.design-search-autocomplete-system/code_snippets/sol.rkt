(define autocomplete-system%
  (class object%
    (super-new)

    ; sentences : (listof string?)

    ; times : (listof exact-integer?)
    (init-field
      sentences
      times)
    
    ; input : char? -> (listof string?)
    (define/public (input c)

      )))

;; Your autocomplete-system% object will be instantiated and called as such:
;; (define obj (new autocomplete-system% [sentences sentences] [times times]))
;; (define param_1 (send obj input c))