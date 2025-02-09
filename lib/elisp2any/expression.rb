require "strscan"

module Elisp2any
  class Expression
    def self.scan(scanner)
      scanner = StringScanner.new(scanner) unless scanner.respond_to?(:skip)
      if scanner.skip("(")
        exps = []
        while (exp = scan(scanner))
          exps << exp
          spaces = scanner.scan(/[ \n]+/)
          exps << spaces if spaces
        end
        scanner.skip(")") or raise Error, scanner.inspect
        new(exps)
      elsif scanner.skip("'")
        exp = scan(scanner) or raise Error, scanner.inspect
        new({ quoted: exp })
      elsif scanner.skip("\"")
        content = +""
        while !scanner.eos? && !scanner.match?("\\") && !scanner.match?('"')
          content << scanner.getch
        end
        scanner.skip('"') or raise Error, scanner.inspect
        new(content)
      elsif scanner.skip("#'")
        exp = scan(scanner) or raise Error, scanner.inspect
        new({ function: exp })
      else
        name = scanner.scan(/[a-z0-9_?.:-]+/) or return
        new(name.to_sym)
      end
    end

    def source
      case @content
      in { quoted: }
        "'#{self.class.source(quoted)}"
      in String
        @content
      in { function: }
        "#'#{self.class.source(function)}"
      in Array
        result = +"("
        @content.each { |exp| result << self.class.source(exp) }
        "#{result})"
      in Symbol
        @content.to_s
      end
    end

    def self.source(arg)
      case arg
      in Symbol
        arg.to_s
      in Array
        result = +"("
        arg.sum { |ele| result << source(ele) }
        "#{result})"
      in Expression
        arg.source
      in String
        arg
      else
        raise arg.inspect
      end
    end

    def deconstruct_keys(*keys)
      result = {}
      keys => [keys]
      keys.each do |key|
        case key
        in :content
          result[:content] = @content
        else # nop
        end
      end
      result
    end

    def deconstruct
      [*@content]
    end

    def initialize(content)
      @content = content
    end
  end
end
