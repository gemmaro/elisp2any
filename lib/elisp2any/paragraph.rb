require 'forwardable'
require "elisp2any/line"

module Elisp2any
  class Paragraph
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      lines = []
      while (line = Line.scan(scanner))
        lines << line
      end
      lines.empty? and return
      new(:TODO, lines, :TODO)
    end

    # TODO: delete
    attr_reader :end_row # :nodoc:

    # TODO: delete node and end_row
    def initialize(node, lines, end_row) # :nodoc:
      @node = node
      @lines = lines
      @end_row = end_row
    end

    # TODO: delete
    def code?
      false
    end

    extend Forwardable # :nodoc:
    def_delegators :@lines, :empty?, :clear, :<<, :each, :deconstruct, :size
    def_delegators :@node, :adjucent?

    include Enumerable
  end
end
