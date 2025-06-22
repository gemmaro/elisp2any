require "strscan"
require "cgi"
require "uri"

class Elisp
  Error = Class.new(StandardError)

  def self.parse(input)
    Elisp::Parser.new(input).parse
  end
end

class Elisp::PageDelimiter
  def html = "<hr>"
end

class Elisp::Desc
  def initialize(content)
    @content = content
  end

  def html
    content = CGI.escape_html(@content)
    %(<p class="description">#{content}</p>)
  end
end

class Elisp::Variables
  def initialize(content)
    @content = content
  end

  def html
    content = CGI.escape_html(@content)
    <<~END_HTML
      <article>
        Header line variables:
        <pre><code>#{content}</code></pre>
      </article>
    END_HTML
  end
end

class Elisp::MajorPara
  def initialize(paras)
    @paras = paras
  end

  def html
    paras = @paras.map(&:html).join("\n")
    "<article>#{paras}</article>"
  end
end

class Elisp::MinorPara
  def initialize(content)
    @content = content
  end

  def html
    content = Elisp::DocStringParser.new(@content).html
    "<pre>#{content}</pre>"
  end
end

class Elisp::Code
  def initialize(content)
    @content = content
  end

  def <<(content)
    @content << "\n#{content}"
  end

  def html
    content = CGI.escape_html(@content)
    %(<pre class="code"><code>#{content}</code></pre>)
  end
end

require_relative "elisp/comment"
require_relative "elisp/parser"
require_relative "elisp/sidebar"
require_relative "elisp/heading"
