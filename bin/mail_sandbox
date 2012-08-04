#!/usr/bin/env ruby
require 'mail_sandbox'
require "eventmachine"

MailSandbox.subscribe MailSandbox::Observer::Http.new('http://localhost:8080/api/mails')

EventMachine::run {
  EventMachine::start_server '127.0.0.1', 2525, MailSandbox::Server
}


