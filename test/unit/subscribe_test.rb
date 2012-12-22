require 'test_helper'

class SubscribeTest < MiniTest::Unit::TestCase

  def setup
    @message = MailSandbox::Message.new
    @subscriber = MailSandbox::Subscriber.new
    @observer = MyObserver.new
  end

  def test_subscribe
    @subscriber.subscribe @observer

    assert_equal 1, @subscriber.observers.count
  end

  def test_observer_notify
    @subscriber.subscribe @observer

    @subscriber.notify @message and sleep 1
    assert_equal @message, @observer.message
  end

  def test_http_observer
    url = "http://localhost/api"
    body = {:body => {:message => @message.to_a}}

    http_mock = mock()
    http_mock.stubs(:callback)
    http_mock.stubs(:errback)

    EventMachine::HttpRequest.any_instance.expects(:post).with(body).returns(http_mock)

    @observer = MailSandbox::Observer::Http.new url
    @subscriber.subscribe @observer

    @subscriber.notify @message and sleep 1

    assert true
  end

end
