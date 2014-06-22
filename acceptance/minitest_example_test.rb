require 'minitest/autorun'

class ExampleWithAFailure < MiniTest::Unit::TestCase
  def test_failure
    assert false
  end
end

class ExampleWithAnError < MiniTest::Unit::TestCase
  def test_error
    raise "second failure"
  end
end

class ExampleThatPasses < MiniTest::Unit::TestCase
  def test_passes
    assert true
  end
end

class ExampleWithOutput < MiniTest::Unit::TestCase
  def test_stdout
    $stdout.puts "This is stdout!"
  end

  def test_stderr
    $stderr.puts "This is stderr!"
  end
end
