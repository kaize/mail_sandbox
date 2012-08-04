require "mail_sandbox/version"
require "eventmachine"

module MailSandbox
  autoload :Server, 'mail_sandbox/server'
  autoload :Message, 'mail_sandbox/message'
  autoload :Subscribe, 'mail_sandbox/subscribe'

  extend Forwardable

  def self.subscribe(observer)
    Subscribe.subscribe observer
  end

  def self.unsubscribe(observer)
    Subscribe.unsubscribe observer
  end

end
