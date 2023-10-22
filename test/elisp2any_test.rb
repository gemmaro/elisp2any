require 'test_helper'

class Elisp2anyTest < ::TestCase
  test 'VERSION' do
    assert do
      ::Elisp2any.const_defined?(:VERSION)
    end
  end
end
