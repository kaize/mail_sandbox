require "eventmachine"
require 'optparse'
require 'fileutils'

module MailSandbox
  class Runner

    attr_accessor :config

    def initialize
      self.config = MailSandbox::Config.new
    end

    def option_parse
      OptionParser.new do |opts|

        opts.on("-c", "--config-file FILE", "Config file") do |f|
          config.config_file = f
        end

        opts.on("-E", "--environment", "Environment") do |f|
          config.environment = f
        end

        opts.on("-D", "--daemonize", "Run daemonized") do |f|
          config.daemonize = f
        end

        opts.on("-P", "--pid", "File to store PID") do |f|
          config.pidfile = f
        end

      end.parse!
    end

    def configure
      config.load_from_yml_file(env) if config.config_file

      if config.http_observe?
        MailSandbox.subscribe MailSandbox::Observer::Http.new(config.http_observe_url)
      end

      MailSandbox.logger.level = case config.log_level.to_sym
                                   when :info then Logger::INFO
                                   when :error then Logger::ERROR
                                   when :warn then Logger::WARN
                                   when :debug then Logger::DEBUG
                                 end
      STDOUT.sync = true
      MailSandbox::Signals.trap
      MailSandbox::Server.parms = config.server_params
    end

    def start
      configure

      Process.daemon if config.daemonize
      write_pidfile if config.pidfile

      MailSandbox.logger.info "Start MailSandbox::Server on #{config.listen}:#{config.port}"

      EventMachine::run {
        EventMachine::start_server config.listen, config.port, MailSandbox::Server
      }
    end

    def env
      config.environment || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || :development
    end

    def write_pidfile
      SimplePid.new(config.pidfile)

      if pid.exists?
        unless pid.running?
          pid.cleanup
          pid.write!
        end
      else
        pid.write!
      end

    end

  end

end
