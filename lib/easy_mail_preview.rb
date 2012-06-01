require "easy_mail_preview/engine"

module EasyMailPreview
  def self.config
    @config ||= OpenStruct.new
  end

  def self.setup(&block)
    block.call(self.config)
  end
end
