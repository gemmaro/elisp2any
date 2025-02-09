require "forwardable"
require "elisp2any/paragraph"
require "elisp2any/blanklines"
require "elisp2any/section"

module Elisp2any
  class Code
    def self.scan(scanner)
      pos = scanner.pos
      heading = Elisp2any.scan_top_heading(scanner) or return
      unless heading == "Code:"
        scanner.pos = pos
        return
      end
      Blanklines.scan(scanner) # optional
      paragraphs = []
      while (par = Paragraph.scan(scanner))
        paragraphs << par
        Blanklines.scan(scanner) # optional
      end
      blocks = [paragraphs]
      pos = scanner.pos
      while (section = Section.scan(scanner))
        if section.heading.level == 1
          blocks << section
          pos = scanner.pos
        else
          scanner.pos = pos
          break
        end
      end
      new(blocks)
    end

    def initialize(blocks)
      @blocks = blocks
    end

    def sections
      @blocks.drop(1)
    end

    extend Forwardable # :nodoc:
    def_delegator :@blocks, :first, :paragraphs
    def_delegator :@blocks, :each

    include Enumerable
  end
end
