RSpec.describe Gateways::FetchYoutubeVideo do
  describe '.execute' do
    context 'when pass nil for youtube video id' do
      it 'raise youtube video not found exception' do
        expect { Gateways::FetchYoutubeVideo.execute(nil) }
          .to raise_exception(Gateways::FetchYoutubeVideo::YoutubeVideoNotFoundException)
      end
    end

    context 'when pass an invalid value for youtube video id' do
      let(:invalid_video_id) { 'invalid_video_id' }

      it 'raise youtube video not found exception' do
        expect { Gateways::FetchYoutubeVideo.execute(invalid_video_id) }
          .to raise_exception(Gateways::FetchYoutubeVideo::YoutubeVideoNotFoundException)
      end
    end

    context 'when pass a valid value for youtube video id' do
      let(:video_id) { '_aghWPzkB7M' }

      it 'return video name and description' do
        title, description = Gateways::FetchYoutubeVideo.execute(video_id)
        expect(title).to be_truthy
        expect(description).to be_truthy
      end
    end
  end
end
