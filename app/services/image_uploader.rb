class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :resize_to_limit => [200, 200]
  process :convert => 'jpg'

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{Time.now.strftime('%Y%m%d%H%M%S')}.jpg" if original_filename.present?
  end
end
