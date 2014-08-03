# coding: utf-8

require 'sinatra'
require 'octokit'
require 'hashie'

require 'json'

require './comments'

# access_token
ACCESS_TOKEN = '9d75246f8907b18fa22d879f80bd15be19c7f75d'

# for sinatra
#set :environment, :production

def pr_comment_for_ios_cookpad(action)
  case action
    when 'opened'
      PR_OPEN_COMMENT_IOS
    when 'closed'
      PR_CLOSE_COMMENT_IOS
    else
      'nothing'
  end
end

def pr_comment_for_android_cookpad(action)
  case action
    when 'opened'
      PR_OPEN_COMMENT_ANDROID
    when 'closed'
      PR_CLOSE_COMMENT_ANDROID
    else
      'nothing'
  end
end

def default_pr_comment(action)
  case action
    when 'opened'
      PR_OPEN_COMMENT
    when 'closed'
      PR_CLOSE_COMMENT
    else
      'nothing'
  end
end


def get_pr_comment_with(repository, action)
  repo = repository.downcase
  case repo
    when 'ios' #full repository name
      pr_comment_for_ios_cookpad(action)
    when 'android' #full repository name
      pr_comment_for_android_cookpad(action)
    else
      default_pr_comment(action)
  end
end


def comment_for_pr(client, repository, issue_number, action)
  if action == 'opened' || action == 'closed'
    client.add_comment(repository, issue_number, get_pr_comment_with(repository, action))
  else
    'nothing'
  end
end

# extend class for original bot
class OctokitBot < Octokit::Client
  def initialize *args
    #Octokit.api_endpoint = 'http://api.github.dev'
    #Octokit.web_endpoint = 'http://github.dev'
    super
  end

  def sample_method
    'Hello Sample Method!'
  end
end

#===================================

get '/' do
  'Hello world !'
end

post '/hook_sample' do
  delivery_id = request.env["HTTP_X_GITHUB_DELIVERY"]
  github_event = request.env['HTTP_X_GITHUB_EVENT']

  req_body =  Hashie::Mash.new(JSON.parse(request.body.read))

  repository = req_body.repository.full_name

  # start instance
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)

  case github_event
    when 'pull_request'
      comment_for_pr(client, repository, req_body.pull_request.number, req_body.action)
    else
      'nothing'
  end
end

get '/participant_list' do
  # start instance
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)

end

get '/sample' do
  client = OctokitBot.new(access_token: ACCESS_TOKEN)

  "#{client.sample_method}"
end