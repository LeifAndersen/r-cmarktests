#lang racket

(require racket/runtime-path
         rackunit)

;; Utilities
(define-runtime-path R (find-executable-path "R"))
(define-runtime-path Rscript (find-executable-path "Rscript"))

(define tests '("global.R"
                "funcs.R"
                "skipper.R"
                "looper.R"
                "samplerun.R"))

(for ([f tests])
  (check-equal?
   (with-output-to-string (λ () (system* Rscript f)))
   (file->string (path-replace-suffix f ".R-sol"))))
