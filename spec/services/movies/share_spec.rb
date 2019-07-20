RSpec.describe Movies::Share do


  describe '#execute' do
    subject { service.execute }
    let(:service) { Movies::Share.new(user, youtube_url) }
    let(:user) { create :user }
    let(:youtube_url) { 'youtube_url' }
    let(:video_id) { 'video_id' }
    let(:video_title) { 'video_title' }
    let(:video_description) { 'video_description' }

    context 'when cannot extract video id from url' do
      before { allow(ExtractYoutubeVideoId).to receive(:execute).with(youtube_url) }

      it 'return false with error message', :aggregate_failures do
        is_expected.to be_falsey
        expect(service.error_message).to eq I18n.t('movies.sharing.youtube_video_not_found')
      end
    end

    context 'when cannot fetch video info from id' do
      before do
        allow(ExtractYoutubeVideoId).to receive(:execute).with(youtube_url).and_return(video_id)
        allow(Gateways::FetchYoutubeVideo).to receive(:execute).with(video_id)
          .and_raise(Gateways::FetchYoutubeVideo::YoutubeVideoNotFoundException)
      end

      it 'return false with error message', :aggregate_failures do
        is_expected.to be_falsey
        expect(service.error_message).to eq I18n.t('movies.sharing.youtube_video_not_found')
      end
    end

    context 'when video indo is fetched successfully' do
      let(:movie) { Movie.first }

      before do
        allow(ExtractYoutubeVideoId).to receive(:execute).with(youtube_url).and_return(video_id)
        allow(Gateways::FetchYoutubeVideo).to receive(:execute).with(video_id)
          .and_return([video_title, video_description])
      end

      it 'return true and the movie is created', :aggregate_failures do
        is_expected.to be_truthy
        expect(service.error_message).to be_nil
        expect(movie.user_id).to eq user.id
        expect(movie.video_id).to eq video_id
        expect(movie.title).to eq video_title
        expect(movie.description).to eq video_description
      end
    end
  end
end
