require 'test_helper'

module Elisp2any
  class ParagraphTest < ::TestCase
    test "scan" do
      source = <<~ELISP
        ;; This is my Emacs configuration file.  It sets up various
        ;; preferences, packages, and keybindings.
      ELISP
      par = ::Elisp2any::Paragraph.scan(source)
      assert_instance_of ::Elisp2any::Paragraph, par
      assert_equal 2, par.lines.size
    end
  end
end
