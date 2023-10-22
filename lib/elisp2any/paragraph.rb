require 'forwardable'

module Elisp2any
  class Paragraph
    attr_reader :end_row # :nodoc:

    def initialize(node, lines, end_row) # :nodoc:
      @node = node
      @lines = lines
      @end_row = end_row
    end

    def code?
      false
    end

    extend Forwardable
    def_delegators :@lines, :empty?, :clear, :<<, :each
    def_delegators :@node, :adjucent?

    include Enumerable
  end
end
