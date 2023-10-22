require 'test_helper'

class Elisp2anyTest < ::TestCase
  class HTMLRendererTest < ::TestCase
    test 'render' do
      source = fixture('init.el')
      file = ::Elisp2any::File.parse(source)
      html = ::Elisp2any::HTMLRenderer.new(file).render
      assert_instance_of String, html
      File.write(fixture('init/index.html', 'w'), html)
    end

    def fixture(path, mode = 'r')
      File.open(File.join(__dir__, '../../fixtures', path), mode)
    end
  end
end
