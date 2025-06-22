require "test/unit"
require_relative "../../lib/elisp"

class TestPageDelimiter < Test::Unit::TestCase
  def test_html_returns_hr_tag
    delimiter = Elisp::PageDelimiter.new
    assert_equal "<hr>", delimiter.html
  end
end
