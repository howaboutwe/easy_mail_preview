class EasyMailPreview::EmailsController < EasyMailPreview::ApplicationController
  def index
    @mailers = EasyMailPreview.config.mailers.map { |action_mailer|
      Mailer.new(action_mailer)
    }
  end

  def show
    params[:id] =~ /(.*?)_(.*)/
    mailer = Module.const_get($1)
    method_name = $2
    args = []
    i = 0
    until params["arg_" + i.to_s].blank?
      eval_str = params["arg_" + i.to_s]
      args << eval(eval_str)
      i += 1
    end
    mail = mailer.send(method_name, *args)
    render text: mail.body.to_s, layout: false
  end
  
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
