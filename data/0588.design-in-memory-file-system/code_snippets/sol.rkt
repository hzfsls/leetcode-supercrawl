(define file-system%
  (class object%
    (super-new)
    (init-field)
    
    ; ls : string? -> (listof string?)
    (define/public (ls path)

      )
    ; mkdir : string? -> void?
    (define/public (mkdir path)

      )
    ; add-content-to-file : string? string? -> void?
    (define/public (add-content-to-file file-path content)

      )
    ; read-content-from-file : string? -> string?
    (define/public (read-content-from-file file-path)

      )))

;; Your file-system% object will be instantiated and called as such:
;; (define obj (new file-system%))
;; (define param_1 (send obj ls path))
;; (send obj mkdir path)
;; (send obj add-content-to-file file-path content)
;; (define param_4 (send obj read-content-from-file file-path))