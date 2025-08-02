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
