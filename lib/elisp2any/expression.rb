module Elisp2any
  class Expression
    attr_reader :content

    def self.scan(scanner)
      content = scanner.scan(/t\b/) or return
      new(content:)
    end

    def initialize(content:)
      @content = content
    end
  end
end
