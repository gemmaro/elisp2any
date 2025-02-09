require "elisp2any/comment"
require "elisp2any/expression"

module Elisp2any
  class HeaderLine
    attr_reader :filename, :description, :variables

    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:pos)
      pos = scanner.pos
      unless (heading = Elisp2any.scan_top_heading(scanner))
        scanner.pos = pos
        return
      end
      cscanner = StringScanner.new(heading)
      unless (filename = Elisp2any.scan_filename(cscanner))
        scanner.pos = pos
        return
      end
      unless cscanner.skip(/ +--- +/)
        scanner.pos = pos
        return
      end
      description = +""
      variables = nil
      until cscanner.eos?
        if (variables = scan_variables(cscanner)) # nop
          break
        else
          description << cscanner.getch
        end
      end
      if description.empty?
        scanner.pos = pos
        return
      end
      new(filename:, description:, variables:)
    end

    def self.scan_variables(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:pos)
      scanner.skip(/ *-[*]- +/) or return
      variables = {}
      until scanner.skip(/ +-[*]- */)
        if scanner.eos?
          raise Error, "unexpected end"
        elsif (assign = scan_assignments(scanner))
          variables[assign[:variable]] = assign[:expression]
        elsif scanner.skip(";")
          break
        else
          raise Error, scanner.inspect
        end
      end
      variables
    end
    private_class_method :scan_variables

    def self.scan_assignments(scanner)
      pos = scanner.pos
      variable = Elisp2any.scan_variable(scanner) or return
      unless scanner.skip(/ *: */)
        scanner.pos = pos
        return
      end
      unless (expression = Expression.scan(scanner))
        scanner.pos = pos
        return
      end
      { variable:, expression: }
    end
    private_class_method :scan_assignments

    def initialize(filename:, description:, variables:)
      @filename = filename
      @description = description
      @variables = variables
    end
  end
end
