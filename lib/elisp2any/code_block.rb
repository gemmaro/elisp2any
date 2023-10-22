require 'forwardable'

module Elisp2any
  class CodeBlock
    def initialize(node) # :nodoc:
      @node = node
    end

    def append(source, end_byte) # :nodoc:
      @node.append(source, end_byte)
    end

    extend Forwardable
    def_delegators :@node, :content
  end
end
