require 'test_helper'

class Elisp2anyTest < ::TestCase
  class FileTest < ::TestCase
    test 'parse, TODO: delete' do
      source = File.read(File.join(__dir__, '../../fixtures/init.el'))
      file = ::Elisp2any::File.parse(source)
      assert_instance_of ::Elisp2any::File, file
    end

    test "scan" do
      source = File.read(File.join(__dir__, '../../fixtures/init.el'))
      file = ::Elisp2any::File.scan(source)
      assert_instance_of ::Elisp2any::File, file
      assert_equal "init.el", file.name
      assert_equal "Emacs configuration", file.synopsis
      assert_instance_of ::Elisp2any::Commentary, file.commentary
      assert_equal 2, file.commentary.paragraphs.size
      assert_empty file.code.paragraphs
      omit "TODO"
      assert_equal 6, file.code.sections.size
      omit "more tests"
    end
  end
end
