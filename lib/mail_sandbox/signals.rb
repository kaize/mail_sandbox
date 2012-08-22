module MailSandbox
  class Signals

    def self.trap
      Signal.trap("TERM") do
        MailSandbox.logger.info "Got TERM signal. Bye."
        exit 0
      end
    end

  end
end

