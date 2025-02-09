require "forwardable"

module Elisp2any
  class FooterLine
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:pos)
      pos = scanner.pos
      heading = Elisp2any.scan_top_heading(scanner) or return
      cscanner = StringScanner.new(heading)
      unless (filename = Elisp2any.scan_filename(cscanner))
        scanner.pos = pos
        return
      end
      unless cscanner.skip(/ ends here\n?/)
        scanner.pos = pos
        return
      end
      new(filename)
    end

    def initialize(filename)
      @filename = filename
    end

    extend Forwardable # :nodoc:
    def_delegator :@filename, :==
  end
end
