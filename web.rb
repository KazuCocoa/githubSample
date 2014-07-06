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
PR_OPEN_COMMENT = '- [ ] 頑張る'
PR_CLOSE_COMMENT = 'イイネ！！ :+1: '



def get_comment_with(status)
  case status
    when OPENED
      PR_OPEN_COMMENT
    when CLOSED
      PR_CLOSE_COMMENT
    else
      'nothing'
  end
end

def comment_for_pr(client, repository, issue_number, status)
  if status == OPENED || status == CLOSED
    client.add_comment(repository, issue_number, get_comment_with(status))
  else
    'nothing'
  end
end


get '/' do
  'Hello world !'
end

post '/hook_sample' do
  delivery_id = request.env["HTTP_X_GITHUB_DELIVERY"]
  github_event = request.env['HTTP_X_GITHUB_EVENT']

  req_body =  Hashie::Mash.new(JSON.parse(request.body.read))

  repository = req_body.repository.full_name

  # start instance
  client = Octokit::Client.new access_token: '9d75246f8907b18fa22d879f80bd15be19c7f75d'

  case github_event
    when PULL_REQUEST
      comment_for_pr client, repository, req_body.pull_request.number, req_body.action
    else
      'nothing'
  end
end
