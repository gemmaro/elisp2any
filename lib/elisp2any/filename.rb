module Elisp2any
  class Filename
    attr_reader :content

    def self.scan(scanner)
      content = scanner.scan(/[a-z]+[.]el\b/) or return
      new(content:)
    end

    def initialize(content:)
      @content = content
    end
  end
end
