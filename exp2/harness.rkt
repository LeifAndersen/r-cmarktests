#lang racket

(require benchmark
         racket/runtime-path
         plot)

;; R tarball
(define-runtime-path R "../R/67685.tar.gz")

;; Patches
(define-runtime-path marks2 "patches/marks2.patch")
(define-runtime-path marks3 "patches/marks3.patch")

;; Destinations
(define-runtime-path R-marks2 "builds/marks2")
(define-runtime-path R-marks3 "builds/marks3")
(define-runtime-path R-clean  "builds/clean")

;; Utilities
(define-runtime-path tar (find-executable-path "tar"))
(define-runtime-path patch (find-executable-path "patch"))
(define-runtime-path make (find-executable-path "make"))
(define (build-R bundle destination #:patch [p #f])
  (make-directory* destination)
  (system* tar "xvf" bundle "-C" destination "--strip-components=1")
  (parameterize ([current-directory destination])
    (when p (with-input-from-file p (λ () (system* patch "-p1"))))
    (system* "./configure" "--without-recommended-packages")
    (system* make "-j5")))

(define-runtime-path results-file "results")
(define-runtime-path plot-file* "plot.pdf")

(define-runtime-path-list test-paths
  '("examples/loop.R"))

;; Build R
(unless (directory-exists? R-marks2) (build-R R R-marks2 #:patch marks2))
(unless (directory-exists? R-marks3) (build-R R R-marks3 #:patch marks3))
(unless (directory-exists? R-clean)  (build-R R R-clean))

(define results
  (parameterize ([current-directory "examples"])
    (run-benchmarks
     test-paths
     '((marks2 marks3 no-marks))
     (λ (file marks)
       (match marks
         ['marks2   (time (system* R-marks2 (path-replace-suffix file ".R-marks")))]
         ['marks3   (time (system* R-marks3 (path-replace-suffix file ".R-marks")))]
         ['no-marks (time (system* R-clean  (path-replace-suffix file ".R")))]))
     ;;#:build
     ;;(λ (file marks)
     ;;  (match marks
     ;;    ['marks2   (build-R R R-marks2 #:patch marks2)]
     ;;    ['marks3   (build-R R R-marks3 #:patch marks3)]
     ;;    ['no-marks (build-R R R-clean)]))
     ;;#:clean
     ;;(λ (file marks)
     ;;  (match marks
     ;;    ['marks2   (delete-directory R-marks2)]
     ;;    ['marks3   (delete-directory R-marks3)]
     ;;    ['no-marks (delete-directory R-clean)]))
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

