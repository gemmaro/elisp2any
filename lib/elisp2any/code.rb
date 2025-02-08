require "elisp2any/top_heading"
require "elisp2any/paragraph"
require "elisp2any/blanklines"
require "elisp2any/section"

module Elisp2any
  class Code
    attr_reader :paragraphs, :sections

    def self.scan(scanner)
      pos = scanner.pos
      heading = TopHeading.scan(scanner) or return
      unless heading.content == "Code:"
        scanner.pos = pos
        return
      end
      Blanklines.scan(scanner) # optional
      paragraphs = []
      while (par = Paragraph.scan(scanner))
        paragraphs << par
        Blanklines.scan(scanner) # optional
      end
      section = Section.scan(scanner)
      unless section.heading.level == 1
        raise "TODO"
      end
      new(paragraphs:, sections: [section])
    end

    def initialize(paragraphs:, sections:)
      @paragraphs = paragraphs
      @sections = sections
    end
  end
end
