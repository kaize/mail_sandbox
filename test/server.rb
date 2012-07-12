require 'test_helper'

class ServerTest < MiniTest::Unit::TestCase

  def setup
    @server = MailSandbox::Server.new
    @pid = fork do
      @server.run
    end
    Process.detach(@pid)
  end

  def teardown
    `kill -9 #{@pid}`
  end

  def test_server_run
    server_run = !!::Process.kill(0, @pid) rescue false
    assert server_run
  end

end