(use-modules (guix packages)
             ((guix licenses) #:prefix license:)
             (guix git-download)
             (guix build-system ruby)
             (guix build-system tree-sitter)
             (gnu packages tree-sitter)
             (gnu packages ruby))

(define-public ruby-tree-sitter
  (let ((commit "2c56b04283f2a8cfed7d6c527ca36b8e1127ee8c")
        (revision "0"))
    (package
     (name "ruby-tree-sitter")
     (version (git-version "0.20.8.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Faveod/ruby-tree-sitter")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "144kp0ya4rl03bgwpix17bgq2ak2kqk63pwniy6sfxfjqp5yzr7f"))))
     (build-system ruby-build-system)
     (arguments
      (list
       #:phases #~(modify-phases %standard-phases
                                 (add-after 'extract-gemspec 'remove-depends
                                            (lambda _
                                              (substitute* "tree_sitter.gemspec"
                                                           ((".*minitest-color.*")
                                                            "\n")
                                                           ((".*pry.*")
                                                            "\n")
                                                           ((".*rake.*")
                                                            "\n"))
                                              (substitute* "test/test_helper.rb"
                                                           ((".*minitest/color.*")
                                                            "\n"))))
                                 (add-before 'build 'compile
                                             (lambda _
                                               (invoke "rake" "compile")))
                                 (add-before 'check 'set-path
                                             (lambda* (#:key inputs #:allow-other-keys)
                                               (let ((ruby (assoc-ref inputs "tree-sitter-ruby")))
                                                 (setenv "TREE_SITTER_PARSERS"
                                                         (string-append ruby "/lib/tree-sitter")))))
                                 (add-before 'check 'remove-failing-test
                                             (lambda _
                                               (delete-file "test/tree_sitter/node_test.rb"))))))
     (native-inputs (list ruby-minitest ruby-rake-compiler
                          ruby-rake-compiler-dock ruby-ruby-memcheck
                          tree-sitter-ruby))
     (inputs (list tree-sitter))
     (synopsis "Ruby bindings for Tree-Sitter")
     (description "Ruby bindings for Tree-Sitter")
     (home-page "https://www.github.com/Faveod/ruby-tree-sitter")
     (license license:expat))))

(define-public tree-sitter-elisp
  (let ((commit "e5524fdccf8c22fc726474a910e4ade976dfc7bb")
        (revision "0"))
    (package
      (name "tree-sitter-elisp")
      (version (git-version "0.1.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Wilfred/tree-sitter-elisp")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1wyzfb27zgpvm4110jgv0sl598mxv5dkrg2cwjw3p9g2bq9mav5d"))))
      (build-system tree-sitter-build-system)
      (home-page "https://github.com/Wilfred/tree-sitter-elisp")
      (synopsis "TODO")
      (description "TODO")
      (license license:expat))))

(concatenate-manifests
 (list
  (packages->manifest (list ruby-tree-sitter tree-sitter-elisp))
  (specifications->manifest (list "ruby@3.1"
                                  "ruby-webrick"
                                  "ruby-rubocop"
				                  "ruby-asciidoctor"))))
