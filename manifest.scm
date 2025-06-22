(use-modules (gnu packages))

(specifications->manifest (list "ruby@3.1"
                                "ruby-webrick"
                                "ruby-rubocop"
				                "ruby-asciidoctor"))
