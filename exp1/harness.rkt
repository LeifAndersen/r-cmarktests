#lang racket

(require benchmark
         racket/runtime-path
         plot)

;; R build without continuation marks
(define-runtime-path R (find-executable-path "clean-Rscript"))

;; Same R build with continuation marks added
(define-runtime-path mark-R (find-executable-path "marks-Rscript"))

;; Implementation of continuation marks in R
(define-runtime-path marks "examples/marks.R")

(define-runtime-path results-file "results")
(define-runtime-path plot-file* "plot.pdf")

(define-runtime-path-list test-paths
  '("examples/loop.R"))

(define results
  (parameterize ([current-directory "examples"])
    (run-benchmarks
     test-paths
     '((r-marks c-marks no-marks))
     (λ (file marks)
       (match marks
         ['r-marks  (time (system* R      (path-replace-suffix file ".R-marks")))]
         ['c-marks  (time (system* mark-R (path-replace-suffix file ".R-marks")))]
         ['no-marks (time (system* R      (path-replace-suffix file ".R")))]))
     ;;#:build (λ (marks) (void))
     ;;#:clean (λ (marks) (void))
     #:num-trials 30
     #:make-name (λ (path)
                   (let-values ([(path-name file-name root?) (split-path path)])
                     (path->string file-name)))
     #:results-file results-file)))

(define results/plot
  (parameterize ([plot-x-ticks no-ticks])
    (plot-file
     #:title "R Continuation Marks Performance"
     #:x-label #f
     #:y-label "normalized time"
     (render-benchmark-alts
      '(no-marks)
      results
      #:normalize? #t)
     plot-file*)))
