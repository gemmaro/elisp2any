require 'test_helper'

class Elisp2anyTest < ::TestCase
  class BlanklinesTest < ::TestCase
    test "scan" do
      lines = ::Elisp2any::Blanklines.scan("\n")
      assert_instance_of ::Elisp2any::Blanklines, lines
      assert_equal 1, lines.to_i
    end

    test "scan count 2" do
      lines = ::Elisp2any::Blanklines.scan("\n\n")
      assert_instance_of ::Elisp2any::Blanklines, lines
      assert_equal 2, lines.to_i
    end

    test "scan whitespace" do
      lines = ::Elisp2any::Blanklines.scan(" \n")
      assert_instance_of ::Elisp2any::Blanklines, lines
      assert_equal 1, lines.to_i
    end
  end
end
