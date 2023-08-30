(define sql%
  (class object%
    (super-new)
    
    ; names : (listof string?)
    ; columns : (listof exact-integer?)
    (init-field
      names
      columns)
    
    ; insert-row : string? (listof string?) -> void?
    (define/public (insert-row name row)

      )
    ; delete-row : string? exact-integer? -> void?
    (define/public (delete-row name row-id)

      )
    ; select-cell : string? exact-integer? exact-integer? -> string?
    (define/public (select-cell name row-id column-id)

      )))

;; Your sql% object will be instantiated and called as such:
;; (define obj (new sql% [names names] [columns columns]))
;; (send obj insert-row name row)
;; (send obj delete-row name row-id)
;; (define param_3 (send obj select-cell name row-id column-id))