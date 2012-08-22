module MailSandbox
  class Signals

    def self.trap
      Signal.list.keys.each do |signal|
        Signal.trap(signal) do
          MailSandbox.logger.info "Got #{signal} signal. Bye."
          exit
        end

      end
    end

  end
end

