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
