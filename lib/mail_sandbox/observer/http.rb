require 'em-http-request'

module MailSandbox
  class Observer::Http

    def initialize(url, method = :post)
      @url = url
      @method = method
    end

    def update(message)
      body = {:message => message.to_json}
      EventMachine::HttpRequest.send @method, :body => body
    end

  end
end