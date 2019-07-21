describe Movies::Fetch do
  describe '#execute' do
    let(:user) { create :user }
    let(:movies) { Movies::Fetch.new(page, per).execute }

    before { create_list :movie, 5, user_id: user.id }

    context 'when get 3 movies of the first page' do
      let(:page) { 1 }
      let(:per) { 3 }
      let(:expected_movie_ids) { Movie.order(id: :desc).offset((page - 1)*per).limit(per).pluck(:id) }

      it 'return the first 3 movies ordered by id descending', :aggregate_failures do
        expect(movies.to_a.size).to eq per
        expect(movies.pluck(:id)).to eq expected_movie_ids
        expect(movies.current_page).to eq page
        expect(movies.next_page).to eq page + 1
        expect(movies.prev_page).to be_nil
        expect(movies.limit_value).to eq per
      end
    end

    context 'when get 3 movies of the second page' do
      let(:page) { 2 }
      let(:per) { 3 }
      let(:expected_movie_ids) { Movie.order(id: :desc).offset((page - 1)*per).limit(per).pluck(:id) }

      it 'return the last 2 movies ordered by id descending', :aggregate_failures do
        expect(movies.to_a.size).to eq 2
        expect(movies.pluck(:id)).to eq expected_movie_ids
        expect(movies.current_page).to eq page
        expect(movies.next_page).to be_nil
        expect(movies.prev_page).to eq page - 1
        expect(movies.limit_value).to eq per
      end
    end

    context 'when get movies without params' do
      let(:page) { nil }
      let(:per) { nil }
      let(:default_number) { 5 }
      let(:expected_movie_ids) { Movie.order(id: :desc).offset(0).limit(default_number).pluck(:id) }

      it 'return first 5 movies ordered by id descending', :aggregate_failures do
        expect(movies.to_a.size).to eq default_number
        expect(movies.pluck(:id)).to eq expected_movie_ids
        expect(movies.current_page).to eq 1
        expect(movies.next_page).to be_nil
        expect(movies.prev_page).to be_nil
        expect(movies.limit_value).to eq default_number
      end
    end
  end
end
