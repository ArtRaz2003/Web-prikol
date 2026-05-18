
class Api::ApiController < ApplicationController
    include WorkImage

    def next_image
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_image_index = next_index(current_index, length)
      next_image_data = show_image(theme_id, new_image_index)

      render json: {
        new_image_index: next_image_data[:index],
        name: next_image_data[:name],
        file: next_image_data[:file],
        image_id: next_image_data[:image_id],
        user_valued: next_image_data[:user_valued],
        common_ave_value: next_image_data[:common_ave_value],
        value: next_image_data[:value],
        values_qty: next_image_data[:values_qty]
      }
    end

    def save_value
      image_id = params[:image_id].to_i
      value_val = params[:value].to_i

      # Находим существующую оценку этого пользователя для этой картинки или создаем заготовку под новую
      # current_user берется из твоей системы аутентификации (Часть 7)
      @value = Value.find_or_initialize_by(user_id: current_user.id, image_id: image_id)
      @value.value = value_val

      if @value.save
        # Пересчитываем среднюю оценку (ave_value) для этой картинки
        image = Image.find(image_id)
        all_values = Value.where(image_id: image_id).pluck(:value)

        if all_values.any?
          new_ave = all_values.sum.to_f / all_values.size
          image.update(ave_value: new_ave)
        end

        render json: { status: 'success', notice: 'Оценка успешно сохранена' }
      else
        render json: { status: 'error', errors: @value.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def prev_image
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_image_index = prev_index(current_index, length)
      prev_image_data = show_image(theme_id, new_image_index)

      render json: {
        new_image_index: prev_image_data[:index],
        name: prev_image_data[:name],
        file: prev_image_data[:file],
        image_id: prev_image_data[:image_id],
        user_valued: prev_image_data[:user_valued],
        common_ave_value: prev_image_data[:common_ave_value],
        value: prev_image_data[:value],
        values_qty: prev_image_data[:values_qty]
      }
    end
  end
