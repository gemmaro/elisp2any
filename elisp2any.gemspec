require_relative 'lib/elisp2any/version'

Gem::Specification.new do |spec|
  spec.name = 'elisp2any'
  spec.version = Elisp2any::VERSION
  spec.authors = ['gemmaro']
  spec.email = ['gemmaro.dev@gmail.com']

  spec.summary = 'Converter from Emacs Lisp to some document markup'
  spec.description = 'elisp2any is a command line tool and library for converting Emacs Lisp source to some document markup, such as HTML or AsciiDoc.'
  spec.required_ruby_version = '>= 2.6.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'ruby_tree_sitter', '~> 0.20.8.1'
  spec.add_development_dependency 'webrick'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'asciidoctor'
end
