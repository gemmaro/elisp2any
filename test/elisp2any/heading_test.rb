require 'test_helper'

module Elisp2any
  class HeadingTest < ::TestCase
    test "scan" do
      scanner = StringScanner.new(";;; Commentary:\n")
      heading = ::Elisp2any::Heading.scan(scanner)
      assert_instance_of ::Elisp2any::Heading, heading
      assert_equal 0, heading.level
      assert_equal "Commentary:", heading.content
      assert scanner.eos?
    end
  end
end
