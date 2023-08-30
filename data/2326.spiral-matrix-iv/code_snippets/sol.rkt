; Definition for singly-linked list:
#|

; val : integer?
; next : (or/c list-node? #f)
(struct list-node
  (val next) #:mutable #:transparent)

; constructor
(define (make-list-node [val 0])
  (list-node val #f))

|#

(define/contract (spiral-matrix m n head)
  (-> exact-integer? exact-integer? (or/c list-node? #f) (listof (listof exact-integer?)))

  )