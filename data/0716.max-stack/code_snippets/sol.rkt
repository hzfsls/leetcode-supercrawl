(define max-stack%
  (class object%
    (super-new)
    (init-field)
    
    ; push : exact-integer? -> void?
    (define/public (push x)

      )
    ; pop : -> exact-integer?
    (define/public (pop)

      )
    ; top : -> exact-integer?
    (define/public (top)

      )
    ; peek-max : -> exact-integer?
    (define/public (peek-max)

      )
    ; pop-max : -> exact-integer?
    (define/public (pop-max)

      )))

;; Your max-stack% object will be instantiated and called as such:
;; (define obj (new max-stack%))
;; (send obj push x)
;; (define param_2 (send obj pop))
;; (define param_3 (send obj top))
;; (define param_4 (send obj peek-max))
;; (define param_5 (send obj pop-max))