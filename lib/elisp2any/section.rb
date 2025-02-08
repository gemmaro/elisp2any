require "elisp2any/heading"
require "elisp2any/paragraph"
require "elisp2any/blanklines"

module Elisp2any
  class Section
    attr_reader :heading

    def self.scan(scanner)
      heading = Heading.scan(scanner) or return
      Blanklines.scan(scanner) # optional
      paragraphs = []
      while (par = Paragraph.scan(scanner))
        paragraphs << par
        Blanklines.scan(scanner) # optional
      end
      new(heading:, paragraphs:)
    end

    def initialize(heading:, paragraphs:)
      @heading = heading
      @paragraphs = paragraphs
    end
  end
end
