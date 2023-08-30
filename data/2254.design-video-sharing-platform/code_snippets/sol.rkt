(define video-sharing-platform%
  (class object%
    (super-new)
    
    (init-field)
    
    ; upload : string? -> exact-integer?
    (define/public (upload video)

      )
    ; remove : exact-integer? -> void?
    (define/public (remove video-id)

      )
    ; watch : exact-integer? exact-integer? exact-integer? -> string?
    (define/public (watch video-id start-minute end-minute)

      )
    ; like : exact-integer? -> void?
    (define/public (like video-id)

      )
    ; dislike : exact-integer? -> void?
    (define/public (dislike video-id)

      )
    ; get-likes-and-dislikes : exact-integer? -> (listof exact-integer?)
    (define/public (get-likes-and-dislikes video-id)

      )
    ; get-views : exact-integer? -> exact-integer?
    (define/public (get-views video-id)

      )))

;; Your video-sharing-platform% object will be instantiated and called as such:
;; (define obj (new video-sharing-platform%))
;; (define param_1 (send obj upload video))
;; (send obj remove video-id)
;; (define param_3 (send obj watch video-id start-minute end-minute))
;; (send obj like video-id)
;; (send obj dislike video-id)
;; (define param_6 (send obj get-likes-and-dislikes video-id))
;; (define param_7 (send obj get-views video-id))