class Elisp::Parser
  HEADER_LINE = %r{
    ;;;[ ]
    (?<title>[a-z]+[.]el)[ ]---[ ](?<desc>.*?)
    (?:[ ]+-[*]-[ ](?<vars>lexical-binding:[ ]?t);?[ ]-[*]-)?
    \n+
  }x
  COMMENT = / *;; (?<comment>.*)\n/
  CODE = %r{
    (?<content>
      (?:
        [A-Za-z0-9&,.:=?_#'`<>()\[\]\t +*/-]
        | [?]\\.
        | "(?:[^\\"]|\\(?:.|\n))*"
      )+?
      (?:[ ]*;.*)?
      | ;;;[#][#][#]autoload.*
    )
    \n
  }x
  BLANKLINES = /\n+/
  CODE_OR_BLANKLINES = Regexp.union(CODE, BLANKLINES)
  DEFAULT_CSS = <<~END_CSS
    <style>
      :root {
        --sidebar-width: 200px;
      }
      body {
        display: flex;
      }
      main {
        max-width: 80rem;
        margin: auto auto auto var(--sidebar-width);
        padding-left: 0.5rem;
        border-box: box-sizing;
      }
      .sidebar {
        padding-right: 0.5rem;
        width: var(--sidebar-width);
        position: fixed;
        boxed-sizing: border-box;
        overflow-y: auto;
        height: 100%;
      }
      .sidebar details ul {
        position: relative;
        left: -1.5rem;
      }
      .description {
        font-style: italic;
      }
      pre {
        font-family: serif;
      }
      pre[class="code"] {
        border-left: solid;
        padding-left: 0.5rem;
        white-space: pre-wrap;
      }
    </style>
  END_CSS
  HEADING = %r{
    ;;;(?<level>;*)[ ](?<title>.+)\n
    (?:(?:;;)?\n)*
  }x

  def initialize(input)
    @scanner = StringScanner.new(input.read)
    @state = :start
    @nodes = []
  end

  def parse
    until @scanner.eos?

      if @state == :start && @scanner.skip(HEADER_LINE)
        @nodes << Elisp::Heading.new(@scanner[:title], level: 1)
        @nodes << Elisp::Desc.new(@scanner[:desc])
        @nodes << Elisp::Variables.new(@scanner[:vars])
        @state = :after_header_line

      elsif [:after_header_line,
             :after_major_para,
             :after_minor_para,
             :after_code,
             :after_page_delimiter,
             :after_heading].include?(@state) &&
            @scanner.skip(HEADING)
        level = @scanner[:level].size
        title = @scanner[:title]
        if level.zero?
          if ["Commentary:", "Code:"].include?(title)
            title.chop!
          elsif title.match?(/[a-z]+[.]el ends here/)
            next  # validate file name?
          end
        end
        @nodes << Elisp::Heading.new(title, level: level + 2)
        @state = :after_heading

      elsif [:after_heading,
             :after_major_para,
             :after_minor_para,
             :after_code,
             :after_header_line].include?(@state) &&
            @scanner.skip(COMMENT)
        @nodes << Elisp::Comment.new(@scanner[:comment])
        @state = :after_comment

      elsif @state == :after_comment && @scanner.skip(";;\n")
        @nodes[-1] = @nodes.last.to_minor_para
        @state = :after_minor_para

      elsif @state == :after_comment && @scanner.skip(COMMENT)
        @nodes.last << @scanner[:comment]

      elsif @state == :after_comment && @scanner.skip(BLANKLINES)
        make_major_para
        @state = :after_major_para

      elsif [:after_major_para, :after_page_delimiter, :after_heading].include?(@state) &&
            @scanner.skip(CODE)
        @nodes << Elisp::Code.new(@scanner[:content])
        @state = :after_code

      elsif @state == :after_comment && @scanner.skip(CODE)
        make_major_para
        @nodes << Elisp::Code.new(@scanner[:content])
        @state = :after_code

      elsif @state == :after_code && @scanner.skip(CODE_OR_BLANKLINES)
        @nodes.last << @scanner[:content]

      elsif @state == :after_code && @scanner.skip(/\f\n+/)
        @nodes << Elisp::PageDelimiter.new
        @state = :after_page_delimiter

      else
        raise Elisp::Error, <<~MESSAGE
          parse failed
          --- rest line (#{@state}) ---
          #{@scanner.rest.lines.first.inspect}
          --- scanner ---
          #{@scanner.inspect}
        MESSAGE
      end
    end
    self
  end

  def make_major_para
    paras = [@nodes.pop.to_minor_para]
    while (node = @nodes.pop)
      if node.is_a?(Elisp::MinorPara)
        paras.unshift(node)
      else
        @nodes.push(node)
        break
      end
    end
    @nodes << Elisp::MajorPara.new(paras)
  end

  def write(output, css: nil)
    css = css ? %(<link rel="stylesheet" href="#{CGI.escape(css)}">) : DEFAULT_CSS
    sidebar = Elisp::Sidebar.new(@nodes.select { |node| node.is_a?(Elisp::Heading) \
                                                          && node.level >= 2 })
                .html
    body = @nodes.map(&:html).join("\n")
    output.write(<<~END_HTML)
      <!doctype html>
      <html>
        <head>
          #{css}
          <meta charset="utf8">
        </head>
        <body>
          <nav class="sidebar">
            #{sidebar}
          </nav>
          <main>
            #{body}
          </main>
        </body>
      </html>
    END_HTML
  end
end
