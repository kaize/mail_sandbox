module MailSandbox
  class Subscribe
    class<<self

      def subscribe(observer)
        observers[observer] ||= observer
      end

      def unsubscribe(observer)
        observers.delete(observer)
      end

      def notify(message)
        observers.each_value do |observer|

          thread = Thread.new do
            mutex.synchronize do
              observer.update(message)
            end
          end

          #thread.run
        end
      end

      def observers
        @observers ||= {}
      end

      def mutex
        @mutex ||= Mutex.new
      end

    end
  end
end