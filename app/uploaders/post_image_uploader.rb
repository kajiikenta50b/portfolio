class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :index_size do
    process resize_and_pad: [600, 400, '#f5ebdc', 'Center']
    process :convert_to_webp
  end

  def convert_to_webp
    manipulate! do |img|
      img.format('webp') { |c| c.fuzz '3%' }
      img
    end
  end

  def filename
    return unless original_filename.present?

    "#{File.basename(original_filename, '.*')}.webp"
  end

  def extension_allowlist
    %w[jpg jpeg gif png heic webp]
  end

  def size_range
    1..5.megabytes
  end
end
