$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'elisp2any'

require 'test-unit'

TestCase = Class.new(Test::Unit::TestCase)
