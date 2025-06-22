class Elisp::Comment
  def initialize(content)
    @content = content
  end

  def <<(content)
    @content << "\n#{content}"
  end

  def to_minor_para
    Elisp::MinorPara.new(@content)
  end

  def html
    self.class.parse(@content)
  end
end
