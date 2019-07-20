describe User do
  describe 'validations' do
    specify { is_expected.to validate_presence_of :email }
    specify { is_expected.to validate_length_of(:email).is_at_most(User::EMAIL_MAX_LENGTH) }
    specify { is_expected.to allow_value(Faker::Internet.email).for(:email) }
    specify { is_expected.to allow_value('Test_123@email.com').for(:email) }
    specify { is_expected.to_not allow_value('not_at_char').for(:email) }
    specify { is_expected.to_not allow_value('not_domain@').for(:email) }
    specify { is_expected.to_not allow_value('@gmail.com').for(:email) }
    specify { is_expected.to_not allow_value('abc_*&@gmail.com').for(:email) }

    specify { is_expected.to validate_presence_of :password }
    specify { is_expected.to validate_length_of(:password).is_at_least(User::PASSWORD_MIN_LENGTH) }

    context 'when create a user' do
      before do
        subject.email = Faker::Internet.email
        subject.password = Faker::Internet.password(6, 20)
      end

      it 'email must be unique' do
        is_expected.to validate_uniqueness_of(:email).case_insensitive
      end
    end
  end

  describe 'associations' do
    specify { is_expected.to have_many(:movies) }
  end

  describe 'callbacks' do
    context 'when user is created' do
      let(:email) { 'UPPER_MAIL@gmail.com' }
      let(:password) { 'abc123' }
      let!(:user) { User.create!(email: email, password: password) }

      it 'the plain password must be cleared', :aggregate_failures do
        expect(user.password).to be_nil
        expect(user.encrypted_password).to be_truthy
        expect(user.encrypted_password).to_not eq password
      end

      it 'the email is transformed to lower case' do
        expect(user.email).to eq email.downcase
      end
    end
  end

  describe '#right_password?' do
    let(:password) { 'Abc123!' }
    let(:user) { create :user, password: password }

    context 'when pass right password' do
      subject { user.right_password?(password) }

      specify { is_expected.to be_truthy }
    end

    context 'when pass wrong password' do
      subject { user.right_password?('Abcd1234&') }

      specify { is_expected.to be_falsey }
    end

    context 'when pass downcase of password' do
      subject { user.right_password?('abc123!') }

      specify { is_expected.to be_falsey }
    end

    context 'when pass uppercase of password' do
      subject { user.right_password?('ABC123!') }

      specify { is_expected.to be_falsey }
    end
  end
end
