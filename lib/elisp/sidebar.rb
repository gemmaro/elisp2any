require "cgi"

class Elisp::Sidebar
  def initialize(headings)
    @headings = headings
  end

  def html
    rest = @headings.dup
    result = +""
    while (head = rest.shift)
      level = head.level
      subheadings = []
      while (heading = rest.shift)
        if heading.level > level
          subheadings << heading
        else
          rest.unshift(heading)
          break
        end
      end
      sub_sidebar =
        subheadings.empty? ? nil
          : (html = self.class.new(subheadings).html
            "<details open>#{html}</details>")
      content = CGI.escape_html(head.content)
      result << <<~END_HTML
        <li>
          <a href="##{head.html_id}">#{content}</a>
          #{sub_sidebar}
        </li>
      END_HTML
    end
    "<ul>#{result}</ul>"
  end
end
