class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = set_locale_from_params || I18n.default_locale
  end

  def set_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
        params[:locale]
      else
        flash.now[:alarm] = "#{params[:locale]} - Перевод страницы отсутствует"
        logger.error flash.now[:alarm]
        nil
      end
    end
  end


  def default_url_options
    { locale: I18n.locale }
  end
end
