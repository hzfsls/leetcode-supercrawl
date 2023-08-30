(define tic-tac-toe%
  (class object%
    (super-new)

    ; n : exact-integer?
    (init-field
      n)
    
    ; move : exact-integer? exact-integer? exact-integer? -> exact-integer?
    (define/public (move row col player)

      )))

;; Your tic-tac-toe% object will be instantiated and called as such:
;; (define obj (new tic-tac-toe% [n n]))
;; (define param_1 (send obj move row col player))