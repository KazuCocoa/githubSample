require 'sinatra'
require 'octokit'

REPO = 'KazuCocoa/tagTestRepository'

Octokit.api_endpoint = 'https://api.github.com'
Octokit.web_endpoint = 'https://github.com'

logs = ''

get '/comment' do

  #client = Octokit::Client.new :login  => 'defunkt', :password => 'c0d3b4ssssss!'
  client = Octokit::Client.new access_token: '9d75246f8907b18fa22d879f80bd15be19c7f75d'

  user = client.user
  user.login

  issues = client.list_issues(REPO)

  #"The number of issue is #{issues[0][:number]}"
  #"The title of issue is #{issues[0][:title]}"

  client.add_comment(REPO, issues[0][:number], "ついかコメント3！！")
  "finish!!"
end

get '/log' do
  "#{logs}"
end

post '/hook_sample' do
  "#{request.header.read}"
end