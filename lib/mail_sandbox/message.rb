require 'json'

module MailSandbox
  class Message

    attr_accessor :data, :recipient, :sender, :completed_at

    def initialize
      @data = []
    end

    def to_json
      json = {
        :recipient => recipient,
        :sender => sender,
        :completed_at => completed_at,
        :data => data.join("\r\n"),
      }.to_json
    end

  end
end