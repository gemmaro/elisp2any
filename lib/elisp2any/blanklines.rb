require "forwardable"

module Elisp2any
  class Blanklines
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      count = 0
      count += 1 while !scanner.eos? && scanner.skip(/ *\n/)
      count.zero? and return
      new(count)
    end

    def initialize(count) # :nodoc:
      @count = count
    end

    extend Forwardable # :nodoc:
    def_delegator :@count, :to_i
  end
end
