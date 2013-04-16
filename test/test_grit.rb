require File.dirname(__FILE__) + '/helper'

class TestGrit < Test::Unit::TestCase
  def setup
    @old_debug  = Gifts::Grit.debug
    @old_logger = Gifts::Grit.logger
    Gifts::Grit.debug  = true
  end

  def teardown
    Gifts::Grit.debug  = @old_debug
    Gifts::Grit.logger = @old_logger
  end

  def test_uses_stdout_logger_by_default
    assert_equal STDOUT, Gifts::Grit.logger.instance_variable_get(:@logdev).dev
  end

  def test_can_override_logger
    my_logger = Logger.new(io = StringIO.new)
    Gifts::Grit.logger = my_logger
    assert_equal my_logger, Gifts::Grit.logger
  end

  def test_logs_to_specified_logger
    Gifts::Grit.logger = Logger.new(io = StringIO.new)
    Gifts::Grit.log 'hi mom'
    io.rewind
    assert io.read.include?('hi mom')
  end

end