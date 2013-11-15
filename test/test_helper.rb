require "bundler/setup"
Bundler.require(:default, :test)

require 'minitest/autorun'
require 'em-http-request'
require "socket"
require 'support/my_observer'
require 'net/smtp'
require 'mocha'

module SpawnHelper
  PID_FILE = "/tmp/mail_sandbox.#{rand*1000.to_i}.pid"

  def spawn_server(options = "")
    @pid = spawn command(options)
    sleep 0.1 until alive?
    Process.detach @pid
    sleep 1
    @pid
  end

  def command(options)
    "bundle exec mail_sandbox #{options}"
  end

  def kill_server(pid = nil)
    pid ||= @pid
    Process.kill "QUIT", pid rescue false
    sleep 0.1 while alive?(pid)
  end

  def alive?(pid = nil)
    pid ||= @pid
    Process.kill 0, pid rescue false
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