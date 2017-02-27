require 'opencv'
require 'twitter'
include OpenCV

namespace :tweet_ideals_task do
  desc '理想の自分をtweetする'

  task tweet_ideals: :environment do
    ideals = Ideal.all
    ideals.each do |ideal|
      if ideal.twitter_post
        new_image_file_name = create_ideal_image(ideal)
        tweet_ideal(ideal, new_image_file_name)
      end
    end
  end

  private

  def create_ideal_image(ideal)
    begin
      face_image = IplImage.load ideal.user_image.path, 1
      mascle_image = IplImage.load './public/mascle_image/sample.jpg', 1
    rescue
      puts 'ファイルが開けません'
      exit
    end

    detector = CvHaarClassifierCascade::load './vendor/bundle/ruby/2.3.0/gems/ruby-opencv-0.0.17/test/samples/haarcascade_frontalface_alt.xml'
    detector.detect_objects(mascle_image).each do |region|
      resized_image = face_image.resize region
      mascle_image.set_roi region
      (resized_image.rows * resized_image.cols).times do |i|
        if resized_image[i][0].to_i > 0 || resized_image[i][1].to_i > 0 || resized_image[i][2].to_i > 0
          mascle_image[i] = resized_image[i]
        end
      end
      mascle_image.reset_roi
    end

    new_image_file_name = "ideal_#{SecureRandom.uuid}.png"
    mascle_image.save_image("./public/ideal_image/#{new_image_file_name}")
    new_image_file_name
  end

  def tweet_ideal(ideal, new_image_file_name)
    client = Twitter::REST::Client.new(
      consumer_key: EnvSettings.twitter.consumer_key,
      consumer_secret: EnvSettings.twitter.consumer_secret,
      access_token: EnvSettings.twitter.access_token,
      access_token_secret: EnvSettings.twitter.access_token_secret
    )

    tweet_image = File.new("./public/ideal_image/#{new_image_file_name}")
    client.update_with_media("@#{ideal.twitter_username}", tweet_image)

  end

end
