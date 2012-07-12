require 'test_helper'

class ServerTest < MiniTest::Unit::TestCase

  def setup
    @pid = fork do
      EventMachine::run {
          EventMachine::start_server '127.0.0.1', 2525, MailSandbox::Server
      }
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

  def test_server_helo
    sleep 0.2
    ehlo = ''
    Socket.tcp('127.0.0.1', 2525) do |socket|
      socket.print "HELO\r\n"
      ehlo = socket.readline
      socket.print "QUIT\r\n"
      socket.close_write
      socket.close_read
    end
    assert_equal ehlo, "EHLO"
  end


end