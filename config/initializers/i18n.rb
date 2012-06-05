require "i18n"

if Rails.env.development?
  module I18n
    class << self
      def translate_with_debug(*args)
        Rails.logger.debug("Translate: #{args.inspect}")
        translate_without_debug(*args)
      end
      alias_method_chain(:translate, :debug)
    end
  end
end
