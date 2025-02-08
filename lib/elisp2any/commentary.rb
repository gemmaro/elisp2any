require "elisp2any/top_heading"
require "elisp2any/paragraph"
require "elisp2any/blanklines"

module Elisp2any
  class Commentary
    attr_reader :paragraphs

    def self.scan(scanner)
      pos = scanner.pos
      heading = TopHeading.scan(scanner) or return
      unless heading.content == "Commentary:"
        scanner.pos = pos
        return
      end
      Blanklines.scan(scanner) # optional
      paragraphs = []
      while (par = Paragraph.scan(scanner))
        paragraphs << par
        Blanklines.scan(scanner) # optional
      end
      new(paragraphs:)
    end

    def initialize(paragraphs:)
      @paragraphs = paragraphs
    end
  end
end
