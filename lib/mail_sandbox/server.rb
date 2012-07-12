require "eventmachine"
module MailSandbox
  class Server < EventMachine::Protocols::SmtpServer

    def run
      sleep 10
    end

  end
end