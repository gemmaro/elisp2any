require 'forwardable'

module Elisp2any
  class CodeBlock # :nodoc:
    def initialize(node) # :nodoc:
      @node = node
    end

    def append(source, end_byte) # :nodoc:
      @node.append(source, end_byte)
    end

    extend Forwardable # :nodoc:
    def_delegators :@node, :content
  end
end
