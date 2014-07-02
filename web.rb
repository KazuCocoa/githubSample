require 'sinatra'
require 'octokit'

REPO = 'KazuCocoa/tagTestRepository'


get '/' do
  Octokit.api_endpoint = 'https://api.github'
  Octokit.web_endpoint = 'https://github'

  #client = Octokit::Client.new :login  => 'defunkt', :password => 'c0d3b4ssssss!'
  client = Octokit::Client.new access_token: '9d75246f8907b18fa22d879f80bd15be19c7f75d'

  user = client.user
  user.login

  isues = Octokit.issues(REPO)

  p issues
end