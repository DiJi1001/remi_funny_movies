feature 'Sharing movie' do
  given(:email) { 'keira.knightley@gmail.com' }
  given(:password) { Faker::Internet.password(6, 20) }

  background { create :user, email: email, password: password }

  scenario 'user go to sharing movie page while does not login yet' do
    visit '/movies/share'
    expect(page).to have_text(I18n.t('users.login.required_login'))
    expect(page).to have_current_path('/')
  end

  scenario 'user shares a movie' do
    # login first
    visit '/'
    input_email = page.find('input[type="text"]').fill_in with: email
    input_password = page.find('input[type="password"]').fill_in with: password
    input_submit = page.find('input[type="submit"]').click

    # go to sharing page
    visit '/movies/share'
    expect(page).to have_current_path('/movies/share')
    expect(page).to have_selector('form#share_movie_form')
    share_movie_form = page.find('form#share_movie_form')
    expect(share_movie_form).to have_selector('label[for="youtube_url"]')
    expect(share_movie_form).to have_selector('input[type="text"][name="youtube_url"]')
    expect(share_movie_form).to have_selector('input[type="submit"]')

    # share an invalid video url
    input_url = page.find('input[type="text"][name="youtube_url"]')
    input_submit = page.find('input[type="submit"]')
    input_url.fill_in with: 'invalid_video_url'
    input_submit.click
    expect(page).to have_text(I18n.t('movies.sharing.youtube_video_not_found'))
    expect(page).to have_current_path('/movies')

    # share a real Youtube video url
    input_url.fill_in with: 'https://www.youtube.com/watch?v=3AtDnEC4zak'
    input_submit.click
    expect(page).to have_text(I18n.t('movies.sharing.share_successfully'))
    expect(page).to have_current_path('/')
    firt_movie_item = page.first('div.movie-item')
    expect(firt_movie_item).to have_selector('iframe[src="https://www.youtube.com/embed/3AtDnEC4zak"]')
    expect(firt_movie_item).to have_text('Charlie Puth - We Don\'t Talk Anymore (feat. Selena Gomez) [Official Video]')
    expect(firt_movie_item).to have_text("Share by: #{email}")
    expect(firt_movie_item).to have_text('Description')
  end
end
