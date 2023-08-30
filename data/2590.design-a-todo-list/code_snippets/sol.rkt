(define todo-list%
  (class object%
    (super-new)
    
    (init-field)
    
    ; add-task : exact-integer? string? exact-integer? (listof string?) -> exact-integer?
    (define/public (add-task user-id task-description due-date tags)

      )
    ; get-all-tasks : exact-integer? -> (listof string?)
    (define/public (get-all-tasks user-id)

      )
    ; get-tasks-for-tag : exact-integer? string? -> (listof string?)
    (define/public (get-tasks-for-tag user-id tag)

      )
    ; complete-task : exact-integer? exact-integer? -> void?
    (define/public (complete-task user-id task-id)

      )))

;; Your todo-list% object will be instantiated and called as such:
;; (define obj (new todo-list%))
;; (define param_1 (send obj add-task user-id task-description due-date tags))
;; (define param_2 (send obj get-all-tasks user-id))
;; (define param_3 (send obj get-tasks-for-tag user-id tag))
;; (send obj complete-task user-id task-id)