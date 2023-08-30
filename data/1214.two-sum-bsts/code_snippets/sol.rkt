; Definition for a binary tree node.
#|

; val : integer?
; left : (or/c tree-node? #f)
; right : (or/c tree-node? #f)
(struct tree-node
  (val left right) #:mutable #:transparent)

; constructor
(define (make-tree-node [val 0])
  (tree-node val #f #f))

|#

(define/contract (two-sum-bs-ts root1 root2 target)
  (-> (or/c tree-node? #f) (or/c tree-node? #f) exact-integer? boolean?)

  )