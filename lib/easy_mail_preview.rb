require "easy_mail_preview/engine"

module EasyMailPreview
  def self.config
    @config ||= OpenStruct.new
  end

  def self.setup(&block)
    block.call(self.config)
  end

  # convenience class for introspecting on an ActionMailer class
  class Mailer
    def initialize(action_mailer)
      @action_mailer = action_mailer
    end

    def mail_methods
      (
        @action_mailer.public_instance_methods -
        @action_mailer.superclass.public_instance_methods -
        @action_mailer.included_modules.map(&:instance_methods).flatten.uniq
      ).map { |method_symbol| Method.new(@action_mailer, method_symbol) }
    end

    def name
      @action_mailer.name
    end

    class Method
      def initialize(action_mailer, method_symbol)
        @action_mailer, @method_symbol = action_mailer, method_symbol
      end

      def arguments
        method = @action_mailer.instance_method(@method_symbol)
        method.parameters.map { |tuple| Argument.new(tuple) }
      end

      def name
        @method_symbol
      end

      class Argument
        def initialize(tuple)
          @tuple = tuple
        end

        def name
          @tuple.last
        end

        def required?
          @tuple.first == :req
        end
      end
    end
  end
end
