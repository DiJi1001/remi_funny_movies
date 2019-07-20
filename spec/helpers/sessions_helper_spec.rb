describe SessionsHelper do
  describe '#login' do
    let(:user) { create :user }

    before { session.destroy }
    after { session.destroy }

    it 'log user in into session' do
      helper.log_in(user)
      expect(session[:user_id]).to eq user.id
    end
  end

  describe '#current_user' do
    let(:user) { create :user }
    let(:current_user) { helper.current_user }

    before { session.destroy }
    after { session.destroy }

    context 'when user has logged in' do
      before { helper.log_in(user) }

      it 'return user' do
        expect(current_user.id).to eq user.id
        expect(current_user.email).to eq user.email.downcase
      end
    end

    context 'when user has not logged in' do
      it 'return nil' do
        expect(current_user).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    subject { helper.logged_in? }
    let(:user) { create :user }

    before { session.destroy }
    after { session.destroy }

    context 'when user has logged in' do
      before { helper.log_in(user) }

      specify { is_expected.to be_truthy }
    end

    context 'when user has not logged in' do
      specify { is_expected.to be_falsey }
    end
  end

  describe '#log_out' do
    let(:user) { create :user }

    before do
      session.destroy
      helper.log_in(user)
    end
    after { session.destroy }

    it 'log user out from session', :aggregate_failures do
      helper.log_out
      expect(session[:user_id]).to be_nil
      expect(helper.current_user).to be_nil
      expect(helper.instance_variable_get(:@current_user)).to be_nil
    end
  end
end
