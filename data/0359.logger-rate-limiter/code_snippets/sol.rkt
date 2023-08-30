(define logger%
  (class object%
    (super-new)
    (init-field)
    
    ; should-print-message : exact-integer? string? -> boolean?
    (define/public (should-print-message timestamp message)

      )))

;; Your logger% object will be instantiated and called as such:
;; (define obj (new logger%))
;; (define param_1 (send obj should-print-message timestamp message))