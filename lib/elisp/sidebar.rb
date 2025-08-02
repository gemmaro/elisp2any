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
