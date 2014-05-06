require "test_helper"

class EmServerTest < MiniTest::Unit::TestCase
  def setup
    @em_host = 'localhost'
    @em_port = 2525
  end

  def test_multiple_recipients
    c = nil
    EM.run {
      EM.start_server(@em_host, @em_port, MailSandbox::Server) { |conn| c = conn }

      EM::Timer.new(5) { EM.stop }

      EM::Protocols::SmtpClient.send ({
        host: @em_host,
        port: @em_port,
        domain: "example.com",
        from: "me@example.com",
        to: ["you@example.com", "we@example.com"],
        header: {"Subject"=>"Email subject line", "Reply-to"=>"me@example.com"},
        body: "Not much of interest here."
      })
    }

    assert_equal( c.message.recipients, ["<you@example.com>", "<we@example.com>"] )
  end
end
