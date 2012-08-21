module MailSandbox
  class Config

    def initialize
      @config = {
          :listen => '127.0.0.1',
          :port => 2525,
          :server_params => {
            :auth => true
          }
      }
    end

    def load_from_yml_file
      yaml = YAML.load_file config_file

      yaml.each do |key, val|
        self.send "#{key}=", val
      end
    end

    def method_missing(method, val = nil)
      m = method.to_s
      if m =~ /=$/
        key = m.match(/(.*)=$/)[1]
        @config[key.to_sym] = val
      else
        @config[method]
      end
    end

  end
end