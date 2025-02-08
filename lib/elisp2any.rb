require_relative 'elisp2any/version'
require_relative 'elisp2any/file'

module Elisp2any
  autoload :HeaderLine, "elisp2any/header_line.rb"
  autoload :Blanklines, "elisp2any/blanklines.rb"
  Error = Class.new(StandardError)
end
