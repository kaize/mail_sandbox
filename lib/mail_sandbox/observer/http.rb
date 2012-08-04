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
      http.errback {
        p http.response_header.status
        p http.response_header
        p http.response
      }
      http.callback {
        p http.response_header.status
        p http.response_header
        p http.response
      }

    end

  end
end