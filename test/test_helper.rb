require "bundler/setup"
Bundler.require(:default, :test)

require 'em-http-request'
require "socket"
require 'support/my_observer'
require 'net/smtp'
require 'mocha'

module SpawnHelper
  PID_FILE = "/tmp/mail_sandbox.#{rand*1000.to_i}.pid"

  def spawn_server(options = "")
    @pid = spawn "bundle exec mail_sandbox #{options}"
    sleep 0.1 until alive?
    Process.detach @pid
    sleep 1
    @pid
  end

  def kill_server
    Process.kill "QUIT", @pid
    sleep 0.1 while alive?
  end

  def alive?
    Process.kill 0, @pid rescue false
  end

  def wait_pid_file
    50.times do
      return true if File.exist?(PID_FILE)
      sleep 0.1
    end
    false
  end

  def wait_bind
    50.times do
      begin
        Socket.tcp('127.0.0.1', 2525)
      rescue
        sleep 0.1
        next
      end
      return true
    end
    false
  end


end