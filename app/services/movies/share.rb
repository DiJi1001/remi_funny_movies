class Movies::Share
  attr_accessor :error_message

  def initialize(user, youtube_url)
    @user = user
    @youtube_url = youtube_url
  end

  def execute
    video_id = ExtractYoutubeVideoId.execute(@youtube_url)
    unless video_id
      @error_message = I18n.t('movies.sharing.youtube_video_not_found')
      false
    else
      video_title, video_description = Gateways::FetchYoutubeVideo.execute(video_id)
      movie = @user.movies.new(title: video_title, video_id: video_id,
                               description: video_description, shared_url: @youtube_url)
      movie.save!
    end
  rescue Gateways::FetchYoutubeVideo::YoutubeVideoNotFoundException, ActiveRecord::RecordInvalid
    @error_message = I18n.t('movies.sharing.youtube_video_not_found')
    false
  end
end
