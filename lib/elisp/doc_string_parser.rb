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
require "uri"
require "strscan"

class Elisp::DocStringParser
  URI_PATTERN = URI.regexp
  URI_PATTERN_WITH_ANGLES = /[<](?<uri>#{ URI_PATTERN })[>]/
  EMAIL = Regexp.new(URI::MailTo::EMAIL_REGEXP.to_s
                       .sub(/\A[(][?]-mix:\\A/, "(?-mix:")
                       .sub(/\\z[)]\z/, ")"))
  EMAIL_WITH_ANGLES = /[<](?<address>#{ EMAIL })[>]/

  def initialize(source)
    @scanner = StringScanner.new(source)
  end

  def html
    result = +""
    normal = +""
    until @scanner.eos?
      if @scanner.skip(/[`](?<code>[A-Za-z!.-]+)[']/)
        result << normal
        normal.clear
        code = CGI.escape_html(@scanner[:code])
        result << "<code>#{code}</code>"
        normal.clear
      elsif @scanner.skip(/\\\\=(?<quote>['`])/)
        normal << @scanner[:quote]
      elsif (uri = scan_http_uri)
        result << normal
        normal.clear
        result << html_url(uri)
      elsif (address = scan_email)
        result << normal
        normal.clear
        uri = CGI.escape(address)
        address = CGI.escape_html(address)
        result << %(<a href="mailto:#{uri}">#{address}</a>)
      elsif @scanner.skip(/Copyright [(]C[)]/)
        result << "Copyright &copy;"
      else
        normal << @scanner.getch
      end
    end
    result << normal
    normal.clear
    result
  end

  def scan_email
    if (address = @scanner.scan(EMAIL))
      address
    elsif @scanner.skip(EMAIL_WITH_ANGLES)
      @scanner[:address]
    else
      return
    end
  end

  def scan_http_uri
    if (uri = @scanner.scan(URI_PATTERN))
    elsif @scanner.skip(URI_PATTERN_WITH_ANGLES)
      uri = @scanner[:uri]
    else
      return
    end
    uri = URI(uri)
    unless uri.is_a?(URI::HTTP)
      @scanner.unscan
      return
    end
    uri
  end

  def html_url(url)
    url = url.to_s
    ref = CGI.escape(url)
    label = CGI.escape_html(url)
    %(<a class="pure-url" href="#{ref}">#{label}</a>)
  end
end
