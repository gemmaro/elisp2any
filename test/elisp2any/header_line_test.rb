require 'test_helper'

module Elisp2any
  class HeaderLineTest < ::TestCase
    test 'scan' do
      source = ";;; init.el --- Emacs configuration  -*- lexical-binding: t; -*-"
      line = ::Elisp2any::HeaderLine.scan(source)
      assert_instance_of ::Elisp2any::HeaderLine, line
      assert_equal "init.el", line.filename
      assert_equal "Emacs configuration", line.description

      expected = { "lexical-binding" => "t" }
      assert_equal expected, line.variables
    end
  end
end
