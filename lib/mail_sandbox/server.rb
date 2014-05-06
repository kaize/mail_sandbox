module MailSandbox
  class Server < EventMachine::Protocols::SmtpServer

    def receive_plain_auth(user, password)
      message.user = user
      message.password = password

      true
    end

    def receive_sender(sender)
      message.sender = sender
      true
    end

    def receive_recipient(recipient)
      message.recipients << recipient
      true
    end

    def receive_message
      message.completed_at = Time.now
      MailSandbox.subscriber.notify(message)
      true
    end

    def process_data_line ln
      super ln
      message.data << ln
      true
    end

    def message
      @message ||= MailSandbox::Message.new
    end

  end
end