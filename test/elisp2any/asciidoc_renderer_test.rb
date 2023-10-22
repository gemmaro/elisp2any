require 'test_helper'

class Elisp2anyTest < ::TestCase
  class AsciiDocRendererTest < ::TestCase
    test 'render' do
      source = fixture('init.el')
      file = ::Elisp2any::File.parse(source)
      adoc = ::Elisp2any::AsciiDocRenderer.new(file).render
      assert_instance_of String, adoc
      File.write(fixture('init/index.adoc', 'w'), adoc)
    end

    def fixture(path, mode = 'r')
      File.open(File.join(__dir__, '../../fixtures', path), mode)
    end
  end
end
