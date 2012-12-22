require "bundler/setup"
Bundler.require(:default, :test)

require 'em-http-request'
require "socket"
require 'support/my_observer'
require 'net/smtp'
require 'mocha'

module SpawnHelper

  def spawn_server
    @pid = spawn "mail_sandbox"
    sleep 0.1 until alive?
    Process.detach @pid
    sleep 1
  end

  def kill_server
    Process.kill "QUIT", @pid
    sleep 0.1 while alive?
  end

  def alive?
    Process.kill 0, @pid rescue false
  end

end