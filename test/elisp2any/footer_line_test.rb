require 'test_helper'

module Elisp2any
  class FooterLineTest < ::TestCase
    test 'scan' do
      source = ";;; init.el ends here"
      vars = ::Elisp2any::FooterLine.scan(source)
      assert_instance_of ::Elisp2any::FooterLine, vars
    end
  end
end
