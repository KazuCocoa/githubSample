# coding: utf-8

require 'sinatra'
require 'octokit'
require 'hashie'

require 'json'

REPO = 'KazuCocoa/tagTestRepository'

Octokit.api_endpoint = 'https://api.github.com'
Octokit.web_endpoint = 'https://github.com'

# for sinatra
#set :environment, :production

# start instance
client = Octokit::Client.new access_token: '9d75246f8907b18fa22d879f80bd15be19c7f75d'


get '/' do
  'Hello world !'
end

get '/issues' do
  "#{client.list_issues(REPO).first.number}"
end

post '/comment' do
  client.add_comment(REPO, client.list_issues(REPO).first.number, "ついかコメント3！！")
  "finish!!"
end

data = ''

post '/hook_sample' do
  delivery_id = request.env["HTTP_X_GITHUB_DELIVERY"]
  github_event = request.env['HTTP_X_GITHUB_EVENT']

  #req_body = Hashie::Mash.new(params[:payload])
  data = request.body.read
  req_body = request.body

  case github_event
    when 'pull_request'
      if req_body['action'] == 'opened'
        client.add_comment(REPO, client.list_issues(REPO).first['number'], "PRが開いたよ！")
        data = 'open PR'
      elsif req_body['action'] == 'closed'
        client.add_comment(REPO, client.list_issues(REPO).first['number'], "PRが閉じたよ！")
        data = 'close PR'
      else
        data = req_body['action']
      end

    when 'issues'
      if req_body.action == 'opened'
        client.add_comment(REPO, client.list_issues(REPO).first.number, "issueが開いたよ！")
        data = 'open issues'
      elsif req_body.action == 'closed'
        client.add_comment(REPO, client.list_issues(REPO).first.number, "issueが閉じたよ！")
        data = 'close issues'
      else
        data = request.body
      end
    else
      data = "sample"
  end

  "#{request.body.read}"

end

get '/data' do
  "#{data}"
end