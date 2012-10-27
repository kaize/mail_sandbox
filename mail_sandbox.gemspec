# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mail_sandbox/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kaize"]
  gem.email         = [""]
  gem.description   = %q{Mail Sandbox}
  gem.summary       = %q{Mail Sandbox}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mail_sandbox"
  gem.require_paths = ["lib"]
  gem.version       = MailSandbox::VERSION

  gem.add_dependency('eventmachine', '~> 0.12.9')
  gem.add_dependency('em-http-request', '~> 0.3.0')
  gem.add_dependency('OptionParser')
  gem.add_dependency('file-utils')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('minitest')
  gem.add_development_dependency('turn')
end
