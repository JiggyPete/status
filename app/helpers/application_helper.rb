module ApplicationHelper
  def base_url
    return 'http://jiggypete-status.herokuapp.com' if Rails.env.production?
    'http://localhost:3000'
  end
end
