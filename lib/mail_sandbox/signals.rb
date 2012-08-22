module MailSandbox
  class Signals

    def self.trap
      %w'TERM QUIT'.each do |signal|
        Signal.trap(signal) do
          MailSandbox.logger.info "Got #{signal} signal. Bye."
          exit
        end

      end
    end

  end
end

