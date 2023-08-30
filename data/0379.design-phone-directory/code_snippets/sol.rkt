(define phone-directory%
  (class object%
    (super-new)

    ; max-numbers : exact-integer?
    (init-field
      max-numbers)
    
    ; get : -> exact-integer?
    (define/public (get)

      )
    ; check : exact-integer? -> boolean?
    (define/public (check number)

      )
    ; release : exact-integer? -> void?
    (define/public (release number)

      )))

;; Your phone-directory% object will be instantiated and called as such:
;; (define obj (new phone-directory% [max-numbers max-numbers]))
;; (define param_1 (send obj get))
;; (define param_2 (send obj check number))
;; (send obj release number)