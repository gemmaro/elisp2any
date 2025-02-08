require 'strscan'
require 'forwardable'
require_relative 'inline_code'
require "elisp2any/comment"

module Elisp2any
  class Line
    def self.scan(scanner)
      pos = scanner.pos
      comment = Comment.scan(scanner) or return
      unless comment.colons == 2
        scanner.pos = pos
        return
      end
      unless comment.padding[0] == " "
        raise Error, "line comment should have a whitespace padding"
      end
      new(["#{comment.padding[1..]}#{comment.content}"])
    end

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
