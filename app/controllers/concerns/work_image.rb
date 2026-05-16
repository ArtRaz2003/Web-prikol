module WorkImage
  extend ActiveSupport::Concern
  include WorkHelper

  def show_image(theme_id, image_index)
    theme_images = Image.theme_images(theme_id)

    # ЗАЩИТА: Если картинок нет (например, ID темы = 0), возвращаем пустой набор данных
    if theme_images.blank? || theme_images[image_index].nil?
      return { index: 0, name: "Нет картинок", file: "default.jpg", image_id: 0,
               user_valued: 0, value: 0, common_ave_value: 0, values_qty: 0, theme_id: theme_id, images_arr_size: 0 }
    end

    current_user_id = current_user.id
    one_image_attr = theme_images[image_index].attributes
    image_id = one_image_attr["id"]

    val = Value.find_by(user_id: current_user_id, image_id: image_id)
    user_valued = val.present? ? 1 : 0
    value = val.present? ? val.value : 0
    values_qty = Value.all.count.round

    {
      index: image_index,
      values_qty: values_qty,
      current_user_id: current_user_id,
      theme_id: theme_id,
      images_arr_size: theme_images.size,
      image_id: image_id,
      name: one_image_attr["name"],
      file: one_image_attr["file"],
      user_valued: user_valued,
      value: value,
      common_ave_value: (Image.find(image_id).ave_value || 0).round
    }
  end

  # Определяет индекс следующей картинки
  def next_index(current_index, length)
    new_index = current_index + 1
    new_index = 0 if new_index >= length # Зацикливаем в начало
    new_index
  end

  # Определяет индекс предыдущей картинки
  def prev_index(current_index, length)
    new_index = current_index - 1
    new_index = length - 1 if new_index < 0 # Зацикливаем в конец
    new_index
  end
end