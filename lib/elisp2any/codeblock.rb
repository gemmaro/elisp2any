require "forwardable"
require "elisp2any/expression"
require "elisp2any/blanklines"
require "elisp2any/aside"

module Elisp2any
  class Codeblock # :nodoc:
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      expressions = []
      while (exp = Expression.scan(scanner) ||
                   scanner.scan(/[ \n]+/) ||
                   Aside.scan(scanner))
        expressions << exp
      end
      expressions.empty? and return
      Blanklines.scan(scanner) # optional
      new(:TODO, expressions:)
    end

    def source
      @expressions.sum(+"") do |exp|
        case exp
        in String
          exp
        else
          exp.source
        end
      end
    end

    # TODO: delete node
    # TODO: Remove default empty array
    def initialize(node, expressions: []) # :nodoc:
      @node = node
      @expressions = expressions
    end

    def append(source, end_byte) # :nodoc:
      @node.append(source, end_byte)
    end

    def content
      if @node.respond_to?(:content)
        @node.content
      else
        @expressions
      end
    end

    extend Forwardable # :nodoc:
    def_delegator :@expressions, :each

    include Enumerable
  end
end
