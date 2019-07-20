RSpec.describe ExtractYoutubeVideoId do
  describe '.execute' do
    context 'when pass nil url' do
      subject { ExtractYoutubeVideoId.execute(nil) }

      specify { is_expected.to be_nil }
    end

    context 'when pass invalid url' do
      subject { ExtractYoutubeVideoId.execute('https://www.googleapis.com/youtube/v3/videos') }

      specify { is_expected.to be_nil }
    end

    context 'when pass normal youtube video url' do
      subject { ExtractYoutubeVideoId.execute('https://www.youtube.com/watch?v=iWkNxcbPtbM&feature=youtu.be&t=46') }

      specify { is_expected.to eq 'iWkNxcbPtbM' }
    end

    context 'when pass sharing youtube video url' do
      subject { ExtractYoutubeVideoId.execute('https://youtu.be/EG05-Y_C4EU') }

      specify { is_expected.to eq 'EG05-Y_C4EU' }
    end

    context 'when pass embed youtube video url' do
      subject { ExtractYoutubeVideoId.execute('https://www.youtube.com/embed/M8U7PR6fQNA') }

      specify { is_expected.to eq 'M8U7PR6fQNA' }
    end
  end
end

