require "forwardable"
require "elisp2any/paragraph"
require "elisp2any/blanklines"

module Elisp2any
  class Commentary
    def self.scan(scanner)
      pos = scanner.pos
      heading = Elisp2any.scan_top_heading(scanner) or return
      unless heading == "Commentary:"
        scanner.pos = pos
        return
      end
      Blanklines.scan(scanner) # optional
      paragraphs = []
      while (par = Paragraph.scan(scanner))
        paragraphs << par
        Blanklines.scan(scanner) # optional
      end
      new(paragraphs)
    end

    def initialize(paragraphs)
      @paragraphs = paragraphs
    end

    extend Forwardable # :nodoc:
    def_delegators :@paragraphs, :each, :size

    include Enumerable
  end
end
