require "elisp2any/variable"
require "elisp2any/expression"
require "elisp2any/header_line_variable_assignment"

module Elisp2any
  class HeaderLineVariables
    attr_reader :variables

    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:pos)
      pos = scanner.pos
      scanner.skip(/ *-[*]- +/) or return
      variables = {}
      until scanner.skip(/ +-[*]- */)
        if scanner.eos?
          scanner.pos = pos
          return
        elsif (assign = HeaderLineVariableAssignment.scan(scanner))
          variables[assign.variable] = assign.expression
        elsif scanner.skip(";")
          break
        else
          raise scanner.inspect
        end
      end
      new(variables:)
    end

    def initialize(variables:)
      @variables = variables
    end
  end
end
