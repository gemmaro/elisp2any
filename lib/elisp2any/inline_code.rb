module Elisp2any
  class InlineCode
    attr_reader :content

    def initialize(content)
      @content = content
    end
  end
end
