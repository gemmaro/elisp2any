require 'test_helper'

module Elisp2any
  class HeaderLineVariablesTest < ::TestCase
    test 'scan' do
      source = "-*- lexical-binding: t; -*-"
      vars = ::Elisp2any::HeaderLineVariables.scan(source)
      expected = { "lexical-binding" => "t" }
      assert_equal expected, vars.variables
    end
  end
end
