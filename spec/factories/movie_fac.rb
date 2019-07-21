FactoryBot.define do
  factory :movie do
    sequence :video_id do |index|
      "video_id_#{index}"
    end
    sequence :title do |index|
      "video_title_#{index}"
    end
    sequence :shared_url do |index|
      "shared_url_#{index}"
    end
    sequence :description do |index|
      "description_#{index}"
    end
    user_id { User.first&.id || 1 }
  end
end
