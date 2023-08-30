(define word-distance%
  (class object%
    (super-new)

    ; words-dict : (listof string?)
    (init-field
      words-dict)
    
    ; shortest : string? string? -> exact-integer?
    (define/public (shortest word1 word2)

      )))

;; Your word-distance% object will be instantiated and called as such:
;; (define obj (new word-distance% [words-dict words-dict]))
;; (define param_1 (send obj shortest word1 word2))