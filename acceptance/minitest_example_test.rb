require 'minitest/autorun'

class ExampleWithAFailure < Minitest::Test
  def test_failure
    assert false
  end
end

class ExampleWithAnError < Minitest::Test
  def test_error
    raise "second failure"
  end
end

class ExampleThatPasses < Minitest::Test
  def test_passes
    assert true
  end
end

class ExampleWithOutput < Minitest::Test
  def test_stdout
    $stdout.puts "This is stdout!"
  end

  def test_stderr
    $stderr.puts "This is stderr!"
  end
end
