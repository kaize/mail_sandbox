require 'test_helper'

class ServerTest < MiniTest::Unit::TestCase

  def setup
    EventMachine::MockHttpRequest.reset_registry!
    EventMachine::MockHttpRequest.reset_counts!
    EventMachine::MockHttpRequest.pass_through_requests = false

    EventMachine::MockHttpRequest.activate!

    @server = Thread.new do
      MailSandbox::Runner.new.start
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

    @http_response = <<-RESPONSE.gsub(/^ +/, '')
              HTTP/1.0 200 OK
              Date: Mon, 16 Nov 2009 20:39:15 GMT
              Expires: -1
              Cache-Control: private, max-age=0
              Content-Type: text/html; charset=ISO-8859-1
              Via: 1.0 .:80 (squid)
              Connection: close

              Success
            RESPONSE

    @url = 'http://localhost:8080/api/mails'

    #wait run server
    sleep 0.5
  end

  def teardown
    EventMachine::MockHttpRequest.deactivate!
    MailSandbox::Subscribe.observers.clear
    @server.terminate
    sleep 0.5
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

  def test_subscribe_mailsandox

    observer = MyObserver.new
    MailSandbox.subscribe observer

    Net::SMTP.start('localhost', 2525) do |smtp|
      smtp.send_message @message, 'me@fromdomain.com', 'test@todomain.com'
    end

    sleep 1

    assert observer.message

  end

  def test_http_observer

    EventMachine::MockHttpRequest.register(@url,:post, nil, @http_response)

    observer = MailSandbox::Observer::Http.new(@url)
    MailSandbox.subscribe observer

    Net::SMTP.start('localhost', 2525) do |smtp|
      smtp.send_message @message, 'me@fromdomain.com', 'test@todomain.com'
    end

    sleep 1

    assert_equal 1, EM::HttpRequest.count(@url, :post)

  end

  def test_auth
    user = 'app_user'
    password = 'KnesSGaF9TQ9wOOdXd2m'

    observer = MyObserver.new
    MailSandbox.subscribe observer

    smtp = Net::SMTP.new('localhost', 2525)
    smtp.start do |smtp|
      smtp.auth_plain(user, password)
      smtp.send_message @message, 'me@fromdomain.com', 'test@todomain.com'
    end

    sleep 1

    assert observer.message
    assert_equal user, observer.message.user
    assert_equal password, observer.message.password

  end


end