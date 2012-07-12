require 'test_helper'

class ServerTest < MiniTest::Unit::TestCase

  def setup
    @pid = fork do
      EventMachine::run {
          EventMachine::start_server '127.0.0.1', 2525, MailSandbox::Server
      }
    end
    #wait run server
    sleep 0.2
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
    bye, helo = nil
    Socket.tcp('127.0.0.1', 2525) do |socket|
      helo = socket.readline
      socket.print "EHLO localhost.localdomain\r\n"
      socket.readpartial(65536)
      socket.print "QUIT\r\n"
      bye = socket.readline
      socket.close_write
      socket.close_read
    end
    assert_match /^220 .*/, helo
    assert_match /^221 .*/, bye
  end


end