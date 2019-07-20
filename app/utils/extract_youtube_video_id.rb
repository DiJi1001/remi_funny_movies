module ExtractYoutubeVideoId
  extend self

  REGEX = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/

  def execute(youtube_url)
    return unless youtube_url
    matches = youtube_url.match(REGEX)
    matches[2] if matches
  end
end
