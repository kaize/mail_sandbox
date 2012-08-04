require 'test_helper'

class ServerTest < MiniTest::Unit::TestCase

  def setup

    @server = Thread.new do
      EventMachine::run {
          EventMachine::start_server '127.0.0.1', 2525, MailSandbox::Server
      }
    end
    @server.abort_on_exception = true
    @server.run

    @message = <<MESSAGE_END
    From: Private Person <me@fromdomain.com>
    To: A Test User <test@todomain.com>
    Subject: SMTP e-mail test

    1 This is a test e-mail message.
    2 This is a test e-mail message.
    3 This is a test e-mail message.
MESSAGE_END


    #wait run server
    sleep 0.2
  end

  def teardown
    Thread.kill @server
    sleep 0.2
  end

  def test_server_run
    server_run = @server.alive?
    assert server_run, "Server not alive"
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

  def test_concurrency_send_data

    client = lambda {
      Socket.tcp('127.0.0.1', 2525) do |socket|
        socket.print "EHLO localhost.localdomain\r\n"
        socket.print "MAIL FROM: my@mail.ru\r\n"
        socket.print "RCPT TO: localhost@localdomain\r\n"

        socket.print "DATA\r\n"

        @message.each_line do |ln|
          socket.print "#{ln}\r\n"
        end
        socket.print ".\r\n"

        socket.print "QUIT\r\n"
        socket.close_write
        socket.close_read

        exit
      end
    }

    2.times do
      fork &client
    end

    assert true

  end

  def test_subscribe_mailsandox

    observer = MyObserver.new
    MailSandbox.subscribe observer

    Net::SMTP.start('localhost', 2525) do |smtp|
      smtp.send_message @message, 'me@fromdomain.com', 'test@todomain.com'
    end

    sleep 1

    assert observer.message

  end


end