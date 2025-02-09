require 'test_helper'

module Elisp2any
  class ExpressionTest < ::TestCase
    test "scan" do
      scanner = StringScanner.new("(require 'package)")
      expr = ::Elisp2any::Expression.scan(scanner)
      assert expr
      assert scanner.eos?
    end
  end
end
