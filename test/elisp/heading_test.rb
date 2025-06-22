require "test/unit"
require_relative "../../lib/elisp"

class TestElispHeading < Test::Unit::TestCase
  def test_initialize_sets_content_and_default_level
    heading = Elisp::Heading.new("My Heading")
    assert_equal "My Heading", heading.content
    assert_equal 2, heading.level
  end

  def test_initialize_sets_custom_level
    heading = Elisp::Heading.new("Another Heading", level: 3)
    assert_equal "Another Heading", heading.content
    assert_equal 3, heading.level
  end
end
