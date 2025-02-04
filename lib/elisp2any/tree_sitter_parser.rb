require 'tree_sitter'

module Elisp2any
  class TreeSitterParser # :nodoc:
    def self.parse(source)
      new(source).parse
    end

    def parse
      @node = parser.parse_string(nil, @source).root_node
    end

    private

    def initialize(source)
      @source = source
    end

    def parser
      TreeSitter::Parser.new.tap do |p|
        p.language = TreeSitter::Language.load('elisp', elisp_library)
      end
    end

    def elisp_library
      shared_object = 'libtree-sitter-elisp.so'

      # Set this env var for Guix shell environment or shared object file is not found
      if ENV['ELISP2ANY_GUIX_USE_PROFILE_PATH']
        shared_object = ::File.join(ENV["GUIX_ENVIRONMENT"], "lib/tree-sitter", shared_object)
      end

      shared_object
    end
  end
end
