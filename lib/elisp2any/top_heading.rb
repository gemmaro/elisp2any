require "elisp2any/heading"

module Elisp2any
  class TopHeading
    attr_reader :content

    def self.scan(scanner)
      pos = scanner.pos
      heading = Heading.scan(scanner)
      unless heading.level.zero?
        scanner.pos = pos
        return
      end
      new(content: heading.content)
    end

    def initialize(content:)
      @content = content
    end
  end
end
