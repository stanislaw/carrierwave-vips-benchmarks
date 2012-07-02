require 'stringio'

# http://thinkingdigitally.com/archive/capturing-output-from-puts-in-ruby/
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out

    yield

    out
  ensure
    $stdout = STDOUT
  end
end
