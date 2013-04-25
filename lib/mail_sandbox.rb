require "mail_sandbox/version"
require "eventmachine"
require 'logger'
require 'yaml'

module MailSandbox
  autoload :Server, 'mail_sandbox/server'
  autoload :Message, 'mail_sandbox/message'
  autoload :Observer, 'mail_sandbox/observer'
  autoload :Subscriber, 'mail_sandbox/subscriber'
  autoload :Config, 'mail_sandbox/config'
  autoload :Runner, 'mail_sandbox/runner'
  autoload :Signals, 'mail_sandbox/signals'

  def self.subscribe(observer)
    subscriber.subscribe observer
  end

  def self.unsubscribe(observer)
    subscriber.unsubscribe observer
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.subscriber
    @subscriber ||= Subscriber.new
  end

end
