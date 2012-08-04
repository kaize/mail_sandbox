module MailSandbox
  class Message

    attr_accessor :data, :recipient, :sender, :complited_at

    def initialize
      @data = []
    end

  end
end