require 'test_helper'

class Elisp2anyTest < ::TestCase
  class FileTest < ::TestCase
    test 'render' do
      source = File.read(File.join(__dir__, '../../fixtures/init.el'))
      file = ::Elisp2any::File.parse(source)
      assert_instance_of ::Elisp2any::File, file
    end
  end
end
