require "forwardable"
require "elisp2any/heading"
require "elisp2any/blanklines"
require "elisp2any/text"

module Elisp2any
  class Section
    attr_reader :heading,
                # TODO: gather blocks and sections
                :blocks,
                :sections

    def self.scan(scanner)
      heading = Heading.scan(scanner) or return
      heading.content = Text.scan(heading.content)
      Blanklines.scan(scanner) # optional
      blocks = []
      while (blo = Paragraph.scan(scanner) || Codeblock.scan(scanner))
        blocks << blo
        Blanklines.scan(scanner) # optional
      end
      pos = scanner.pos
      sections = []
      while (section = scan(scanner))
        if section.level == heading.level + 1
          sections << section
          pos = scanner.pos
        elsif section.level >= heading.level + 2
          raise Error, "too demoted heading"
        else
          scanner.pos = pos
          break
        end
      end
      new(heading:, blocks:, sections:)
    end

    def initialize(heading:, blocks:, sections:)
      @heading = heading
      @blocks = blocks
      @sections = sections
    end

    alias paragraphs blocks # TODO: delete

    extend Forwardable # :nodoc:
    def_delegator :@heading, :level
  end
end
