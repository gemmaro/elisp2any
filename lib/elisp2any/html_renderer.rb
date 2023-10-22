require 'erb'
require 'forwardable'
require 'cgi/util'
require_relative 'inline_code'
require_relative 'heading'
require_relative 'paragraph'
require_relative 'code_block'

module Elisp2any
  class HTMLRenderer
    def initialize(file)
      @file = file
    end

    def render
      erb_render('index.html.erb')
    end

    private

    def render_paragraph(paragraph)
      html = ''
      paragraph.each do |line|
        line.each do |chunk|
          case chunk
          when InlineCode
            html << "<code>#{h(chunk.content)}</code>"
          when String
            html << h(chunk)
          end
        end
      end
      html
    end

    def render_block(block, level:)
      html = ''
      case block
      when Heading
        name = "h#{level + block.level - 1}"
        html << "<#{name}>#{h(block.content)}</#{name}>"
      when Paragraph
        html << render_paragraph(block)
      when CodeBlock
        html << "<pre><code>#{h(block.content)}</code></pre>"
      end
      html
    end

    def erb_render(path)
      source = ::File.read(::File.join(__dir__, 'html_renderer', path))
      ERB.new(source).result(binding)
    end

    def h(string)
      CGI.escape_html(string)
    end

    extend Forwardable
    def_delegators :@file, :name, :synopsis, :commentary, :code
  end
end
