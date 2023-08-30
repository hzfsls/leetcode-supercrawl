(define trie%
  (class object%
    (super-new)
    (init-field)
    
    ; insert : string? -> void?
    (define/public (insert word)

      )
    ; count-words-equal-to : string? -> exact-integer?
    (define/public (count-words-equal-to word)

      )
    ; count-words-starting-with : string? -> exact-integer?
    (define/public (count-words-starting-with prefix)

      )
    ; erase : string? -> void?
    (define/public (erase word)

      )))

;; Your trie% object will be instantiated and called as such:
;; (define obj (new trie%))
;; (send obj insert word)
;; (define param_2 (send obj count-words-equal-to word))
;; (define param_3 (send obj count-words-starting-with prefix))
;; (send obj erase word)