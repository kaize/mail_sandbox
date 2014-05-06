require 'em-http-request'

module MailSandbox
  class Observer::Http

    def initialize(url, method = :post)
      @url = url
      @method = method
    end

    def update(message)
      body = {:message => message.to_hash}

      MailSandbox.logger.debug "Observer::Http send to #{@url} method #{@method} body #{body.to_s}"

      http = EventMachine::HttpRequest.new(@url).send @method, :body => body
      http.errback {  MailSandbox.logger.error 'Observer::Http error.'   }
      http.callback {  MailSandbox.logger.debug 'Observer::Http sended.'   }

    end

  end
end