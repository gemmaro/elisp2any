require "elisp2any/comment"
require "elisp2any/filename"
require "elisp2any/header_line_variables"

module Elisp2any
  class HeaderLine
    attr_reader :filename, :description, :variables

    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:pos)
      pos = scanner.pos
      unless (heading = TopHeading.scan(scanner))
        scanner.pos = pos
        return
      end
      cscanner = StringScanner.new(heading.content)
      unless (filename = Filename.scan(cscanner))
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
        if (variables = HeaderLineVariables.scan(cscanner)) # nop
          break
        else
          description << cscanner.getch
        end
      end
      if description.empty?
        scanner.pos = pos
        return
      end
      new(filename: filename.content, description:, variables: variables.variables)
    end

    def initialize(filename:, description:, variables:)
      @filename = filename
      @description = description
      @variables = variables
    end
  end
end
