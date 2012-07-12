#!/usr/bin/env ruby
require 'mail_sandbox'
require "eventmachine"

EventMachine::run {
  EventMachine::start_server '127.0.0.1', 2525, MailSandbox::Server
}
