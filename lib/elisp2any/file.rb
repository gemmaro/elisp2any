require_relative 'node'
require_relative 'tree_sitter_parser'

module Elisp2any
  class File
    attr_reader :name, :synopsis, :commentary, :code

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
