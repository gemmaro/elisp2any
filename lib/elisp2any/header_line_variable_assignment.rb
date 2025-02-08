require "elisp2any/variable"
require "elisp2any/expression"

module Elisp2any
  class HeaderLineVariableAssignment
    attr_reader :variable, :expression

    def self.scan(scanner)
      pos = scanner.pos
      variable = Variable.scan(scanner) or return
      unless scanner.skip(/ *: */)
        scanner.pos = pos
        return
      end
      unless (expression = Expression.scan(scanner))
        scanner.pos = pos
        return
      end
      new(variable: variable.name, expression: expression.content)
    end

    def initialize(variable:, expression:)
      @variable = variable
      @expression = expression
    end
  end
end
