require "test_helper"

class ServerTest < MiniTest::Unit::TestCase
  include SpawnHelper

  def setup
    spawn_server
  end

  def teardown
    kill_server
  end

  def test_server_run
    assert alive?, "Server not alive."
  end

  def test_server_bind_port
    assert wait_bind, "Server doesn't bind."
  end

  def test_server_helo
    wait_bind

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

  def test_server_auth
    wait_bind

    user = 'app_user'
    password = 'KnesSGaF9TQ9wOOdXd2m'

    @message = File.read(File.expand_path("../../fixtures/message.txt", __FILE__))

    smtp = Net::SMTP.new('localhost', 2525)
    smtp.start do |smtp|
      smtp.auth_plain(user, password)
      smtp.send_message @message, 'me@fromdomain.com', 'test@todomain.com'
    end

    assert alive?
  end
end
