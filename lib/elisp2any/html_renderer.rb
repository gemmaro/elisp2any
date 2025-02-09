require 'erb'
require 'forwardable'
require 'cgi/util'
require_relative 'inline_code'
require_relative 'heading'
require_relative 'paragraph'
require_relative 'codeblock'

module Elisp2any
  class HTMLRenderer
    def initialize(file, css: nil, mode:)
      @file = file
      @css = css || "https://unpkg.com/mvp.css"
      @mode = mode
    end

    # Write gradually?
    def render(node = nil)
      if node
        case node
        in Paragraph
          par = node.sum(+"") { |line| render(line) }
          "<p>#{par}</p>"
        in Line
          begin
            node.sum(+"") { |chunk| render(chunk) }
          rescue => e
            warn node.inspect
            raise e
          end
        in String
          h(node)
        in [] # huh?  nop.
        in Section
          result = render(node.heading)
          node.blocks.each { |blo| result << render(blo) }
          node.sections.each { |sec| result << render(sec) }
          result
        in Heading[level:, content:]
          lev = level + 2
          "<h#{lev}>#{render(content)}</h#{lev}>"
        in Codeblock
          "<pre><code>#{h(node.source.chomp)}</code></pre>"
        in { code: }
          "<code>#{h(code)}</code>"
        in Hash
          result = node.sum(+"<dl>") do |key, value|
            "<dt>#{render(key)}</dt><dd>#{render(value)}</dd>"
          end
          "#{result}</dl>"
        in Expression
          "<code>#{h(node.source)}</code>"
        in Text
          node.sum(+"") { |ele| render(ele) }
        else
          raise Error, node.inspect
        end
      else
        case @mode
        in :old
          erb_render('index.html.erb')
        in :new
          source = ::File.read(::File.join(__dir__, 'html_renderer.erb'))
          ERB.new(source).result(binding)
        end
      end
    end

    private

    def render_paragraph(paragraph)
      html = ''
      paragraph.each do |line|
        line.each do |chunk|
          case chunk
          in InlineCode
            html << "<code>#{h(chunk.content)}</code>"
          in String
            html << h(chunk)
          in { code: }
            html << "<code>#{h(code)}</code>"
          else
            raise Error, chunk.inspect
          end
        end
      end
      html
    end

    # TODO: remove level
    def render_block(block, level: nil)
      html = ''
      case block
      when Heading
        lev = level
        if level
          lev = level + block.level - 1
        else
          lev = block.level
        end
        name = "h#{lev}"
        html << "<#{name}>#{h(block.content)}</#{name}>"
      when Paragraph
        html << render_paragraph(block)
      when Codeblock
        html << "<pre><code>#{h(block.content)}</code></pre>"
      when [] # huh?  nop
      when Section
        render_block(block.heading)
        block.blocks.each do |blo|
          render_block(blo)
        end
        block.sections.each do |sec|
          render_block(sec)
        end
      else
        raise Error, block.inspect
      end
      html
    end

    def erb_render(path)
      source = ::File.read(::File.join(__dir__, 'html_renderer', path))
      ERB.new(source).result(binding)
    end

    def h(arg)
      case arg
      in String
        CGI.escape_html(arg)
      in Array
        arg.map do |ele|
          h(ele)
        end.join
      in Symbol
        h(arg.to_s)
      in Expression
        h(arg.source)
      in Integer
        h(arg.to_s)
      in Aside
        h(arg.content)
      end
    end

    extend Forwardable # :nodoc:
    def_delegators :@file, :name, :synopsis, :commentary, :code, :header_line
  end
end
