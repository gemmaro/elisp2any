require 'test_helper'
require 'elisp2any/tree_sitter_parser'

class Elisp2anyTest < ::TestCase
  class NodeTest < ::TestCase
    test 'from Tree-sitter' do
      source = File.read(File.join(__dir__, '../../fixtures/init.el'))
      ts_node = ::Elisp2any::TreeSitterParser.parse(source)
      nodes = ::Elisp2any::Node.from_tree_sitter(source, ts_node)
      assert_instance_of Array, nodes
      assert_instance_of ::Elisp2any::Heading, nodes.first
      # pp nodes
    end
  end
end
