require 'strscan'
require 'forwardable'
require_relative 'inline_code'

module Elisp2any
  class Line
    def initialize(chunks) # :nodoc:
      @chunks = chunks
    end

    def self.parse(string) # :nodoc:
      scanner = StringScanner.new(string)
      chunks = []

      until scanner.eos?
        if scanner.skip(/`(?<content>[^']+)'/)
          chunks << InlineCode.new(scanner[:content])
        else
          chunk = scanner.getch
          if (last = chunks.last).is_a?(String)
            last << chunk
          else
            chunks << chunk
          end
        end
      end

      new(chunks)
    end

    extend Forwardable
    def_delegators :@chunks, :each

    include Enumerable
  end
end
