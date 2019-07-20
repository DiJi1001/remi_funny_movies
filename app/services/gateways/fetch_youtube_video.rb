module Gateways::FetchYoutubeVideo
  GOOGLE_API_KEY = ENV.fetch('GOOGLE_API_KEY') { 'AIzaSyDiRsLcRPYkGPx0R2WEncsxvyeXMjjuoE0' }
  GOOGLE_API_URL = "https://www.googleapis.com/youtube/v3/videos?part=snippet&key=#{GOOGLE_API_KEY}"

  class << self
    def execute(youtube_video_id)
      uri = URI("#{GOOGLE_API_URL}&id=#{youtube_video_id}")
      response = Net::HTTP.get_response(uri)
      if response.kind_of? Net::HTTPSuccess
        body = JSON.parse(response.body)
        video_info = body && body['items']&.first
        raise YoutubeVideoNotFoundException.new(youtube_video_id) unless video_info

        snippet = video_info['snippet']
        [snippet['title'], snippet['description']]
      else
        raise YoutubeVideoNotFoundException.new(youtube_video_id)
      end
    end
  end

  class YoutubeVideoNotFoundException < Exception
    def initialize(youtube_video_id)
      @youtube_video_id = youtube_video_id
    end

    def message
      I18n.t('movies.sharing.youtube_video_not_found', youtube_video_id: @youtube_video_id)
    end
  end
end
