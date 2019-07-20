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
        raise YoutubeVideoNotFoundException unless video_info

        snippet = video_info['snippet']
        [snippet['title'], snippet['description']]
      else
        raise YoutubeVideoNotFoundException
      end
    end
  end

  class YoutubeVideoNotFoundException < Exception; end
end
