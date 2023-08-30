(define file-sharing%
  (class object%
    (super-new)

    ; m : exact-integer?
    (init-field
      m)
    
    ; join : (listof exact-integer?) -> exact-integer?
    (define/public (join owned-chunks)

      )
    ; leave : exact-integer? -> void?
    (define/public (leave user-id)

      )
    ; request : exact-integer? exact-integer? -> (listof exact-integer?)
    (define/public (request user-id chunk-id)

      )))

;; Your file-sharing% object will be instantiated and called as such:
;; (define obj (new file-sharing% [m m]))
;; (define param_1 (send obj join owned-chunks))
;; (send obj leave user-id)
;; (define param_3 (send obj request user-id chunk-id))