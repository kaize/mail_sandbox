module MailSandbox
  class Signals

    def self.trap(server)

      %w'TERM QUIT'.each do |signal|
        Signal.trap(signal) do
          server.terminate
        end
      end

    end

  end
end

