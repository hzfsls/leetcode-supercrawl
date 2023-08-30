(define snake-game%
  (class object%
    (super-new)

    ; width : exact-integer?

    ; height : exact-integer?

    ; food : (listof (listof exact-integer?))
    (init-field
      width
      height
      food)
    
    ; move : string? -> exact-integer?
    (define/public (move direction)

      )))

;; Your snake-game% object will be instantiated and called as such:
;; (define obj (new snake-game% [width width] [height height] [food food]))
;; (define param_1 (send obj move direction))