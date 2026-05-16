class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image # Эта строка, скорее всего, уже есть от скаффолда
end
