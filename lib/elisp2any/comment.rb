module Elisp2any
  class Comment
    attr_reader :colons, :content, :padding

    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      scanner.skip(/(?<colons>;+)(?<padding> *)(?<content>.*)\n?/) or return
      new(colons: scanner[:colons].size, content: scanner[:content], padding: scanner[:padding])
    end

    def initialize(colons:, content:, padding:)
      @colons = colons
      @content = content
      @padding = padding
    end
  end
end
