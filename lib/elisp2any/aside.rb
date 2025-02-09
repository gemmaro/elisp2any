require "elisp2any/comment"

module Elisp2any
  class Aside
    def self.scan(scanner)
      pos = scanner.pos
      com = Comment.scan(scanner) or return
      unless com.colons == 1
        scanner.pos = pos
        return
      end
      new(com.content)
    end

    def source
      ";#{@content}\n"
    end

    def initialize(content)
      @content = content
    end
  end
end
