describe Movie do
  describe 'validations' do
    specify { is_expected.to validate_presence_of :user_id }
    specify { is_expected.to validate_presence_of :video_id }
    specify { is_expected.to validate_presence_of :title }
  end

  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
  end
end
