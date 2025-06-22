require "cgi"

class Elisp::Heading
  attr_reader :level, :content

  def initialize(content, level: 2)
    @content = content
    @level = level
  end

  def html
    name = "h#{@level}"
    content = CGI.escape_html(@content)
    <<~END_HTML
      <#{name} id="#{html_id}">
        #{content}
        <a href="##{html_id}">#</a>
      </#{name}>
    END_HTML
  end

  def html_id
    content = CGI.escape(@content)
    "#{@level}-#{content}"
  end
end
