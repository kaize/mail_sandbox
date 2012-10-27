# MailSandbox [![Build Status](https://secure.travis-ci.org/kaize/mail_sandbox.png)](http://travis-ci.org/kaize/mail_sandbox)

Gem has run SMTP server and manipulate letters received. Using the Observer pattern you can subscribe to the event server.

## Installation

Add this line to your application's Gemfile:

    gem 'mail_sandbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail_sandbox

## Usage

To start the server:

```ruby
  runner = MailSandbox::Runner.new
  runner.config.config_file = "config/mail_sandbox.yml"
  runner.start
```

Cofig.yml

```yaml
staging:
  http_observe?: true
  http_observe_url: 'http://my_url.ru/api/mail_messages'
  listen: '0.0.0.0'
  log_level: debug
development:
  http_observe?: true
  http_observe_url: 'http://localhost:8080/api/mail_messages'
  listen: '0.0.0.0'
  log_level: debug
```

For more details see ```MailSandbox::Config```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
