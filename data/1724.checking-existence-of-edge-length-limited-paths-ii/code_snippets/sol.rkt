(define distance-limited-paths-exist%
  (class object%
    (super-new)

    ; n : exact-integer?

    ; edge-list : (listof (listof exact-integer?))
    (init-field
      n
      edge-list)
    
    ; query : exact-integer? exact-integer? exact-integer? -> boolean?
    (define/public (query p q limit)

      )))

;; Your distance-limited-paths-exist% object will be instantiated and called as such:
;; (define obj (new distance-limited-paths-exist% [n n] [edgeList edgeList]))
;; (define param_1 (send obj query p q limit))