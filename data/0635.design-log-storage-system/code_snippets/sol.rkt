(define log-system%
  (class object%
    (super-new)
    (init-field)
    
    ; put : exact-integer? string? -> void?
    (define/public (put id timestamp)

      )
    ; retrieve : string? string? string? -> (listof exact-integer?)
    (define/public (retrieve start end granularity)

      )))

;; Your log-system% object will be instantiated and called as such:
;; (define obj (new log-system%))
;; (send obj put id timestamp)
;; (define param_2 (send obj retrieve start end granularity))