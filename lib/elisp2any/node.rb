require_relative 'code_block'
require_relative 'line'
require_relative 'heading'
require_relative 'paragraph'
require 'strscan'

module Elisp2any
  class Node
    attr_reader :range # :nodoc:
    attr_reader :content

    def self.from_tree_sitter(source, ts_node) #:nodoc:
      nodes = []
      (0 ... ts_node.child_count).map { |index| ts_node[index] }.each do |top_level_node|
        range = top_level_node.start_byte .. top_level_node.end_byte
        content = source.byteslice(range)
        node = Node.new(content, range)
        case top_level_node.type
        when :comment
          scanner = StringScanner.new(content)
          scanner.skip(';') or raise Error, 'no semicolon for comment'
          unless scanner.skip(';')
            (last_node = nodes.last) && last_node.is_a?(CodeBlock) or raise Error, 'no prior code for single semicolon comment'
            last_node.append(source, range.end)
            next
          end

          if (level = scanner.skip(/;+/))
            scanner.skip(' ') or raise Error, 'no space after heading semicolons'
            nodes << Heading.new(node, level, scanner.rest.chomp)
          elsif scanner.skip("\n")
            # nop
          else
            scanner.skip(' ') or raise Error, "no space after semicolons: #{scanner.inspect}"
            line = Line.parse(scanner.rest)
            if (last_node = nodes.last) && last_node.is_a?(Paragraph) && last_node.end_row + 1 == top_level_node.start_point.row
              last_node << line
            else
              paragraph = Paragraph.new(node, [line], top_level_node.end_point.row)
              nodes << paragraph
            end
          end
        else
          if (last_node = nodes.last) && last_node.is_a?(CodeBlock)
            last_node.append(source, range.end)
          else
            nodes << CodeBlock.new(node)
          end
        end
      end
      nodes
    end

    def append(source, end_byte) # :nodoc:
      @range = range = @range.begin .. end_byte
      @content = source.byteslice(range)
    end

    def initialize(content, range) # :nodoc:
      @content = content
      @range = range
    end
  end
end
