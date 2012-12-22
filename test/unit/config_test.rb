require 'test_helper'

class ConfigTest < MiniTest::Unit::TestCase

  def setup
    @config = MailSandbox::Config.new
  end

  def test_set_get_value
    @config.my_val = :test_val

    assert_equal :test_val, @config.my_val
  end

  def test_load_from_yml_file
    @config.load_from_yml_file(:development, 'test/support/config.yml')

    assert @config.test_key
    assert_equal 'development value', @config.test_key
  end

  def test_load_file
    @config.config_file = 'test/support/config.yml'

    @config.load_from_yml_file(:production)

    assert @config.test_key
    assert_equal 'production value', @config.test_key
  end



end