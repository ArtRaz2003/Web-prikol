
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
