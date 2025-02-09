require "forwardable"

module Elisp2any
  class Text
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      tokens = []
      until scanner.eos?
        if scanner.skip(/`(?<content>[^']+)'/)
          tokens << { code: scanner[:content] }
        else
          char = scanner.getch
          case tokens
          in [*, String => last]
            last << char
          else
            tokens << char
          end
        end
      end
      new(tokens)
    end

    def initialize(tokens)
      @tokens = tokens
    end

    extend Forwardable # :nodoc:
    def_delegators :@tokens, :each, :deconstruct

    include Enumerable
  end
end
