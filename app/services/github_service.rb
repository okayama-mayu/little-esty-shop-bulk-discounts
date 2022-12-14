class GithubService
  def repo
    get_url("")
  end

  def usernames 
    get_url("/contributors")
  end

  def commits(username)
    get_url("/commits?author=#{username}&per_page=100")
  end

  def pull_requests
    get_url("/pulls?state=all")
  end

  def get_url(arg)
    response = HTTParty.get("https://api.github.com/repos/okayama-mayu/little-esty-shop#{arg}")
    JSON.parse(response.body, symbolize_names: true)
  end
end
