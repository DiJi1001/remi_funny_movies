feature 'View movie listing' do
  given(:user) { create :user }
  given(:title) { 'Green Vase' }
  given(:description) { 'This is a description' }

  background do
    create_list :movie, 12, user_id: user.id, title: title, video_id: "IEjHUKhYs_Y",
                shared_url: "https://youtu.be/IEjHUKhYs_Y", description: description
  end

  scenario 'visitor visits the home page' do
    visit '/'
    movie_items = page.all('div.movie-item')
    expect(movie_items.size).to eq 5
    movie_item = movie_items.sample

    expect(movie_item).to have_selector('iframe[src="https://www.youtube.com/embed/IEjHUKhYs_Y"]')
    expect(movie_item).to have_text(title)
    expect(movie_item).to have_text("Share by: #{user.email}")
    expect(movie_item).to have_text('Description')
    expect(movie_item).to have_text(description)

    expect(page).to have_selector('nav')
    navigation = page.find('nav')
    expect(navigation).to have_selector('li.page-item.active>a', text: 1)
    expect(navigation).to have_selector('li.page-item>a[href="/?page=2"]', text: 2)
    expect(navigation).to have_selector('li.page-item>a[href="/?page=3"]', text: 3)
    expect(navigation).to have_selector('li.page-item>a[href="/?page=2"]', text: '›')
    expect(navigation).to have_selector('li.page-item>a[href="/?page=3"]', text: '»')

    last_page_link = navigation.find('li.page-item>a[href="/?page=3"]', text: '»')
    last_page_link.click

    expect(page).to have_current_path('/?page=3')
    movie_items = page.all('div.movie-item')
    expect(movie_items.size).to eq 2

    navigation = page.find('nav')
    expect(navigation).to have_selector('li.page-item.active>a', text: 3)
    expect(navigation).to have_selector('li.page-item>a[href="/?page=2"]', text: 2)
    expect(navigation).to have_selector('li.page-item>a[href="/?page=2"]', text: '‹')
    expect(navigation).to have_selector('li.page-item>a[href="/"]', text: '«')
  end
end
