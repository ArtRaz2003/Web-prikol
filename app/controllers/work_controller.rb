class WorkController < ApplicationController
  include WorkImage

  def index
    @images_count = Image.all.count
    @selected_theme = "Выберите тему"
    @selected_image_name = ''
    @values_qty = Value.all.count
    session[:selected_theme_id] = @selected_theme
  end

  def choose_theme
    @themes = Theme.all.pluck(:name)
    respond_to :html, :js
  end

  def display_theme
    @image_data = {}
    current_user_id = current_user.id

    if params[:theme] == "Выберите тему" || params[:theme].blank?
      theme = "Выберите тему"
      theme_id = 1
      values_qty = Value.all.count.round
      data = { index: 0, name: 'Дефолт', values_qty: values_qty,
               file: 'default.jpg', image_id: 1,
               current_user_id: current_user_id, user_valued: false,
               common_ave_value: 0, value: 0 }
    else
      theme = params[:theme]
      # Находим ID темы по её имени
      theme_id = Theme.find_by(name: theme).id
      data = show_image(theme_id, 0)
    end

    session[:selected_theme_id] = theme_id
    image_data(theme, data)
  end
end