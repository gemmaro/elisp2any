require_relative 'node'
require_relative 'tree_sitter_parser'
require "elisp2any/header_line"
require "elisp2any/blanklines"
require "elisp2any/commentary"
require "elisp2any/code"

module Elisp2any
  class File
    attr_reader :name, # TODO: filename
                :synopsis, # TODO: header_line, including description
                :commentary, :code

    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      line = HeaderLine.scan(scanner) or return
      Blanklines.scan(scanner) # optional
      commentary = Commentary.scan(scanner)
      Blanklines.scan(scanner) # optional
      code = Code.scan(scanner)
      new(name: line.filename, synopsis: line.description, commentary:, code:)
    end

    def self.parse(source)
      source = source.respond_to?(:read) ? source.read : source
      ts_node = TreeSitterParser.parse(source)
      first_heading, second_heading, *nodes, last_heading = Node.from_tree_sitter(source, ts_node)
      name, synopsis = first_heading.name_and_synopsis
      second_heading.commentary? or raise Error, "no commentary heading: #{second_heading.inspect}"
      commentary = []
      until nodes.empty?
        (node = nodes.shift).code? and break
        commentary << node
      end
      code = nodes
      last_heading.final_name == name or raise Error, 'different names'
      new(name: name, synopsis: synopsis, commentary: commentary, code: code)
    end

    def initialize(name:, synopsis:, commentary:, code:) # :nodoc:
      @name = name
      @synopsis = synopsis
      @commentary = commentary
      @code = code
    end
  end
end
