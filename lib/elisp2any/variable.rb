module Elisp2any
  class Variable
    attr_reader :name

    def self.scan(scanner)
      name = scanner.scan(/[a-z-]+/) or return
      new(name:)
    end

    def initialize(name:)
      @name = name
    end
  end
end
