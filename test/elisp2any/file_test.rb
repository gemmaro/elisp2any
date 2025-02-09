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
      assert_equal 2, file.commentary.size
      assert_empty file.code.paragraphs
      package, ui, font, _theme, _hooks, fin = file.code.sections
      package.heading.content => ["Package"]
      assert_empty package.paragraphs
      init, use_package, *none = package.sections
      init.heading.content => ["Initialize package manager"]
      assert_equal 2, init.blocks.size
      init.blocks => [_, par]
      par => [::Elisp2any::Line]
      use_package.heading.content => ["Install and configure ",
                                      { code: "use-package" },
                                      " for managing packages"]
      assert_empty none
      ui.heading.content => ["Basic UI and keybindings"]
      font.heading.content => ["Font"]
      fin.heading.content => ["Finalize and run"]
    end
  end
end
