(define vector2-d%
  (class object%
    (super-new)

    ; vec : (listof (listof exact-integer?))
    (init-field
      vec)
    
    ; next : -> exact-integer?
    (define/public (next)

      )
    ; has-next : -> boolean?
    (define/public (has-next)

      )))

;; Your vector2-d% object will be instantiated and called as such:
;; (define obj (new vector2-d% [vec vec]))
;; (define param_1 (send obj next))
;; (define param_2 (send obj has-next))