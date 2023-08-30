(define file-system%
  (class object%
    (super-new)
    (init-field)
    
    ; create-path : string? exact-integer? -> boolean?
    (define/public (create-path path value)

      )
    ; get : string? -> exact-integer?
    (define/public (get path)

      )))

;; Your file-system% object will be instantiated and called as such:
;; (define obj (new file-system%))
;; (define param_1 (send obj create-path path value))
;; (define param_2 (send obj get path))