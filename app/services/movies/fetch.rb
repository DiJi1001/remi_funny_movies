class Movies::Fetch
  def initialize(page = nil, per = nil)
    @page = page
    @per = per
  end

  def execute
    Movie.order(id: :desc).includes(:user).page(@page).per(@per)
  end
end
