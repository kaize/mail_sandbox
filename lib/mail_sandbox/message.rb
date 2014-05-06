require 'json'

module MailSandbox
  class Message
    attr_accessor :data, :recipients, :sender, :completed_at, :user, :password

    def initialize
      @data = []
      @recipients = []
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {
        :password => password,
        :user => user,
        :recipients => recipients.join(','),
        :sender => sender,
        :completed_at => completed_at,
        :data => data.join("\r\n"),
      }
    end
  end
end