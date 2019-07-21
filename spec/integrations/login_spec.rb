feature 'Login process' do
  given(:email) { 'keira.knightley@gmail.com' }
  given(:password) { Faker::Internet.password(6, 20) }

  scenario 'user login and logout' do
    visit '/'
    # before register
    header = page.find('header')
    expect(header).to have_selector('i.fa.fa-home')
    expect(header).to have_text('Funny Movies')
    expect(header).to have_selector('form#login_form')
    login_form = header.find('form#login_form')
    expect(login_form).to have_selector('input[type="text"][name="email"]')
    expect(login_form).to have_selector('input[type="password"][name="password"]')
    expect(login_form).to have_selector('input[type="submit"]')

    # register
    input_email = header.find('input[type="text"]')
    input_password = header.find('input[type="password"]')
    input_submit = header.find('input[type="submit"]')
    input_email.fill_in with: email
    input_password.fill_in with: password
    input_submit.click

    # after register
    expect(header).to have_text(I18n.t('users.login.register_login_successfully'))
    expect(header).to have_selector('i.fa.fa-home')
    expect(header).to have_text('Funny Movies')
    expect(header).to_not have_selector('form#login_form')
    expect(header).to have_text("Welcome #{email}")
    expect(header).to have_selector('a.btn[href="/movies/share"]', text: I18n.t('movies.share_btn'))
    expect(header).to have_selector('a.btn[href="/logout"][data-method="delete"]', text: I18n.t('users.logout_btn'))

    # logout
    logout_link = header.find('a.btn[href="/logout"]')
    logout_link.click

    # after logout
    expect(header).to have_selector('form#login_form')
    expect(header).to_not have_text("Welcome")

    # login with wrong password
    input_email.fill_in with: email
    input_password.fill_in with: "#{password}_wrong"
    input_submit.click
    expect(header).to have_text(I18n.t('users.login.incorrect_password'))

    # login again with correct password
    input_email.fill_in with: email
    input_password.fill_in with: password
    input_submit.click

    # after login
    expect(header).to have_text(I18n.t('users.login.login_successfully'))
    expect(header).to_not have_selector('form#login_form')
    expect(header).to have_text("Welcome #{email}")
    expect(header).to have_selector('a.btn[href="/movies/share"]', text: I18n.t('movies.share_btn'))
    expect(header).to have_selector('a.btn[href="/logout"][data-method="delete"]', text: I18n.t('users.logout_btn'))
  end
end
