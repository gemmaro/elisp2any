# Copyright (C) 2025  gemmaro
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
        <pre class="code"><code>#{content}</code></pre>
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
require_relative "elisp/heading"
require_relative "elisp/doc_string_parser"
