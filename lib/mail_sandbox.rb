require "mail_sandbox/version"
require "eventmachine"
require 'logger'

module MailSandbox
  autoload :Server, 'mail_sandbox/server'
  autoload :Message, 'mail_sandbox/message'
  autoload :Observer, 'mail_sandbox/observer'
  autoload :Subscribe, 'mail_sandbox/subscribe'
  autoload :Config, 'mail_sandbox/config'
  autoload :Runner, 'mail_sandbox/runner'
  autoload :Signals, 'mail_sandbox/signals'

  def self.subscribe(observer)
    Subscribe.subscribe observer
  end

  def self.unsubscribe(observer)
    Subscribe.unsubscribe observer
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

end
