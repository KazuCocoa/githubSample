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

# definition of event
PULL_REQUEST = 'pull_request'.freeze
ISSUES = 'issues'.freeze

# definition of action
OPENED = 'opened'.freeze
CLOSED = 'closed'.freeze

# message
CHECK_LIST = '- [ ] 頑張る'



# start instance
client = Octokit::Client.new access_token: '9d75246f8907b18fa22d879f80bd15be19c7f75d'


get '/' do
  'Hello world !'
end

get '/issues' do
  "#{client.list_issues(REPO).first.number}"
end

data = ''

post '/hook_sample' do
  delivery_id = request.env["HTTP_X_GITHUB_DELIVERY"]
  github_event = request.env['HTTP_X_GITHUB_EVENT']

  req_body =  Hashie::Mash.new(JSON.parse(request.body.read))

  data << repository = req_body.pull_request.repo.full_name
  puts repository

  data << issue_number = req_body.number
  puts issue_number

  case github_event
    when PULL_REQUEST
      case req_body.action
        when OPENED
          client.add_comment(repository, issue_number, CHECK_LIST)
        when CLOSED
          client.add_comment(repository, issue_number, "コングラッチュレーション！！ :+1: ")
        else
          data = 'else in pull request'
      end
    else
      data = 'sample'
  end
end

get '/data' do
  "#{data}"
end