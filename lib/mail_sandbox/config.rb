module MailSandbox
  class Config

    # @config:Array
    #   :listen:String
    #   :port:Integer
    #   :log_level:Symbol = :info (:info :error :warn :debug)
    #   :server_params:Array
    #       :auth:Boolean - enable smtp authorization, now it's only PLAIN
    #   :config_file:String - path to yaml config file
    #   :http_observe?:Boolean - subscribe Observer::Http to receive new messages and push them by http protocol
    #   :http_observe_url:String - url for push on receive new messages, use by Observer::Http
    #
    def initialize
      @config = {
          :listen => '127.0.0.1',
          :port => 2525,
          :log_level => :info,
          :server_params => {
              :auth => true
          }
      }
    end

    def load_from_yml_file(env, file = nil)
      file ||= config_file
      yaml = YAML.load_file(file)[env.to_s]

      merge_config(yaml)
    end

    def merge_config(hash)
      symbolize_merge(@config, hash)
    end

    def symbolize_merge(conf, hash)
      hash.each do |key, val|
        if val.kind_of? Hash
          symbolize_merge(conf[key.to_sym], val)
        else
          conf[key.to_sym] = val
        end
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