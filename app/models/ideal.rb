class Ideal < ApplicationRecord
  mount_uploader :user_image, ImageUploader
  belongs_to :user
end
