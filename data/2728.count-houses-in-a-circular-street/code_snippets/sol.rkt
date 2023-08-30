; Definition for a street:
#|

(define street%
  (class object%
    (super-new)
    (init (doors '()))
    (define/public (open-door) (-> void?))
    (define/public (close-door) (-> void?))
    (define/public (is-door-open) (-> boolean?)) 
    (define/public (move-right) (-> void?))
    (define/public (move-left) (-> void?))
  ))

|#

(define (house-count street k)
  ;; (-> street? exact-integer? exact-integer?)

  )