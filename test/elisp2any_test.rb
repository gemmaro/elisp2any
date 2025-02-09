require 'test_helper'

class Elisp2anyTest < ::TestCase
  test 'VERSION' do
    assert do
      ::Elisp2any.const_defined?(:VERSION)
    end
  end

  test "init fixture" do
    exe = File.join(__dir__, "../exe/elisp2any")
    lisp = File.join(__dir__, "../fixtures/init.el")
    system exe, "--input", lisp, "--output", "/dev/null", "--new", exception: true
  end

  test "init fixture but old" do
    exe = File.join(__dir__, "../exe/elisp2any")
    lisp = File.join(__dir__, "../fixtures/init.el")
    system exe, "--input", lisp, "--output", "/dev/null", exception: true
  end

  test "scan top heading" do
    scanner = StringScanner.new(";;; init.el ends here")
    heading = ::Elisp2any.scan_top_heading(scanner)
    assert_equal "init.el ends here", heading
    assert scanner.eos?
  end
end
