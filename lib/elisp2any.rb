require_relative 'elisp2any/version'
require_relative 'elisp2any/file'
require_relative 'elisp2any/heading'

module Elisp2any
  autoload :HeaderLine, "elisp2any/header_line.rb"
  autoload :Blanklines, "elisp2any/blanklines.rb"
  Error = Class.new(StandardError)

  def self.scan_filename(scanner) # :nodoc:
    scanner.scan(/[a-z]+[.]el\b/)
  end

  def self.scan_variable(scanner) # :nodoc:
    scanner.scan(/[a-z-]+\b/)
  end

  def self.scan_top_heading(scanner) # :nodoc:
    pos = scanner.pos
    heading = Heading.scan(scanner) or return
    unless heading.level.zero?
      scanner.pos = pos
      return
    end
    heading.content
  end
end
