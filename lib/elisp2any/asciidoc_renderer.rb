require 'forwardable'

module Elisp2any
  # This renderer is experimental.
  class AsciiDocRenderer
    def initialize(file)
      @file = file
    end

    def render
      erb_renderer('index.adoc.erb')
    end

    private

    def render_paragraph(paragraph)
      adoc = ''
      paragraph.each do |line|
        line.each do |chunk|
          case chunk
          when InlineCode
            adoc << "``#{chunk.content}``"
          when String
            adoc << chunk
          end
        end
      end
      adoc
    end

    def render_block(block, level:)
      adoc = ''
      case block
      when Heading
        prefix = '=' * (level + block.level - 1)
        adoc << "#{prefix} #{block.content}"
      when Paragraph
        adoc << render_paragraph(block)
      when CodeBlock
        adoc << <<~ADOC
          ----
          #{block.content}
          ----
        ADOC
      end
      adoc
    end

    def erb_renderer(path)
      source = ::File.read(::File.join(__dir__, 'asciidoc_renderer', path))
      ERB.new(source).result(binding)
    end

    extend Forwardable
    def_delegators :@file, :name, :synopsis, :commentary, :code
  end
end
