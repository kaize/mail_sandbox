require 'em-http-request'

module MailSandbox
  class Observer::Http

    def initialize(url, method = :post)
      @url = url
      @method = method
    end

    def update(message)
      body = {:message => message.to_a}
      http = EventMachine::HttpRequest.new(@url).send @method, :body => body
      http.errback {  p 'Observer::Http error.'   }
      http.callback {  p 'Observer::Http sended.'   }

    end

  end
end