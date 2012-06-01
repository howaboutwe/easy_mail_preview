class EasyMailPreview::EmailsController <
      EasyMailPreview::ApplicationController
  def index
    @mailers = EasyMailPreview.config.mailers.map { |action_mailer|
      EasyMailPreview::Mailer.new(action_mailer)
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
end
