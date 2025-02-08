require 'strscan'
require 'forwardable'

module Elisp2any
  class Heading
    attr_reader :level, :content

    def self.scan(scanner)
      pos = scanner.pos
      comment = Comment.scan(scanner) or return
      unless comment.colons >= 3
        scanner.pos = pos
        return
      end
      new(:TODO, comment.colons - 3, comment.content)
    end

    # TODO
    def initialize(node, level, content) # :nodoc:
      @node = node
      @level = level
      @content = content
    end

    # Returns nil if failed
    def name_and_synopsis # :nodoc:
      scanner = StringScanner.new(@content)
      name = scanner.scan_until(/\.el/) or return
      name = name[nil...-3] or return
      scanner.skip(/\s+---\s+/) or return
      scanner.skip(/(?<synopsis>.+?)(:?\s+-\*- .+? -\*-)?\Z/) or return
      synopsis = scanner[:synopsis]
      return name, synopsis
    end

    def commentary? # :nodoc:
      @level == 1 && @content == 'Commentary:'
    end

    def code? # :nodoc:
      @level == 1 && @content == 'Code:'
    end

    def final_name # :nodoc:
      @content.match(/\A(?<name>.+?)\.el ends here\Z/)[:name]
    end

    extend Forwardable
    def_delegator :@level, :<=>
  end
end
