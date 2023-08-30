(define leaderboard%
  (class object%
    (super-new)
    (init-field)
    
    ; add-score : exact-integer? exact-integer? -> void?
    (define/public (add-score player-id score)

      )
    ; top : exact-integer? -> exact-integer?
    (define/public (top k)

      )
    ; reset : exact-integer? -> void?
    (define/public (reset player-id)

      )))

;; Your leaderboard% object will be instantiated and called as such:
;; (define obj (new leaderboard%))
;; (send obj add-score player-id score)
;; (define param_2 (send obj top k))
;; (send obj reset player-id)